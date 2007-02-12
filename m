Return-Path: <linux-kernel-owner+w=401wt.eu-S1030507AbXBLXou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030507AbXBLXou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 18:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030509AbXBLXos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 18:44:48 -0500
Received: from mail.suse.de ([195.135.220.2]:53316 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030507AbXBLXoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 18:44:44 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 13 Feb 2007 10:44:07 +1100
Message-Id: <1070212234407.29239@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 002 of 9] knfsd: nfsd4: relax checking of ACL inheritance bits
References: <20070213103941.28958.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: J. Bruce Fields <bfields@citi.umich.edu>
The rfc allows us to be more permissive about the ACL inheritance bits we
accept:

	"If the server supports a single "inherit ACE" flag that applies to
	both files and directories, the server may reject the request
	(i.e., requiring the client to set both the file and directory
	inheritance flags). The server may also accept the request and
	silently turn on the ACE4_DIRECTORY_INHERIT_ACE flag."

Let's take the latter option--the ACL is a complex attribute that could be
rejected for a wide variety of reasons, and the protocol gives us little
ability to explain the reason for the rejection, so erroring out is a
user-unfriendly last resort.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfs4acl.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff .prev/fs/nfsd/nfs4acl.c ./fs/nfsd/nfs4acl.c
--- .prev/fs/nfsd/nfs4acl.c	2007-02-13 09:50:26.000000000 +1100
+++ ./fs/nfsd/nfs4acl.c	2007-02-13 10:01:42.000000000 +1100
@@ -61,9 +61,11 @@
 
 /* flags used to simulate posix default ACLs */
 #define NFS4_INHERITANCE_FLAGS (NFS4_ACE_FILE_INHERIT_ACE \
-		| NFS4_ACE_DIRECTORY_INHERIT_ACE | NFS4_ACE_INHERIT_ONLY_ACE)
+		| NFS4_ACE_DIRECTORY_INHERIT_ACE)
 
-#define NFS4_SUPPORTED_FLAGS (NFS4_INHERITANCE_FLAGS | NFS4_ACE_IDENTIFIER_GROUP)
+#define NFS4_SUPPORTED_FLAGS (NFS4_INHERITANCE_FLAGS \
+		| NFS4_ACE_INHERIT_ONLY_ACE \
+		| NFS4_ACE_IDENTIFIER_GROUP)
 
 #define MASK_EQUAL(mask1, mask2) \
 	( ((mask1) & NFS4_ACE_MASK_ALL) == ((mask2) & NFS4_ACE_MASK_ALL) )
@@ -707,11 +709,16 @@ nfs4_acl_split(struct nfs4_acl *acl, str
 		if (ace->flag & ~NFS4_SUPPORTED_FLAGS)
 			return -EINVAL;
 
-		switch (ace->flag & NFS4_INHERITANCE_FLAGS) {
-		case 0:
+		if ((ace->flag & NFS4_INHERITANCE_FLAGS) == 0) {
 			/* Leave this ace in the effective acl: */
 			continue;
-		case NFS4_INHERITANCE_FLAGS:
+		}
+		/*
+		 * Note that when only one of FILE_INHERIT or DIRECTORY_INHERIT
+		 * is set, we're effectively turning on the other.  That's OK,
+		 * according to rfc 3530.
+		 */
+		if (ace->flag & NFS4_ACE_INHERIT_ONLY_ACE) {
 			/* Add this ace to the default acl and remove it
 			 * from the effective acl: */
 			error = nfs4_acl_add_ace(dacl, ace->type, ace->flag,
@@ -721,17 +728,13 @@ nfs4_acl_split(struct nfs4_acl *acl, str
 			list_del(h);
 			kfree(ace);
 			acl->naces--;
-			break;
-		case NFS4_INHERITANCE_FLAGS & ~NFS4_ACE_INHERIT_ONLY_ACE:
+		} else {
 			/* Add this ace to the default, but leave it in
 			 * the effective acl as well: */
 			error = nfs4_acl_add_ace(dacl, ace->type, ace->flag,
 				ace->access_mask, ace->whotype, ace->who);
 			if (error)
 				return error;
-			break;
-		default:
-			return -EINVAL;
 		}
 	}
 	return 0;
