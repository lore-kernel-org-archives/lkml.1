Return-Path: <linux-kernel-owner+w=401wt.eu-S1755070AbZKIMhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbZKIMhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 07:37:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001AbZKIMhC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 07:37:02 -0500
Received: from mga06.intel.com ([134.134.136.21]:26851 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754930AbZKIMhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 07:37:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,708,1249282800"; 
   d="scan'208";a="567819742"
Date: Mon, 9 Nov 2009 20:10:05 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] x86: under bios control, restore AP's APIC_LVTTHMR
	to the BSP value
Message-ID: <20091109121005.GB3896@ywang-moblin2.bj.intel.com>
References: <20091109114752.GA3896@ywang-moblin2.bj.intel.com> <20091109122919.GA32321@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109122919.GA32321@aftab>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 01:29:19PM +0100, Borislav Petkov wrote:
> On Mon, Nov 09, 2009 at 07:47:52PM +0800, Yong Wang wrote:
> 
> [..]
> 
> > diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> > index 0a64353..e6f0ef9 100644
> > --- a/arch/x86/kernel/setup.c
> > +++ b/arch/x86/kernel/setup.c
> > @@ -110,6 +110,7 @@
> >  #ifdef CONFIG_X86_64
> >  #include <asm/numa_64.h>
> >  #endif
> > +#include <asm/mce.h>
> >  
> >  /*
> >   * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
> > @@ -1040,6 +1041,8 @@ void __init setup_arch(char **cmdline_p)
> >  #endif
> >  #endif
> >  	x86_init.oem.banner();
> > +
> > +	mcheck_init();
> 
> I think you need
> 
> #ifdef CONFIG_X86_MCE
> ...
> #endif
> 
> here for cases where mcheck is config-disabled, no?
> 

Petkov, thanks for the review. Part of my patch is as below. Does this
resolve your concern?

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 161485d..41d8e42 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -120,8 +120,10 @@ extern int mce_disabled;
 extern int mce_p5_enabled;

 #ifdef CONFIG_X86_MCE
+int mcheck_init(void);
 void mcheck_cpu_init(struct cpuinfo_x86 *c);
 #else
+static int mcheck_init(void) { return 0; }
 static inline void mcheck_cpu_init(struct cpuinfo_x86 *c) {}
 #endif

Thanks
-Yong
