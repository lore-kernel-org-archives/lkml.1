Return-Path: <linux-kernel-owner+w=401wt.eu-S1752598AbXIQFIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbXIQFIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 01:08:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbXIQFIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 01:08:39 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:54276 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbXIQFIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 01:08:39 -0400
Date: Sun, 16 Sep 2007 22:06:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: crashme fault
Message-Id: <20070916220643.bea3e44f.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.0.999.0709161055070.16478@woody.linux-foundation.org>
References: <20070912222151.70d1fc7d.randy.dunlap@oracle.com>
	<alpine.LFD.0.999.0709142101140.16478@woody.linux-foundation.org>
	<20070915183412.GA14501@one.firstfloor.org>
	<46EC2702.3090000@oracle.com>
	<alpine.LFD.0.999.0709151224400.16478@woody.linux-foundation.org>
	<alpine.LFD.0.999.0709151508590.16478@woody.linux-foundation.org>
	<alpine.LFD.0.999.0709151542340.16478@woody.linux-foundation.org>
	<46EC6F2A.5090008@oracle.com>
	<alpine.LFD.0.999.0709151727180.16478@woody.linux-foundation.org>
	<20070916094001.d87ed0f0.randy.dunlap@oracle.com>
	<alpine.LFD.0.999.0709161004080.16478@woody.linux-foundation.org>
	<alpine.LFD.0.999.0709161055070.16478@woody.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Sep 2007 11:12:23 -0700 (PDT) Linus Torvalds wrote:

> 
> 
> On Sun, 16 Sep 2007, Linus Torvalds wrote:
> > 
> > I'm really starting to suspect some early EM64T bug, and I also suspect 
> > that it's harmless but that we should just do the trivial patch to say "if 
> > the register state is in user mode, we don't care if the CPU says it was a 
> > kernel access".
> 
> Namely something like this..
> 
> The basic idea is that it's pointless to test for "error_code & PF_USER" 
> to decide whether we should oops or kill the process: the *real* issue is 
> whether we *can* kill the process or not. And that depends not on whether 
> the CPU claimed it was a user access or not, but on whether the register 
> state we'd return to is user-mode or not!
> 
> So anything that decides whether it should send a signal or do to the 
> "no_context" Ooops path should use "user_mode_vm(regs)" (yeah, I realize 
> that the "_vm" part is unnecessary on x86-64, but it doesn't hurt either, 
> and all of the issues are the same on 32/64-bit) which tests the right 
> thing.
> 
> Now, normally the USER bit in the error code should be the exact same 
> thing, except for
> 
>  - Some CPU bug (microcode issue, whatever) where some complex fault 
>    situation sets the wrong error code.
> 
>  - user space accesses that caused a system page fault (ie a page fault 
>    while handling another trap - possibly due to lazy page table setup 
>    and having the LDT or some other CPU data structure in vmalloc space)
> 
> Now, the vmalloc space accesses should be handled separately anyway, so I 
> really wonder if it's some subtle CPU bug (I can't reproduce any problems 
> on my Core 2 Duo), but the point is that I think this patch really is 
> conceptually a real fix regardless, even if it _shouldn't_ matter.
> 
> Comments?
> 
> Randy, this replaces the hacky patch I sent, but also shuts up about the 
> odd thing you're hitting, so for testing your case further this may not be 
> the right thing. However, it would be nice to hear whether this just makes 
> "crashme" work properly for you without any side effects..

I'll test this overnight on 2.6.23-rc6-git2 since that was failing.

I haven't been able to reproduce the fault on 2.6.21 after several
hours of testing.

I'll also test a microcode update to see if it helps.

---
~Randy
