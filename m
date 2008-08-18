Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbYHRJ4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbYHRJ4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 05:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374AbYHRJ4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 05:56:10 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:54759 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYHRJ4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 05:56:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=UJkVAKVxyCPZDRfGAxIUaKYe74TOUD6gn9yOQbSlK1Q1TKrwfPM9QvnMnrGX5uE6qe
         HMVukZMrs3MID/Wbu15QnWzMG/gtse07cDbqj6j0Tx/9JZ+sO2ykM/ksLgTFu3JD7SjY
         /QF7oru1+qKubkhlwSxyG0nb2v6FUP0GdmthE=
Message-ID: <48A9472F.908@panasas.com>
Date: Mon, 18 Aug 2008 12:55:59 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] debug: fix BUILD_BUG_ON() for non-constant expressions
References: <20080816100948.GB19926@martell.zuzino.mipt.ru> <alpine.LFD.1.10.0808170936260.3324@nehalem.linux-foundation.org> <20080817173319.GA2450@elte.hu> <200808181109.43203.rusty@rustcorp.com.au> <20080818075459.GH30694@elte.hu>
In-Reply-To: <20080818075459.GH30694@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
>> On Monday 18 August 2008 03:33:19 Ingo Molnar wrote:
>>> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>>> Gag me now.
>>>>
>>>> Why not just do
>>>>
>>>>  #define __BBO(c)                sizeof(const char[1 - 2*!!(c)])
>>>>  #define __BBONC(c)              __BBO(!__builtin_constant_p(c))
>>>>  #define BUILD_BUG_ON_ZERO(c)    (__BBO(c) - __BBONC(c))
>>>>  #define BUILD_BUG_ON(c)         (void)BUILD_BUG_ON_ZERO(c)
>>>>
>>>> and be done with it?
>>> yeah, i first tried a few variants of that (compile-time warnings are
>>> much better than link time warnings), but none worked when i tested
>>> various failure modes.
>> Hey, I thought I was the "undisputed ruler of Ugly-land".
>>
>> How about this instead:
>>
>> #define BUILD_BUG_ON(condition)						\
>> do {									\
>> 	static struct { char arr[1 - 2*!!(condition)]; } x __maybe_unused;	\
>> } while(0)
> 
> hm, have you tried it and do we get a severe enough link error about 
> that? If the macro gets ignored by the compiler that's really a hard 
> error - such things are essential safeguards of kernel sanity:
> 
> 	/*
> 	 * Build-time sanity checks on the kernel image and module
> 	 * area mappings. (these are purely build-time and produce no code)
> 	 */
> 	BUILD_BUG_ON(MODULES_VADDR < KERNEL_IMAGE_START);
> 	BUILD_BUG_ON(MODULES_VADDR-KERNEL_IMAGE_START < KERNEL_IMAGE_SIZE);
> 	BUILD_BUG_ON(MODULES_LEN + KERNEL_IMAGE_SIZE > 2*PUD_SIZE);
> 	BUILD_BUG_ON((KERNEL_IMAGE_START & ~PMD_MASK) != 0);
> 	BUILD_BUG_ON((MODULES_VADDR & ~PMD_MASK) != 0);
> 	BUILD_BUG_ON(!(MODULES_VADDR > __START_KERNEL));
> 	BUILD_BUG_ON(!(((MODULES_END - 1) & PGDIR_MASK) ==
> 				(__START_KERNEL & PGDIR_MASK)));
> 	BUILD_BUG_ON(__fix_to_virt(__end_of_fixed_addresses) <= MODULES_END);
> 
> ( and propagating them into runtime failures not only increases bloat,
>   it also makes failures harder to debug. These checks 'run' _early_. )
> 
> Link time warnings are easy enough to miss.
> 
> So unless there's a better way of doing it all at compile time (i'd 
> really prefer that!) i'd prefer the link time error about botched 
> BUILD_BUG_ON() conditions - as my commits introduce.
> 
> 	Ingo
> --

#define BUILD_BUG_ON(condition)						\
do {
	enum { bad = !!(condition)}; 									\
	static struct { char arr[1 - 2*bad]; } x __maybe_unused;	\
} while(0)

the enum definition will not let in anything not compile-time constant.
But then I fail on: (include/linux/virtio_config.h:99)

	if (__builtin_constant_p(fbit))
		BUILD_BUG_ON(fbit >= 32);

is that code broken?

Boaz
