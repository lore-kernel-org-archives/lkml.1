Return-Path: <linux-kernel-owner+w=401wt.eu-S1765660AbYEAVe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765660AbYEAVe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:34:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932376AbYEAVej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:34:39 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:56656 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932569AbYEAVei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:34:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=LCOXr1puaqy+odJw40uZY64e8r5WNuwbfcK2Ck4JleWxNiUVVuejV0ax4LsN6rx6mskYknjlic53pasqfwOdFmojigUIlS62JIboBXV23GK/0+wLMmPDw1BM6Ru8GPwHblv0O6E/SdEEavDpPAKdTEggksxJAhGVsZri9+S6Fgk=
Date: Fri, 2 May 2008 02:29:50 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       lucho@ionkov.net, ericvh@gmail.com
Subject: Re: [PATCH] fix flags length in net 9p
Message-ID: <20080501222950.GA16470@martell.zuzino.mipt.ru>
References: <Pine.LNX.4.58.0805011706070.12785@gandalf.stny.rr.com> <20080501141919.78b7dc4f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501141919.78b7dc4f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 02:19:19PM -0700, Andrew Morton wrote:
> On Thu, 1 May 2008 17:08:05 -0400 (EDT)
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Some files in the net/9p directory uses "int" for flags. This can
> > cause hard to find bugs on some architectures. This patch converts the
> > flags to use "long" instead.
> 
> gargh.
> 
> > This bug was discovered by doing an allyesconfig make on the -rt kernel
> > where checks are done to ensure all flags are of size sizeof(long).
> 
> I was about to suggest that we do something like that...
> 
> I wonder how messy it is.  I long ago lost the ability to follow the
> convolutions in include/linux/spinlock*.h :(  gotta patch?

Me, me, take me back!


commit ee3ce191e8eaa4cc15c51a28b34143b36404c4f5
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Sat Nov 25 11:09:36 2006 -0800

    [PATCH] Enforce "unsigned long flags;" when spinlocking
    
    Make it break or warn if you pass to spin_lock_irqsave() and friends
    something different from "unsigned long flags;".  Suprisingly large amount
    of these was caught by recent commit
    c53421b18f205c5f97c604ae55c6a921f034b0f6 and others.
    
    Idea is largely from FRV typechecking. Suggestions from Andrew Morton.
    All stupid typos in first version fixed.
    
    Passes allmodconfig on i386, x86_64, alpha, arm as well as my usual config.
    
    Note #1: checking with sparse is still needed, because a driver can save
    	 and pass around flags or something. So far patch is very intrusive.
    Note #2: techically, we should break only if
    		sizeof(flags) < sizeof(unsigned long),
    	 however, the more pain for getting suspicious code into kernel,
    	 the better.
    
    Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Andrew Morton <akpm@osdl.org>
    Signed-off-by: Linus Torvalds <torvalds@osdl.org>

diff --git a/include/linux/irqflags.h b/include/linux/irqflags.h
index 412e025..4fe740b 100644
--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -11,6 +11,12 @@
 #ifndef _LINUX_TRACE_IRQFLAGS_H
 #define _LINUX_TRACE_IRQFLAGS_H
 
+#define BUILD_CHECK_IRQ_FLAGS(flags)					\
+	do {								\
+		BUILD_BUG_ON(sizeof(flags) != sizeof(unsigned long));	\
+		typecheck(unsigned long, flags);			\
+	} while (0)
+
 #ifdef CONFIG_TRACE_IRQFLAGS
   extern void trace_hardirqs_on(void);
   extern void trace_hardirqs_off(void);
@@ -50,10 +56,15 @@
 #define local_irq_disable() \
 	do { raw_local_irq_disable(); trace_hardirqs_off(); } while (0)
 #define local_irq_save(flags) \
-	do { raw_local_irq_save(flags); trace_hardirqs_off(); } while (0)
+	do {					\
+		BUILD_CHECK_IRQ_FLAGS(flags);	\
+		raw_local_irq_save(flags);	\
+		trace_hardirqs_off();		\
+	} while (0)
 
 #define local_irq_restore(flags)				\
 	do {							\
+		BUILD_CHECK_IRQ_FLAGS(flags);			\
 		if (raw_irqs_disabled_flags(flags)) {		\
 			raw_local_irq_restore(flags);		\
 			trace_hardirqs_off();			\
@@ -69,8 +80,16 @@
  */
 # define raw_local_irq_disable()	local_irq_disable()
 # define raw_local_irq_enable()		local_irq_enable()
-# define raw_local_irq_save(flags)	local_irq_save(flags)
-# define raw_local_irq_restore(flags)	local_irq_restore(flags)
+# define raw_local_irq_save(flags)		\
+	do {					\
+		BUILD_CHECK_IRQ_FLAGS(flags);	\
+		local_irq_save(flags);		\
+	} while (0)
+# define raw_local_irq_restore(flags)		\
+	do {					\
+		BUILD_CHECK_IRQ_FLAGS(flags);	\
+		local_irq_restore(flags);	\
+	} while (0)
 #endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */
 
 #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
@@ -80,7 +99,11 @@
 		raw_safe_halt();				\
 	} while (0)
 
-#define local_save_flags(flags)		raw_local_save_flags(flags)
+#define local_save_flags(flags)			\
+	do {					\
+		BUILD_CHECK_IRQ_FLAGS(flags);	\
+		raw_local_save_flags(flags);	\
+	} while (0)
 
 #define irqs_disabled()						\
 ({								\
@@ -90,7 +113,11 @@
 	raw_irqs_disabled_flags(flags);				\
 })
 
-#define irqs_disabled_flags(flags)	raw_irqs_disabled_flags(flags)
+#define irqs_disabled_flags(flags)	\
+({					\
+	BUILD_CHECK_IRQ_FLAGS(flags);	\
+	raw_irqs_disabled_flags(flags);	\
+})
 #endif		/* CONFIG_X86 */
 
 #endif
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index b800d2d..54ad370 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -52,6 +52,7 @@
 #include <linux/thread_info.h>
 #include <linux/kernel.h>
 #include <linux/stringify.h>
+#include <linux/irqflags.h>
 
 #include <asm/system.h>
 
@@ -183,13 +184,37 @@ do {								\
 #define read_lock(lock)			_read_lock(lock)
 
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-#define spin_lock_irqsave(lock, flags)	flags = _spin_lock_irqsave(lock)
-#define read_lock_irqsave(lock, flags)	flags = _read_lock_irqsave(lock)
-#define write_lock_irqsave(lock, flags)	flags = _write_lock_irqsave(lock)
+#define spin_lock_irqsave(lock, flags)			\
+	do {						\
+		BUILD_CHECK_IRQ_FLAGS(flags);		\
+		flags = _spin_lock_irqsave(lock);	\
+	} while (0)
+#define read_lock_irqsave(lock, flags)			\
+	do {						\
+		BUILD_CHECK_IRQ_FLAGS(flags);		\
+		flags = _read_lock_irqsave(lock);	\
+	} while (0)
+#define write_lock_irqsave(lock, flags)			\
+	do {						\
+		BUILD_CHECK_IRQ_FLAGS(flags);		\
+		flags = _write_lock_irqsave(lock);	\
+	} while (0)
 #else
-#define spin_lock_irqsave(lock, flags)	_spin_lock_irqsave(lock, flags)
-#define read_lock_irqsave(lock, flags)	_read_lock_irqsave(lock, flags)
-#define write_lock_irqsave(lock, flags)	_write_lock_irqsave(lock, flags)
+#define spin_lock_irqsave(lock, flags)			\
+	do {						\
+		BUILD_CHECK_IRQ_FLAGS(flags);		\
+		_spin_lock_irqsave(lock, flags);	\
+	} while (0)
+#define read_lock_irqsave(lock, flags)			\
+	do {						\
+		BUILD_CHECK_IRQ_FLAGS(flags);		\
+		_read_lock_irqsave(lock, flags);	\
+	} while (0)
+#define write_lock_irqsave(lock, flags)			\
+	do {						\
+		BUILD_CHECK_IRQ_FLAGS(flags);		\
+		_write_lock_irqsave(lock, flags);	\
+	} while (0)
 #endif
 
 #define spin_lock_irq(lock)		_spin_lock_irq(lock)
@@ -225,15 +250,24 @@ do {								\
 #endif
 
 #define spin_unlock_irqrestore(lock, flags) \
-					_spin_unlock_irqrestore(lock, flags)
+	do {						\
+		BUILD_CHECK_IRQ_FLAGS(flags);		\
+		_spin_unlock_irqrestore(lock, flags);	\
+	} while (0)
 #define spin_unlock_bh(lock)		_spin_unlock_bh(lock)
 
 #define read_unlock_irqrestore(lock, flags) \
-					_read_unlock_irqrestore(lock, flags)
+	do {						\
+		BUILD_CHECK_IRQ_FLAGS(flags);		\
+		_read_unlock_irqrestore(lock, flags);	\
+	} while (0)
 #define read_unlock_bh(lock)		_read_unlock_bh(lock)
 
 #define write_unlock_irqrestore(lock, flags) \
-					_write_unlock_irqrestore(lock, flags)
+	do {						\
+		BUILD_CHECK_IRQ_FLAGS(flags);		\
+		_write_unlock_irqrestore(lock, flags);	\
+	} while (0)
 #define write_unlock_bh(lock)		_write_unlock_bh(lock)
 
 #define spin_trylock_bh(lock)	__cond_lock(lock, _spin_trylock_bh(lock))
@@ -247,6 +281,7 @@ do {								\
 
 #define spin_trylock_irqsave(lock, flags) \
 ({ \
+	BUILD_CHECK_IRQ_FLAGS(flags); \
 	local_irq_save(flags); \
 	spin_trylock(lock) ? \
 	1 : ({ local_irq_restore(flags); 0; }); \



Seriously, if people can suggest _good_ *** for the following idiom

	flags = spin_lock_irq***(&lock);
		...
	spin_unlock_irqrestore(&lock, flags);

I can do tree-wide conversion with irq_flags_t and new locking
primitive.

If people can't, I can do just irq_flags_t conversion and enforce build
breakage if one use something other than irq_flags_t .

