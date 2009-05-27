Return-Path: <linux-kernel-owner+w=401wt.eu-S1763340AbZE0UAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763340AbZE0UAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757852AbZE0UAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:00:23 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:55012 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759550AbZE0UAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:00:22 -0400
Message-ID: <4A1D9BD0.8090508@nortel.com>
Date: Wed, 27 May 2009 14:00:16 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ulrich Drepper <drepper@redhat.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: linux missing support for _POSIX_THREAD_CPUTIME?
References: <4A1D6E71.90602@nortel.com> <alpine.LFD.2.00.0905271855290.3397@localhost.localdomain> <4A1D7512.9080604@nortel.com> <alpine.LFD.2.00.0905271922470.3397@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905271922470.3397@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2009 20:00:21.0460 (UTC) FILETIME=[C4196940:01C9DF05]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Wed, 27 May 2009, Chris Friesen wrote:
> 
> 
>>Thomas Gleixner wrote:
>>
>>>On Wed, 27 May 2009, Chris Friesen wrote:
>>>
>>>That's more a question for the glibc folks. CC'ed.
>>
>>Actually, I'm looking at the kernel code here.  It looks like
>>posix_cpu_clock_get() should be able to handle a per-task cpu clock for
>>another thread within the same process.  However, it's only ever called
>>by thread_cpu_clock_get(), which hardcodes a clock_id of THREAD_CLOCK,
>>which corresponds to the current thread.
> 
> 
> No, it's also called via the CLOCK_DISPATCH magic in posix_timers.c

>>Similarly, invalid_clockid() will say that the clock_id is invalid if
>>it's positive but greater than 15.  If my math is right, this means that
>>any pid > 2 will result in invalid_clockid() failing.

Both invalid_clockid() and CLOCK_DISPATCH assume that the clock_id will
be negative in order to call posix_cpu_clock_get().

In pthread_getcpuclockid() in glibc, I couldn't see how we were ending
up with a negative clock_id.  However, I finally clued in to the fact
that there are multiple implementations of this function, and in one
code path in one of the implementations we call MAKE_THREAD_CPUCLOCK()
which can result in a negative clock_id.

Thanks for the help.

Chris
