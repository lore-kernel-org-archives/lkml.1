Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbZEKQAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbZEKQAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 12:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbZEKP7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:59:50 -0400
Received: from smtp.citrix.com ([66.165.176.89]:18896 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbZEKP7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:59:49 -0400
X-IronPort-AV: E=Sophos;i="4.40,328,1238990400"; 
   d="scan'208";a="4193495"
Subject: Re: [tip:x86/xen] x86: use flush_tlb_others to implement
	flush_tlb_all, fix
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
In-Reply-To: <20090511154202.GA31655@elte.hu>
References: <1241797927.15972.51.camel@zakaz.uk.xensource.com>
	 <tip-636afdbe85d50d9b88f5283b5e6d0f8518431aac@git.kernel.org>
	 <20090511131230.GA32693@elte.hu>
	 <1242054041.29990.88.camel@zakaz.uk.xensource.com>
	 <20090511151151.GA3267@elte.hu>
	 <1242056394.29990.94.camel@zakaz.uk.xensource.com>
	 <20090511154202.GA31655@elte.hu>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Mon, 11 May 2009 16:59:48 +0100
Message-ID: <1242057588.29990.105.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-11 at 11:42 -0400, Ingo Molnar wrote:
> * Ian Campbell <Ian.Campbell@eu.citrix.com> wrote:
> 
> > in any case I would guess that the fix is:
> > 
> > --- a/arch/x86/kernel/setup.c
> > +++ b/arch/x86/kernel/setup.c
> > @@ -87,6 +87,7 @@
> >  #include <asm/cacheflush.h>
> >  #include <asm/processor.h>
> >  #include <asm/bugs.h>
> > +#include <asm/tlbflush.h>
> >  
> >  #include <asm/system.h>
> >  #include <asm/vsyscall.h>
> 
> Guessing is not enough - please review the prototype position. Is it 
> available on all configs? It is not ...

Damn, you are (of course) right. There is nothing for it to do on !SMP
so patch below. I also observe that since it's no longer an initcall
there is no need for a return value so included that change too.

> But even the proper fix runs into that smp_processor_id() bug i just 
> posted.

That's back to an issue in the original patch from Jeremy I think, I'll
leave that one to him and/or tomorrow -- I've botched enough patches for
one day!

Ian.

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index a3f42bf..e1e3e6a 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -89,6 +89,8 @@ static inline void __flush_tlb_one(unsigned long addr)
 
 #ifndef CONFIG_SMP
 
+static inline void init_smp_flush(void) {}
+
 #define flush_tlb() __flush_tlb()
 #define flush_tlb_all() __flush_tlb_all()
 #define local_flush_tlb() __flush_tlb()
@@ -129,7 +131,7 @@ static inline void reset_lazy_tlbstate(void)
 
 #define local_flush_tlb() __flush_tlb()
 
-extern int init_smp_flush(void);
+extern void init_smp_flush(void);
 
 extern void flush_tlb_all(void);
 extern void flush_tlb_current_task(void);
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 03f52f5..db28919 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -217,14 +217,12 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 	flush_tlb_others_ipi(cpumask, mm, va);
 }
 
-int __init init_smp_flush(void)
+void __init init_smp_flush(void)
 {
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(flush_state); i++)
 		spin_lock_init(&flush_state[i].tlbstate_lock);
-
-	return 0;
 }
 
 void flush_tlb_current_task(void)


