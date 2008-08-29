Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbYH2NoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbYH2NoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 09:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756572AbYH2NoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 09:44:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44009 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268AbYH2Nn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 09:43:59 -0400
Date: Fri, 29 Aug 2008 09:43:57 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pavel Machek <pavel@suse.cz>
cc: LKML <linux-kernel@vger.kernel.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ftrace: disable tracing for suspend to ram
In-Reply-To: <20080828072840.GA15474@elf.ucw.cz>
Message-ID: <alpine.DEB.1.10.0808290942450.8716@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0808211139420.3947@gandalf.stny.rr.com> <20080822104610.GA3482@elf.ucw.cz> <alpine.DEB.1.10.0808221632410.14231@gandalf.stny.rr.com> <200808222252.12547.rjw@sisk.pl> <alpine.DEB.1.10.0808221651350.15941@gandalf.stny.rr.com>
 <alpine.DEB.1.10.0808270844500.7871@gandalf.stny.rr.com> <20080828072840.GA15474@elf.ucw.cz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 28 Aug 2008, Pavel Machek wrote:

> On Wed 2008-08-27 09:14:40, Steven Rostedt wrote:
> > 
> > I've been painstakingly debugging the issue with suspend to ram and 
> > ftraced. The 2.6.28 code does not have this issue, but since the mcount 
> > recording is not going to be in 27, this must be solved for the ftrace 
> > daemon version.
> > 
> > The resume from suspend to ram would reboot because it was triple 
> > faulting. Debugging further, I found that calling the mcount function 
> > itself was not an issue, but it would fault when it incremented 
> > preempt_count. preempt_count is on the tasks info structure that is on the 
> > low memory address of the task's stack.  For some reason, it could not 
> > write to it. Resuming out of suspend to ram does quite a lot of funny 
> > tricks to get to work, so it is not surprising at all that simply doing a 
> > preempt_disable() would cause a fault.
> > 
> > Thanks to Rafael for suggesting to add a "while (1);" to find the place in 
> > resuming that is causing the fault. I would place the loop somewhere in 
> > the code, compile and reboot and see if it would either reboot (hit the 
> > fault) or simply hang (hit the loop).  Doing this over and over again, I 
> > narrowed it down that it was happening in enable_nonboot_cpus.
> > 
> > At this point, I found that it is easier to simply disable tracing around 
> > the suspend code, instead of searching for the particular function that 
> > can not handle doing a preempt_disable.
> > 
> > This patch disables the tracer as it suspends and reenables it on resume.
> > 
> > I tested this patch on my Laptop, and it can resume fine with the patch.
> > 
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> 
> So this is going to be reverted after 2.6.27? Okay, then.

Maybe not. The difference is that in 27 it would cause s2ram to fail every
time. In 28 (I have not proved this yet), it may fail s2ram if the tracer 
is on.

-- Steve

> 
> Acked-by: Pavel Machek <pavel@suse.cz>
> 
