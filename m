Return-Path: <linux-kernel-owner+w=401wt.eu-S1762205AbYCHBZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762205AbYCHBZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 20:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760054AbYCHBZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 20:25:05 -0500
Received: from smtp-out.google.com ([216.239.45.13]:56885 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759950AbYCHBZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 20:25:02 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=uSYqsPdtXtjArJ/uXwFJylYab/TLsihSZA0k7FrBEXWL83QAeUi/XHtjz4fUvE4px
	bFw7O+okbZJT8eSDsfMbQ==
Date: Fri, 7 Mar 2008 17:24:15 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [patch -mm 2/2] mempolicy: use default_policy mode instead of
 MPOL_DEFAULT
In-Reply-To: <alpine.DEB.1.00.0803071720460.4611@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0803071722170.4611@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0803071720460.4611@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

default_policy is defined in mm/mempolicy.c as the default system policy:

	struct mempolicy default_policy = {
		.refcnt = ATOMIC_INIT(1),
		.policy = MPOL_DEFAULT,
	};

So instead of checking for comparisons against a mempolicy's mode to
MPOL_DEFAULT or falling back stricly to MPOL_DEFAULT throughout the code,
we should use the mode that is defined in this struct.

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/mempolicy.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -185,7 +185,7 @@ static struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
 			return ERR_PTR(-EINVAL);
 	} else if (nodes && nodes_empty(*nodes))
 		return ERR_PTR(-EINVAL);
-	if (mode == MPOL_DEFAULT)
+	if (mode == default_policy.policy)
 		return NULL;
 	policy = kmem_cache_alloc(policy_cache, GFP_KERNEL);
 	if (!policy)
@@ -1232,7 +1232,7 @@ static struct mempolicy * get_vma_policy(struct task_struct *task,
 			pol = vma->vm_ops->get_policy(vma, addr);
 			shared_pol = 1;	/* if pol non-NULL, add ref below */
 		} else if (vma->vm_policy &&
-				vma->vm_policy->policy != MPOL_DEFAULT)
+			   vma->vm_policy->policy != default_policy.policy)
 			pol = vma->vm_policy;
 	}
 	if (!pol)
@@ -1588,7 +1588,7 @@ void __mpol_free(struct mempolicy *p)
 {
 	if (!atomic_dec_and_test(&p->refcnt))
 		return;
-	p->policy = MPOL_DEFAULT;
+	p->policy = default_policy.policy;
 	kmem_cache_free(policy_cache, p);
 }
 
@@ -1752,10 +1752,10 @@ void mpol_shared_policy_init(struct shared_policy *info, unsigned short policy,
 	info->root = RB_ROOT;
 	spin_lock_init(&info->lock);
 
-	if (policy != MPOL_DEFAULT) {
+	if (policy != default_policy.policy) {
 		struct mempolicy *newpol;
 
-		/* Falls back to MPOL_DEFAULT on any error */
+		/* Falls back to default_policy on any error */
 		newpol = mpol_new(policy, flags, policy_nodes);
 		if (!IS_ERR(newpol)) {
 			/* Create pseudo-vma that contains just the policy */
@@ -1860,7 +1860,7 @@ void __init numa_policy_init(void)
 /* Reset policy of current process to default */
 void numa_default_policy(void)
 {
-	do_set_mempolicy(MPOL_DEFAULT, 0, NULL);
+	do_set_mempolicy(default_policy.policy, 0, NULL);
 }
 
 /*
