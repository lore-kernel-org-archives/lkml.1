Return-Path: <linux-kernel-owner+w=401wt.eu-S1753062AbYI3Gyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062AbYI3Gyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 02:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYI3Gyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 02:54:47 -0400
Received: from gw.goop.org ([64.81.55.164]:37962 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbYI3Gyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 02:54:46 -0400
Message-ID: <48E1CD29.8050109@goop.org>
Date: Mon, 29 Sep 2008 23:54:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Krzysztof Helt <krzysztof.h1@poczta.fm>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: do not allow to optimize flag_is_changeable_p()
References: <20080929200603.dcdc5b71.krzysztof.h1@poczta.fm>	 <48E1C3BD.5020705@goop.org> <86802c440809292334o557d2158ob2c52aebd3caf0b3@mail.gmail.com>
In-Reply-To: <86802c440809292334o557d2158ob2c52aebd3caf0b3@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Mon, Sep 29, 2008 at 11:14 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>   
>> Krzysztof Helt wrote:
>>     
>>> From: Krzysztof Helt <krzysztof.h1@wp.pl>
>>>
>>> The flag_is_changeable_p() is used by
>>> has_cpuid_p() which can return different results
>>> in the code sequence below:
>>>
>>>  if (!have_cpuid_p())
>>>       identify_cpu_without_cpuid(c);
>>>
>>>   /* cyrix could have cpuid enabled via c_identify()*/
>>>   if (!have_cpuid_p())
>>>       return;
>>>
>>> Otherwise, the gcc 3.4.6 optimizes these two calls
>>> into one which make the code not working correctly.
>>> Cyrix cpus have the CPUID instruction enabled but
>>> it is not detected due to the gcc optimization.
>>> Thus the ARR registers (mtrr like) are not detected
>>> on such a cpu.
>>>
>>>       
>> If "asm volatile" changes the code and fixes the bug, it seems like
>> you're making use of an undocumented - or at least non-portable - behaviour.
>>
>> Does adding a "memory" clobber also fix the problem?  That would have
>> better defined characteristics.
>>
>>     
>
> how about
>
>         if (!have_cpuid_p()) {
>                 identify_cpu_without_cpuid(c);
>
>                 /* cyrix could have cpuid enabled via c_identify()*/
>                 if (!have_cpuid_p())
>                         return;
>         }
>   

That doesn't help, does it?  If gcc thinks it can get away with
evaluating have_cpuid_p() once, then that's the same as:

	if (!have_cpuid_p()) {
		identify_cpu_without_cpuid(c);

		return;
	}

even though identify_cpu_without_cpuid() can cause the cpu to suddenly
start supporting cpuid.

The trouble is that flag_is_changeable_p() doesn't have any obvious
global dependencies; it just takes a constant argument and returns a
result.   The asm() needs to be updated to have a "memory" constraint as
a stand-in for the specific constraint of "cpu has switched into
cpuid-supporting state".

    J
