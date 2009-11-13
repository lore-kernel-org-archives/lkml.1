Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbZKMSny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbZKMSny (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 13:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756804AbZKMSnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 13:43:50 -0500
Received: from lucidpixels.com ([75.144.35.66]:54787 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756392AbZKMSnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 13:43:49 -0500
Date: Fri, 13 Nov 2009 13:43:54 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: RE: 2.6.31.4: WARNING: at arch/x86/kernel/hpet.c:390
 hpet_next_event+0x70/0x80() [occurs when ACPI_PROCESSOR=y]
In-Reply-To: <1258137165.21141.20.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0911131340140.5316@p34.internal.lan>
References: <alpine.DEB.2.00.0911080932590.4556@p34.internal.lan>  <20091111195016.GB22225@redhat.com>  <alpine.DEB.2.00.0911111608020.5456@p34.internal.lan>  <alpine.DEB.2.00.0911121120330.6976@p34.internal.lan>  <alpine.DEB.2.00.0911121127500.6976@p34.internal.lan>
  <1f1b08da0911121513l32d47b4x8b9722ad3440ceb6@mail.gmail.com>  <alpine.DEB.2.00.0911121824290.2852@p34.internal.lan>  <1258069232.14894.9.camel@localhost.localdomain>  <alpine.LFD.2.00.0911130045070.24119@localhost.localdomain> 
 <alpine.DEB.2.00.0911121855170.5147@p34.internal.lan>  <7E82351C108FA840AB1866AC776AEC467647ABBD@orsmsx505.amr.corp.intel.com>  <alpine.LFD.2.00.0911131035550.24119@localhost.localdomain> <1258137165.21141.20.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 13 Nov 2009, Pallipadi, Venkatesh wrote:

> On Fri, 2009-11-13 at 01:38 -0800, Thomas Gleixner wrote:
>> On Thu, 12 Nov 2009, Pallipadi, Venkatesh wrote:
>>> Yes. Yes. This is a hardware errata. I have a patch to workaround this and
>>> waiting on the errata description to get published..
>>
>> Can we at least have some PCI quirk or whatever until you can push the
>> final workaround out so peoples machines do not explode ?
>
> Its a harmless bug functionality-wise and should not have any side
> effect other than triggering the WARN_ON_ONCE in hpet next event code.
>
> Thanks,
> Venki
>

Venki,

When the following patch is applied though: (courtesy of john stultz)

--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -376,7 +376,7 @@ static void hpet_set_mode(enum clock_event_mode mode,
  static int hpet_next_event(unsigned long delta,
                            struct clock_event_device *evt, int timer)
  {
-       u32 cnt;
+       u32 cnt, check;

         cnt = hpet_readl(HPET_COUNTER);
         cnt += (u32) delta;
@@ -387,7 +387,12 @@ static int hpet_next_event(unsigned long delta,
          * what we wrote hit the chip before we compare it to the
          * counter.
          */
-       WARN_ON_ONCE((u32)hpet_readl(HPET_Tn_CMP(timer)) != cnt);
+       check = (u32)hpet_readl(HPET_Tn_CMP(timer));
+       if(check != cnt) {
+               printk("hpet_next_event: hpet_writel failed: 0x%x != 0x%x\n",
+                       check, cnt); 
+               hpet_writel(cnt, HPET_Tn_CMP(timer));
+       }

         return (s32)((u32)hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
  }

You can see what it is doing with this patch:

[   22.856850] hpet_next_event: hpet_writel failed: 0x13b7690a != 0x138c5241
[   22.900424] hpet_next_event: hpet_writel failed: 0x138c5241 != 0x13b7691a
[   22.906429] hpet_next_event: hpet_writel failed: 0x13b7691a != 0x1391467c
[   22.923096] hpet_next_event: hpet_writel failed: 0x1391467c != 0x13974b5f
[   22.950698] hpet_next_event: hpet_writel failed: 0x13974b5f != 0x13b7692c
[   22.959424] hpet_next_event: hpet_writel failed: 0x13ad247d != 0x139cdade
[   22.976065] hpet_next_event: hpet_writel failed: 0x139cdade != 0x13ad247c
[   23.003919] hpet_next_event: hpet_writel failed: 0x13ad247c != 0x13a69410
[   23.020581] hpet_next_event: hpet_writel failed: 0x13a69410 != 0x13ad2489
[   23.050692] hpet_next_event: hpet_writel failed: 0x13ad2489 != 0x13b7694d
[   23.069921] hpet_next_event: hpet_writel failed: 0x13b7694d != 0x13b50004
[   23.086577] hpet_next_event: hpet_writel failed: 0x13b50004 != 0x13b8a43d
[   23.103251] hpet_next_event: hpet_writel failed: 0x13b8a43d != 0x13db0607
[   23.124690] hpet_next_event: hpet_writel failed: 0x13bd5467 != 0x13c2fdba
[   23.150604] hpet_next_event: hpet_writel failed: 0x13c2fdba != 0x13db061a
[   23.155307] hpet_next_event: hpet_writel failed: 0x13db061a != 0x13c7a97e
[   23.171975] hpet_next_event: hpet_writel failed: 0x13c7a97e != 0x13d8d6d4
[   23.202978] hpet_next_event: hpet_writel failed: 0x13d8d6d4 != 0x13d21457
[   23.219647] hpet_next_event: hpet_writel failed: 0x13d21457 != 0x13d5b8b8

It makes a high-pitch squeal when this is occurring, is that OK for the HW?

For your patch, will it allow Turbo Mode and the processor module to both
function properly?

Without the patch/processor module, is there any other way to achieve turbo
mode via a BIOS setting or am I stuck with the max CPU multiplier non-turbo?

If your patch is working, do you have it available for testing?

Justin.

