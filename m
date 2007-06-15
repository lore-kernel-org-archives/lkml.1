Return-Path: <linux-kernel-owner+w=401wt.eu-S1756916AbXFOV0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbXFOV0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbXFOV0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:26:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbXFOV0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:26:06 -0400
Message-ID: <467303C9.9030706@redhat.com>
Date: Fri, 15 Jun 2007 17:25:29 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: mingo@elte.hu, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: [BUG] long freezes on thinkpad t60
References: <E1HrC3W-0005SZ-00@dorka.pomaz.szeredi.hu> <20070524125453.GA7554@elte.hu> <E1HrDuQ-0005m7-00@dorka.pomaz.szeredi.hu> <20070524141059.GA19872@elte.hu> <E1HrEIp-0005qy-00@dorka.pomaz.szeredi.hu> <20070524144447.GA25068@elte.hu> <E1HrGom-0006AC-00@dorka.pomaz.szeredi.hu> <20070524210153.GB19672@elte.hu> <E1HrWSH-0000mH-00@dorka.pomaz.szeredi.hu> <E1Hyrnk-0006On-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1Hyrnk-0006On-00@dorka.pomaz.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2007 12:04 PM, Miklos Szeredi wrote:
> I've got some more info about this bug.  It is gathered with
> nmi_watchdog=2 and a modified nmi_watchdog_tick(), which instead of
> calling die_nmi() just prints a line and calls show_registers().
> 
> This makes the machine actually survive the NMI tracing.  The attached
> traces are gathered over about an hour of stressing.  An mp3 player is
> also going on continually, and I can hear a couple of seconds of
> "looping" quite often, but it gets as far as the NMI trace only
> rarely.  AFAICS only the last pair shows a trace for both CPUs during
> the same "freeze".
> 
> I've put some effort into understanding what's going on, but I'm not
> familiar with how interrupts work and that sort of thing.
> 
> The pattern that emerges is that on CPU0 we have an interrupt, which
> is trying to acquire the rq lock, but can't.
> 
> On CPU1 we have strace which is doing wait_task_inactive(), which sort
> of spins acquiring and releasing the rq lock.  I've checked some of
> the traces and it is just before acquiring the rq lock, or just after
> releasing it, but is not actually holding it.
> 
> So is it possible that wait_task_inactive() could be starving the
> other waiters of the rq spinlock?  Any ideas?

Spinlocks aren't fair, so this kind of problem is always a possibility.
I think maybe we need another kind of unlock that gives another processor
a fair chance at the lock. Some things you could try to see if they help:

- add smp_mb() after the unlock
- replace cpu_relax() with usleep()
- use an xchcg instruction to do the unlock, like i386 does when
  CONFIG_X86_OOSTORE is set

