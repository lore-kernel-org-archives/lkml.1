Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbYKNB63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbYKNB63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 20:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYKNB6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 20:58:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:34163 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbYKNB6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 20:58:19 -0500
Date: Fri, 14 Nov 2008 02:58:17 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] x86: optimise page fault path a little
Message-ID: <20081114015817.GC5063@wotan.suse.de>
References: <20081113072821.GB2946@wotan.suse.de> <alpine.LFD.2.00.0811130749440.3468@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811130749440.3468@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 08:00:08AM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 13 Nov 2008, Nick Piggin wrote:
> > 
> > It's only about 1.1% on the profile of the workload I'm looking at, so my
> > improvement is pretty close to in the noise, but I wonder if micro
> > optimisations like the following would be welcome?
> 
> I think splitting it up is good, but I hate how your split-up ends up also 
> splitting the locking (ie now you do a "down_read()" and "up_read()" in 
> different functions).

True, but is it any better to jam them all into a 300 line function
with gotos? Hmm, this goes to there, which releases mmap_sem, and falls
through to that, then returns... oh wait, no it actually can also
`goto again`.

versus

OK, it calls some error handler, then returns. If I really cared, I
will look at how they work.

 
> I also think that to some degree you made it less readable, particularly 
> this area:
> 
> 	+       if (write) {
> 	+               if (unlikely(!(vma->vm_flags & VM_WRITE))) {
> 	+                       bad_area_accerr(regs, error_code, address);
> 	+                       return;
> 	+               }
> 	+       } else if (unlikely(error_code & PF_PROT)) {
> 	+               bad_area_accerr(regs, error_code, address);
> 	+               return;
> 	+       } else if (unlikely(!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)))) {
> 	+               bad_area_accerr(regs, error_code, address);
> 	+               return;
> 
> makes me go "whaa?" and I wonder if it wouldn't be nicer to have one 
> complex conditional hidden in an inline function, and then just have
> 
> 	if (unlikely(access_error(write, error_code, vma))) {
> 		bad_area_access_error(regs, error_code, address);
> 		return;
> 	}

That would look much nicer, yes.

 
> where the point is that we don't want to duplicate the error case three 
> times, and that "accerr" is bad naming.

accerr is just the name of the error condition, but I agree your version
reads better.
 

> IOW, I do think that the patch looks like a step in the right direction, 
> but cleanliness should be a primary concern.

I guess I consider it secondary for this function, although I honestly
it is cleaner after the patch anyway... But your suggestions are
appreciated, and made it yet cleaner again I think.

Note that I haven't actually tested all the paths in the patch myself.
In particular, not the oom path or the kernel fault path and I don't
think I tested both main sigbus paths... so I don't really feel
comfortable having this patch put in a public tree until I get around
to that. But thanks everyone for the feedback so far.

