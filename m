Return-Path: <linux-kernel-owner+w=401wt.eu-S1030508AbXBLXqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030508AbXBLXqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 18:46:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030502AbXBLXqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 18:46:19 -0500
Received: from ns2.suse.de ([195.135.220.15]:55193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030508AbXBLXps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 18:45:48 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 13 Feb 2007 10:45:01 +1100
Message-Id: <1070212234501.29343@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 008 of 9] knfsd: nfsd4: acls: avoid unnecessary denies
References: <20070213103941.28958.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: J. Bruce Fields <bfields@snoopy.citi.umich.edu>
We're inserting deny's between some ACEs in order to enforce posix draft
acl semantics which prevent permissions from accumulating across entries
in an acl.

That's fine, but we're doing that by inserting a deny after *every* allow,
which is overkill.  We shouldn't be adding them in places where they
actually make no difference.

Also replaced some helper functions for creating acl entries; I prefer
just assigning directly to the struct fields--it takes a few more lines,
but the field names provide some documentation that I think makes the
result easier understand.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfs4acl.c |  190 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 145 insertions(+), 45 deletions(-)

diff .prev/fs/nfsd/nfs4acl.c ./fs/nfsd/nfs4acl.c
--- .prev/fs/nfsd/nfs4acl.c	2007-02-13 10:37:27.000000000 +1100
+++ ./fs/nfsd/nfs4acl.c	2007-02-13 10:38:09.000000000 +1100
@@ -89,12 +89,19 @@ mask_from_posix(unsigned short perm, uns
 }
 
 static u32
-deny_mask(u32 allow_mask, unsigned int flags)
+deny_mask_from_posix(unsigned short perm, u32 flags)
 {
-	u32 ret = ~allow_mask & ~NFS4_MASK_UNSUPP;
-	if (!(flags & NFS4_ACL_DIR))
-		ret &= ~NFS4_ACE_DELETE_CHILD;
-	return ret;
+	u32 mask = 0;
+
+	if (perm & ACL_READ)
+		mask |= NFS4_READ_MODE;
+	if (perm & ACL_WRITE)
+		mask |= NFS4_WRITE_MODE;
+	if ((perm & ACL_WRITE) && (flags & NFS4_ACL_DIR))
+		mask |= NFS4_ACE_DELETE_CHILD;
+	if (perm & ACL_EXECUTE)
+		mask |= NFS4_EXECUTE_MODE;
+	return mask;
 }
 
 /* XXX: modify functions to return NFS errors; they're only ever
@@ -164,14 +171,51 @@ nfs4_acl_posix_to_nfsv4(struct posix_acl
 	return acl;
 }
 
+struct posix_acl_summary {
+	unsigned short owner;
+	unsigned short users;
+	unsigned short group;
+	unsigned short groups;
+	unsigned short other;
+	unsigned short mask;
+};
+
 static void
-nfs4_acl_add_pair(struct nfs4_acl *acl, int eflag, u32 mask, int whotype,
-		uid_t owner, unsigned int flags)
+summarize_posix_acl(struct posix_acl *acl, struct posix_acl_summary *pas)
 {
-	nfs4_acl_add_ace(acl, NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE,
-				 eflag, mask, whotype, owner);
-	nfs4_acl_add_ace(acl, NFS4_ACE_ACCESS_DENIED_ACE_TYPE,
-				eflag, deny_mask(mask, flags), whotype, owner);
+	struct posix_acl_entry *pa, *pe;
+	pas->users = 0;
+	pas->groups = 0;
+	pas->mask = 07;
+
+	pe = acl->a_entries + acl->a_count;
+
+	FOREACH_ACL_ENTRY(pa, acl, pe) {
+		switch (pa->e_tag) {
+			case ACL_USER_OBJ:
+				pas->owner = pa->e_perm;
+				break;
+			case ACL_GROUP_OBJ:
+				pas->group = pa->e_perm;
+				break;
+			case ACL_USER:
+				pas->users |= pa->e_perm;
+				break;
+			case ACL_GROUP:
+				pas->groups |= pa->e_perm;
+				break;
+			case ACL_OTHER:
+				pas->other = pa->e_perm;
+				break;
+			case ACL_MASK:
+				pas->mask = pa->e_perm;
+				break;
+		}
+	}
+	/* We'll only care about effective permissions: */
+	pas->users &= pas->mask;
+	pas->group &= pas->mask;
+	pas->groups &= pas->mask;
 }
 
 /* We assume the acl has been verified with posix_acl_valid. */
@@ -179,30 +223,63 @@ static void
 _posix_to_nfsv4_one(struct posix_acl *pacl, struct nfs4_acl *acl,
 						unsigned int flags)
 {
-	struct posix_acl_entry *pa, *pe, *group_owner_entry;
-	u32 mask;
-	unsigned short mask_mask;
+	struct posix_acl_entry *pa, *group_owner_entry;
+	struct nfs4_ace *ace;
+	struct posix_acl_summary pas;
+	unsigned short deny;
 	int eflag = ((flags & NFS4_ACL_TYPE_DEFAULT) ?
 					NFS4_INHERITANCE_FLAGS : 0);
 
 	BUG_ON(pacl->a_count < 3);
-	pe = pacl->a_entries + pacl->a_count;
-	pa = pe - 2; /* if mask entry exists, it's second from the last. */
-	if (pa->e_tag == ACL_MASK)
-		mask_mask = pa->e_perm;
-	else
-		mask_mask = S_IRWXO;
+	summarize_posix_acl(pacl, &pas);
 
 	pa = pacl->a_entries;
-	BUG_ON(pa->e_tag != ACL_USER_OBJ);
-	mask = mask_from_posix(pa->e_perm, flags | NFS4_ACL_OWNER);
-	nfs4_acl_add_pair(acl, eflag, mask, NFS4_ACL_WHO_OWNER, 0, flags);
+	ace = acl->aces + acl->naces;
+
+	/* We could deny everything not granted by the owner: */
+	deny = ~pas.owner;
+	/*
+	 * but it is equivalent (and simpler) to deny only what is not
+	 * granted by later entries:
+	 */
+	deny &= pas.users | pas.group | pas.groups | pas.other;
+	if (deny) {
+		ace->type = NFS4_ACE_ACCESS_DENIED_ACE_TYPE;
+		ace->flag = eflag;
+		ace->access_mask = deny_mask_from_posix(deny, flags);
+		ace->whotype = NFS4_ACL_WHO_OWNER;
+		ace++;
+		acl->naces++;
+	}
+
+	ace->type = NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE;
+	ace->flag = eflag;
+	ace->access_mask = mask_from_posix(pa->e_perm, flags | NFS4_ACL_OWNER);
+	ace->whotype = NFS4_ACL_WHO_OWNER;
+	ace++;
+	acl->naces++;
 	pa++;
 
 	while (pa->e_tag == ACL_USER) {
-		mask = mask_from_posix(pa->e_perm & mask_mask, flags);
-		nfs4_acl_add_pair(acl, eflag, mask,
-				NFS4_ACL_WHO_NAMED, pa->e_id, flags);
+		deny = ~(pa->e_perm & pas.mask);
+		deny &= pas.groups | pas.group | pas.other;
+		if (deny) {
+			ace->type = NFS4_ACE_ACCESS_DENIED_ACE_TYPE;
+			ace->flag = eflag;
+			ace->access_mask = deny_mask_from_posix(deny, flags);
+			ace->whotype = NFS4_ACL_WHO_NAMED;
+			ace->who = pa->e_id;
+			ace++;
+			acl->naces++;
+		}
+		ace->type = NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE;
+		ace->flag = eflag;
+		ace->access_mask = mask_from_posix(pa->e_perm & pas.mask,
+						   flags);
+		ace->whotype = NFS4_ACL_WHO_NAMED;
+		ace->who = pa->e_id;
+		ace++;
+		acl->naces++;
 		pa++;
 	}
 
@@ -212,41 +289,64 @@ _posix_to_nfsv4_one(struct posix_acl *pa
 	/* allow ACEs */
 
 	group_owner_entry = pa;
-	mask = mask_from_posix(pa->e_perm & mask_mask, flags);
-	nfs4_acl_add_ace(acl, NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE,
-			NFS4_ACE_IDENTIFIER_GROUP | eflag, mask,
-			NFS4_ACL_WHO_GROUP, 0);
+
+	ace->type = NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE;
+	ace->flag = eflag;
+	ace->access_mask = mask_from_posix(pas.group, flags);
+	ace->whotype = NFS4_ACL_WHO_GROUP;
+	ace++;
+	acl->naces++;
 	pa++;
 
 	while (pa->e_tag == ACL_GROUP) {
-		mask = mask_from_posix(pa->e_perm & mask_mask, flags);
-		nfs4_acl_add_ace(acl, NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE,
-		    		NFS4_ACE_IDENTIFIER_GROUP | eflag, mask,
-		    		NFS4_ACL_WHO_NAMED, pa->e_id);
+		ace->type = NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE;
+		ace->flag = eflag | NFS4_ACE_IDENTIFIER_GROUP;
+		ace->access_mask = mask_from_posix(pa->e_perm & pas.mask,
+						   flags);
+		ace->whotype = NFS4_ACL_WHO_NAMED;
+		ace->who = pa->e_id;
+		ace++;
+		acl->naces++;
 		pa++;
 	}
 
 	/* deny ACEs */
 
 	pa = group_owner_entry;
-	mask = mask_from_posix(pa->e_perm, flags);
-	nfs4_acl_add_ace(acl, NFS4_ACE_ACCESS_DENIED_ACE_TYPE,
-			NFS4_ACE_IDENTIFIER_GROUP | eflag,
-			deny_mask(mask, flags), NFS4_ACL_WHO_GROUP, 0);
+
+	deny = ~pas.group & pas.other;
+	if (deny) {
+		ace->type = NFS4_ACE_ACCESS_DENIED_ACE_TYPE;
+		ace->flag = eflag | NFS4_ACE_IDENTIFIER_GROUP;
+		ace->access_mask = deny_mask_from_posix(deny, flags);
+		ace->whotype = NFS4_ACL_WHO_GROUP;
+		ace++;
+		acl->naces++;
+	}
 	pa++;
+
 	while (pa->e_tag == ACL_GROUP) {
-		mask = mask_from_posix(pa->e_perm, flags);
-		nfs4_acl_add_ace(acl, NFS4_ACE_ACCESS_DENIED_ACE_TYPE,
-		    		NFS4_ACE_IDENTIFIER_GROUP | eflag,
-		    		deny_mask(mask, flags), NFS4_ACL_WHO_NAMED, pa->e_id);
+		deny = ~(pa->e_perm & pas.mask);
+		deny &= pas.other;
+		if (deny) {
+			ace->type = NFS4_ACE_ACCESS_DENIED_ACE_TYPE;
+			ace->flag = eflag | NFS4_ACE_IDENTIFIER_GROUP;
+			ace->access_mask = mask_from_posix(deny, flags);
+			ace->whotype = NFS4_ACL_WHO_NAMED;
+			ace->who = pa->e_id;
+			ace++;
+			acl->naces++;
+		}
 		pa++;
 	}
 
 	if (pa->e_tag == ACL_MASK)
 		pa++;
-	BUG_ON(pa->e_tag != ACL_OTHER);
-	mask = mask_from_posix(pa->e_perm, flags);
-	nfs4_acl_add_pair(acl, eflag, mask, NFS4_ACL_WHO_EVERYONE, 0, flags);
+	ace->type = NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE;
+	ace->flag = eflag;
+	ace->access_mask = mask_from_posix(pa->e_perm, flags);
+	ace->whotype = NFS4_ACL_WHO_EVERYONE;
+	acl->naces++;
 }
 
 static void
