Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbZBDIp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbZBDIp4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 03:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbZBDIpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 03:45:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46992 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbZBDIpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 03:45:47 -0500
Subject: Re: Performance counter API review was [patch] Performance
 Counters for Linux, v3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
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
In-Reply-To: <18824.64228.358045.890823@cargo.ozlabs.ibm.com>
References: <20081211155230.GA4230@elte.hu>
	 <87r64ag68n.fsf@basil.nowhere.org> <49875199.3010609@linux.vnet.ibm.com>
	 <1233606782.10184.4.camel@laptop>
	 <18824.64228.358045.890823@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 09:45:24 +0100
Message-Id: <1233737124.10184.57.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 13:18 +1100, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > Doing a single fd for all cpus is going to suck chunks because its going
> > to be a global serialization point.
> 
> If we need statistics for the system as a whole (and we do), then the
> serialization is going to happen somewhere - the only question is
> whether it's in the kernel or in userspace.  I don't see that it needs
> to be a _global_ serialization point in either case.  Given that the
> kernel has facilities like smp_call_function() available that
> userspace doesn't, I think it will end up cleaner to do it in the
> kernel.

How is smp_call_function() going to help here? You still need to pull
all that data through that one FD. That's a cacheline bounce fest.

Why not collect all this data with per-cpu threads and post-process in
user-space. The processing might even be capable of doing per-cpu
filtering, reducing the amount of data that needs to be merged.

No way that's better done in the kernel.

> That's actually a bit independent of whether it should be accessed via
> one fd or multiple fds.  One alternative might be to use something
> analogous to the counter group concept we have (i.e. multiple fd's,
> but have a way to logically join them together).

Why would you ever want to do that for? Per-cpu channels is a good
thing.

> > Also, why would you be profiling while doing a hotplug? Both cpu
> > profiling, and hotplug, are administrator operations, just don't do
> > that.
> 
> Performance counters are also used for counting, which by definition
> is something that takes place over a period of time, possibly quite a
> long time.  It would be annoying to have to stop counting and start a
> new count every time we need to plug or unplug a cpu.

Well, you need to at least stop/start the cpu to be hot-(un)plugged, no
way around that.

> > The inheritance thing will also suffer this issue, if you're going to do
> > reads of your fds at any other point than at the end -- it will have to
> > walk the whole inheritance tree and sum all the values (or propagate
> > interrupts up the tree). Which sounds rather expensive.
> 
> I'm planning to make that operation (summing over all children) be
> something that userspace can request via an ioctl, so userspace gets
> to decide when and how often it's worth the expense of doing it.

Userspace already has that control, you don't have to read the counter
before you get SIGCHLD.

I'm not seeing how an ioctl will help here, or did you mean a toggle
between:
  - collect the full hierarchy
  - read the currently collected data and don't bother with the
    active kids

Which might be useful.

