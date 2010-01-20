Return-Path: <linux-kernel-owner+w=401wt.eu-S932146Ab0ATC2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab0ATC2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 21:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030Ab0ATC2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 21:28:30 -0500
Received: from ozlabs.org ([203.10.76.45]:35532 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab0ATC23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 21:28:29 -0500
Date: Wed, 20 Jan 2010 13:28:02 +1100
From: Anton Blanchard <anton@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH 2/2] perf tools: Cope with sparsely-numbered CPUs
Message-ID: <20100120022802.GW12666@kryten>
References: <20091215093437.GB18661@brick.ozlabs.ibm.com>
 <20091215120851.GA21780@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091215120851.GA21780@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

> > For system-wide monitoring, the perf tools currently ask how many CPUs are 
> > online, and then instantiate perf_events for CPUs 0 ... N-1.  This doesn't 
> > work correctly when CPUs are numbered sparsely.  For example, a four-core 
> > POWER6 in single-thread mode will have CPUs 0, 2, 4 and 6. The perf tools 
> > will try to open counters on CPUs 0, 1, 2 and 3, and either fail with an 
> > error message or silently ignore CPUs 4 and 6.
> > 
> > This fixes the problem by making perf stat, perf record and perf top
> > create counters for increasing CPU numbers until they have a counter
> > for each online CPU.  If the attempt to create a counter on a given
> > CPU fails, we get an ENODEV error and we just move on to the next CPU.
> > To avoid an infinite loop in case the number of online CPUs gets
> > reduced while we are creating counters, we re-read the number of
> > online CPUs when we fail to create a counter on some CPU.
> > 
> > Reported-by: Michael Neuling <mikey@neuling.org>
> > Tested-by: Michael Neuling <mikey@neuling.org>
> > Cc: stable@kernel.org
> > Signed-off-by: Paul Mackerras <paulus@samba.org>
> > ---
> >  tools/perf/builtin-record.c |   36 ++++++++++++++++++++++++++++--------
> >  tools/perf/builtin-stat.c   |   15 +++++++++++++--
> >  tools/perf/builtin-top.c    |   27 +++++++++++++++++++--------
> >  3 files changed, 60 insertions(+), 18 deletions(-)
> 
> nice fix!
> 
> The linecount bloat is a bit worrying though. I'm wondering, since we have 3 
> loops now (and possibly more upcoming), wouldnt it be a cleaner fix to have 
> some generic idiom of 'loop through all online cpus' somewhere in lib/*.c?
> 
> This would work better in the long run than spreading all the sysconf calls 
> and special cases across all those callsites. (new tools will inevitably get 
> it wrong as well)
> 
> As a practical matter we can commit your fix and do the cleanup/consolidation 
> as a separate patch, to not hold up your fix (and to help fix/bisect any 
> problems that would happen due to the consolidation) - as long as a 
> consolidation patch is forthcoming as well.

It looks like this hasn't made it to mainline. Any chance we could get
it in and look at a cleanup post 2.6.33?

Thanks,
Anton
