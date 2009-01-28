Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbZA1BqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbZA1BqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 20:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZA1Bp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 20:45:58 -0500
Received: from rn-out-0910.google.com ([64.233.170.188]:63602 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbZA1Bp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 20:45:58 -0500
MIME-Version: 1.0
In-Reply-To: <497F7BBE.4070500@zytor.com>
References: <497A0500.3080706@gmail.com> <497B408C.20802@gmail.com>
	 <20090124172758.GA31699@elte.hu> <200901272042.57272.baldrick@free.fr>
	 <497F7BBE.4070500@zytor.com>
Date: Tue, 27 Jan 2009 20:45:55 -0500
Message-ID: <f73f7ab80901271745o4e426baew8a1f67dbacbe1aef@mail.gmail.com>
Subject: Re: [LLVMdev] inline asm semantics: output constraint width smaller 
	than input
From: Kyle Moffett <kyle@moffetthome.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Duncan Sands <baldrick@free.fr>, llvmdev@cs.uiuc.edu,
       Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 4:25 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> However, things get a bit ugly in the case of different widths that affect
> individually scheduled registers, like 32- and 64-bit types on a 32-bit
> machine.  Consider the case above where "bar" is a 64-bit type and "baz" is
> a 32-bit type, then you functionally have, at least on x86:
>
>        uint64_t tmp = bar;
>        asm("foo" : "+r" (tmp));
>        baz = (uint32_t)tmp;
>
> One could possibly argue that the latter case should be
> "baz = (uint32_t)(tmp >> 32);" on a bigendian machine... since this is a gcc
> syntax it probably should be "whatever gcc does" in that case, as opposed to
> what might make sense.
>
> (I'm afraid I don't have a bigendian box readily available at the moment, so
> I can't test it out to see what gcc does.  I have a powerpc machine, but
> it's at home and turned off.)

Actually, PPC64 boxes basically don't care... the usable GPRs are all
either 32-bit (for PPC32) or 64-bit (for PPC64), the <=32-bit
instructions are identical across both, they just
truncate/sign-extend/etc based on the lower 32-bits of the register.
Also, you would only do a right-shift if you were going all the way
out to memory as 64-bit and all the way back in as 32-bit... within a
single register it's kept coherent.

Structs are basically irrelevant for inline ASM as you can't pass a
struct to one... you can only pass the *address* of a struct, which is
always pointer-sized.

I think that really the only sane solution (which is hopefully what
GCC does) for integer types is to use a register the same size as the
larger of the two integers.  Then you copy the value to/from the
smaller register (or just mask it on PPC64-alike architectures) before
or after the inline ASM.

Cheers,
Kyle Moffett
