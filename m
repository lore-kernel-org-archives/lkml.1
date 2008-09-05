Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbYIEK6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbYIEK6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 06:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYIEK5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 06:57:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57708 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbYIEK5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 06:57:50 -0400
Date: Fri, 5 Sep 2008 12:57:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Rui Sousa <rui.p.m.sousa@gmail.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       Jeff Dike <jdike@addtoit.com>, Alexander Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATH] Fix compilation when CONFIG_TRACE_IRQFLAGS_SUPPORT is
	not set
Message-ID: <20080905105721.GD17776@elte.hu>
References: <200809031753.07292.rui.p.m.sousa@gmail.com> <20080904143918.GA28095@elte.hu> <48C0175B.3070500@ct.jp.nec.com> <200809041947.54339.rui.p.m.sousa@gmail.com> <48C0291D.6060205@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C0291D.6060205@ct.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> Rui Sousa wrote:
> > On Thursday 4 September 2008 19:14, Hiroshi Shimamoto wrote:
> >> Ingo Molnar wrote:
> >>> * Rui Sousa <rui.p.m.sousa@gmail.com> wrote:
> >>>> Hi,
> >>>>
> >>>> This patch fixes compilation if CONFIG_TRACE_IRQFLAGS_SUPPORT is ever
> >>>> disabled (which is currently not allowed by Kconfig). Alternatively we
> >>>> could just remove the option altogether and the associated code paths.
> >>>> Since the compilation error has been in the tree for at least two
> >>>> years and no one noticed it, I guess we don't really have the need for
> >>>> CONFIG_TRACE_IRQFLAGS_SUPPORT=n. Boot tested on x86 UP.
> >>> applied to tip/core/locking - thanks Rui.
> >>>
> >>> since you fixed it i prefer the fix over the removal. We could still
> >>> remove the !TRACE_IRQFLAGS_SUPPORT now (in a separate commit) and
> >>> simpify this header a bit that way. Thus if someone needs the
> >>> !TRACE_IRQFLAGS_SUPPORT mode of build for future work, it can be
> >>> restored via a simple revert.
> >> Hi, it seems that this patch breaks uml build.
> > 
> > Hi Hiroshi,
> > 
> >> kernel/printk.c: In function 'vprintk':
> >> kernel/printk.c:674: error: implicit declaration of function
> >> 'raw_local_irq_save' kernel/printk.c:772: error: implicit declaration of
> >> function 'raw_local_irq_restore'
> > 
> > With the patch bellow it compiles (make ARCH=um with a x86 host), but I'm 
> > really out of my league on this one...
> 
> Hi Rui,
> 
> with this patch, build and boot (on my x86_64 box) looks ok.
> 
> I CC-ed to uml people to check this.

i've applied the fix below to tip/core/locking - but would be nice if 
the UML folks had a comment as well.

	Ingo

>From 8c56250f48347750c82ab18d98d647dcf99ca674 Mon Sep 17 00:00:00 2001
From: Rui Sousa <rui.p.m.sousa@gmail.com>
Date: Thu, 4 Sep 2008 19:47:53 +0200
Subject: [PATCH] lockdep, UML: fix compilation when CONFIG_TRACE_IRQFLAGS_SUPPORT is not set

Hiroshi Shimamoto reported:

> > !TRACE_IRQFLAGS_SUPPORT mode of build for future work, it can be
> > restored via a simple revert.
>
> Hi, it seems that this patch breaks uml build.
>
> kernel/printk.c: In function 'vprintk':
> kernel/printk.c:674: error: implicit declaration of function
> 'raw_local_irq_save' kernel/printk.c:772: error: implicit declaration of
> function 'raw_local_irq_restore'

With the patch bellow it compiles (make ARCH=um with a x86 host), but I'm
really out of my league on this one...

Reported-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-um/system-generic.h |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/asm-um/system-generic.h b/include/asm-um/system-generic.h
index 5bcfa35..f1ea4da 100644
--- a/include/asm-um/system-generic.h
+++ b/include/asm-um/system-generic.h
@@ -4,15 +4,15 @@
 #include "asm/arch/system.h"
 
 #undef switch_to
-#undef local_irq_save
-#undef local_irq_restore
-#undef local_irq_disable
-#undef local_irq_enable
-#undef local_save_flags
-#undef local_irq_restore
-#undef local_irq_enable
-#undef local_irq_disable
-#undef local_irq_save
+#undef raw_local_irq_save
+#undef raw_local_irq_restore
+#undef raw_local_irq_disable
+#undef raw_local_irq_enable
+#undef raw_local_save_flags
+#undef raw_local_irq_restore
+#undef raw_local_irq_enable
+#undef raw_local_irq_disable
+#undef raw_local_irq_save
 #undef irqs_disabled
 
 extern void *switch_to(void *prev, void *next, void *last);
@@ -23,21 +23,21 @@ extern int get_signals(void);
 extern void block_signals(void);
 extern void unblock_signals(void);
 
-#define local_save_flags(flags) do { typecheck(unsigned long, flags); \
+#define raw_local_save_flags(flags) do { typecheck(unsigned long, flags); \
 				     (flags) = get_signals(); } while(0)
-#define local_irq_restore(flags) do { typecheck(unsigned long, flags); \
+#define raw_local_irq_restore(flags) do { typecheck(unsigned long, flags); \
 				      set_signals(flags); } while(0)
 
-#define local_irq_save(flags) do { local_save_flags(flags); \
-                                   local_irq_disable(); } while(0)
+#define raw_local_irq_save(flags) do { raw_local_save_flags(flags); \
+                                   raw_local_irq_disable(); } while(0)
 
-#define local_irq_enable() unblock_signals()
-#define local_irq_disable() block_signals()
+#define raw_local_irq_enable() unblock_signals()
+#define raw_local_irq_disable() block_signals()
 
 #define irqs_disabled()                 \
 ({                                      \
         unsigned long flags;            \
-        local_save_flags(flags);        \
+        raw_local_save_flags(flags);        \
         (flags == 0);                   \
 })
 
