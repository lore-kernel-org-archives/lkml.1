Return-Path: <linux-kernel-owner+w=401wt.eu-S1762079AbYBOXqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762079AbYBOXqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 18:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757155AbYBOXqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 18:46:04 -0500
Received: from relay1.sgi.com ([192.48.171.29]:52350 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754387AbYBOXqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 18:46:01 -0500
Date: Fri, 15 Feb 2008 17:45:54 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
Message-Id: <20080215174554.92f14bac.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802151216330.19332@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
	<20080214040918.d735e920.pj@sgi.com>
	<alpine.DEB.1.00.0802141336590.6067@chino.kir.corp.google.com>
	<20080215032748.8b07e5eb.pj@sgi.com>
	<alpine.DEB.1.00.0802151216330.19332@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David responding to pj:
> > I don't think so.  It's not possible to detemine if exactly the low
> > eight bits of the 'policy' short are a valid mode, -however- that
> > "eight" is a spurious detail.  Remove it.
> 
> Sure it is, you can determine if the low MPOL_FLAG_SHIFT bits are a valid 
> mode by masking off the upper bits and testing if the result is >= 
> MPOL_MAX.

Sorry ... my response was ambiguous, so not surprisingly you read it
the other way than I intended it and missed my point.

Let me try this again.

Yes, if we drop that MPOL_FLAG_SHIFT, we can't tell if exactly the low
eight bits are valid, -however- we can still tell if the low bits not
used by our MPOL_F_* flag bits are valid, and that's sufficient.

I included a PATCH in my last reply, in order to demonstrate this.


> Well, it's still an implementation detail that needs to be explicitly 
> defined, otherwise we have no way to separate mode from flags when the 
> user passes in their int formal as part of either syscall.

No.

That is not an implementation detail that must be explicitly defined
in order to separate the mode from the flags.

One can separate out the high order flag bits by simply masking them off.


> We should make sure to return -EINVAL to a user specifying an invalid flag 
> if, for example, they are using an older kernel that doesn't support what 
> they're asking for.

I agree that we must return -EINVAL if the user specifies an invalid
flag.  I have always agreed with this.

======

> It would be possible to do all of this in both sys_set_mempolicy() and 
> sys_mbind() by masking off the set of possible modes and checking the 
> result for being >= MPOL_MAX:

    Bingo!!

That's what I've been saying all along.

I'm not quite sure how we got here; this seems to me such a sharp turn
from what went before that I fear I've misread you, but I suppose I
should just be glad we're in agreement, despite the strange journey.

You go on to suggest a couple of variations of this check, by first
masking off the high order flag bits:

	if ((mode & MPOL_MODE_FLAGS) >= MPOL_MAX)
		return -EINVAL;

and then, in a follow-on message, refining that line of thought with:

	unsigned short flags;

	flags = mode & MPOL_MODE_FLAGS;
	mode &= ~MPOL_MODE_FLAGS;
	if (mode < 0 || mode >= MPOL_MAX)
		return -EINVAL;

Actually, I don't think you need to add either variation, as I think you
-already- have that check, in both sys_mbind() and sys_set_mempolicy(),
as the check:

        if (mpol_mode(mode) >= MPOL_MAX)
                return -EINVAL;

With one minor tweak (changing the return type of mpol_mode() from
uchar to ushort), here again is the PATCH of my last reply, with this
check present (actually, it's a check of yours, unchanged from what has
been in your patch for days now).

Does this PATCH do what you have in mind?

---
 include/linux/mempolicy.h |   30 +++++++++++++++++-------------
 mm/mempolicy.c            |    6 ------
 2 files changed, 17 insertions(+), 19 deletions(-)

--- 2.6.24-mm1.orig/include/linux/mempolicy.h	2008-02-15 00:11:10.000000000 -0800
+++ 2.6.24-mm1/include/linux/mempolicy.h	2008-02-15 15:16:16.031031424 -0800
@@ -8,6 +8,14 @@
  * Copyright 2003,2004 Andi Kleen SuSE Labs
  */
 
+/*
+ * The 'policy' field of 'struct mempolicy' has both a mode and
+ * some flags packed into it.  The flags (MPOL_F_* below) occupy
+ * the high bit positions (MPOL_MODE_FLAGS), and the mempolicy
+ * modes (the "Policies" below) are encoded in the remaining low
+ * bit positions.
+ */
+
 /* Policies */
 enum {
 	MPOL_DEFAULT,
@@ -18,16 +26,12 @@ enum {
 };
 
 /*
- * The lower MPOL_FLAG_SHIFT bits of the policy mode represent the MPOL_*
- * constants defined in the above enum.  The upper bits represent optional
- * set_mempolicy() or mbind() MPOL_F_* mode flags.
+ * Optional flags that modify nodemask numbering.
  */
-#define MPOL_FLAG_SHIFT		(8)
-#define MPOL_MODE_MASK		((1 << MPOL_FLAG_SHIFT) - 1)
-
-/* Flags for set_mempolicy */
-#define MPOL_F_STATIC_NODES	(1 << MPOL_FLAG_SHIFT)
-#define MPOL_MODE_FLAGS		(MPOL_F_STATIC_NODES)	/* legal set_mempolicy() MPOL_F_* flags */
+#define MPOL_F_RELATIVE_NODES (1<<14)		/* remapped relative to cpuset */
+#define MPOL_F_STATIC_NODES (1<<15)		/* unremapped physical masks */
+#define MPOL_MODE_FLAGS (MPOL_F_RELATIVE_NODES|MPOL_F_STATIC_NODES)
+						/* combined MPOL_F_* mask flags */
 
 /* Flags for get_mempolicy */
 #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
@@ -128,14 +132,14 @@ static inline int mpol_equal(struct memp
 
 #define mpol_set_vma_default(vma) ((vma)->vm_policy = NULL)
 
-static inline unsigned char mpol_mode(unsigned short mode)
+static inline unsigned short mpol_mode(unsigned short mode)
 {
-	return mode & MPOL_MODE_MASK;
+	return mode & ~MPOL_MODE_FLAGS;
 }
 
 static inline unsigned short mpol_flags(unsigned short mode)
 {
-	return mode & ~MPOL_MODE_MASK;
+	return mode & MPOL_MODE_FLAGS;
 }
 
 /*
@@ -201,7 +205,7 @@ static inline int mpol_equal(struct memp
 
 #define mpol_set_vma_default(vma) do {} while(0)
 
-static inline unsigned char mpol_mode(unsigned short mode)
+static inline unsigned short mpol_mode(unsigned short mode)
 {
 	return 0;
 }
--- 2.6.24-mm1.orig/mm/mempolicy.c	2008-02-15 00:18:35.000000000 -0800
+++ 2.6.24-mm1/mm/mempolicy.c	2008-02-15 08:16:52.034431591 -0800
@@ -884,8 +884,6 @@ asmlinkage long sys_mbind(unsigned long 
 
 	if (mpol_mode(mode) >= MPOL_MAX)
 		return -EINVAL;
-	if (mpol_flags(mode) & ~MPOL_MODE_FLAGS)
-		return -EINVAL;
 	err = get_nodes(&nodes, nmask, maxnode);
 	if (err)
 		return err;
@@ -898,13 +896,9 @@ asmlinkage long sys_set_mempolicy(int mo
 {
 	int err;
 	nodemask_t nodes;
-	unsigned short flags;
 
 	if (mpol_mode(mode) >= MPOL_MAX)
 		return -EINVAL;
-	if (mpol_flags(mode) & ~MPOL_MODE_FLAGS)
-		return -EINVAL;
-	flags = mpol_flags(mode) & MPOL_MODE_FLAGS;
 	err = get_nodes(&nodes, nmask, maxnode);
 	if (err)
 		return err;


-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
