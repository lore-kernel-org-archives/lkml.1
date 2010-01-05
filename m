Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158Ab0AEAu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab0AEAu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701Ab0AEAuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:50:52 -0500
Received: from kroah.org ([198.145.64.141]:34217 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab0AEAfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:08 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jeff Layton <jlayton@redhat.com>,
       Steve French <sfrench@us.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 33/97] cifs: NULL out tcon, pSesInfo, and srvTcp pointers when chasing DFS referrals
Date: Mon,  4 Jan 2010 16:32:46 -0800
Message-Id: <1262651630-7354-33-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 63ea83f..3bbcaa7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2287,12 +2287,12 @@ int
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
@@ -2301,6 +2301,10 @@ cifs_mount(struct super_block *sb, struct cifs_sb_info *cifs_sb,
 	int referral_walks_count = 0;
 try_mount_again:
 #endif
+	rc = 0;
+	tcon = NULL;
+	pSesInfo = NULL;
+	srvTcp = NULL;
 	full_path = NULL;
 
 	xid = GetXid();
@@ -2597,6 +2601,7 @@ remote_path_check:
 
 			cleanup_volume_info(&volume_info);
 			referral_walks_count++;
+			FreeXid(xid);
 			goto try_mount_again;
 		}
 #else /* No DFS support, return error on mount */
-- 
1.6.6

