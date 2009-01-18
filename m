Return-Path: <linux-kernel-owner+w=401wt.eu-S932721AbZARAO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721AbZARAO0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 19:14:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbZARAOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 19:14:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58982 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbZARAOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 19:14:16 -0500
Message-ID: <4972738A.6030506@zytor.com>
Date: Sat, 17 Jan 2009 16:10:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Kyle McMartin <kyle@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Mikael Pettersson <mikpe@it.uu.se>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "eliminate warn_on_slowpath()" change causes many gcc-3.2.3 warnings
References: <200901171519.n0HFJZuf028704@harpo.it.uu.se> <20090117161817.GA10825@elte.hu> <49723912.6020108@zytor.com> <20090117204421.GA1700@bombadil.infradead.org> <alpine.LFD.2.00.0901181032350.3006@localhost.localdomain> <49726C56.6080905@zytor.com> <alpine.LFD.2.00.0901181045550.3006@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901181045550.3006@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 17 Jan 2009, H. Peter Anvin wrote:
>> At least on x86, the two ops should be the same cost?
> 
> Not with the code Kyle had, which forces a memory load.
> 
> But yes, with a constant address, it at least comes close. But with a 
> small explicit constant value, the compiler can often do even better. For 
> example, you can generate a 64-bit -1 in many ways, while a 64-bit random 
> address is much more work to generate.
> 
> Of course, I don't know how much gcc takes advantage of this. Maybe it 
> always just generates a silly "movq" rather than being smarter about it 
> (eg "orl $-1,reg" can do it in four bytes, I think, because you can use a 
> single-byte constant).
> 
> Of course, zero is even easier to generate, so NULL is the best constant 
> of all, but generally small integers are more amenable to optimization 
> than generic addresses. They're also generally easier to test for.
> 

When compiling with -O2 -mcmodel=kernel on gcc 4.3.2, you end up with
the same 7-byte sequence:

   4:   48 c7 c7 00 00 00 00    mov    $0x0,%rdi
                        7: R_X86_64_32S bluttan
  10:   48 c7 c7 ff ff ff ff    mov    $0xffffffffffffffff,%rdi

With -Os -mcmodel=kernel, it's a bit better:


   4:   48 c7 c7 00 00 00 00    mov    $0x0,%rdi
                        7: R_X86_64_32S bluttan
  10:   48 83 cf ff             or     $0xffffffffffffffff,%rdi

I would have expected it to have used leaq in the first case, but it's
the same length (7 bytes) and probably has higher latencies.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


