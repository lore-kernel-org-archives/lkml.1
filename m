Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab0BKRnM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 12:43:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36533 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756351Ab0BKRnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 12:43:10 -0500
Message-ID: <4B743F7D.3090605@zytor.com>
Date: Thu, 11 Feb 2010 09:33:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Borislav Petkov <petkovbb@googlemail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for hweight_long(CONSTANT)
References: <1265296432.22001.18.camel@laptop> <20100204155419.GD32711@aftab> <1265299457.22001.72.camel@laptop> <20100205121139.GA9044@aftab> <4B6C93A2.1090302@zytor.com> <20100206093659.GA28326@aftab> <4B6E1DA3.50204@zytor.com> <20100208092845.GB12618@a1.tnic> <4B6FDAED.9060204@zytor.com> <20100208095945.GA14740@a1.tnic> <20100211172424.GB19779@aftab>
In-Reply-To: <20100211172424.GB19779@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2010 09:24 AM, Borislav Petkov wrote:
> On Mon, Feb 08, 2010 at 10:59:45AM +0100, Borislav Petkov wrote:
>> Let me prep another version when I get back on Wed. (currently
>> travelling) with all the stuff we discussed to see how it would turn.
> 
> Ok, here's another version ontop of PeterZ's patch at
> http://lkml.org/lkml/2010/2/4/119. I need to handle 32- and 64-bit
> differently wrt to popcnt opcode so on 32-bit I do "popcnt %eax, %eax"
> while on 64-bit I do "popcnt %rdi, %rdi".

On 64 bits it should be "popcnt %rdi, %rax".

> I also did some rudimentary tracing with the function graph tracer of
> all the cpumask_weight-calls in <kernel/sched.c> while doing a kernel
> compile and the preliminary results show that hweight in software takes
> about 9.768 usecs the longest while the hardware popcnt about 8.515
> usecs. The machine is a Fam10 revB2 quadcore.
> 
> What remains to be done is see whether the saving/restoring of
> callee-clobbered regs with this patch has any noticeable negative
> effects on the software hweight case on machines which don't support
> popcnt. Also, I'm open for better tracing ideas :).
> 
> +	asm volatile(PUSH_CLOBBERED
> +		     ALTERNATIVE("call __sw_hweight64", POPCNT, X86_FEATURE_POPCNT)
> +		      POP_CLOBBERED
> +		     : "="ARG0 (res)
> +		     : ARG0 (w));


Sorry, no.

You don't do the push/pop inline -- if you're going to take the hit of
pushing this into the caller, it's better to list them as explicit
clobbers and let the compiler figure out how to do it.  The point of
doing an explicit push/pop is that it can be pushed into the out-of-line
subroutine.

Furthermore, you're still putting "volatile" on there... this is a pure
computation -- no side effects -- so it is exactly when you *shouldn't*
declare your asm statement volatile.

Note: given how simple and regular a popcnt actually is, it might be
preferrable to have the out-of-line implementation either in assembly,
or using gcc's -fcall-saved-* options to reduce the number of registers
that is clobbered by the routine.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

