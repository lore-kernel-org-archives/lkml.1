Return-Path: <linux-kernel-owner+w=401wt.eu-S1758418AbZLGAhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418AbZLGAhX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758213AbZLGAhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:37:18 -0500
Received: from kroah.org ([198.145.64.141]:34147 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758126AbZLGAMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:25 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:41 2009
Message-Id: <20091207000641.115073729@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 15:59:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [003/119] cifs: clean up handling when server doesnt consistently support inode numbers
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=cifs-clean-up-handling-when-server-doesn-t-consistently-support-inode-numbers.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jeff Layton <jlayton@redhat.com>

commit ec06aedd44541129840ed52e6165afa3796a27bf upstream.

It's possible that a server will return a valid FileID when we query the
FILE_INTERNAL_INFO for the root inode, but then zeroed out inode numbers
when we do a FindFile with an infolevel of
SMB_FIND_FILE_ID_FULL_DIR_INFO.

In this situation turn off querying for server inode numbers, generate a
warning for the user and just generate an inode number using iunique.
Once we generate any inode number with iunique we can no longer use any
server inode numbers or we risk collisions, so ensure that we don't do
that in cifs_get_inode_info either.

Reported-by: Timothy Normand Miller <theosib@gmail.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifsproto.h |    1 +
 fs/cifs/inode.c     |    7 ++-----
 fs/cifs/misc.c      |   14 ++++++++++++++
 fs/cifs/readdir.c   |    7 ++++---
 4 files changed, 21 insertions(+), 8 deletions(-)

--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -389,4 +389,5 @@ extern int CIFSSMBSetPosixACL(const int 
 		const struct nls_table *nls_codepage, int remap_special_chars);
 extern int CIFSGetExtAttr(const int xid, struct cifsTconInfo *tcon,
 			const int netfid, __u64 *pExtAttrBits, __u64 *pMask);
+extern void cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb);
 #endif			/* _CIFSPROTO_H */
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -512,13 +512,10 @@ int cifs_get_inode_info(struct inode **p
 					cifs_sb->local_nls,
 					cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
-			if (rc1) {
+			if (rc1 || !fattr.cf_uniqueid) {
 				cFYI(1, ("GetSrvInodeNum rc %d", rc1));
 				fattr.cf_uniqueid = iunique(sb, ROOT_I);
-				/* disable serverino if call not supported */
-				if (rc1 == -EINVAL)
-					cifs_sb->mnt_cifs_flags &=
-							~CIFS_MOUNT_SERVER_INUM;
+				cifs_autodisable_serverino(cifs_sb);
 			}
 		} else {
 			fattr.cf_uniqueid = iunique(sb, ROOT_I);
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -705,3 +705,17 @@ cifsConvertToUCS(__le16 *target, const c
 ctoUCS_out:
 	return i;
 }
+
+void
+cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb)
+{
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
+		cifs_sb->mnt_cifs_flags &= CIFS_MOUNT_SERVER_INUM;
+		cERROR(1, ("Autodisabling the use of server inode numbers on "
+			   "%s. This server doesn't seem to support them "
+			   "properly. Hardlinks will not be recognized on this "
+			   "mount. Consider mounting with the \"noserverino\" "
+			   "option to silence this message.",
+			   cifs_sb->tcon->treeName));
+	}
+}
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -727,11 +727,12 @@ static int cifs_filldir(char *pfindEntry
 		cifs_dir_info_to_fattr(&fattr, (FILE_DIRECTORY_INFO *)
 					pfindEntry, cifs_sb);
 
-	/* FIXME: make _to_fattr functions fill this out */
-	if (pCifsF->srch_inf.info_level == SMB_FIND_FILE_ID_FULL_DIR_INFO)
+	if (inum && (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
 		fattr.cf_uniqueid = inum;
-	else
+	} else {
 		fattr.cf_uniqueid = iunique(sb, ROOT_I);
+		cifs_autodisable_serverino(cifs_sb);
+	}
 
 	ino = cifs_uniqueid_to_ino_t(fattr.cf_uniqueid);
 	tmp_dentry = cifs_readdir_lookup(file->f_dentry, &qstring, &fattr);


