Return-Path: <linux-kernel-owner+w=401wt.eu-S1758817AbYFWQzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbYFWQzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 12:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbYFWQzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 12:55:11 -0400
Received: from relay2.sgi.com ([192.48.171.30]:51661 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751649AbYFWQzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 12:55:09 -0400
Message-ID: <485FD56B.1090303@sgi.com>
Date: Mon, 23 Jun 2008 09:55:07 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<20080605102222.GA21319@elte.hu> <484EF29C.7080100@sgi.com>	<485947A8.8060801@goop.org> <4859511E.5050605@sgi.com>	<48596315.6020104@goop.org> <48596893.4040908@sgi.com>	<485AADAC.3070301@sgi.com> <485AB78B.5090904@goop.org>	<485AC120.6010202@sgi.com> <485AC5D4.6040302@goop.org>	<485ACA8F.10006@sgi.com> <485ACD92.8050109@sgi.com>	<485AD138.4010404@goop.org> <485ADA12.5010505@sgi.com>	<485ADC73.60009@goop.org> <485BDB04.4090709@sgi.com>	<485BE80E.10209@goop.org>	<Pine.LNX.4.64.0806201045460.15874@schroedinger.engr.sgi.com>	<485BF8F5.6010802@goop.org> <485BFFC5.6020404@sgi.com> <m1skv7onvh.fsf@frodo.ebiederm.org>
In-Reply-To: <m1skv7onvh.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Mike Travis <travis@sgi.com> writes:
> 
>> Jeremy Fitzhardinge wrote:
>>>
>>> BTW, I think __per_cpu_load will cause trouble if you make a relocatable
>>> kernel, being an absolute symbol.  But I have relocation off at the moment.
>>>
>> ...
>> Here's where it's defined (in include/asm-generic/vmlinux.lds.h):
>>
>> #ifdef CONFIG_HAVE_ZERO_BASED_PER_CPU
>> #define PERCPU(align)                                                   \
>>         . = ALIGN(align);                                               \
>>         percpu : { } :percpu                                            \
>>         __per_cpu_load = .;                                             \
>>         .data.percpu 0 : AT(__per_cpu_load - LOAD_OFFSET) {             \
>>                 *(.data.percpu.first)                                   \
>>                 *(.data.percpu.shared_aligned)                          \
>>                 *(.data.percpu)                                         \
>>                 *(.data.percpu.page_aligned)                            \
>>                 ____per_cpu_size = .;                                   \
>>         }                                                               \
>>         . = __per_cpu_load + ____per_cpu_size;                          \
>>         data : { } :data
>> #else
>>
>> Can we generate a new symbol which would account for LOAD_OFFSET?
> 
> Ouch.  Absolute symbols indeed.  On the 32bit kernel that may play havoc
> with the relocatable kernel, although we have had similar absolute logic
> for the last year. With __per_cpu_start and __per_cpu_end so it may
> not be a problem.
> 
> To initialize the percpu data you do want to talk to the virtual address
> at __per_coup_load.  But it is absolute Ugh.  
> 
> It might be worth saying something like.
> .data.percpu.start : AT(.data.percpu.dummy - LOAD_OFFSET) {
> 	DATA(0)                   
> 	. = ALIGN(align);
>         __per_cpu_load = . ;                   
> }
> To make __per_cpu_load a relative symbol. ld has a bad habit of taking
> symbols out of empty sections and making them absolute.  Which is why
> I added the DATA(0).
> 
> Still I don't think that would be the 64bit problem.
> 
> Eric

I'm not sure I understand the linker lingo enough to fill in the rest
of the blanks... I've tried various versions around this framework and
none have been accepted yet.

#ifdef CONFIG_HAVE_ZERO_BASED_PER_CPU
#define PERCPU(align)                                                   \
        .data.percpu.start : AT(.data.percpu.dummy - LOAD_OFFSET) {     \
                DATA(0)                                                 \
                . = ALIGN(align);                                       \
                __per_cpu_load = .;                                     \
                *(.data.percpu.first)                                   \
                *(.data.percpu.shared_aligned)                          \
                *(.data.percpu)                                         \
                *(.data.percpu.page_aligned)                            \
                ____per_cpu_size = . - __per_cpu_load                   \
        }                                                               \
#else

Thanks,
Mike
