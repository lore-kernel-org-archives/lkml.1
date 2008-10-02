Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYJBWGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYJBWGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 18:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbYJBWGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 18:06:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:22828 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbYJBWGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 18:06:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,353,1220252400"; 
   d="scan'208";a="386942399"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: "Luck, Tony" <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <dwmw2@infradead.org>, Avi Kivity <avi@redhat.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>
Date: Thu, 2 Oct 2008 15:06:18 -0700
Subject: RE: [PATCH 1/2]Add Variable Page Size and IA64 Support in Intel
	IOMMU: Generic Part
Thread-Topic: [PATCH 1/2]Add Variable Page Size and IA64 Support in Intel
	IOMMU: Generic Part
Thread-Index: AckkaQ76upWredApRiKnIi+i0K/3lQAb0gBw
Message-ID: <A6AD88C3F2289247BE726C37303E1EB88408AE54@orsmsx505.amr.corp.intel.com>
References: <BAE9DCEF64577A439B3A37F36F9B691C0339372B@orsmsx418.amr.corp.intel.com>
 <617E1C2C70743745A92448908E030B2A02AD5AD7@scsmsx411.amr.corp.intel.com>
 <20081001165725.GA21559@linux-os.sc.intel.com>
 <20081002082942.GA26084@elte.hu>
In-Reply-To: <20081002082942.GA26084@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> --- a/drivers/pci/dmar.c
>> +++ b/drivers/pci/dmar.c
>> @@ -35,6 +35,10 @@
>>  #undef PREFIX
>>  #define PREFIX "DMAR:"
>>
>> +#ifdef CONFIG_IA64
>> +#define cpu_has_x2apic 0
>> +#endif
>
>hm, that's not too nice - why not add it to arch/ia64/include/?

OK. I'll move this to arch/ia64/include (along with other #ifdef CONFIG_IA64 places if needed).


>> diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
>> index e7b196b..d84612a 100644
>> --- a/include/linux/intel-iommu.h
>> +++ b/include/linux/intel-iommu.h
>> @@ -67,6 +67,13 @@
>>               hi = readl(dmar + reg + 4); \
>>               (((u64) hi) << 32) + lo; })
>>  */
>> +#ifdef CONFIG_IA64
>> +#define dmar_readq readq
>> +static inline void dmar_writeq(void __iomem *addr, u64 val)
>> +{
>> +     writeq(val, addr);
>> +}
>> +#else
>>  static inline u64 dmar_readq(void __iomem *addr)
>>  {
>>       u32 lo, hi;
>> @@ -80,6 +87,7 @@ static inline void dmar_writeq(void __iomem *addr, u64 val)
>>       writel((u32)val, addr);
>>       writel((u32)(val >> 32), addr + 4);
>>  }
>> +#endif
>
>What's this all about?  Why do we need #ifdef CONFIG_IA64 here?
>Doesn't x86 provide its own readq/writeq implementation?

This is a comment from Bjorn.

In my patch, one readq/one writeq are working faster than two readl/two writel on IA64. X86 uses two readl/two writel so that the code works on both x86 and x86-64 although Intel IOMMU only has x86-64 version currently. dmar_readq() and dmar_writeq() are in moderate performance critical path.

Do you think my current implementation is ok to have #ifdef CONFIG_IA64 here? Or I can change X86 to use readq/writeq as well or IA64 uses two readl/two writel for clean code?

Thanks.

-Fenghua


