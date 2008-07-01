Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbYGALty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbYGALty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 07:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbYGALtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 07:49:45 -0400
Received: from relay2.sgi.com ([192.48.171.30]:54149 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751768AbYGALto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 07:49:44 -0400
Message-ID: <486A19D5.7010000@sgi.com>
Date: Tue, 01 Jul 2008 04:49:41 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       cl@linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<48596315.6020104@goop.org> <48596893.4040908@sgi.com>	<485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org>	<485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org>	<485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com>	<485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com>	<485ADC73.60009@goop.org> <485BDB04.4090709@sgi.com>	<485BE80E.10209@goop.org>	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com>	<m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com>	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com> <m14p7asl3x.fsf@frodo.ebiederm.org>
In-Reply-To: <m14p7asl3x.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Mike Travis <travis@sgi.com> writes:
> 
>> H. Peter Anvin wrote:
>>> Mike Travis wrote:
>>>> FYI, I did try this out and it caused the bootloader to scramble the
>>>> loaded data.  The first corruption I found was the .x86cpuvendor.init
>>>> section contained all zeroes.
>>>>
>>> Explain what you mean with "the bootloader" in this context.
>>>
>>>     -hpa
>>
>> After the code was loaded (the compressed code, it seems that my GRUB
>> doesn't support uncompressed loading), the above section contained
>> zeroes.  I snapped it fairly early, around secondary_startup_64, and
>> then printed it in x86_64_start_kernel.
>>
>> The object file had the correct data (as displayed by objdump) so I'm
>> assuming that the bootloading process didn't load the section correctly.
>>
>> Below was the linker script I used:
>>
>> --- linux-2.6.tip.orig/include/asm-generic/vmlinux.lds.h
>> +++ linux-2.6.tip/include/asm-generic/vmlinux.lds.h
>> @@ -373,9 +373,13 @@
>>
>>  #ifdef CONFIG_HAVE_ZERO_BASED_PER_CPU
>>  #define PERCPU(align)                                                  \
>> -       . = ALIGN(align);                                               \
>> +       .data.percpu.abs = .;                                           \
>>         percpu : { } :percpu                                            \
>> -       __per_cpu_load = .;                                             \
>> +       .data.percpu.rel : AT(.data.percpu.abs - LOAD_OFFSET) {         \
>> +               BYTE(0)                                                 \
>> +               . = ALIGN(align);                                       \
>> +               __per_cpu_load = .;                                     \
>> +       }                                                               \
>>         .data.percpu 0 : AT(__per_cpu_load - LOAD_OFFSET) {             \
>>                 *(.data.percpu.first)                                   \
>>                 *(.data.percpu.shared_aligned)                          \
>> @@ -383,8 +387,8 @@
>>                 *(.data.percpu.page_aligned)                            \
>>                 ____per_cpu_size = .;                                   \
>>         }                                                               \
>> -       . = __per_cpu_load + ____per_cpu_size;                          \
>> -       data : { } :data
>> +       . = __per_cpu_load + ____per_cpu_size;
>> +
>>  #else
>>  #define PERCPU(align)                                                  \
>>         . = ALIGN(align);                                               \
>>
>> It showed all the correct address in the map and __per_cpu_load was a
>> relative symbol (which was the objective.)
>>
>> Btw, our simulator, which only loads uncompressed code, had the data correct,
>> so it *may* only be a result of the code being compressed.
> 
> Weird.  Grub doesn't get involved in the decompression the kernel does it
> all itself so we should be able to track where things go bad.
> 
> Last I looked the compressed code was formed by essentially.
> objcopy vmlinux -O binary vmlinux.bin
> gzip vmlinux.bin
> And then we take on a magic header to the gzip compressed file.
> 
> Are things only bad with the change above?
> 
> Eric

Yes.  The failure was "Unsupported CPU" (or some such) which clued me into
the vendor section.

I was able to get the zero-based variables working well for standard
configs.  It's getting tripped up now by some of Ingo's random configs,
in very unusual places... And once again, it only fails on real h/w, not
on our simulator, so catching the elusive bugger is tricky.

Thanks,
Mike
