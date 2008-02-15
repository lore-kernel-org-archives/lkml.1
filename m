Return-Path: <linux-kernel-owner+w=401wt.eu-S1761468AbYBOJ3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761468AbYBOJ3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 04:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933006AbYBOJ17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 04:27:59 -0500
Received: from relay2.sgi.com ([192.48.171.30]:50585 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932633AbYBOJ1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 04:27:54 -0500
Date: Fri, 15 Feb 2008 03:27:48 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
Message-Id: <20080215032748.8b07e5eb.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802141336590.6067@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
	<20080214040918.d735e920.pj@sgi.com>
	<alpine.DEB.1.00.0802141336590.6067@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> But without MPOL_FLAG_SHIFT it becomes 
> impossible to determine whether a user passed an invalid flag.

I don't think so.  It's not possible to detemine if exactly the low
eight bits of the 'policy' short are a valid mode, -however- that
"eight" is a spurious detail.  Remove it.

Instead of specifying that the 'policy' short consists of two bytes,
one for mode and one for flags, rather specify that the policy fields
consists of some high bits for flags, and the remaining low bits
(however many remain) for the mode.

That in turn exposes the opportunity to remove a couple of checks
for "(mpol_flags(mode) & ~MPOL_MODE_FLAGS)" being zero, and that
in turn makes it obvious that the 'flags' variable in
sys_set_mempolicy() is unused.

Consider the following patch, on top of the latest you sent me a day
ago.

---
 include/linux/mempolicy.h |   26 +++++++++++++++-----------
 mm/mempolicy.c            |    6 ------
 2 files changed, 15 insertions(+), 17 deletions(-)

--- 2.6.24-mm1.orig/include/linux/mempolicy.h	2008-02-15 00:11:10.000000000 -0800
+++ 2.6.24-mm1/include/linux/mempolicy.h	2008-02-15 01:13:51.597894429 -0800
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
@@ -130,12 +134,12 @@ static inline int mpol_equal(struct memp
 
 static inline unsigned char mpol_mode(unsigned short mode)
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
--- 2.6.24-mm1.orig/mm/mempolicy.c	2008-02-15 00:18:35.000000000 -0800
+++ 2.6.24-mm1/mm/mempolicy.c	2008-02-15 01:23:53.775748002 -0800
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
