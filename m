Return-Path: <linux-kernel-owner+w=401wt.eu-S1762207AbXK2Bau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762207AbXK2Bau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 20:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758024AbXK2Bal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 20:30:41 -0500
Received: from gw.goop.org ([64.81.55.164]:51199 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756722AbXK2Bak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 20:30:40 -0500
Message-ID: <474E163E.2070702@goop.org>
Date: Wed, 28 Nov 2007 17:30:38 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: [patch 05/14] percpu: Use a Kconfig variable to configure arch
 specific percpu setup
References: <20071127001407.859743255@sgi.com> <200711281236.02014.rusty@rustcorp.com.au> <Pine.LNX.4.64.0711281050470.11968@schroedinger.engr.sgi.com> <200711291017.52727.rusty@rustcorp.com.au> <474DFD7E.907@goop.org> <Pine.LNX.4.64.0711281604560.17738@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711281604560.17738@schroedinger.engr.sgi.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Wed, 28 Nov 2007, Jeremy Fitzhardinge wrote:
>
>  > Yes, I would like to convert x86_64 to match i386's percpu, and drop the
>   
>> pda altogether.  The only thing preventing this is the stack canary, and
>> I'm wondering how much value there is in keeping it, given the
>> disadvantages of having this divergence between 32 and 64 bit.
>>     
>
> I think most of the PDA could be gotten rid of. The problems are
>
> 1. The stack canary
>   

Yes, this is a biggie.  It needs one of:

    * fix gcc
    * post-process the .s file
    * drop support for stack-protector (does it really help? do people
      use it?)


> 2. The PDA is used to store per cpu data before the per cpu areas
>    are setup.
>   

I don't see the problem.  The way i386 does it inherently supports
per-cpu data very early on (it uses the prototype percpu section until
the real percpu values are set up).

> The i386 way of referring to per cpu data is not optimal because it is 
> always offset by __per_cpu_start. per cpu data offsets need to be relative 
> to the beginning of the per cpu area. per cpu data is less than 64k so 2 
> byte offsets would be enough.
>   

I don't see that's terribly important.  percpu references aren't all
that common overall, and - at least on x86 - using a 16-bit offset
(assuming its possible) would require a prefix anyway, so it would only
save 1 byte per reference.  But I can't convince gas to generate a
16-bit offset anyway.

> That way the __per_cpu_offset array and the registers that are used on 
> various platforms are pointing to the actual data and can be loaded
> directly into a register and then a load with a small offset to that 
> register can be performed. On x86_64 this is gs, on i386 fs, on sparc g5, 
> on ia64 a fixed address stands in for the register.

The asm used to generate these references is inherently arch-specific
anyway, so the type and size of offset needed from the per-cpu base
register to the data itself can be arch-dependent without loss of
generality.  

I definitely see that small offsets might be useful for other
architectures, but for x86 it doesn't help and makes things more
complex.  The only difference between 32- and 64-bit is whether we
generate an offset from %fs, %gs or nothing (for the UP case).


>  In loops over all per 
> cpu variables this will also simplify the code.
>   

Why's that?

> And ultimately we can get rid of the ugly RELOC_HIDE macro. It simply 
> becomes the adding of the base address in a register to a per cpu offset.
>   

I was never quite sure what that was for.

    J
