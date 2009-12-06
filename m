Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbZLGAgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbZLGAgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758227AbZLGAMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:12:30 -0500
Received: from kroah.org ([198.145.64.141]:34159 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758210AbZLGAM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:27 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:41 2009
Message-Id: <20091207000641.394756970@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:59:41 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Shirish Pargaonkar <shirishp@us.ibm.com>,
       Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [005/119] CIFS: fix oops in cifs_lookup during net boot
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=cifs-fix-oops-in-cifs_lookup-during-net-boot.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Steve French <sfrench@us.ibm.com>

commit 8e6c0332d5032aef2d3bc8f41771f999112c8c66 upstream.

Fixes bugzilla.kernel.org bug number 14641

Lookup called during network boot (network root filesystem
for diskless workstation) has case where nd is null in
lookup.  This patch fixes that in cifs_lookup.

(Shirish noted that 2.6.30 and 2.6.31 stable need the same check)

Signed-off-by: Shirish Pargaonkar <shirishp@us.ibm.com>
Acked-by: Jeff Layton <jlayton@redhat.com>
Tested-by:  Vladimir Stavrinov <vs@inist.ru>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/dir.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -648,7 +648,7 @@ cifs_lookup(struct inode *parent_dir_ino
 	 * O_EXCL: optimize away the lookup, but don't hash the dentry. Let
 	 * the VFS handle the create.
 	 */
-	if (nd->flags & LOOKUP_EXCL) {
+	if (nd && (nd->flags & LOOKUP_EXCL)) {
 		d_instantiate(direntry, NULL);
 		return 0;
 	}
@@ -680,7 +680,7 @@ cifs_lookup(struct inode *parent_dir_ino
 	 * reduction in network traffic in the other paths.
 	 */
 	if (pTcon->unix_ext) {
-		if (!(nd->flags & (LOOKUP_PARENT | LOOKUP_DIRECTORY)) &&
+		if (nd && !(nd->flags & (LOOKUP_PARENT | LOOKUP_DIRECTORY)) &&
 		     (nd->flags & LOOKUP_OPEN) && !pTcon->broken_posix_open &&
 		     (nd->intent.open.flags & O_CREAT)) {
 			rc = cifs_posix_open(full_path, &newInode,


