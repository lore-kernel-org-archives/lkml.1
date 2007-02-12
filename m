Return-Path: <linux-kernel-owner+w=401wt.eu-S1030509AbXBLXqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030509AbXBLXqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 18:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030508AbXBLXqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 18:46:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55186 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030518AbXBLXpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 18:45:44 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 13 Feb 2007 10:45:07 +1100
Message-Id: <1070212234507.29358@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 009 of 9] knfsd: nfsd4: fix handling of directories without default ACLs
References: <20070213103941.28958.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: J. Bruce Fields <bfields@citi.umich.edu>
When setting an ACL that lacks inheritable ACEs on a directory, we
should set a default ACL of zero length, not a default ACL with all bits
denied.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/nfs4acl.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff .prev/fs/nfsd/nfs4acl.c ./fs/nfsd/nfs4acl.c
--- .prev/fs/nfsd/nfs4acl.c	2007-02-13 10:38:09.000000000 +1100
+++ ./fs/nfsd/nfs4acl.c	2007-02-13 10:38:26.000000000 +1100
@@ -416,6 +416,7 @@ struct posix_ace_state_array {
  * calculated so far: */
 
 struct posix_acl_state {
+	int empty;
 	struct posix_ace_state owner;
 	struct posix_ace_state group;
 	struct posix_ace_state other;
@@ -431,6 +432,7 @@ init_state(struct posix_acl_state *state
 	int alloc;
 
 	memset(state, 0, sizeof(struct posix_acl_state));
+	state->empty = 1;
 	/*
 	 * In the worst case, each individual acl could be for a distinct
 	 * named user or group, but we don't no which, so we allocate
@@ -498,6 +500,20 @@ posix_state_to_acl(struct posix_acl_stat
 	int nace;
 	int i, error = 0;
 
+	/*
+	 * ACLs with no ACEs are treated differently in the inheritable
+	 * and effective cases: when there are no inheritable ACEs, we
+	 * set a zero-length default posix acl:
+	 */
+	if (state->empty && (flags & NFS4_ACL_TYPE_DEFAULT)) {
+		pacl = posix_acl_alloc(0, GFP_KERNEL);
+		return pacl ? pacl : ERR_PTR(-ENOMEM);
+	}
+	/*
+	 * When there are no effective ACEs, the following will end
+	 * up setting a 3-element effective posix ACL with all
+	 * permissions zero.
+	 */
 	nace = 4 + state->users->n + state->groups->n;
 	pacl = posix_acl_alloc(nace, GFP_KERNEL);
 	if (!pacl)
@@ -613,6 +629,8 @@ static void process_one_v4_ace(struct po
 	u32 mask = ace->access_mask;
 	int i;
 
+	state->empty = 0;
+
 	switch (ace2type(ace)) {
 	case ACL_USER_OBJ:
 		if (ace->type == NFS4_ACE_ACCESS_ALLOWED_ACE_TYPE) {
@@ -717,7 +735,8 @@ int nfs4_acl_nfsv4_to_posix(struct nfs4_
 		ret = PTR_ERR(*pacl);
 		goto out_dstate;
 	}
-	*dpacl = posix_state_to_acl(&default_acl_state, flags);
+	*dpacl = posix_state_to_acl(&default_acl_state,
+						flags | NFS4_ACL_TYPE_DEFAULT);
 	if (IS_ERR(*dpacl)) {
 		ret = PTR_ERR(*dpacl);
 		posix_acl_release(*pacl);
