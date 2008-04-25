Return-Path: <linux-kernel-owner+w=401wt.eu-S1758669AbYDYLlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758669AbYDYLlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 07:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbYDYLlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 07:41:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:54346 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbYDYLlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 07:41:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=I+sg8GJRjMsqaiPJbEKwPFh4OUZfRICuyX2cpV2u+wIhW11H9J30cbggMpYNEpUkCI+58Our7Mapg0Va9/nEB/0/oHccFMeRX+ExsMeWiCRbLWBMREYLiO+SYiuxmI0zAOToYvmXZ12s5GoLvZ7W0v6nxXDzBZrdnpGrSHCmMdc=
Message-ID: <4811C352.5080802@googlemail.com>
Date: Fri, 25 Apr 2008 13:41:06 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Priit Laes <plaes@plaes.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [REGRESSION] x86: support for new UV apic
References: <1209098600.3707.13.camel@localhost>	<20080425064405.GA23043@elte.hu> <87abjixo7d.fsf@basil.nowhere.org> <4811BEA1.502@googlemail.com>
In-Reply-To: <4811BEA1.502@googlemail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gabriel C wrote:
> Andi Kleen wrote:
>> Ingo Molnar <mingo@elte.hu> writes:
>>
>>> * Priit Laes <plaes@plaes.org> wrote:
>>>
>>>> Hey,
>>>>
>>>> I am getting two following warnings (probable one per each CPU core) 
>>>> using the latest Linus's git:
>>>>
>>>> WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x30/0x62()
>>>> Modules linked in:
>>>> Pid: 1, comm: swapper Not tainted 2.6.25-03563-gf7288b1 #20
>>> thanks - could you check the patch below, does it fix the warnings?
>> I think it would have been better to change the WARN_ON to
>>
>> WARN_ON(preemptible() && num_online_cpus() > 1)
> 
> Hmm , I think you are right , Ingo's patch fixes the warning on boot but now I get one when I reboot the box.
> 
>> Preemption is actually ok here because this runs before the other
>> CPUs are started
>>
>> Alternative patch appended.
> 
> I will test your patch in some minutes.

Your patch works better , at least for my box , 4 reboots with your patch and boot/reboot warnings are all gone.


>>
>> Don't warn in read_apic_id() when preemptible but only one CPU online.
>>
>> Signed-off-by: Andi Kleen <andi@firstfloor.org>
>>
>> Index: linux/arch/x86/kernel/genapic_64.c
>> ===================================================================
>> --- linux.orig/arch/x86/kernel/genapic_64.c
>> +++ linux/arch/x86/kernel/genapic_64.c
>> @@ -83,7 +83,7 @@ unsigned int read_apic_id(void)
>>  {
>>  	unsigned int id;
>>  
>> -	WARN_ON(preemptible());
>> +	WARN_ON(preemptible() && num_online_cpus() > 1);
>>  	id = apic_read(APIC_ID);
>>  	if (uv_system_type >= UV_X2APIC)
>>  		id  |= __get_cpu_var(x2apic_extra_bits);
> 
> 
