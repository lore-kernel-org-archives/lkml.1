Return-Path: <linux-kernel-owner+w=401wt.eu-S1760374AbXJZP1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760374AbXJZP1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXJZP1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:27:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45601 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361AbXJZP1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:27:34 -0400
Date: Fri, 26 Oct 2007 08:27:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bart Van Assche <bart.vanassche@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Is gcc thread-unsafe?
In-Reply-To: <e2e108260710260740k27210c4fu2f75d5fb31ccdccc@mail.gmail.com>
Message-ID: <alpine.LFD.0.999.0710260814570.30120@woody.linux-foundation.org>
References: <e2e108260710260729x4603211cgb68d7434ce1e54e9@mail.gmail.com>
 <e2e108260710260740k27210c4fu2f75d5fb31ccdccc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Oct 2007, Bart Van Assche wrote:
> 
> You can find my proposal to improve gcc here:
> http://gcc.gnu.org/ml/gcc/2007-10/msg00465.html

Btw, I think this is fine per se, but putting "__attribute__((acquire))" 
on the functions that acquire a lock does seem to be problematic, in that 
quite often you might well want to inline those things. How would you 
handle that?

The fact is, the whole optimization is broken. You should never do 
extraneous writes to anything but registers (or your own spill pool on the 
stack - anything that hasn't had its address taken and cannot be visible 
to outsiders). A C compiler should basically do what the user asks it to 
do, and that means that it simply should be _very_ nervous about doing 
optimizations that can have visible secondary effects.

So the first question that should be asked is: "is that optimization even 
worth it in the first place outside of registers and the spill pool?"

If an optimization introduces visible behaviour differences to the 
"obvious" stupid interpretation of the code, it should automatically be 
something that should be given a lot of thought, and perhaps not enabled 
at all by default (where "default" is certainly normal optimization 
levels).

And different languages have different usages. In C, it's quite common 
(and _possible_) for the programmer to specify how to do things at a 
fairly low level. That's not true in all other languages, and it affects 
how a compiler should optimize things. In C, a compiler should give more 
weight to "this is how the user specified the solution" because in C, 
programmers really *do* that. 

So I don't think your proposal is wrong, but I think before even going to 
something like that, you should ask yourself: "was that a valid 
optimization to start with?"

(That said, there may well be *other* reasons for wanting gcc to know 
about lock/unlock behaviour and teaching gcc about barriers. If gcc starts 
getting more threading knowledge, gcc may well need to have that kind of 
information in other places).

				Linus
