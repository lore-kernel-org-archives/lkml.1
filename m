Return-Path: <linux-kernel-owner+w=401wt.eu-S1755647AbZHNCLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbZHNCLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 22:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbZHNCLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 22:11:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:65330 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbZHNCLH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 22:11:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,378,1246863600"; 
   d="scan'208";a="541231857"
From: "Wang, Shane" <shane.wang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
CC: "Cihula, Joseph" <joseph.cihula@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>
Date: Fri, 14 Aug 2009 10:06:44 +0800
Subject: RE: [PATCH 1/1] intel_txt: to fix build errors of CONFIG_ACPI_SLEEP
Thread-Topic: [PATCH 1/1] intel_txt: to fix build errors of CONFIG_ACPI_SLEEP
Thread-Index: AcocK/0pu9CQfup6S+yUOTQqByXulQAUQjKw
Message-ID: <037F493892196B458CD3E193E8EBAD4F01EAB6464E@pdsmsx502.ccr.corp.intel.com>
References: <4A4ACA60.1000209@intel.com> <20090807072752.GA12119@elte.hu>
 <20090812145321.GA11347@elte.hu>
 <037F493892196B458CD3E193E8EBAD4F01EAB64402@pdsmsx502.ccr.corp.intel.com>
 <20090813064634.GA12143@elte.hu> <4A842C5B.7050100@zytor.com>
In-Reply-To: <4A842C5B.7050100@zytor.com>
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

I agree with hpa, considering TXT doesnot depends on acpi sleep.

However, for hpa's patch, set_mac_regions() is for S3 only. I am wondering whether we should enlarge the range of CONFIG_ACPI_SLEEP in set_mac_regions().
Certainly, for code cleanness, this patch is fine since the assignment

+#ifdef CONFIG_X86_TRAMPOLINE
 	/* AP trampoline code */
-	tboot->mac_regions[1].start =
-			PFN_PHYS(PFN_DOWN(virt_to_phys(trampoline_base)));
-	tboot->mac_regions[1].size = PFN_UP(TRAMPOLINE_SIZE) << PAGE_SHIFT;
+	add_mac_region(virt_to_phys(trampoline_base), TRAMPOLINE_SIZE);
+#endif
 	/* kernel code + data + bss */
-	tboot->mac_regions[2].start = PFN_PHYS(PFN_DOWN(virt_to_phys(&_text)));
-	tboot->mac_regions[2].size = PFN_PHYS(PFN_UP(virt_to_phys(&_end))) -
-				     PFN_PHYS(PFN_DOWN(virt_to_phys(&_text)));
+	add_mac_region(virt_to_phys(_text), _end - _text);

takes effect but tboot->mac_regions[] will never be used without S3.

Thanks.
Shane

H. Peter Anvin wrote:
> On 08/12/2009 11:46 PM, Ingo Molnar wrote:
>> * Wang, Shane <shane.wang@intel.com> wrote:
>> 
>>> Signed-off-by: Shane Wang <shane.wang@intel.com>
>>> 
>>> diff -r 7358cf1b3090 arch/x86/kernel/tboot.c
>>> --- a/arch/x86/kernel/tboot.c   Wed Aug 12 03:04:23 2009 -0700
>>> +++ b/arch/x86/kernel/tboot.c   Wed Aug 12 18:06:21 2009 -0700
>>> @@ -169,6 +169,7 @@ void tboot_create_trampoline(void)
>>> 
>>>  static void set_mac_regions(void)
>>>  {
>>> +#ifdef CONFIG_ACPI_SLEEP
>>>         tboot->num_mac_regions = 3;
>>>         /* S3 resume code */
>>>         tboot->mac_regions[0].start =
>>> PFN_PHYS(PFN_DOWN(acpi_wakeup_address)); @@ -181,6 +182,7 @@ static
>>>         void set_mac_regions(void) tboot->mac_regions[2].start =
>>>         PFN_PHYS(PFN_DOWN(virt_to_phys(&_text)));
>>>                                      tboot->mac_regions[2].size =
>>> PFN_PHYS(PFN_UP(virt_to_phys(&_end))) -
>>> PFN_PHYS(PFN_DOWN(virt_to_phys(&_text))); +#endif 
>> 
>> These #ifdefs are quite ugly. Why not add a 'depends on ACPI_SLEEP'
>> rule to the INTEL_TXT Kconfig section?
> 
> I *strongly* disagree with that kind of false dependencies.  It makes
> it seem like there is something magic going on, which invites cargo
> cult programming in the future.  I also think those particular
> #ifdefs are fairly innocuous... it's not like they're hiding flow of
> control or major chunks of code.
> 
> However, I think the actual code to set the sections is ugly as hell,
> which is probably why the #ifdef sticks in your eyes.
> 
> Consider the attached instead patch, which abstracts some of the (way
> more complex than it should be) open-coded stuff and therefore makes
> it stick out less.
> 
> 	-hpa

