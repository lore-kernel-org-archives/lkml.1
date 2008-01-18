Return-Path: <linux-kernel-owner+w=401wt.eu-S1762777AbYARQTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762777AbYARQTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760001AbYARQTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:19:22 -0500
Received: from gw.goop.org ([64.81.55.164]:50935 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758167AbYARQTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:19:21 -0500
Message-ID: <4790D187.8050000@goop.org>
Date: Fri, 18 Jan 2008 08:19:19 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: xming <xmingske@gmail.com>
CC: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: Cannot boot xen DomU > 2.6.23.1
References: <519a8b110801170813h96b8f2by795e6d8b72a00ba4@mail.gmail.com>	 <478F8D22.60004@goop.org>	 <519a8b110801171113y20a3bedfg446e29a30712a26d@mail.gmail.com>	 <4790561E.9040508@goop.org> <519a8b110801180438l389ec1d6t7b888b8c78d59dd8@mail.gmail.com>
In-Reply-To: <519a8b110801180438l389ec1d6t7b888b8c78d59dd8@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xming wrote:
>> OK, I misunderstood your original report to mean that something was
>> complaining about "too much" output.  You're saying that lots of console
>> output seems to lock the domain.
>>     
>
> Sorry about that, and yes that is the case.
>
>   
>> I've had a report about heavy disk IO seems to lock up as well.  Perhaps
>> they're both related to high event rates.  Do you think you could try an
>> IO-intensive workload to see if you can get a similar lockup?
>>     
>
> IO-intensive locks up too (see below)
>
>   
>> When the domain is locked up, what does /usr/lib/xen/bin/xenctx say?
>>     
>
> see below
>
>   
>> Hm.  Rather than backing out the structure-change patch, could you try
>> this workaround:
>>
>> diff -r be3ca4e0e19e arch/x86/xen/enlighten.c
>> --- a/arch/x86/xen/enlighten.c  Thu Jan 17 14:25:07 2008 -0800
>> +++ b/arch/x86/xen/enlighten.c  Thu Jan 17 16:37:42 2008 -0800
>> @@ -95,7 +95,7 @@ struct shared_info *HYPERVISOR_shared_in
>>   *
>>   * 0: not available, 1: available
>>   */
>> -static int have_vcpu_info_placement = 1;
>> +static int have_vcpu_info_placement = 0;
>>
>>  static void __init xen_vcpu_setup(int cpu)
>>  {
>>     
>
> First of all this patch solves the lock-ups, it works as advertised :)

OK, good.  I guess events are getting lost somewhere with vcpu_info 
placement.

> # /usr/lib/xen/bin/xenctx 113
>   

Would it be possible to map the eip and some top parts of the stack back 
to kernel symbols?  Seems to be the same place in both traces, which is 
interesting.

> eip: c037c0c7
> esp: c0343f90
> eax: 00000000   ebx: 00000001   ecx: 00000000   edx: c0342000
> esi: c0373004   edi: c1210df4   ebp: 00001b7d
>  cs: 00000061    ds: 0000007b    fs: 000000d8    gs: 00000000
>
> Stack:
>  c0100add c0378980 c0101962 c0104821 c120a000 c0378df4 c0348cff 00000025
>  c0348430 00000004 00009000 00006df4 00ea1000 c0363be0 c0343fe8 c03dd007
>  00000000 c0343fec c0349868 c0343fe0 178bc1f1 00002001 00020800 00060fb1
>  00000000 c03dd000 00000000 00000000
>
> Code:
> cc cc cc cc cc cc cc cc cc cc cc cc cc cc b8 06 00 00 00 cd 82 <c3> cc
> cc cc cc cc cc cc cc cc cc
>
> Call Trace:
>   [<c037c0c7>]  <--
>   [<c0100add>]
>   [<c0378980>]
>   [<c0101962>]
>   [<c0104821>]
>   [<c120a000>]
>   [<c0378df4>]
>   [<c0348cff>]
>   [<c0348430>]
>   [<c0363be0>]
>   [<c0343fe8>]
>   [<c03dd007>]
>   [<c0343fec>]
>   [<c0349868>]
>   [<c0343fe0>]
>   [<178bc1f1>]
>   [<c03dd000>]
>
> Scenario 2 (have_vcpu_info_placement = 0)
> --------------------------------------------------------------
>
> test1: no crash
> test2: no crash, but occationally I still get funny output like this
>
> 00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
> 00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
> 00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
> 00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
> 0000AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
> 00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
> 00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
> 000AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
> 000AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
> 00AAAAAAAAAAAAAAAAAAAAAAAAAAZZ
>   

Hm, I guess some of the output is getting dropped.  Does this happen 
with 2.6.18-xen?

    J
