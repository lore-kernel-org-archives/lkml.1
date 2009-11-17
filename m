Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbZKQVhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbZKQVhI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 16:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753343AbZKQVhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 16:37:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:25630 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbZKQVhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 16:37:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,760,1249282800"; 
   d="scan'208";a="468179037"
Date: Tue, 17 Nov 2009 13:37:12 -0800
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: 2.6.31.4: WARNING: at arch/x86/kernel/hpet.c:390 hpet_next_event+0x70/0x80() [occurs when ACPI_PROCESSOR=y]
Message-ID: <20091117213711.GA19132@linux-os.sc.intel.com>
References: <1258069232.14894.9.camel@localhost.localdomain> <alpine.LFD.2.00.0911130045070.24119@localhost.localdomain> <alpine.DEB.2.00.0911121855170.5147@p34.internal.lan> <7E82351C108FA840AB1866AC776AEC467647ABBD@orsmsx505.amr.corp.intel.com> <alpine.LFD.2.00.0911131035550.24119@localhost.localdomain> <1258137165.21141.20.camel@localhost.localdomain> <alpine.DEB.2.00.0911131340140.5316@p34.internal.lan> <1258161139.21141.29.camel@localhost.localdomain> <alpine.DEB.2.00.0911140344430.29547@p34.internal.lan> <alpine.DEB.2.00.0911170643430.25285@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0911170643430.25285@p34.internal.lan>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 03:45:31AM -0800, Justin Piszcz wrote:
> 
> 
> On Sat, 14 Nov 2009, Justin Piszcz wrote:
> 
> >
> >
> > On Fri, 13 Nov 2009, Pallipadi, Venkatesh wrote:
> >
> >> On Fri, 2009-11-13 at 10:43 -0800, Justin Piszcz wrote:
> >>> 
> >>> On Fri, 13 Nov 2009, Pallipadi, Venkatesh wrote:
> >>> 
> >>>> On Fri, 2009-11-13 at 01:38 -0800, Thomas Gleixner wrote:
> >>>>> On Thu, 12 Nov 2009, Pallipadi, Venkatesh wrote:
> >>>>>> Yes. Yes. This is a hardware errata. I have a patch to workaround this 
> >>>>>> and
> >>>>>> waiting on the errata description to get published..
> 
> 1. Do we have an ETA of when this will get published?
> 2. Is there a patch available for testing?

Unfortunately, I don't have an ETA for when the errata will be published.

I am still stuck up on what is the original problem you have without the patch
on vanilla kernel? You will see the WARNING in the dmesg. As I understand,
that should not prevent you from loading processor driver or getting the
turbo boost or anything like that. The warning is a one time info and timer
and ACPI P/C states should work just fine.

Anyways, below is the patch that you can use for testing.

---
 arch/x86/kernel/hpet.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index dedc2bd..6beb5b5 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -387,7 +387,8 @@ static int hpet_next_event(unsigned long delta,
 	 * what we wrote hit the chip before we compare it to the
 	 * counter.
 	 */
-	WARN_ON_ONCE((u32)hpet_readl(HPET_Tn_CMP(timer)) != cnt);
+	if (unlikely((u32)hpet_readl(HPET_Tn_CMP(timer)) != cnt))
+		WARN_ON_ONCE((u32)hpet_readl(HPET_Tn_CMP(timer)) != cnt);
 
 	return (s32)((u32)hpet_readl(HPET_COUNTER) - cnt) >= 0 ? -ETIME : 0;
 }
-- 
1.6.0.6


