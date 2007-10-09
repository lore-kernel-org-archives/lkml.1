Return-Path: <linux-kernel-owner+w=401wt.eu-S1757021AbXJIStz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbXJIStz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 14:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbXJIStq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 14:49:46 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41140 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464AbXJIStp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 14:49:45 -0400
Date: Tue, 9 Oct 2007 11:49:53 -0700
From: Mike Kravetz <kravetz@us.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -rt more realtime scheduling issues
Message-ID: <20071009184953.GA3285@monkey.ibm.com>
References: <20071006021548.GE4587@monkey.ibm.com> <20071008184523.GA29656@monkey.ibm.com> <20071009030412.GB12915@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009030412.GB12915@goodmis.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 11:04:12PM -0400, Steven Rostedt wrote:
> On Mon, Oct 08, 2007 at 11:45:23AM -0700, Mike Kravetz wrote:
> > Are these accurate statements?  I'll start working on a reliable delivery
> > mechanism for RealTime scheduling.  But, I just want to make sure that
> > is really necessary.
> 
> For i386 I don't think so. Seems that the interrupt handler will set the
> current task to "need_resched" and on exit of the interrupt handler, the
> schedule should take place. I don't see the race (that doesn't mean
> there is one).

The more I try understand the IPI handling the more confused I get. :(
At fist I was concerned about an IPI happening in the middle of the
__schedule routine.  But, then it occurred to me that interrupts are
disabled when in this routine (when holding the runqueue lock).  So, IPIs
are not delivered during __schedule processing.  Right?

But, if this is case then I don't understand the following code in
schedule():

        local_irq_disable();

        do {
                __schedule();
        } while (unlikely(test_thread_flag(TIF_NEED_RESCHED) ||
                          test_thread_flag(TIF_NEED_RESCHED_DELAYED)));

        local_irq_enable();

How can the reschedule flags possibly be set AFTER running __schedule.
Especially when the call is explicitly surrounded by local_irq_disable/
local_irq_enable.

Can someone help me?
-- 
Mike
