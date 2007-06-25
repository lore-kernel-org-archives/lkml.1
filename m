Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbXFYVDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbXFYVDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 17:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbXFYVDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 17:03:39 -0400
Received: from mail.gmx.net ([213.165.64.20]:53810 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751738AbXFYVDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 17:03:38 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX18z1Mgmp88z7P7f8tvZtPPIQc/+70j0YKqDq3EYTG
	kQVj8FGH9eZWze
Date: Mon, 25 Jun 2007 23:04:25 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andi Kleen <ak@suse.de>, ingo@elte.hu, linux-kernel@vger.kernel.org,
       levon@movementarian.org, perfmon@napali.hpl.hp.com,
       oprofile-list@lists.sourceforge.net, wcohen@redhat.com
Subject: Re: [PATCH 1/2] Always probe the NMI watchdog
Message-ID: <20070625210425.GA15258@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Stephane Eranian <eranian@hpl.hp.com>, Andi Kleen <ak@suse.de>,
	ingo@elte.hu, linux-kernel@vger.kernel.org, levon@movementarian.org,
	perfmon@napali.hpl.hp.com, oprofile-list@lists.sourceforge.net,
	wcohen@redhat.com
References: <20070618103214.GA12045@atjola.homenet> <20070620183448.GB3251@atjola.homenet> <20070625120926.0a86373c.akpm@linux-foundation.org> <200706252136.18366.ak@suse.de> <20070625200158.GC12139@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070625200158.GC12139@frankl.hpl.hp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.25 13:01:58 -0700, Stephane Eranian wrote:
> Hi,
> On Mon, Jun 25, 2007 at 09:36:17PM +0200, Andi Kleen wrote:
> > On Monday 25 June 2007 21:09, Andrew Morton wrote:
> > > On Wed, 20 Jun 2007 20:34:48 +0200
> > >
> > > Bj__rn Steinbrink <B.Steinbrink@gmx.de> wrote:
> > > > The performance counter allocator relies on the nmi watchdog being
> > > > probed, so we have to do that even if the watchdog is not enabled.
> > >
> > > So...  what's the status of this lot?
> > >
> > > I've just merged this patch and the second one:
> > >
> > > Subject: [PATCH 2/2] Reserve the right performance counter for the Intel
> > > PerfMon NMI watchdog Message-ID: <20070620183551.GC3251@atjola.homenet>
> > >
> > > but there was no followup discussion afaict.
> > >
> > > Andi, Stephane: acks?
> > 
> > Yes, although I'm still a little uneasy about the always probe one.
> > 
> 
> I looked at the code I have in my tree coming from Bjon's patches and
> I am a bit confused by the flow for probing as well.
> 
> The register allocator works globally, i.e., you reserve a register
> for all CPUs at once.
> 
> The probe_nmi_watchdog() routine simply probes the CPU type to initialize
> the watchdog data structure (wd_ops). This needs to be done once and for all.
> Why put it in a route that is called with on_each_cpu()?

Ehrm, that's a good question actually... I moved the probing call up
into setup_local_APIC in that other big patch and put a check at the
start of the probing function, so that it is executed only once. No idea
why I did it so weird in this one.

> I think the tricky part is that we do want to reserve perfctr1 even
> though the NMI watchdog is not active. This comes from the fact that
> the NMI watchdog knows about only one counter and if it can't get that
> one, it probably fails.  By reserving it from the start, we ensure NMI
> watchdog will work when eventually activated.

Can you enable it later on at all? It failed for me when I tried,
because it didn't know which hardware to use. Had to pass the kernel
parameter to make the proc files do anything. Seems like it has to be
enable at boot to work at all.

And AFAICT we never unconditionally reserved a perfctr for the watchdog.

> Unlike sharing between Oprofile and perfmon which works by enforcing
> mutual exclusion between the two subsystems, the NMI watchdog must
> work concurrently with either Oprofile or Perfmon.

In 2.6.21 the nmi watchdog, if enabled, just reserved its perfctrs and
everything else had to deal with it. Since the cleanup, the watchdog
will release its perfctr when disabled, so another subsystem can grab
it. But that also means that that other subsystem must release it again
before you can reenable the watchdog.

> Bjorn, did I understand the constraints correctly?

I'll tell you, once I'm sure that I understood them correctly ;-)

Björn
