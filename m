Return-Path: <linux-kernel-owner+w=401wt.eu-S1751544AbZLUXoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbZLUXoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 18:44:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbZLUXoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 18:44:10 -0500
Received: from ozlabs.org ([203.10.76.45]:47498 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbZLUXoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 18:44:07 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Fix BUILD_BUG_ON in fs/compat_ioctl.c to build with gcc 4.5 snapshot
Date: Tue, 22 Dec 2009 10:14:02 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; i686; ; )
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, rguenther@suse.de, arnd@arndb.de
References: <20091220165315.GA13208@basil.fritz.box> <200912212102.39878.rusty@rustcorp.com.au> <20091221105138.GD25372@basil.fritz.box>
In-Reply-To: <20091221105138.GD25372@basil.fritz.box>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912221014.02545.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Dec 2009 09:21:39 pm Andi Kleen wrote:
> On Mon, Dec 21, 2009 at 09:02:39PM +1030, Rusty Russell wrote:
> > On Mon, 21 Dec 2009 03:23:15 am Andi Kleen wrote:
> > > Fix BUILD_BUG_ON in fs/compat_ioctl.c to build with gcc 4.5 snapshot
> > > 
> > > The BUILD_BUG_ON in compat_ioctl_check_table() fails
> > > with a recent gcc mainline snapshot (gcc version 4.5.0 20091219)
> > > (GCC)), even though it works with older compilers.
> > 
> > We have a proper fix for BUILD_BUG_ON which I sent Linus a pull req for,
> > but I think it was too late:
> > 
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git BUILD_BUG_ON
> > 
> > It's not really high priority, but it'd be nice to fix this properly.
> 
> AFAIK the code I fixed was not correct in the first place because
> "const int xxx" is not a constant expression in the standards sense.
> 
> So it's orthogonal to whatever changes you come up.

No, it's solving the same problem, generically.  There are numerous places
where we want to use BUILD_BUG_ON() but we don't have a constant expression.
Look for MAYBE_BUILD_BUG_ON().

Subject: BUILD_BUG_ON: make it handle more cases

BUILD_BUG_ON used to use the optimizer to do code elimination or fail
at link time; it was changed to first the size of a negative array (a
nicer compile time error), then (in
8c87df457cb58fe75b9b893007917cf8095660a0) to a bitfield.

bitfields: needs a literal constant at parse time, and can't be put under
	"if (__builtin_constant_p(x))" for example.
negative array: can handle anything, but if the compiler can't tell it's
	a constant, silently has no effect.
link time: breaks link if the compiler can't determine the value, but the
	linker output is not usually as informative as a compiler error.

If we use the negative-array-size method *and* the link time trick,
we get the ability to use BUILD_BUG_ON() under __builtin_constant_p()
branches, and maximal ability for the compiler to detect errors at
build time.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Hollis Blanchard <hollisb@us.ibm.com>
---
 include/linux/kernel.h |   33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -683,12 +683,6 @@ struct sysinfo {
 	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
 };
 
-/* Force a compilation error if condition is true */
-#define BUILD_BUG_ON(condition) ((void)BUILD_BUG_ON_ZERO(condition))
-
-/* Force a compilation error if condition is constant and true */
-#define MAYBE_BUILD_BUG_ON(cond) ((void)sizeof(char[1 - 2 * !!(cond)]))
-
 /* Force a compilation error if condition is true, but also produce a
    result (of value 0 and type size_t), so the expression can be used
    e.g. in a structure initializer (or where-ever else comma expressions
@@ -696,6 +690,33 @@ struct sysinfo {
 #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
 #define BUILD_BUG_ON_NULL(e) ((void *)sizeof(struct { int:-!!(e); }))
 
+/**
+ * BUILD_BUG_ON - break compile if a condition is true.
+ * @cond: the condition which the compiler should know is false.
+ *
+ * If you have some code which relies on certain constants being equal, or
+ * other compile-time-evaluated condition, you should use BUILD_BUG_ON to
+ * detect if someone changes it.
+ *
+ * The implementation uses gcc's reluctance to create a negative array, but
+ * gcc (as of 4.4) only emits that error for obvious cases (eg. not arguments
+ * to inline functions).  So as a fallback we use the optimizer; if it can't
+ * prove the condition is false, it will cause a link error on the undefined
+ * "__build_bug_on_failed".  This error message can be harder to track down
+ * though, hence the two different methods.
+ */
+#ifndef __OPTIMIZE__
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
+#else
+extern int __build_bug_on_failed;
+#define BUILD_BUG_ON(condition)					\
+	do {							\
+		((void)sizeof(char[1 - 2*!!(condition)]));	\
+		if (condition) __build_bug_on_failed = 1;	\
+	} while(0)
+#endif
+#define MAYBE_BUILD_BUG_ON(condition) BUILD_BUG_ON(condition)
+
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
 
