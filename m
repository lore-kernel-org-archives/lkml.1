Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbZBDKrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbZBDKrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 05:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZBDKr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 05:47:27 -0500
Received: from ozlabs.org ([203.10.76.45]:54247 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbZBDKr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 05:47:26 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18825.29238.559809.341658@cargo.ozlabs.ibm.com>
Date: Wed, 4 Feb 2009 21:47:18 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>,
       Maynard Johnson <mpjohn@us.ibm.com>, carll@us.ibm.com
Subject: Re: Performance counter API review was [patch] Performance
 Counters for Linux, v3
In-Reply-To: <1233737124.10184.57.camel@laptop>
References: <20081211155230.GA4230@elte.hu>
	<87r64ag68n.fsf@basil.nowhere.org>
	<49875199.3010609@linux.vnet.ibm.com>
	<1233606782.10184.4.camel@laptop>
	<18824.64228.358045.890823@cargo.ozlabs.ibm.com>
	<1233737124.10184.57.camel@laptop>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> How is smp_call_function() going to help here? You still need to pull
> all that data through that one FD. That's a cacheline bounce fest.

Well, let's put this into perspective.  We would be collecting 8 bytes
of data from each CPU.  Hardly a "cacheline bounce fest". :)

> Why not collect all this data with per-cpu threads and post-process in
> user-space. The processing might even be capable of doing per-cpu
> filtering, reducing the amount of data that needs to be merged.
> 
> No way that's better done in the kernel.

Not quite sure why you think there's an enormous volume of data to be
managed...

> > > Also, why would you be profiling while doing a hotplug? Both cpu
> > > profiling, and hotplug, are administrator operations, just don't do
> > > that.
> > 
> > Performance counters are also used for counting, which by definition
> > is something that takes place over a period of time, possibly quite a
> > long time.  It would be annoying to have to stop counting and start a
> > new count every time we need to plug or unplug a cpu.
> 
> Well, you need to at least stop/start the cpu to be hot-(un)plugged, no
> way around that.

It might be worth having the kernel do that automatically, given that
the perfcounters code already has a hotplug notifier routine.
However, I don't think this point is worth debating until we have a
more concrete proposal.

> > I'm planning to make that operation (summing over all children) be
> > something that userspace can request via an ioctl, so userspace gets
> > to decide when and how often it's worth the expense of doing it.
> 
> Userspace already has that control, you don't have to read the counter
> before you get SIGCHLD.
> 
> I'm not seeing how an ioctl will help here, or did you mean a toggle
> between:
>   - collect the full hierarchy
>   - read the currently collected data and don't bother with the
>     active kids

No, I meant an operation that syncs up all the child counters to the
parent so that a subsequent read of the counter immediately afterwards
will get a full total (just by reading the parent counter).  But it
could be implemented as a toggle instead.

Paul.
