Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbXFYUEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbXFYUEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 16:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbXFYUE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 16:04:28 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:54295 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039AbXFYUE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 16:04:27 -0400
Date: Mon, 25 Jun 2007 13:01:58 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <ak@suse.de>
Cc: b.steinbrink@gmx.de, ingo@elte.hu, linux-kernel@vger.kernel.org,
       levon@movementarian.org, perfmon@napali.hpl.hp.com,
       oprofile-list@lists.sourceforge.net, wcohen@redhat.com,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: [PATCH 1/2] Always probe the NMI watchdog
Message-ID: <20070625200158.GC12139@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070618103214.GA12045@atjola.homenet> <20070620183448.GB3251@atjola.homenet> <20070625120926.0a86373c.akpm@linux-foundation.org> <200706252136.18366.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706252136.18366.ak@suse.de>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Mon, Jun 25, 2007 at 09:36:17PM +0200, Andi Kleen wrote:
> On Monday 25 June 2007 21:09, Andrew Morton wrote:
> > On Wed, 20 Jun 2007 20:34:48 +0200
> >
> > Bj__rn Steinbrink <B.Steinbrink@gmx.de> wrote:
> > > The performance counter allocator relies on the nmi watchdog being
> > > probed, so we have to do that even if the watchdog is not enabled.
> >
> > So...  what's the status of this lot?
> >
> > I've just merged this patch and the second one:
> >
> > Subject: [PATCH 2/2] Reserve the right performance counter for the Intel
> > PerfMon NMI watchdog Message-ID: <20070620183551.GC3251@atjola.homenet>
> >
> > but there was no followup discussion afaict.
> >
> > Andi, Stephane: acks?
> 
> Yes, although I'm still a little uneasy about the always probe one.
> 

I looked at the code I have in my tree coming from Bjon's patches and
I am a bit confused by the flow for probing as well.

The register allocator works globally, i.e., you reserve a register
for all CPUs at once.

The probe_nmi_watchdog() routine simply probes the CPU type to initialize
the watchdog data structure (wd_ops). This needs to be done once and for all.
Why put it in a route that is called with on_each_cpu()?

I think the tricky part is that we do want to reserve perfctr1 even though
the NMI watchdog is not active. This comes from the fact that the NMI watchdog
knows about only one counter and if it can't get that one, it probably fails.
By reserving it from the start, we ensure NMI watchdog will work when eventually
activated.

Unlike sharing between Oprofile and perfmon which works by enforcing
mutual exclusion between the two subsystems, the NMI watchdog must work
concurrently with either Oprofile or Perfmon.

Bjorn, did I understand the constraints correctly?

-- 
-Stephane
