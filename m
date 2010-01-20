Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739Ab0ATHuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab0ATHuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 02:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750947Ab0ATHuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 02:50:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40929 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab0ATHuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 02:50:04 -0500
Date: Wed, 20 Jan 2010 08:49:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Anton Blanchard <anton@samba.org>
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Michael Neuling <mikey@neuling.org>
Subject: Re: [PATCH 2/2] perf tools: Cope with sparsely-numbered CPUs
Message-ID: <20100120074946.GA20621@elte.hu>
References: <20091215093437.GB18661@brick.ozlabs.ibm.com>
 <20091215120851.GA21780@elte.hu>
 <20100120022802.GW12666@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120022802.GW12666@kryten>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Anton Blanchard <anton@samba.org> wrote:

> 
> Hi Ingo,
> 
> > > For system-wide monitoring, the perf tools currently ask how many CPUs are 
> > > online, and then instantiate perf_events for CPUs 0 ... N-1.  This doesn't 
> > > work correctly when CPUs are numbered sparsely.  For example, a four-core 
> > > POWER6 in single-thread mode will have CPUs 0, 2, 4 and 6. The perf tools 
> > > will try to open counters on CPUs 0, 1, 2 and 3, and either fail with an 
> > > error message or silently ignore CPUs 4 and 6.
> > > 
> > > This fixes the problem by making perf stat, perf record and perf top
> > > create counters for increasing CPU numbers until they have a counter
> > > for each online CPU.  If the attempt to create a counter on a given
> > > CPU fails, we get an ENODEV error and we just move on to the next CPU.
> > > To avoid an infinite loop in case the number of online CPUs gets
> > > reduced while we are creating counters, we re-read the number of
> > > online CPUs when we fail to create a counter on some CPU.
> > > 
> > > Reported-by: Michael Neuling <mikey@neuling.org>
> > > Tested-by: Michael Neuling <mikey@neuling.org>
> > > Cc: stable@kernel.org
> > > Signed-off-by: Paul Mackerras <paulus@samba.org>
> > > ---
> > >  tools/perf/builtin-record.c |   36 ++++++++++++++++++++++++++++--------
> > >  tools/perf/builtin-stat.c   |   15 +++++++++++++--
> > >  tools/perf/builtin-top.c    |   27 +++++++++++++++++++--------
> > >  3 files changed, 60 insertions(+), 18 deletions(-)
> > 
> > nice fix!
> > 
> > The linecount bloat is a bit worrying though. I'm wondering, since we have 3 
> > loops now (and possibly more upcoming), wouldnt it be a cleaner fix to have 
> > some generic idiom of 'loop through all online cpus' somewhere in lib/*.c?
> > 
> > This would work better in the long run than spreading all the sysconf calls 
> > and special cases across all those callsites. (new tools will inevitably get 
> > it wrong as well)
> > 
> > As a practical matter we can commit your fix and do the cleanup/consolidation 
> > as a separate patch, to not hold up your fix (and to help fix/bisect any 
> > problems that would happen due to the consolidation) - as long as a 
> > consolidation patch is forthcoming as well.
> 
> It looks like this hasn't made it to mainline. Any chance we could get it in 
> and look at a cleanup post 2.6.33?

Sure, if they come together we can apply one to an urgent branch and the other 
to a .34 branch.

	Ingo
