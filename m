Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbYJRAAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbYJRAAp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 20:00:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876AbYJRAAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 20:00:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755875AbYJRAAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 20:00:34 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
X-Fcc: ~/Mail/linus
Cc: prasad@linux.vnet.ibm.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <mingo@elte.hu>,
       <jason.wessel@windriver.com>, <avi@qumranet.com>,
       <richardj_moore@uk.ibm.com>
Subject: Re: [RFC Patch 1/9] Introducing generic hardware breakpoint handler
 interfaces
In-Reply-To: Alan Stern's message of  Thursday, 16 October 2008 10:38:44 -0400 <Pine.LNX.4.44L0.0810161027100.2487-100000@iolanthe.rowland.org>
References: <20081016024956.602C61544CB@magilla.localdomain>
	<Pine.LNX.4.44L0.0810161027100.2487-100000@iolanthe.rowland.org>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20081017235838.7BD231544CB@magilla.localdomain>
Date: Fri, 17 Oct 2008 16:58:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmm...  What happens on x86 if you have both an instruction breakpoint 
> and a data breakpoint triggered for the same instruction?  My old 386 
> manual seems to imply that you'll get two exceptions: a fault and a 
> trap.

Yes, those are not really "the same instruction".  The instruction
breakpoint gives you a fault-type debug exception, which means the
instruction hasn't actually been executed yet.  You then might not execute
it at all, if you change the PC in the trap frame.  To execute it, you have
to either set RF or disable that breakpoint, and then execute it.  If it
actually completes (doesn't have some other normal fault first like a page
fault, or an external interrupt first, etc), then you get a single-step
trap after it's executed.  As far as the hardware is concerned these two
events are entirely separate.

> There's another RF-related issue which the patch currently ignores.  
> Namely, what should happen if a new user breakpoint is registered at
> the current PC address?  We should force the RF flag to 0 so that the
> breakpoint will be triggered when execution resumes.  The problem is
> that it's not easy to tell whether the current PC corresponds to the
> same linear address as that registered for the breakpoint -- i.e., I
> don't know how the code should go about translating from virtual
> addresses to linear addresses.  Would this in fact always be the
> identity mapping?  Presumably not if we're in VM86 mode.

Um, punt?  There is the hair in step.c:convert_ip_to_linear, but, bah.
Well, I can see doing it, and it would integrate with the whole handling of
changes to ->ip, etc.  But here we have another fine example of the new can
of worms involved in getting RF handling correct.  I'm thoroughly convinced
we should drop instruction breakpoint support from the initial version of
the x86 patch and hash out this whole RF picture separately after we've got
the rest of hw_breakpoint somewhat more settled.


Thanks,
Roland
