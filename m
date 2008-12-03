Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbYLCOI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbYLCOI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 09:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYLCOIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 09:08:19 -0500
Received: from mga12.intel.com ([143.182.124.36]:11750 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750799AbYLCOIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 09:08:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,708,1220252400"; 
   d="scan'208";a="85965394"
Message-ID: <493692E2.9050302@linux.intel.com>
Date: Wed, 03 Dec 2008 15:08:34 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Robert Richter <robert.richter@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <dada1@cosmosbay.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] oprofile: fix CPU unplug panic in ppro_stop()
References: <4934D3E1.1000507@cosmosbay.com> <20081202081729.GA5424@elte.hu> <20081203115954.GH11656@erda.amd.com>
In-Reply-To: <20081203115954.GH11656@erda.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Richter wrote:
> On 02.12.08 09:17:29, Ingo Molnar wrote:
>> * Eric Dumazet <dada1@cosmosbay.com> wrote:
>>
>>> If oprofile statically compiled in kernel, a cpu unplug triggers
>>> a panic in ppro_stop(), because a NULL pointer is dereferenced.
>>>
>>> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
>>> ---
>>> arch/x86/oprofile/op_model_ppro.c |    4 ++++
>>> 1 files changed, 4 insertions(+)
>>> diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
>>> index 716d26f..e9f80c7 100644
>>> --- a/arch/x86/oprofile/op_model_ppro.c
>>> +++ b/arch/x86/oprofile/op_model_ppro.c
>>> @@ -156,6 +156,8 @@ static void ppro_start(struct op_msrs const * const msrs)
>>>  	unsigned int low, high;
>>>  	int i;
>>>  
>>> +	if (!reset_value)
>>> +		return;
>>>
>>> 	for (i = 0; i < num_counters; ++i) {
>>>  		if (reset_value[i]) {
>>>  			CTRL_READ(low, high, msrs, i);
> 
> The patch fixes the null pointer access and this ok. But the root
> cause seems to be in the cpu hotplug and initialization
> code. xxx_start() should not be called before xxx_setup_ctrs() or
> after xxx_shutdown(). 

Yes, it would be better to fix that. At least it would make
the code cleaner than the add checks for this backdoor everywhere.

> Also, running only xxx_start() and xxx_stop() in
> the cpu notifier functions is not sufficient. There is at least some
> on_each_cpu code in nmi_setup() that should be called also in the cpu
> notifier functions. I have to review that code.

AFAIK cpu hotplug has more problems in oprofile anyways. That is why
I didn't test that case.

> 
> [...]
> 
>> It was absolutely unnecessary to add kmalloc to this rarely executed 
>> codepath - and the way it was added was absolutely horrible as well, it 
>> was tacked on in the middle of an existing codepath, instead of factoring 
>> it out nicely. Perfmon will eventually replace PMC management anyway, so 
>> there was no "this way it's cleaner" argument either. So this code should 
>> have been changed minimally, instead of slapping in a full kmalloc for a 
>> simple array extension from 2 to 4 entries ...
> 
> Ingo, you are right that using kmalloc is unnecessary for
> reset_value. So, Andi, maybe you could make this code easier?

The reason I added the kmalloc is that there's also a varying number
of separate fixed function counters (although that's not currently
submitted).

Also I would prefer to not have a hard coded number for future
CPUs. Contrary to other people's opinion architectural perfmon is
not for Nehalem only.

-Andi
