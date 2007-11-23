Return-Path: <linux-kernel-owner+w=401wt.eu-S1757131AbXKWOhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbXKWOhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 09:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756029AbXKWOgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 09:36:55 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:58949 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834AbXKWOgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 09:36:54 -0500
Date: Fri, 23 Nov 2007 06:28:31 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, perfmon2-devel@lists.sourceforge.net
Subject: Re: conflict between tickless and perfmon2
Message-ID: <20071123142831.GD1453@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071109104438.GB18909@frankl.hpl.hp.com> <1194605991.6289.162.camel@twins> <alpine.LRH.0.999.0711091934210.1196@www.tglx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.0.999.0711091934210.1196@www.tglx.de>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Nov 09, 2007 at 07:40:31PM +0100, Thomas Gleixner wrote:
> On Fri, 9 Nov 2007, Peter Zijlstra wrote:
> 
> > On Fri, 2007-11-09 at 02:44 -0800, Stephane Eranian wrote:
> > > Hello,
> > > 
> > > We have identified a conflict between TICKLESS (CONFIG_NO_HZ) and
> > > the current perfmon2 implementation. The problem impacts system-wide
> > > sessions using timeout-based event set multiplexing.
> > > 
> > > Event set multiplexing allows monitoring tools to measure more events
> > > than there are actual performance counters on the processor. Events
> > > are grouped in sets which are then multiplexed onto the actual counters.
> > > Switching can be triggered either by a timeout or by a counter overflow.
> > > This is supported for per-thread and system-wide sessions.
> > > 
> > > For timeout-based switching, the duration expressed in nanoseconds is
> > > meant to represent wall-clock time in system-wide mode, and execution
> > > time in per-thread mode. Granularity is limited by HZ.
> > > 
> 
> Using a hrtimer is perfrectly fine, I'd say it's preferred over hooks in 
> some code which has absoluty no guarantee of being executed periodically 
> or even executed at all. OTOH it seems rather stupid to measure stuff 
> while the system is idle and doing nothing.
> 

I have now converted the timeout-based set mtuliplexing to use hrtimer instead.
The patch is available from the perfmon2 GIT tree on kernel.org.

with this patch, multiplexing works with tickless kernels for system-wide
sessions. All the arch specific hooks are gone.

For system-wide, the timeout is measurement wall-clock time. For per-thread,
it is measuring virtual time. I could not find a way to count virtual time
with hrtimer. Thus I ended up using a hrtimer/cpu and cancel/restore timeout
on context switch. I suspect there may be a better way of doing this but for
now it seems to work.

With this patch, timeout-bsed multiplexing should work on all arch. I have
test on i386. x86-64, ia64. Please try the other ones as well.

Couple of interfaces changes related to this patch:

  - switch timeout is only running between pfm_start/pfm_stop calls and when the
    context is not masked due to sampling overflows. It used to be running between
    pfm_load_contex/pfm_unload_context. This means that on architectures which allow
    start/stop for user level (e.g., IA-64), it is now necessary to call pfm_start and
    pfm_stop when using multiple sets. It is not really practical to combine set
    switching in the kernel with user level direct reading of the registers.

  - pfm_create_evtsets() fails if the timeout is not a multiple of the clock resolution.
    Using clock_getres(CLOCK_MONOTONIC) users can figure out the granularity and adjust
    the timeout accordingly.


-- 
-Stephane
