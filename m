Return-Path: <linux-kernel-owner+w=401wt.eu-S1762709AbXJZFEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762709AbXJZFEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 01:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbXJZFD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 01:03:58 -0400
Received: from 1wt.eu ([62.212.114.60]:3560 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbXJZFD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 01:03:57 -0400
Date: Fri, 26 Oct 2007 06:57:55 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Is gcc thread-unsafe?
Message-ID: <20071026045754.GX10199@1wt.eu>
References: <200710251324.49888.nickpiggin@yahoo.com.au> <200710260116.10904.ak@suse.de> <alpine.LFD.0.999.0710251628440.30120@woody.linux-foundation.org> <200710260142.37902.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710260142.37902.ak@suse.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 01:42:37AM +0200, Andi Kleen wrote:
> On Friday 26 October 2007 01:32:53 Linus Torvalds wrote:
> > 
> > On Fri, 26 Oct 2007, Andi Kleen wrote:
> > > 
> > > No it can't (at least not on x86) as I have explained in the rest of the mail 
> > > you conveniently snipped.
> > 
> > I "conveniently snipped it" because it was pointless.
> > 
> > "adc" or "cmov" has nothing what-so-ever to do with it. If some routine 
> > returns 0-vs-1 and gcc then turns "if (routine()) x++" into 
> > "x+=routine()", what does that have to do with adc or cmov?
> 
> That is not what gcc did in that case. I don't think it tracks sets of values
> over function calls (or even inside functions) at all.
> 
> The generated code was
> 
>           cmpl    $1, %eax                ; test res
>           movl    acquires_count, %edx    ; load
>           adcl    $0, %edx                ; maybe add 1
>           movl    %edx, acquires_count    ; store
> 
> So it just added the result of a comparison into a variable
> by (ab)using carry for this.

While this is OK in mono-threaded code, it introduces a race condition in
multi-threaded code. The code above tried to acquire a lock, and eax was
set to 1 if it succeeded. And whatever the result, all threads still
happily modify the shared memory area (acquires_count). So the classical
case where two threads perform the same operation at the same time ends
up with a random value in acquires_count.

> In theory such things can be done with CMOV too by redirecting
> a store into a dummy variable to cancel it, but gcc doesn't
> do that on its own.

Even with a CMOV, it's the memory write which should not be performed
if the lock was not acquired.

(...)
> But for registers it's a fine optimization.

100% agree.

What would really be needed is an attribute around conditions to
indicate whether they *may* be optimized or not. Something similar
to the likely/unlikely we currently use, we could have something
like __attribute__((unsafe_cond(cond))). I think that it could still
optimize by default but let the user explicitly state that he is
playing with thread-unsafe code. As you pointed out, you did not
find any such mis-optimization in the kernel, which means that it
does not hit too often. That's the reason why I'd let the user be
careful.

Willy

