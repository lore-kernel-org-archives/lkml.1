Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbYIDRsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbYIDRsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 13:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbYIDRsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 13:48:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:36702 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbYIDRsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 13:48:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=qo5RzTzmJmitfgtAwELRFiskgPy0dYEjHVhDRP2v6EF2r+HYBGEExXMvddFBiT2oDp
         fFSAldqnqkstTS9w634uRtDmUQ6iXA3erven/R0LVZITkf+Ffq/fFTmY0sivaBMdqBg6
         qQOciWIng3afjV/7yPqWDCpOV4SNOi1BurOH4=
From: Rui Sousa <rui.p.m.sousa@gmail.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: Re: [PATH] Fix compilation when CONFIG_TRACE_IRQFLAGS_SUPPORT is not set
Date: Thu, 4 Sep 2008 19:47:53 +0200
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <200809031753.07292.rui.p.m.sousa@gmail.com> <20080904143918.GA28095@elte.hu> <48C0175B.3070500@ct.jp.nec.com>
In-Reply-To: <48C0175B.3070500@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809041947.54339.rui.p.m.sousa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 4 September 2008 19:14, Hiroshi Shimamoto wrote:
> Ingo Molnar wrote:
> > * Rui Sousa <rui.p.m.sousa@gmail.com> wrote:
> >> Hi,
> >>
> >> This patch fixes compilation if CONFIG_TRACE_IRQFLAGS_SUPPORT is ever
> >> disabled (which is currently not allowed by Kconfig). Alternatively we
> >> could just remove the option altogether and the associated code paths.
> >> Since the compilation error has been in the tree for at least two
> >> years and no one noticed it, I guess we don't really have the need for
> >> CONFIG_TRACE_IRQFLAGS_SUPPORT=n. Boot tested on x86 UP.
> >
> > applied to tip/core/locking - thanks Rui.
> >
> > since you fixed it i prefer the fix over the removal. We could still
> > remove the !TRACE_IRQFLAGS_SUPPORT now (in a separate commit) and
> > simpify this header a bit that way. Thus if someone needs the
> > !TRACE_IRQFLAGS_SUPPORT mode of build for future work, it can be
> > restored via a simple revert.
>
> Hi, it seems that this patch breaks uml build.

Hi Hiroshi,

> kernel/printk.c: In function 'vprintk':
> kernel/printk.c:674: error: implicit declaration of function
> 'raw_local_irq_save' kernel/printk.c:772: error: implicit declaration of
> function 'raw_local_irq_restore'

With the patch bellow it compiles (make ARCH=um with a x86 host), but I'm 
really out of my league on this one...

> thanks,
> Hiroshi Shimamoto

Thanks,
Rui

---
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
 
