Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393Ab0BDTcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:32:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45451 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758231Ab0BDTcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:32:31 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] PM: disable nonboot cpus before suspending devices
Date: Thu, 4 Feb 2010 20:33:01 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
References: <alpine.LFD.2.00.1001221841490.2266@localhost> <20100203172147.2411966d.akpm@linux-foundation.org> <20100203174150.192a417a.akpm@linux-foundation.org>
In-Reply-To: <20100203174150.192a417a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002042033.01192.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 February 2010, Andrew Morton wrote:
> On Wed, 3 Feb 2010 17:21:47 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Thu, 4 Feb 2010 01:50:26 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > --- linux-2.6.orig/mm/page_alloc.c
> > > +++ linux-2.6/mm/page_alloc.c
> > > @@ -76,6 +76,30 @@ unsigned long totalreserve_pages __read_
> > >  int percpu_pagelist_fraction;
> > >  gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
> > >  
> > > +/*
> > > + * The following functions are used by the suspend/hibernate code to temporarily
> > > + * change gfp_allowed_mask in order to avoid using I/O during memory allocations
> > > + * while devices are suspended.  To avoid races with the suspend/hibernate code,
> > > + * they should always be called with pm_mutex held (gfp_allowed_mask also should
> > > + * only be modified with pm_mutex held, unless the suspend/hibernate code is
> > > + * guaranteed not to run in parallel with that modification).
> > > + */
> > > +
> > > +void set_gfp_allowed_mask(gfp_t mask)
> > > +{
> > > +	WARN_ON(!mutex_is_locked(&pm_mutex));
> > > +	gfp_allowed_mask = mask;
> > > +}
> > > +
> > > +gfp_t clear_gfp_allowed_mask(gfp_t mask)
> > > +{
> > > +	gfp_t ret = gfp_allowed_mask;
> > > +
> > > +	WARN_ON(!mutex_is_locked(&pm_mutex));
> > > +	gfp_allowed_mask &= ~mask;
> > > +	return ret;
> > > +}
> > 
> > Maybe put an ifdef CONFIG_foo around these so they don't get included
> > when they're unneeded?
> > 
> 
> I guess this:
> 
> mm/built-in.o: In function `clear_gfp_allowed_mask':
> : undefined reference to `pm_mutex'
> mm/built-in.o: In function `set_gfp_allowed_mask':
> : undefined reference to `pm_mutex'
> 
> kinda answers my question.

Sorry about that.  I tend to forget about test-compiling with CONFIG_PM unset.

The one below shouldn't have this issue.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: MM / PM: Force GFP_NOIO during suspend/hibernation and resume (rev. 3)

There are quite a few GFP_KERNEL memory allocations made during
suspend/hibernation and resume that may cause the system to hang,
because the I/O operations they depend on cannot be completed due to
the underlying devices being suspended.

Mitigate this problem by clearing the __GFP_IO and __GFP_FS bits in
gfp_allowed_mask before suspend/hibernation and restoring the
original values of these bits in gfp_allowed_mask durig the
subsequent resume.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 include/linux/gfp.h      |    7 +++----
 init/main.c              |    2 +-
 kernel/power/hibernate.c |    9 +++++++++
 kernel/power/suspend.c   |    3 +++
 mm/page_alloc.c          |   26 ++++++++++++++++++++++++++
 5 files changed, 42 insertions(+), 5 deletions(-)

Index: linux-2.6/include/linux/gfp.h
===================================================================
--- linux-2.6.orig/include/linux/gfp.h
+++ linux-2.6/include/linux/gfp.h
@@ -83,6 +83,7 @@ struct vm_area_struct;
 #define GFP_HIGHUSER_MOVABLE	(__GFP_WAIT | __GFP_IO | __GFP_FS | \
 				 __GFP_HARDWALL | __GFP_HIGHMEM | \
 				 __GFP_MOVABLE)
+#define GFP_IOFS	(__GFP_IO | __GFP_FS)
 
 #ifdef CONFIG_NUMA
 #define GFP_THISNODE	(__GFP_THISNODE | __GFP_NOWARN | __GFP_NORETRY)
@@ -337,9 +338,7 @@ void drain_local_pages(void *dummy);
 
 extern gfp_t gfp_allowed_mask;
 
-static inline void set_gfp_allowed_mask(gfp_t mask)
-{
-	gfp_allowed_mask = mask;
-}
+extern void set_gfp_allowed_mask(gfp_t mask);
+extern gfp_t clear_gfp_allowed_mask(gfp_t mask);
 
 #endif /* __LINUX_GFP_H */
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -601,7 +601,7 @@ asmlinkage void __init start_kernel(void
 	local_irq_enable();
 
 	/* Interrupts are enabled now so all GFP allocations are safe. */
-	set_gfp_allowed_mask(__GFP_BITS_MASK);
+	gfp_allowed_mask = __GFP_BITS_MASK;
 
 	kmem_cache_init_late();
 
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -76,6 +76,32 @@ unsigned long totalreserve_pages __read_
 int percpu_pagelist_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 
+#ifdef CONFIG_PM_SLEEP
+/*
+ * The following functions are used by the suspend/hibernate code to temporarily
+ * change gfp_allowed_mask in order to avoid using I/O during memory allocations
+ * while devices are suspended.  To avoid races with the suspend/hibernate code,
+ * they should always be called with pm_mutex held (gfp_allowed_mask also should
+ * only be modified with pm_mutex held, unless the suspend/hibernate code is
+ * guaranteed not to run in parallel with that modification).
+ */
+
+void set_gfp_allowed_mask(gfp_t mask)
+{
+	WARN_ON(!mutex_is_locked(&pm_mutex));
+	gfp_allowed_mask = mask;
+}
+
+gfp_t clear_gfp_allowed_mask(gfp_t mask)
+{
+	gfp_t ret = gfp_allowed_mask;
+
+	WARN_ON(!mutex_is_locked(&pm_mutex));
+	gfp_allowed_mask &= ~mask;
+	return ret;
+}
+#endif /* CONFIG_PM_SLEEP */
+
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE
 int pageblock_order __read_mostly;
 #endif
Index: linux-2.6/kernel/power/hibernate.c
===================================================================
--- linux-2.6.orig/kernel/power/hibernate.c
+++ linux-2.6/kernel/power/hibernate.c
@@ -323,6 +323,7 @@ static int create_image(int platform_mod
 int hibernation_snapshot(int platform_mode)
 {
 	int error;
+	gfp_t saved_mask;
 
 	error = platform_begin(platform_mode);
 	if (error)
@@ -334,6 +335,7 @@ int hibernation_snapshot(int platform_mo
 		goto Close;
 
 	suspend_console();
+	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
 	error = dpm_suspend_start(PMSG_FREEZE);
 	if (error)
 		goto Recover_platform;
@@ -351,6 +353,7 @@ int hibernation_snapshot(int platform_mo
 
 	dpm_resume_end(in_suspend ?
 		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
+	set_gfp_allowed_mask(saved_mask);
 	resume_console();
  Close:
 	platform_end(platform_mode);
@@ -445,14 +448,17 @@ static int resume_target_kernel(bool pla
 int hibernation_restore(int platform_mode)
 {
 	int error;
+	gfp_t saved_mask;
 
 	pm_prepare_console();
 	suspend_console();
+	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
 	error = dpm_suspend_start(PMSG_QUIESCE);
 	if (!error) {
 		error = resume_target_kernel(platform_mode);
 		dpm_resume_end(PMSG_RECOVER);
 	}
+	set_gfp_allowed_mask(saved_mask);
 	resume_console();
 	pm_restore_console();
 	return error;
@@ -466,6 +472,7 @@ int hibernation_restore(int platform_mod
 int hibernation_platform_enter(void)
 {
 	int error;
+	gfp_t saved_mask;
 
 	if (!hibernation_ops)
 		return -ENOSYS;
@@ -481,6 +488,7 @@ int hibernation_platform_enter(void)
 
 	entering_platform_hibernation = true;
 	suspend_console();
+	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
 	error = dpm_suspend_start(PMSG_HIBERNATE);
 	if (error) {
 		if (hibernation_ops->recover)
@@ -518,6 +526,7 @@ int hibernation_platform_enter(void)
  Resume_devices:
 	entering_platform_hibernation = false;
 	dpm_resume_end(PMSG_RESTORE);
+	set_gfp_allowed_mask(saved_mask);
 	resume_console();
 
  Close:
Index: linux-2.6/kernel/power/suspend.c
===================================================================
--- linux-2.6.orig/kernel/power/suspend.c
+++ linux-2.6/kernel/power/suspend.c
@@ -198,6 +198,7 @@ static int suspend_enter(suspend_state_t
 int suspend_devices_and_enter(suspend_state_t state)
 {
 	int error;
+	gfp_t saved_mask;
 
 	if (!suspend_ops)
 		return -ENOSYS;
@@ -208,6 +209,7 @@ int suspend_devices_and_enter(suspend_st
 			goto Close;
 	}
 	suspend_console();
+	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
 	suspend_test_start();
 	error = dpm_suspend_start(PMSG_SUSPEND);
 	if (error) {
@@ -224,6 +226,7 @@ int suspend_devices_and_enter(suspend_st
 	suspend_test_start();
 	dpm_resume_end(PMSG_RESUME);
 	suspend_test_finish("resume devices");
+	set_gfp_allowed_mask(saved_mask);
 	resume_console();
  Close:
 	if (suspend_ops->end)
