Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbYINJCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbYINJCO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 05:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYINJB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 05:01:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:33378 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbYINJB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 05:01:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eh/ALyaslM0iNxpVOh297lEK1J+PYgBNNdFSb/dhXtnJKOjjmg8aHqrEEKZWvvq5SD
         EV91EmqZH5HlWF8PH4nEQ8kxh0jY1AymKkzTT+adiVFmR5J9tJlU9CA7F64bxFPRfV6F
         OrxGgEzCxZk4fDW+EXF4ikZwTe/RlpbEk+s24=
Message-ID: <86802c440809140201q566fba43t49ec25331b774643@mail.gmail.com>
Date: Sun, 14 Sep 2008 02:01:54 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Krzysztof Helt" <krzysztof.h1@wp.pl>
Subject: Re: [PATCH] x86: better CPU identification without the CPUID
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       mingo@redhat.com
In-Reply-To: <20080914103018.f1d684a8.krzysztof.h1@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080913125606.d655bdcf.krzysztof.h1@wp.pl>
	 <86802c440809132143p287edb82i6a73efbc53e6e93f@mail.gmail.com>
	 <86802c440809132255sa518aa8g51136ae21a880e2d@mail.gmail.com>
	 <20080914103018.f1d684a8.krzysztof.h1@wp.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2008 at 1:30 AM, Krzysztof Helt <krzysztof.h1@wp.pl> wrote:
> On Sat, 13 Sep 2008 22:55:10 -0700
> "Yinghai Lu" <yhlu.kernel@gmail.com> wrote:
>
>> On Sat, Sep 13, 2008 at 9:43 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> > On Sat, Sep 13, 2008 at 3:56 AM, Krzysztof Helt <krzysztof.h1@wp.pl> wrote:
>> >> From: Krzysztof Helt <krzysztof.h1@wp.pl>
>> >>
>> >> cpus without the CPUID instruction are identified
>> >> as general 386 or 486 while some cpus (mostly made
>> >> by Cyrix) provide c_identify function which identify
>> >> correctly older cpus using cpu specific registers).
>> >>
>> >> Cyrix cpus are even worse as 5x86 and 6x68 have
>> >> the CPUID instruction disabled. The CPUID is
>> >> enabled by the c_identify() but the c_identify
>> >> is only called when the CPUID is available.
>> >>
>> >> Fix this by calling the c_identify() for all known
>> >> cpu families if there is no the CPUID instruction
>>
>> I updated it to tip/master and call that in early_identify_cpu. it
>> should solve mtrr detection for Cyrix ...
>>
>
>
> As I wrote I have no CPU to test this (Cyrix with ARRs). Finally, I am going
>  to buy one or two of them during next two weeks so I will test.
>
> I would like to postpone your patch until I (or someone else) test it.
>
> There is some misunderstanding about the patch. There are two issues here.
> The early enabling of mtrr registers and nicer and more accurate /proc/cpuinfo
> content (and the CPU's name during boot). My patch was only about the latter.
> It was not about the early identification or solving the mtrr problem (as without
> testing I am not sure I can correctly do this). Your patch resets the /proc/cpuinfo
> content to the old status (before my patch).
>
>> From: "Yinghai Lu" <yhlu.kernel@gmail.com>
>>
>> [PATCH] x86: identify_cpu_without_cpuid
>>
>> need to call c_identify() for cpus without cpuid earlier...
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
>
>>  /*
>>   * Do minimum CPU detection early.
>>   * Fields really needed: vendor, cpuid_level, family, model, mask,
>> @@ -503,18 +530,17 @@ static void __init early_identify_cpu(st
>>  #endif
>>       c->x86_cache_alignment = c->x86_clflush_size;
>>
>> -     if (!have_cpuid_p())
>> -             return;
>> -
>>       memset(&c->x86_capability, 0, sizeof c->x86_capability);
>> -
>>       c->extended_cpuid_level = 0;
>>
>> -     cpu_detect(c);
>> -
>> -     get_cpu_vendor(c);
>> -
>> -     get_cpu_cap(c);
>> +     if (!have_cpuid_p()) {
>> +             identify_cpu_without_cpuid(c);
>> +             return;
>> +     } else {
>> +             cpu_detect(c);
>> +             get_cpu_vendor(c);
>> +             get_cpu_cap(c);
>> +     }
>>
>>       if (this_cpu->c_early_init)
>>               this_cpu->c_early_init(c);
>
> One wants to call c_early_init() here for Cyrix cpus- otherwise
> the mtrr caps are not set. The correct patch here is only:
>
>  -
>  -      if (!have_cpuid_p())
>  -              return;
>
> -           cpu_detect(c);
>
> +       if (!have_cpuid_p())
> +               enable_cpuid_on_some_cpus(); /* pseudo code for now */
>
> +       if (have_cpuid_p())
> +           cpu_detect(c);
>

could change to

if (!have_cpuid_p()) {
         identify_cpu_without_cpuid(c);

if (!have_cpuid_p())
         return;

cpu_detect(c);
get_cpu_vendor(c);
get_cpu_cap(c);

if (this_cpu->c_early_init)
 this_cpu->c_early_init(c);

will update the patch if Ingo didn't pick the patch.

>
> The enabling of the cpuid instruction should be added there but only the enabling.
>
>> @@ -583,11 +609,13 @@ static void __cpuinit detect_nopl(struct
>>
>>  static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
>>  {
>> -     if (!have_cpuid_p())
>> -             return;
>> -
>
> I have just checked:
> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git
>
> and it differs here. It is the same as in my patch (who is out of sync?).

tip/master is changed a lot to mainline.

YH
