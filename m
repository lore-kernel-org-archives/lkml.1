Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486Ab0AEUGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab0AEUGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755438Ab0AEUGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:06:08 -0500
Received: from kroah.org ([198.145.64.141]:49933 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109Ab0AEUF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:05:58 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:02:59 2010
Message-Id: <20100105200259.210742281@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:01:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [03/39] cifs: NULL out tcon, pSesInfo, and srvTcp pointers when chasing DFS referrals
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit a2934c7b363ddcc001964f2444649f909e583bef upstream.

The scenario is this:

The kernel gets EREMOTE and starts chasing a DFS referral at mount time.
The tcon reference is put, which puts the session reference too, but
neither pointer is zeroed out.

The mount gets retried (goto try_mount_again) with new mount info.
Session setup fails fails and rc ends up being non-zero. The code then
falls through to the end and tries to put the previously freed tcon
pointer again.  Oops at: cifs_put_smb_ses+0x14/0xd0

Fix this by moving the initialization of the rc variable and the tcon,
pSesInfo and srvTcp pointers below the try_mount_again label. Also, add
a FreeXid() before the goto to prevent xid "leaks".

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reported-by: Gustavo Carvalho Homem <gustavo@angulosolido.pt>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/connect.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2267,12 +2267,12 @@ int
 cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 		char *mount_data_global, const char *devname)
 {
-	int rc = 0;
+	int rc;
 	int xid;
 	struct smb_vol *volume_info;
-	struct cifsSesInfo *pSesInfo = NULL;
-	struct cifsTconInfo *tcon = NULL;
-	struct TCP_Server_Info *srvTcp = NULL;
+	struct cifsSesInfo *pSesInfo;
+	struct cifsTconInfo *tcon;
+	struct TCP_Server_Info *srvTcp;
 	char   *full_path;
 	char *mount_data = mount_data_global;
 #ifdef CONFIG_CIFS_DFS_UPCALL
@@ -2281,6 +2281,10 @@ cifs_mount(struct super_block *sb, struc
 	int referral_walks_count = 0;
 try_mount_again:
 #endif
+	rc = 0;
+	tcon = NULL;
+	pSesInfo = NULL;
+	srvTcp = NULL;
 	full_path = NULL;
 
 	xid = GetXid();
@@ -2577,6 +2581,7 @@ remote_path_check:
 
 			cleanup_volume_info(&volume_info);
 			referral_walks_count++;
+			FreeXid(xid);
 			goto try_mount_again;
 		}
 #else /* No DFS support, return error on mount */


