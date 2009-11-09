Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbZKIAjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbZKIAjF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 19:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbZKIAjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 19:39:04 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:59948 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbZKIAjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 19:39:00 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org,
       linux-fsdevel@vger.kernel.org
Cc: smfrench@gmail.com
Subject: [PATCH] cifs: clean up handling when server doesn't consistently support inode numbers
Date: Sun,  8 Nov 2009 19:39:03 -0500
Message-Id: <1257727144-6468-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's possible that a server will return a valid FileID when we query the
FILE_INTERNAL_INFO for the root inode, but then zeroed out inode numbers
when we do a FindFile with an infolevel of
SMB_FIND_FILE_ID_FULL_DIR_INFO.

In this situation turn off querying for server inode numbers, generate a
warning for the user and just generate an inode number using iunique.
Once we generate any inode number with iunique we can no longer use any
server inode numbers or we risk collisions, so ensure that we don't do
that in cifs_get_inode_info either.

Cc: Stable <stable@kernel.org>
Reported-by: Timothy Normand Miller <theosib@gmail.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
---
 fs/cifs/cifsproto.h |    1 +
 fs/cifs/inode.c     |    7 ++-----
 fs/cifs/misc.c      |   14 ++++++++++++++
 fs/cifs/readdir.c   |    7 ++++---
 4 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 6928c24..5646727 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -388,4 +388,5 @@ extern int CIFSSMBSetPosixACL(const int xid, struct cifsTconInfo *tcon,
 		const struct nls_table *nls_codepage, int remap_special_chars);
 extern int CIFSGetExtAttr(const int xid, struct cifsTconInfo *tcon,
 			const int netfid, __u64 *pExtAttrBits, __u64 *pMask);
+extern void cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb);
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 5e24925..cababd8 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -512,13 +512,10 @@ int cifs_get_inode_info(struct inode **pinode,
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
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 0241b25..1e25efc 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -715,3 +715,17 @@ cifsConvertToUCS(__le16 *target, const char *source, int maxlen,
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
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 1f098ca..f84062f 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -727,11 +727,12 @@ static int cifs_filldir(char *pfindEntry, struct file *file, filldir_t filldir,
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
-- 
1.6.0.6

