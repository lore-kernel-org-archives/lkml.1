Return-Path: <linux-kernel-owner+w=401wt.eu-S1752304AbYGVEM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbYGVEM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 00:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750707AbYGVEMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 00:12:20 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35208 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbYGVEMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 00:12:18 -0400
Subject: Re: [RFC] schedule_timeout_range()
From: David Woodhouse <dwmw2@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, arjan@infradead.org
In-Reply-To: <200807221356.29892.nickpiggin@yahoo.com.au>
References: <1216695757.18980.16.camel@shinybook.infradead.org>
	 <1216695942.18980.19.camel@shinybook.infradead.org>
	 <200807221356.29892.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Tue, 22 Jul 2008 00:12:02 -0400
Message-Id: <1216699922.18980.66.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-22 at 13:56 +1000, Nick Piggin wrote:
> Rather than specific "deadline" values (which we can't guarantee anyway),
> or vague "can defer" values,

We already _have_ those vague 'can defer' timers. They'll get run the
next time the CPU happens to be awake after they expire.

>  I would prefer just a small selection of maybe orders of magnitude
> flags, maybe SECONDS, MILLISECONDS, MICROSECONDS which gives an amount
> of delay the kernel might add to the timer.

As far as I can tell, any implementation of that ends up being converted
into what we have at the moment -- a deferrable timer which gets run
some time after it expires, and a timer which would actually _wake_ a
sleeping CPU. You have to create a value for that final timer anyway, so
why not just let the in-kernel caller provide it?

There's no point in trying to coalesce the 'final' timeouts; if just one
of them wakes the CPU and we're in the range for any other 'range
timers', those others will happy immediately anyway.

We did ponder the idea of a per-process setting which affects userspace
delays like nanosleep/poll/select, and introduces a variable extra delay
if the CPU is actually sleeping. So we can reduce the number of CPU
wakeup events for thosee userspace apps which aren't timing-sensitive.

We were also thinking of extending nanosleep/ppoll/pselect also to take
a 'range', for those cases where the process-wide setting needs to be
overridden. The prctl is a simple solution which doesn't involve
modifying large chunks of userspace to use new system calls, but it's
not a panacea -- in some places, an app might _want_ a prompt wakeup.

For kernel timers, though, I think it's better to let the caller set a
non-deferrable timer at a specific time. Although you're right that
'deadline' is probably a bad name for it. 

How about 'start' and 'end'? Or 'early' and 'late'? I really don't care
too much what it's called.

-- 
dwmw2

