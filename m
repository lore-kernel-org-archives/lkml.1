Return-Path: <linux-kernel-owner+w=401wt.eu-S1760346AbYE0WBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760346AbYE0WBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 18:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758928AbYE0WBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 18:01:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:64277 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758349AbYE0WBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 18:01:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=huICjjwETNL8chCKP1GSNAAyyn6sMXNCSFaiCsw6DayGOpnyPWvCb38p09XsoGQqEIVl7mF88p1FSMFoxvQdVOsHHEbkRW2Gvbf8VI2+nw0MNPO/rM8NRwtBz+SfhVS+SEzQQhcGbSqbM66I2SJmAEyE2RgfurPrpimayzqCsEA=
Message-ID: <19f34abd0805271501p5eb4916h5dd37c18be8d21fb@mail.gmail.com>
Date: Wed, 28 May 2008 00:01:02 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [PATCH] x86: break mutual header inclusion
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20080527213819.GC11310@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080527204926.GA15020@damson.getinternet.no>
	 <20080527213819.GC11310@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Tue, May 27, 2008 at 11:38 PM, Adrian Bunk <bunk@kernel.org> wrote:
> On Tue, May 27, 2008 at 10:49:26PM +0200, Vegard Nossum wrote:
>> Hi,
>>
>> What do you think about this? The new file (vm86_mask.h) could actually be
>> embedded completely in processor-flags.h, but I went for what I believe is
>> the safer approach.
>
> Breaking the mutual header inclusion is appreciated, but some comments
> are below.

[...]

>> -/* the DS BTS struct is used for ptrace as well */
>> -#include <asm/ds.h>
>> -
>>  struct task_struct;
>>
>>  extern void ptrace_bts_take_timestamp(struct task_struct *, enum bts_qualifier);
>
> Moving #include's out of an #ifdef __KERNEL__ can (and does here) break
> our userspace headers.
>
> Running "make headers_check" after touching anything under include/ is
> recommended since it catches these problems.
>

Ah, that's true. My mistake.

  CHECK   include/asm/ptrace.h
[...]/usr/include/asm/ptrace.h requires asm/ds.h, which does not exist
in exported headers

What do you reckon is better here, to put #ifdef __KERNEL__ around the
whole of ds.h and export it, or put #ifdef __KERNEL__ around the
#include in ptrace.h? It feels wasteful to put it around the whole
ds.h, since what is the point in exporting an empty file? On the other
hand, it makes much more sense to put it there than in the "caller" in
order to avoid the duplication of #ifdef __KERNEL__. So unless you
prefer otherwise, I will choose the former (to export ds.h as well).

I hope you agree with the idea of moving the #include line to the top
of the file, however?

Thanks for the tip, that is very useful. I didn't realize I should use
that and I'm sorry for wasting your time with the first attempt :-(

>>...
>> --- /dev/null
>> +++ b/include/asm-x86/vm86_mask.h
>> @@ -0,0 +1,12 @@
>> +#ifndef ASM_X86_VM86_MASK
>> +#define ASM_X86_VM86_MASK
>> +
>> +#include <asm/processor-flags.h>
>> +
>> +#ifdef CONFIG_VM86
>> +#define X86_VM_MASK  X86_EFLAGS_VM
>> +#else
>> +#define X86_VM_MASK  0 /* No VM86 support */
>> +#endif
>> +
>> +#endif
>
> Do we need a new header for this or can it go into processor-flags.h ?

It can go in there, yes. I will do that in the re-worked (hopefully
correct) patch.

This business of breaking cycles is a bit nasty. There are very many
traps to fall into, very many setups to break, and very little support
from the tools to help you get it right (though with 'make
headers_check' I am a little better off).

Thanks for the help :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
