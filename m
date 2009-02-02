Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbZBBJ7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbZBBJ7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 04:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbZBBJ7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 04:59:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48184 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbZBBJ7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 04:59:33 -0500
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Oliver Neukum <oliver@neukum.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Chris Mason <chris.mason@oracle.com>
In-Reply-To: <1233567993.18767.81.camel@pasglop>
References: <20090127001708.GA4815@nowhere>
	 <4986B205.2040807@s5r6.in-berlin.de> <1233565528.18767.80.camel@pasglop>
	 <200902021014.10203.oliver@neukum.org>  <1233567993.18767.81.camel@pasglop>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 10:58:47 +0100
Message-Id: <1233568727.4787.116.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 20:46 +1100, Benjamin Herrenschmidt wrote:
> On Mon, 2009-02-02 at 10:14 +0100, Oliver Neukum wrote:
> > Am Monday 02 February 2009 10:05:28 schrieb Benjamin Herrenschmidt:
> > > > Work which /may/ sleep longer, for example performs SCSI transactions,
> > > > needs to go into a private workqueue or other kind of context.
> > > 
> > > Well, it's a bit silly to allocate a private workqueue with all it's
> > > associated per CPU kernel threads for something as rare as resetting
> > > your eth NIC ... or even SCSI error handling in fact.
> > 
> > How do you avoid a deadlock if SCSI error handling doesn't use
> > a dedicated workqueue?
> 
> Something such as slow-work or async funcs (not sure about the later, I
> have to look at the implementation) but the basic idea is to have a pool
> of threads for "generic" delayed work, when its busy, pick another one,
> and the pool itself should resize if there's too much pressure.

One thing that comes to mind is that some people want strict cpu
affinity for their work, while others want the work to be freely
scheduled so that the load-balancer can get the most out of the system.

I think mason does something like that in btrfs, where he has likes to
keep all cpus busy doing checksumming or something or other.

One could of course layer these things so that the principal thread
pools are per-cpu and then let the next layer RR the work between all
cpus.

Furthermore, all cpus seems like too wide a mask, imagine what happens
on a 4k cpu system, do we really want a cpu half the world away from the
IO node doing checksumming? -- is there a nice solution?

