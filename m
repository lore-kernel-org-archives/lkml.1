Return-Path: <linux-kernel-owner+w=401wt.eu-S1759613AbZDDIzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613AbZDDIzs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 04:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbZDDIzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 04:55:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:35040 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbZDDIzi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 04:55:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,323,1235980800"; 
   d="scan'208";a="127851893"
From: "Han, Weidong" <weidong.han@intel.com>
To: "'David Woodhouse'" <dwmw2@infradead.org>
CC: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "'Ingo Molnar'" <mingo@elte.hu>,
       "'IOMMU'" <iommu@lists.linux-foundation.org>,
       "'LKML'" <linux-kernel@vger.kernel.org>
Date: Sat, 4 Apr 2009 16:48:50 +0800
Subject: RE: [patch 2/2] x2apic/intr-remap: decouple interrupt remapping
 from x2apic
Thread-Topic: [patch 2/2] x2apic/intr-remap: decouple interrupt remapping
 from x2apic
Thread-Index: Acm0/2smej6UXqgBRaCCobRsYuWidAAANHVA
Message-ID: <715D42877B251141A38726ABF5CABF2C01A2F7C440@pdsmsx503.ccr.corp.intel.com>
References: <715D42877B251141A38726ABF5CABF2C01A2F7C3A7@pdsmsx503.ccr.corp.intel.com>
	 <1238781474.27006.7866.camel@localhost.localdomain>
	 <715D42877B251141A38726ABF5CABF2C01A2F7C435@pdsmsx503.ccr.corp.intel.com>
 <1238833738.3560.14.camel@macbook.infradead.org>
In-Reply-To: <1238833738.3560.14.camel@macbook.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> On Sat, 2009-04-04 at 11:37 +0800, Han, Weidong wrote:
>> Siddha, Suresh B wrote:
>>> On Fri, 2009-04-03 at 02:15 -0700, Han, Weidong wrote:
>>>> 
>>>> -#ifdef CONFIG_INTR_REMAP
>>>> +#ifdef CONFIG_X86_X2APIC
>>> 
>>> Weidong, Can we also fix these config options?
>>> 
>>> Today, selecting CONFIG_INTR_REMAP automatically selects
>>> CONFIG_X86_X2APIC. It should be the other way round.
>>> 
>>> i.e., turning on CONFIG_X86_X2APIC should automatically enable
>>> CONFIG_INTR_REMAP and just enabling CONFIG_INTR_REMAP shouldn't
>>> enable CONFIG_X86_X2APIC. 
>>> 
>>> Also please make sure that the code compiles (and works :)) in
>>> different combinations of these config settings.
>> 
>> 
>> Thanks for your reminder. Following patch changes the config options
>> selection. The code can compiles in different combinations.
> 
> Doesn't build for me.
> 
> Firstly, your patch 2/2 doesn't apply against git HEAD. I needed to
> massage it to work. I think you're testing against an old kernel.
> 

Now I'm working on linux head:
	commit 6bb597507f9839b13498781e481f5458aea33620	
	Merge: 09f38dc... c5c67c7...
	Author: Linus Torvalds <torvalds@linux-foundation.org>
	Date:   Fri Apr 3 17:36:21 2009 -0700

I massaged the patch 2/2 like what you did in iommu-2.6.git, and applied it on linux head. 

> Then (with the massaged version in the iommu-2.6.git tree) if I apply
> your third patch below I get this error when building with INTR_REMAP
> && !X2APIC:
> 
> arch/x86/kernel/apic/apic.c: In function 'lapic_resume':
> arch/x86/kernel/apic/apic.c:2054: error: 'EIM_32BIT_APIC_ID'
> undeclared (first use in this function)
> arch/x86/kernel/apic/apic.c:2054: error: (Each undeclared identifier
> is reported only once arch/x86/kernel/apic/apic.c:2054: error: for
> each function it appears in.)  
> make[2]: *** [arch/x86/kernel/apic/apic.o] Error 1
> 

On linux head, I cannot find EIM_32BIT_APIC_ID in apic.c. I suspect iommu-2.6.git doesn't sync up with linux head on apic.c. I also fixed a bug which causes system hang due to queue invalidation is disabled when enable interrupt remapping. I will resend the patches. Do you want patches based on linux head or your iommu-2.6.git? BTW, I pull iommu-2.6.git very slow due to office proxy. But I can do it if you want. 

Regards,
Weidong


> If I apply the naïve fix of just changing a couple more #ifdef
> CONFIG_INTR_REMAP to #ifdef CONFIG_X86_X2APIC (in enable_IR_x2apic()
> and 
> lapic_resume()), it builds but doesn't boot -- it just hangs after
> reporting Queued Invalidation, at the code you added in dmar.c to call
> enable_intr_remapping().
> 
> Please make sure you're testing against a current kernel, and test
> that 
> it builds and boots in all three configurations (no remapping,
> remapping 
> but no x2apic, and with both enabled).

