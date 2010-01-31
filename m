Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201Ab0AaAqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab0AaAqb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 19:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035Ab0AaAq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 19:46:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:46115 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab0AaAq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 19:46:27 -0500
Date: Sat, 30 Jan 2010 16:47:16 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: High scheduler wake up times
Message-ID: <20100130164716.230dfe31@infradead.org>
In-Reply-To: <20100131003549.GC27390@mediacenter.gateway.2wire.net>
References: <20100130234551.GA27390@mediacenter.gateway.2wire.net>
	<20100130161114.07278221@infradead.org>
	<20100131003549.GC27390@mediacenter.gateway.2wire.net>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jan 2010 18:35:49 -0600
Shawn Bohrer <shawn.bohrer@gmail.com> wrote:
\
> 
> I agree that we are currently depending on a bug in epoll.  The epoll
> implementation currently rounds up to the next jiffie, so specifying a
> timeout of 1 ms really just wakes the process up at the next timer
> tick. I have a patch to fix epoll by converting it to use
> schedule_hrtimeout_range() that I'll gladly send, but I still need a
> way to achieve the same thing.

it's not going to help you; your expectation is incorrect.
you CANNOT get 1000 iterations per second if you do

<wait 1 msec>
<do a bunch of work>
<wait 1 msec>
etc in a loop

the more accurate (read: not rounding down) the implementation, the
more not-1000 you will get, because to hit 1000 the two actions

<wait 1 msec>
<do a bunch of work>

combined are not allowed to take more than 1000 microseconds wallcock
time. Assuming "do a bunch of work" takes 100 microseconds, for you to
hit 1000 there would need to be 900 microseconds in a milliseconds...
and sadly physics don't work that way.

(and that's even ignoring various OS, CPU wakeup and scheduler
contention overheads)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
