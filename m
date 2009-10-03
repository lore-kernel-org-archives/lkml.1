Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbZJCJx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbZJCJx5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 05:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbZJCJx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 05:53:57 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:32832 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbZJCJx4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 05:53:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=VnvC69lP/6L3z78aZyA6Q4zPVsdNSf4zM1AKgElJkVuDfRvZneYeoGgP/QCawUEvTw
         EA43okOK5zqPZ5dmCKmzfOY5l6Kc7ADQjM/GIHrN0nbE9OdxNFTc/KrkJSMqSyteazq7
         7fxLUuUiMk19oAI7IDwHlSMf4wmjc0REb2bac=
MIME-Version: 1.0
In-Reply-To: <20091003072127.GC21407@elte.hu>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> 
	<20091003072127.GC21407@elte.hu>
From: Matteo Croce <technoboy85@gmail.com>
Date: Sat, 3 Oct 2009 11:53:39 +0200
Message-ID: <40101cc30910030253w70adc454r1bb38ff4424c7b14@mail.gmail.com>
Subject: Re: i686 quirk for AMD Geode
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 3, 2009 at 9:21 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Matteo Croce <technoboy85@gmail.com> wrote:
>
>> Hi,
>>
>> the AMD GEode LX has an x86 id of 5 (i586) tought it's technically an i686:
>>
>> root@alix:/usr/src# cat /proc/cpuinfo
>> processor       : 0
>> vendor_id       : AuthenticAMD
>> cpu family      : 5
>> model           : 10
>> model name      : Geode(TM) Integrated Processor by AMD PCS
>> stepping        : 2
>> cpu MHz         : 498.060
>> cache size      : 128 KB
>> fdiv_bug        : no
>> hlt_bug         : no
>> f00f_bug        : no
>> coma_bug        : no
>> fpu             : yes
>> fpu_exception   : yes
>> cpuid level     : 1
>> wp              : yes
>> flags           : fpu de pse tsc msr cx8 sep pge cmov clflush mmx
>> mmxext 3dnowext 3dnow
>> bogomips        : 996.12
>> clflush size    : 32
>> cache_alignment : 32
>> address sizes   : 32 bits physical, 32 bits virtual
>> power management:
>>
>> indeed it has mmx, mmxext and cmov.
>> So I added the quirk below and I can confirm that the system is running fine.
>> I did an x264 encode to trigger any SIGILL due to missing opcodes, but
>> it worked.
>>
>> I also did this simple test which gives a ~2.5x speed boost:
>> http://pastebin.ca/1590089
>>
>> I wish some feedback from someone, I really dunno why AMD set the
>> cpuid value to 5
>>
>> --- a/arch/x86/kernel/cpu/bugs.c      2009-10-03 03:43:02.399323313 +0200
>> +++ b/arch/x86/kernel/cpu/bugs.c      2009-10-03 03:54:22.582205090 +0200
>> @@ -151,6 +151,12 @@
>>  #endif
>>  }
>>
>> +static void __init check_geode_i586(void)
>> +{
>> +     if(boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
>> +        boot_cpu_data.x86_model == 10 && boot_cpu_data.x86 == 5)
>> +             boot_cpu_data.x86 = 6;
>> +}
>>
>>  void __init check_bugs(void)
>>  {
>> @@ -163,6 +169,7 @@
>>       check_fpu();
>>       check_hlt();
>>       check_popad();
>> +     check_geode_i586();
>>       init_utsname()->machine[1] =
>>               '0' + (boot_cpu_data.x86 > 6 ? 6 : boot_cpu_data.x86);
>>       alternative_instructions();
>
> Looks good, but your signoff line is missing.
>
>        Ingo
>

Sorry Ingo but if you read my last mail I wrote that the GEODE does
supports FCOMI but not NOPL
so i don't know if it's worth it, even is I haven't ANY binary in my
system with such instruction:

# find /lib/tls/i686 /lib/i686 -type f |xargs objdump -d |grep -c nopl
0
