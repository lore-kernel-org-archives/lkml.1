Return-Path: <linux-kernel-owner+w=401wt.eu-S932305AbZLRRbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbZLRRbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:31:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932268AbZLRRbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:31:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:59636 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156AbZLRRbY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:31:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,419,1257148800"; 
   d="scan'208";a="580263496"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 18 Dec 2009 09:31:19 -0800
Subject: RE: [PATCH 1/2] x86: initialize stack canary in secondary start
Thread-Topic: [PATCH 1/2] x86: initialize stack canary in secondary start
Thread-Index: Acp/+4gxn19aajImRKa9MSMCPklogQAC8D/w
Message-ID: <43F901BD926A4E43B106BF17856F07559A2581E5@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07559A257B5F@orsmsx508.amr.corp.intel.com>
 <alpine.LFD.2.00.0912181701470.2755@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912181701470.2755@localhost.localdomain>
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



>-----Original Message-----
>From: Thomas Gleixner [mailto:tglx@linutronix.de]
>Sent: Friday, December 18, 2009 8:03 AM
>To: Pan, Jacob jun
>Cc: H. Peter Anvin; x86@kernel.org; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH 1/2] x86: initialize stack canary in secondary start
>
>On Thu, 17 Dec 2009, Pan, Jacob jun wrote:
>> >From 06503838368350268a46528e134c1dad9f4f8c93 Mon Sep 17 00:00:00 2001
>> From: Jacob Pan <jacob.jun.pan@intel.com>
>> Date: Thu, 17 Sep 2009 07:36:43 -0700
>> Subject: [PATCH 1/2] x86: initialize stack canary in secondary start
>>
>> some secondary clockevent setup code needs to call request_irq, which will
>> cause fake stack check failure in schedule() if voluntary preemption
>> model is chosen, it is safe to have stack canary initialized here early,
>> since start_secondary() does not return.
>
>Where is it initialized now ? Shouldnt the current init be removed ?
>
[[JPAN]] it is currently in cpu_idle(), i don't think it can be removed since
there are other path calling it. calling boot_init_stack_canary() is redundant
in some case but harmless.

>Thanks,
>
>	tglx
>
>> Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
>> ---
>>  arch/x86/kernel/smpboot.c |    4 ++++
>>  1 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
>> index 678d0b8..56ce974 100644
>> --- a/arch/x86/kernel/smpboot.c
>> +++ b/arch/x86/kernel/smpboot.c
>> @@ -48,6 +48,7 @@
>>  #include <linux/err.h>
>>  #include <linux/nmi.h>
>>  #include <linux/tboot.h>
>> +#include <linux/stackprotector.h>
>>
>>  #include <asm/acpi.h>
>>  #include <asm/desc.h>
>> @@ -324,6 +325,9 @@ notrace static void __cpuinit start_secondary(void
>*unused)
>>  	/* enable local interrupts */
>>  	local_irq_enable();
>>
>> +	/* to prevent fake stack check failure in clock setup */
>> +	boot_init_stack_canary();
>> +
>>  	x86_cpuinit.setup_percpu_clockev();
>>
>>  	wmb();
>> --
>> 1.6.5.3
>>
>>
