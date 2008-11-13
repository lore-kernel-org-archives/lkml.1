Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbYKMQBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbYKMQBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 11:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbYKMQBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 11:01:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751268AbYKMQBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 11:01:06 -0500
Date: Thu, 13 Nov 2008 08:00:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] x86: optimise page fault path a little
In-Reply-To: <20081113072821.GB2946@wotan.suse.de>
Message-ID: <alpine.LFD.2.00.0811130749440.3468@nehalem.linux-foundation.org>
References: <20081113072821.GB2946@wotan.suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 Nov 2008, Nick Piggin wrote:
> 
> It's only about 1.1% on the profile of the workload I'm looking at, so my
> improvement is pretty close to in the noise, but I wonder if micro
> optimisations like the following would be welcome?

I think splitting it up is good, but I hate how your split-up ends up also 
splitting the locking (ie now you do a "down_read()" and "up_read()" in 
different functions).

I also think that to some degree you made it less readable, particularly 
this area:

	+       if (write) {
	+               if (unlikely(!(vma->vm_flags & VM_WRITE))) {
	+                       bad_area_accerr(regs, error_code, address);
	+                       return;
	+               }
	+       } else if (unlikely(error_code & PF_PROT)) {
	+               bad_area_accerr(regs, error_code, address);
	+               return;
	+       } else if (unlikely(!(vma->vm_flags & (VM_READ | VM_EXEC | VM_WRITE)))) {
	+               bad_area_accerr(regs, error_code, address);
	+               return;

makes me go "whaa?" and I wonder if it wouldn't be nicer to have one 
complex conditional hidden in an inline function, and then just have

	if (unlikely(access_error(write, error_code, vma))) {
		bad_area_access_error(regs, error_code, address);
		return;
	}

where the point is that we don't want to duplicate the error case three 
times, and that "accerr" is bad naming.

IOW, I do think that the patch looks like a step in the right direction, 
but cleanliness should be a primary concern.

		Linus
