Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbYL0X1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbYL0X1j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 18:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbYL0X1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 18:27:30 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44388 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754236AbYL0X1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 18:27:30 -0500
Date: Sat, 27 Dec 2008 15:27:31 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org, ralf@linux-mips.org, kernel@wantstofly.org,
       hskinnemoen@atmel.com, cooloney@kernel.org, tony.luck@intel.com,
       geert@linux-m68k.org, zippel@linux-m68k.org, jwboyer@linux.vnet.ibm.com,
       mporter@kernel.crashing.org, grant.likely@secretlab.ca,
       paulus@samba.org, benh@kernel.crashing.org, dhowells@redhat.com,
       yasutake.koichi@jp.panasonic.com, lethal@linux-sh.org, hpa@zytor.com
Subject: Re: [PATCH, -tip] Make hierarchical RCU be the default
Message-ID: <20081227232731.GC7041@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1229991147545-git-send-email-paulmck@linux.vnet.ibm.com> <12299911471985-git-send-email-paulmck@linux.vnet.ibm.com> <20081223142542.GC29151@elte.hu> <20081223215948.GA16137@linux.vnet.ibm.com> <20081223220345.GA16472@linux.vnet.ibm.com> <20081223220648.GB16472@linux.vnet.ibm.com> <20081227103501.GG14639@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227103501.GG14639@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 11:35:01AM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > --- a/include/linux/hardirq.h
> > +++ b/include/linux/hardirq.h
> > @@ -118,7 +118,7 @@ static inline void account_system_vtime(struct task_struct *tsk)
> >  }
> >  #endif
> >  
> > -#if defined(CONFIG_NO_HZ) && !defined(CONFIG_CLASSIC_RCU)
> > +#if defined(CONFIG_NO_HZ) && !defined(CONFIG_FLAT_RCU)
> 
> this can be done in an even lazier fashion, via a ~5 lines patch.

I clearly need serious help on this laziness thing.  ;-)

> Just add FLAT_RCU as the new kconfig method, and make CONFIG_CLASSIC_RCU 
> mirror it via something like:
> 
>   config CLASSIC_RCU
>   bool
>   default FLAT_RCU
> 
> that makes your patch only affect the Kconfig file - and makes it easily 
> revertable, etc.

OK.  But don't I also need "select FLAT_RCU" so that all of the
defconfig files containing "CLASSIC_RCU" do the right thing?  If I try
that, "make defconfig" complains as follows:

	init/Kconfig:941:error: found recursive dependency: FLAT_RCU -> CLASSIC_RCU -> FLAT_RCU -> <choice>

So unless I am missing a laziness opportunity in here somewhere, it
seems to me that I need to either (1) change all the arch files so that
what is now "CLASSIC_RCU" instead becomes "FLAT_RCU" or (2) change all
in-code references to "CLASSIC_RCU" to instead reference "FLAT_RCU".

Unless there is some other way out, option #2 seems to me to be the
lazier of the two, which is represented by the earlier patch.  This
patch, updated to handle the RCU choice moving to init/Kconfig, appears
below.  One consequence of this change is that RCU moves from the
"Processor type and features" menu to the top level is xconfig and
friends.

Which might be why Sam is suggesting HAVE_PREEMPT, which could allow it
to stay where it is?

If so, another alternative would be to add kernel/Kconfig.rcu, and add
it to all the arch/*/Kconfig files.  Then it would still appear in the
"Processor type and features" menu, but would also be available to all
arches.

Thoughts?

							Thanx, Paul

------------------------------------------------------------------------

This patch makes the new TREE_RCU be the default, pointing the old
CLASSIC_RCU Kconfig symbol at it and introducing a new FLAT_RCU symbol
to allow the old version to be selected.

This patch is -not- yet suitable for inclusion, only for testing in
-tip, -next, and the like.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 include/linux/hardirq.h  |    4 ++--
 include/linux/pagemap.h  |    4 ++--
 include/linux/rcupdate.h |    4 ++--
 init/Kconfig             |   14 ++++++++++----
 kernel/Makefile          |    2 +-
 lib/Kconfig.debug        |    2 +-
 6 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 9b70b92..0afd180 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -118,7 +118,7 @@ static inline void account_system_vtime(struct task_struct *tsk)
 }
 #endif
 
-#if defined(CONFIG_NO_HZ) && !defined(CONFIG_CLASSIC_RCU)
+#if defined(CONFIG_NO_HZ) && !defined(CONFIG_FLAT_RCU)
 extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
 extern void rcu_nmi_enter(void);
@@ -128,7 +128,7 @@ extern void rcu_nmi_exit(void);
 # define rcu_irq_exit() do { } while (0)
 # define rcu_nmi_enter() do { } while (0)
 # define rcu_nmi_exit() do { } while (0)
-#endif /* #if defined(CONFIG_NO_HZ) && !defined(CONFIG_CLASSIC_RCU) */
+#endif /* #if defined(CONFIG_NO_HZ) && !defined(CONFIG_FLAT_RCU) */
 
 /*
  * It is safe to do non-atomic ops on ->hardirq_context,
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 709742b..5cfb133 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -140,7 +140,7 @@ static inline int page_cache_get_speculative(struct page *page)
 {
 	VM_BUG_ON(in_interrupt());
 
-#if !defined(CONFIG_SMP) && defined(CONFIG_CLASSIC_RCU)
+#if !defined(CONFIG_SMP) && defined(CONFIG_FLAT_RCU)
 # ifdef CONFIG_PREEMPT
 	VM_BUG_ON(!in_atomic());
 # endif
@@ -178,7 +178,7 @@ static inline int page_cache_add_speculative(struct page *page, int count)
 {
 	VM_BUG_ON(in_interrupt());
 
-#if !defined(CONFIG_SMP) && defined(CONFIG_CLASSIC_RCU)
+#if !defined(CONFIG_SMP) && defined(CONFIG_FLAT_RCU)
 # ifdef CONFIG_PREEMPT
 	VM_BUG_ON(!in_atomic());
 # endif
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index bfd289a..819bf83 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -52,7 +52,7 @@ struct rcu_head {
 	void (*func)(struct rcu_head *head);
 };
 
-#if defined(CONFIG_CLASSIC_RCU)
+#if defined(CONFIG_FLAT_RCU)
 #include <linux/rcuclassic.h>
 #elif defined(CONFIG_TREE_RCU)
 #include <linux/rcutree.h>
@@ -60,7 +60,7 @@ struct rcu_head {
 #include <linux/rcupreempt.h>
 #else
 #error "Unknown RCU implementation specified to kernel configuration"
-#endif /* #else #if defined(CONFIG_CLASSIC_RCU) */
+#endif /* #else #if defined(CONFIG_FLAT_RCU) */
 
 #define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL }
 #define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
diff --git a/init/Kconfig b/init/Kconfig
index 6b0fded..58d6575 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -928,16 +928,22 @@ source "block/Kconfig"
 config PREEMPT_NOTIFIERS
 	bool
 
+config CLASSIC_RCU
+	bool
+	select TREE_RCU
+
 choice
 	prompt "RCU Implementation"
-	default CLASSIC_RCU
+	default TREE_RCU
 
-config CLASSIC_RCU
-	bool "Classic RCU"
+config FLAT_RCU
+	bool "Flat (AKA classic) RCU"
 	help
 	  This option selects the classic RCU implementation that is
 	  designed for best read-side performance on non-realtime
-	  systems.
+	  systems with modest numbers of CPUs.  Its flat bit-map
+	  implementation makes it unsuitable for systems with hundreds
+	  or thousands of CPUs.
 
 	  Select this option if you are unsure.
 
diff --git a/kernel/Makefile b/kernel/Makefile
index b4fdbbf..73e9a94 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -73,7 +73,7 @@ obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
-obj-$(CONFIG_CLASSIC_RCU) += rcuclassic.o
+obj-$(CONFIG_FLAT_RCU) += rcuclassic.o
 obj-$(CONFIG_TREE_RCU) += rcutree.o
 obj-$(CONFIG_PREEMPT_RCU) += rcupreempt.o
 obj-$(CONFIG_TREE_RCU_TRACE) += rcutree_trace.o
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 465d822..a036720 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -621,7 +621,7 @@ config RCU_CPU_STALL_DETECTOR
 
 config RCU_CPU_STALL_DETECTOR
 	bool "Check for stalled CPUs delaying RCU grace periods"
-	depends on CLASSIC_RCU || TREE_RCU
+	depends on TREE_RCU || FLAT_RCU
 	default n
 	help
 	  This option causes RCU to printk information on which
