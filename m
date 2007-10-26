Return-Path: <linux-kernel-owner+w=401wt.eu-S1761597AbXJZQ3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761597AbXJZQ3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbXJZQ3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:29:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33358 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750862AbXJZQ3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:29:35 -0400
Date: Fri, 26 Oct 2007 09:28:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bart Van Assche <bart.vanassche@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Haley <aph@redhat.com>
Subject: Re: Is gcc thread-unsafe?
In-Reply-To: <alpine.LFD.0.999.0710260814570.30120@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0710260917500.30120@woody.linux-foundation.org>
References: <e2e108260710260729x4603211cgb68d7434ce1e54e9@mail.gmail.com>
 <e2e108260710260740k27210c4fu2f75d5fb31ccdccc@mail.gmail.com>
 <alpine.LFD.0.999.0710260814570.30120@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 26 Oct 2007, Linus Torvalds wrote:

> 
> 
> On Fri, 26 Oct 2007, Bart Van Assche wrote:
> > 
> > You can find my proposal to improve gcc here:
> > http://gcc.gnu.org/ml/gcc/2007-10/msg00465.html
> 
> Btw, I think this is fine per se, but putting "__attribute__((acquire))" 
> on the functions that acquire a lock does seem to be problematic, in that 
> quite often you might well want to inline those things. How would you 
> handle that?

Thinking some more about this, you really have two cases:

 - full functions taking/releasing locks (possibly conditionally, ie 
   with something lik etrylock and/or based on argument values). 

   You simply *cannot* require these to be marked, because the locking may 
   have been done indirectly. Yes, you can mark things like 
   "pthread_mutex_trylock()" as being an acquire-function, but the fact 
   is, users will then wrap these things in *other* functions, and return 
   their return values.

   Ergo: a compiler *must* assume that a function call that it 
   didn't inline involves locking. There's no point in adding some 
   gcc-specific attributes to system header files, because it's not going 
   to fix anything in any portable program.

 - inline assembly (together with, potentially, compiler primitives). 
   That's the only other way to reliably do locking from C. 

   This one gcc could certainly extend on. But would there really be any 
   upside? It would be easier/better to say that inline assembly (at least 
   if it clobbers memory or is volatile) has the same serialization issues 
   as a function call.

So the fact is, any compiler that turns

	if (conditional)
		x++;

into an unconditional write to x (where 'x' is potentially visible to the 
outside - global visibility or has had its address taken) is just broken. 

No ifs, buts or maybes about it. You simply cannot do that optimization, 
because there is no way for the compiler to know whether the conditional 
implies that you hold a lock or not.

				Linus
