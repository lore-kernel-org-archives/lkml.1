Return-Path: <linux-kernel-owner+w=401wt.eu-S1758794AbXJYXmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbXJYXmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 19:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751940AbXJYXmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 19:42:10 -0400
Received: from mail-dub.bigfish.com ([213.199.154.10]:35215 "EHLO
	mail12-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbXJYXmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 19:42:08 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <472129C3.6040405@am.sony.com>
Date: Thu, 25 Oct 2007 16:41:55 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Jon Smirl <jonsmirl@yahoo.com>
Subject: Re: IRQ off latency of printk is very high
References: <4720F21F.9090404@am.sony.com> <20071025222804.GA13954@Krystal> <47211E2C.90301@am.sony.com> <20071025231237.GT19691@waste.org>
In-Reply-To: <20071025231237.GT19691@waste.org>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2007 23:42:04.0085 (UTC) FILETIME=[A57DE650:01C81760]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Thu, Oct 25, 2007 at 03:52:28PM -0700, Tim Bird wrote:
>> Mathieu Desnoyers wrote:
>>> It might help to read this thread I posted on LKML in January 2006
>>> explaining the problem, which led to some discussion about the issue.
>>>
>>> http://lkml.org/lkml/2006/6/3/48
>> This is very helpful.  Jon Smirl's answer seems to give the
>> rationale for supporting printk output in interrupt context.
>> I'm not sure, however, if extending the interrupt off period
>> to cover the console output is required.  It didn't until
>> Ingo changed it in 2.6.17.
> 
> Hmm, I see this at the beginning of the post-BK era (2.6.12-rc2):
> 
> 	        spin_lock_irqsave(&logbuf_lock, flags);
> 		...
> 		spin_unlock(&logbuf_lock);
> 		call_console_drivers(_con_start, _log_end);
> 		local_irq_restore(flags);
> 

Well, I need to do some more research.  This must be in
release_console_sem().  I was looking at vprintk, through
the ages.  At 2.6.16, it looked like this:

        spin_lock_irqsave(&logbuf_lock, flags);
        ...
              spin_unlock_irqrestore(&logbuf_lock, flags);
              console_may_schedule = 0;
              release_console_sem();

but the irq restore has been moving around to different places
in that function over the last few years.  I suspect that in the
common case the irqsave in vprintk is the one that disables
ints.

It appears that formerly interrupts were enabled in vprintk but
re-disabled immediately upon entering release_console_sem().
As it is now, they're held during formatting, buffering,
and output, which seems excessive.

It seems draconian to drain the entire buffer with ints disabled.
Is it possible to break this up and send out smaller chunks
at a time?  Maybe by putting a chunk loop in release_console_sem()?

Just an idea.  I can see that there are a lot of requirements
for this code, and the concurrency control has gotten
complex over the years.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

