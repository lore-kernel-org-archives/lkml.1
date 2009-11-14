Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbZKNBMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbZKNBMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 20:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZKNBMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 20:12:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:23862 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861AbZKNBMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 20:12:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,740,1249282800"; 
   d="scan'208";a="513697373"
Subject: RE: 2.6.31.4: WARNING: at arch/x86/kernel/hpet.c:390
 hpet_next_event+0x70/0x80() [occurs when ACPI_PROCESSOR=y]
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.DEB.2.00.0911131340140.5316@p34.internal.lan>
References: <alpine.DEB.2.00.0911080932590.4556@p34.internal.lan>
	 <20091111195016.GB22225@redhat.com>
	 <alpine.DEB.2.00.0911111608020.5456@p34.internal.lan>
	 <alpine.DEB.2.00.0911121120330.6976@p34.internal.lan>
	 <alpine.DEB.2.00.0911121127500.6976@p34.internal.lan>
	 <1f1b08da0911121513l32d47b4x8b9722ad3440ceb6@mail.gmail.com>
	 <alpine.DEB.2.00.0911121824290.2852@p34.internal.lan>
	 <1258069232.14894.9.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0911130045070.24119@localhost.localdomain>
	 <alpine.DEB.2.00.0911121855170.5147@p34.internal.lan>
	 <7E82351C108FA840AB1866AC776AEC467647ABBD@orsmsx505.amr.corp.intel.com>
	 <alpine.LFD.2.00.0911131035550.24119@localhost.localdomain>
	 <1258137165.21141.20.camel@localhost.localdomain>
	 <alpine.DEB.2.00.0911131340140.5316@p34.internal.lan>
Content-Type: text/plain
Date: Fri, 13 Nov 2009 17:12:19 -0800
Message-Id: <1258161139.21141.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-13 at 10:43 -0800, Justin Piszcz wrote:
> 
> On Fri, 13 Nov 2009, Pallipadi, Venkatesh wrote:
> 
> > On Fri, 2009-11-13 at 01:38 -0800, Thomas Gleixner wrote:
> >> On Thu, 12 Nov 2009, Pallipadi, Venkatesh wrote:
> >>> Yes. Yes. This is a hardware errata. I have a patch to workaround this and
> >>> waiting on the errata description to get published..
> >>
> >> Can we at least have some PCI quirk or whatever until you can push the
> >> final workaround out so peoples machines do not explode ?
> >
> > Its a harmless bug functionality-wise and should not have any side
> > effect other than triggering the WARN_ON_ONCE in hpet next event code.
> >
> > Thanks,
> > Venki
> >
> 
> Venki,
> 
> When the following patch is applied though: (courtesy of john stultz)
> 

Justin,

I am missing something in here.
Without the below patch, on 2.6.31.4 and ACPI_PROCESSOR loaded (either
as module or builtin), you may see the WARNING. But, that should not
cause any other problems with C-states, P-states, or anything else.
Is that what you are seeing?

The below patch is not a workaround for the problem. Infact it will make
situation worse with constant stream of prinkts and can reduce the
C-state residency and turbo upside.

Thanks,
Venki
 
> --- a/arch/x86/kernel/hpet.c
> +++ b/arch/x86/kernel/hpet.c
> @@ -376,7 +376,7 @@ static void hpet_set_mode(enum clock_event_mode mode,
>   static int hpet_next_event(unsigned long delta,
>                             struct clock_event_device *evt, int timer)
>   {
> -       u32 cnt;
> +       u32 cnt, check;
> 
>          cnt = hpet_readl(HPET_COUNTER);
>          cnt += (u32) delta;
> @@ -387,7 +387,12 @@ static int hpet_next_event(unsigned long delta,
>           * what we wrote hit the chip before we compare it to the
>           * counter.
>           */
> -       WARN_ON_ONCE((u32)hpet_readl(HPET_Tn_CMP(timer)) != cnt);
> +       check = (u32)hpet_readl(HPET_Tn_CMP(timer));
> +       if(check != cnt) {
> +               printk("hpet_next_event: hpet_writel failed: 0x%x != 0x%x\n",
> +                       check, cnt); 
> +               hpet_writel(cnt, HPET_Tn_CMP(timer));
> +       }
> 
>          return (s32)((u32)hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
>   }
> 


