Return-Path: <linux-kernel-owner+w=401wt.eu-S932857AbYF3VIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbYF3VIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755122AbYF3VIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:08:22 -0400
Received: from gw.goop.org ([64.81.55.164]:48012 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbYF3VIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:08:21 -0400
Message-ID: <48694B3B.3010600@goop.org>
Date: Mon, 30 Jun 2008 14:08:11 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<48596315.6020104@goop.org> <48596893.4040908@sgi.com>	<485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org>	<485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org>	<485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com>	<485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com>	<485ADC73.60009@goop.org> <485BDB04.4090709@sgi.com>	<485BE80E.10209@goop.org>	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com>	<m1skv7onvh.fsf@frodo.ebiederm.org> <486912C4.8070705@sgi.com>	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com> <m14p7asl3x.fsf@frodo.ebiederm.org>
In-Reply-To: <m14p7asl3x.fsf@frodo.ebiederm.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Mike Travis <travis@sgi.com> writes:
>
>   
>> H. Peter Anvin wrote:
>>     
>>> Mike Travis wrote:
>>>       
>>>> FYI, I did try this out and it caused the bootloader to scramble the
>>>> loaded data.  The first corruption I found was the .x86cpuvendor.init
>>>> section contained all zeroes.
>>>>
>>>>         
>>> Explain what you mean with "the bootloader" in this context.
>>>
>>>     -hpa
>>>       
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
>>     
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

No, the original crash being discussed was a GP fault in head_64.S as it 
tries to initialize the kernel segments.  The cause was that the 
prototype GDT is all zero, even though it's an initialized variable, and 
inspection of vmlinux shows that it has the right contents.  But somehow 
it's either 1) getting zeroed on load, or 2) is loaded to the wrong place.

The zero-based PDA mechanism requires the introduction of a new ELF 
segment based at vaddr 0 which is sufficiently unusual that it wouldn't 
surprise me if its triggering some toolchain bug.

Mike: what would happen if the PDA were based at 4k rather than 0?  The 
stack canary would still be at its small offset (0x20?), but it doesn't 
need to be initialized.  I'm not sure if doing so would fix anything, 
however.

    J
