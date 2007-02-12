Return-Path: <linux-kernel-owner+w=401wt.eu-S1030523AbXBLXqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030523AbXBLXqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 18:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030509AbXBLXqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 18:46:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030521AbXBLXpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 18:45:40 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 13 Feb 2007 10:44:37 +1100
Message-Id: <1070212234437.29316@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 007 of 9] knfsd: nfsd4: acls: don't return explicit mask
References: <20070213103941.28958.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: J. Bruce Fields <bfields@snoopy.citi.umich.edu>
Return just the effective permissions, and forget about the mask.  It isn't
worth the complexity.

WARNING: This breaks backwards compatibility with overly-picky nfsv4->posix acl
translation, as may has been included in some patched versions of libacl.  To
our knowledge no such version was every distributed by anyone outside citi.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfs4acl.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff .prev/fs/nfsd/nfs4acl.c ./fs/nfsd/nfs4acl.c
--- .prev/fs/nfsd/nfs4acl.c	2007-02-13 10:23:49.000000000 +1100
+++ ./fs/nfsd/nfs4acl.c	2007-02-13 10:37:27.000000000 +1100
@@ -180,7 +180,8 @@ _posix_to_nfsv4_one(struct posix_acl *pa
 						unsigned int flags)
 {
 	struct posix_acl_entry *pa, *pe, *group_owner_entry;
-	u32 mask, mask_mask;
+	u32 mask;
+	unsigned short mask_mask;
 	int eflag = ((flags & NFS4_ACL_TYPE_DEFAULT) ?
 					NFS4_INHERITANCE_FLAGS : 0);
 
@@ -188,9 +189,9 @@ _posix_to_nfsv4_one(struct posix_acl *pa
 	pe = pacl->a_entries + pacl->a_count;
 	pa = pe - 2; /* if mask entry exists, it's second from the last. */
 	if (pa->e_tag == ACL_MASK)
-		mask_mask = deny_mask(mask_from_posix(pa->e_perm, flags), flags);
+		mask_mask = pa->e_perm;
 	else
-		mask_mask = 0;
+		mask_mask = S_IRWXO;
 
 	pa = pacl->a_entries;
 	BUG_ON(pa->e_tag != ACL_USER_OBJ);
@@ -199,10 +200,7 @@ _posix_to_nfsv4_one(struct posix_acl *pa
 	pa++;
 
 	while (pa->e_tag == ACL_USER) {
-		mask = mask_from_posix(pa->e_perm, flags);
-		nfs4_acl_add_ace(acl, NFS4_ACE_ACCESS_DENIED_ACE_TYPE,
-				eflag,  mask_mask, NFS4_ACL_WHO_NAMED, pa->e_id);
-
+		mask = mask_from_posix(pa->e_perm & mask_mask, flags);
 		nfs4_acl_add_pair(acl, eflag, mask,
 				NFS4_ACL_WHO_NAMED, pa->e_id, flags);
 		pa++;
@@ -213,24 +211,15 @@ _posix_to_nfsv4_one(struct posix_acl *pa
 
 	/* allow ACEs */
 
-	if (pacl->a_count > 3) {
-		BUG_ON(pa->e_tag != ACL_GROUP_OBJ);
-		nfs4_acl_add_ace(acl, NFS4_ACE_ACCESS_DENIED_ACE_TYPE,
-				NFS4_ACE_IDENTIFIER_GROUP | eflag, mask_mask,
-				NFS4_ACL_WHO_GROUP, 0);
-	}
 	group_owner_entry = pa;
-	mask = mask_from_posix(pa->e_perm, flags);
+	mask = mask_from_posix(pa->e_perm & mask_mask, flags);
 	nfs4_acl_add_ace(acl, NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE,
 			NFS4_ACE_IDENTIFIER_GROUP | eflag, mask,
 			NFS4_ACL_WHO_GROUP, 0);
 	pa++;
 
 	while (pa->e_tag == ACL_GROUP) {
-		mask = mask_from_posix(pa->e_perm, flags);
-		nfs4_acl_add_ace(acl, NFS4_ACE_ACCESS_DENIED_ACE_TYPE,
-				NFS4_ACE_IDENTIFIER_GROUP | eflag, mask_mask,
-				NFS4_ACL_WHO_NAMED, pa->e_id);
+		mask = mask_from_posix(pa->e_perm & mask_mask, flags);
 		nfs4_acl_add_ace(acl, NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE,
 		    		NFS4_ACE_IDENTIFIER_GROUP | eflag, mask,
 		    		NFS4_ACL_WHO_NAMED, pa->e_id);
