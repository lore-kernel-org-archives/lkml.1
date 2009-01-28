Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbZA1B4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbZA1B4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 20:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZA1B4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 20:56:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58036 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZA1B4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 20:56:37 -0500
Message-ID: <497FBB30.3020804@zytor.com>
Date: Tue, 27 Jan 2009 17:56:00 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Kyle Moffett <kyle@moffetthome.net>
CC: Duncan Sands <baldrick@free.fr>, llvmdev@cs.uiuc.edu,
       Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [LLVMdev] inline asm semantics: output constraint width smaller
 	than input
References: <497A0500.3080706@gmail.com> <497B408C.20802@gmail.com>	 <20090124172758.GA31699@elte.hu> <200901272042.57272.baldrick@free.fr>	 <497F7BBE.4070500@zytor.com> <f73f7ab80901271745o4e426baew8a1f67dbacbe1aef@mail.gmail.com>
In-Reply-To: <f73f7ab80901271745o4e426baew8a1f67dbacbe1aef@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett wrote:
> 
> Actually, PPC64 boxes basically don't care... the usable GPRs are all
> either 32-bit (for PPC32) or 64-bit (for PPC64), the <=32-bit
> instructions are identical across both, they just
> truncate/sign-extend/etc based on the lower 32-bits of the register.
> Also, you would only do a right-shift if you were going all the way
> out to memory as 64-bit and all the way back in as 32-bit... within a
> single register it's kept coherent.
> 

Think about a 64-bit integer on ppc32.  It will by necessity kept in two 
registers.  On gcc I believe it will always be a consecutive pair of 
registers (AFAIK that's a hard-coded assumption in gcc, with the result 
that gcc has a nonstandard internal register numbering for x86 since the 
commonly used dx:ax pair is actually registers 2:0 in the hardware 
numbering.)

> Structs are basically irrelevant for inline ASM as you can't pass a
> struct to one... you can only pass the *address* of a struct, which is
> always pointer-sized.

Right, of course.

> I think that really the only sane solution (which is hopefully what
> GCC does) for integer types is to use a register the same size as the
> larger of the two integers.  Then you copy the value to/from the
> smaller register (or just mask it on PPC64-alike architectures) before
> or after the inline ASM.

Pretty much.  Then you can do conventional copy propagation and 
elimination after expanding subregisters to get rid of the extra ops in 
the common case.

	-hpa

