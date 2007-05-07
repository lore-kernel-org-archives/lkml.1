Return-Path: <linux-kernel-owner+w=401wt.eu-S1753045AbXEGAgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbXEGAgw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 20:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbXEGAgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 20:36:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57816 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbXEGAg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 20:36:26 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 7 May 2007 10:36:03 +1000
Message-Id: <1070507003603.24205@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
Subject: [PATCH 008 of 8] knfsd: Avoid Oops if buggy userspace performs confusing filehandle->dentry mapping.
References: <20070507103211.23855.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When a lookup request arrives, nfsd uses information provided by
userspace (mountd) to find the right filesystem.
It then assumes that the same filehandle type as the incoming filehandle
can be used to create an outgoing filehandle.
However if mountd is buggy, or maybe just being creative, the filesystem
may not support that filesystem type, and the kernel could oops, particularly
if 'ex_uuid' is NULL but a FSID_UUID* filehandle type is used.

So add some proper checking that the fsid version/type from the
incoming filehandle is actually supportable, and ignore that information
if it isn't supportable.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfsfh.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 50 insertions(+), 6 deletions(-)

diff .prev/fs/nfsd/nfsfh.c ./fs/nfsd/nfsfh.c
--- .prev/fs/nfsd/nfsfh.c	2007-05-07 10:30:13.000000000 +1000
+++ ./fs/nfsd/nfsfh.c	2007-05-07 10:31:05.000000000 +1000
@@ -323,7 +323,7 @@ fh_compose(struct svc_fh *fhp, struct sv
 	 *
 	 */
 
-	u8 version = 1;
+	u8 version;
 	u8 fsid_type = 0;
 	struct inode * inode = dentry->d_inode;
 	struct dentry *parent = dentry->d_parent;
@@ -341,15 +341,59 @@ fh_compose(struct svc_fh *fhp, struct sv
 	 * the reference filehandle (if it is in the same export)
 	 * or the export options.
 	 */
+ retry:
+	version = 1;
 	if (ref_fh && ref_fh->fh_export == exp) {
 		version = ref_fh->fh_handle.fh_version;
-		if (version == 0xca)
+		fsid_type = ref_fh->fh_handle.fh_fsid_type;
+
+		if (ref_fh == fhp)
+			fh_put(ref_fh);
+		ref_fh = NULL;
+
+		switch (version) {
+		case 0xca:
 			fsid_type = FSID_DEV;
-		else
-			fsid_type = ref_fh->fh_handle.fh_fsid_type;
-		/* We know this version/type works for this export
-		 * so there is no need for further checks.
+			break;
+		case 1:
+			break;
+		default:
+			goto retry;
+		}
+
+		/* Need to check that this type works for this
+		 * export point.  As the fsid -> filesystem mapping
+		 * was guided by user-space, there is no guarantee
+		 * that the filesystem actually supports that fsid
+		 * type. If it doesn't we loop around again without
+		 * ref_fh set.
 		 */
+		switch(fsid_type) {
+		case FSID_DEV:
+			if (!old_valid_dev(ex_dev))
+				goto retry;
+			/* FALL THROUGH */
+		case FSID_MAJOR_MINOR:
+		case FSID_ENCODE_DEV:
+			if (!(exp->ex_dentry->d_inode->i_sb->s_type->fs_flags
+			      & FS_REQUIRES_DEV))
+				goto retry;
+			break;
+		case FSID_NUM:
+			if (! (exp->ex_flags & NFSEXP_FSID))
+				goto retry;
+			break;
+		case FSID_UUID8:
+		case FSID_UUID16:
+			if (!root_export)
+				goto retry;
+			/* fall through */
+		case FSID_UUID4_INUM:
+		case FSID_UUID16_INUM:
+			if (exp->ex_uuid == NULL)
+				goto retry;
+			break;
+		}
 	} else if (exp->ex_uuid) {
 		if (fhp->fh_maxsize >= 64) {
 			if (root_export)
