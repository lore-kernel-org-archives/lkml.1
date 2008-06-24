Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbYFXKll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbYFXKll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 06:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbYFXKld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 06:41:33 -0400
Received: from saeurebad.de ([85.214.36.134]:52336 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578AbYFXKlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 06:41:31 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: a.p.zijlstra@chello.nl, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] softirq softlockup debugging
References: <20080622122845.GA10133@damson.getinternet.no>
Date: Tue, 24 Jun 2008 12:41:13 +0200
In-Reply-To: <20080622122845.GA10133@damson.getinternet.no> (Vegard Nossum's
	message of "Sun, 22 Jun 2008 14:28:45 +0200")
Message-ID: <87prq79kty.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vegard,

Vegard Nossum <vegard.nossum@gmail.com> writes:

> Hi,
>
> I'm debugging a problem with a softirq that gets stuck for a long time,
> so I wrote this patch to help find out what's going wrong.
>
> I actually think it can be useful in general as well, see for example
> http://www.kerneloops.org/search.php?search=__do_softirq&btnG=Function+Search
>
> ..and these cases are virtually impossible to debug since we don't know
> anything about *what* it was that got stuck. (The NMI watchdog could
> help, though.)
>
> The patch is #ifdef-ugly, I know... Suggestions are welcome.
>
>
> Vegard
>
>
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Sun, 22 Jun 2008 14:12:31 +0200
> Subject: [PATCH] softirq softlockup debugging
>
>>From the Kconfig: If a softlockup happens in a softirq, the softlockup
> stack trace is utterly unhelpful; it will only show the stack up to
> __do_softirq(), since this is where interrupts are reenabled.

After more staring at the code in question, I think that the approach is
not correct (or I didn't understand it, which is not unlikely).

I hunted down the address of the traces from kerneloops.org
(__do_softirq+0x6d) on a kernel image with a fedora config and it's at
the local_irq_enable() right after the restart:label in __do_softirq().

So if the softirq handler had disabled interrupts, the softlockup would
have been detected still within the handler (when it reenables irqs and
the timer irq runs) and the stackframe should be there.

do_softirq()
  local_irq_save()			1)
  local_softirq_pending()
  __do_softirq()
   restart:				2)
    local_irq_enable()			3)
    run a handler
    local_irq_disable()			4)
    jnz restart

So the lockup must be caused somewhere
  between 1) and 3)
or
  between 4) and 3) [when we jump back]

These functions are in the path and possible candidates for causing it:

- local_softirq_pending()
- account_system_vtime()
- __local_bh_disable()
- trace_softirq_enter()
- smp_processor_id()
- set_softirq_pending()

What do you think?  You said you actually used your patch already for
debugging lockups in softirq handlers, so it confuses me why the
stackframe of the handler was no longer present.

	Hannes
