Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbYKGK2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbYKGK2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 05:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYKGK23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 05:28:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45644 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbYKGK22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 05:28:28 -0500
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
From: Peter Zijlstra <peterz@infradead.org>
To: Frank Mayhar <fmayhar@google.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Doug Chapman <doug.chapman@hp.com>, mingo@elte.hu, roland@redhat.com,
       adobriyan@gmail.com, akpm@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1226015568.2186.20.camel@bobble.smo.corp.google.com>
References: <1224694989.8431.23.camel@oberon>
	 <1225132746.14792.13.camel@bobble.smo.corp.google.com>
	 <1225219114.24204.37.camel@oberon>
	 <1225936715.27507.44.camel@bobble.smo.corp.google.com>
	 <1225969420.7803.4366.camel@twins>
	 <Pine.LNX.4.64.0811060900450.3595@quilx.com>
	 <1225984098.7803.4642.camel@twins>
	 <1226015568.2186.20.camel@bobble.smo.corp.google.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Nov 2008 11:29:04 +0100
Message-Id: <1226053744.7803.5851.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(fwiw your email doesn't come across properly, evo refuses to display
them, there's some mangling of headers which makes it think there's an
attachment)

On Thu, 2008-11-06 at 15:52 -0800, Frank Mayhar wrote:
> On Thu, 2008-11-06 at 16:08 +0100, Peter Zijlstra wrote: 
> > On Thu, 2008-11-06 at 09:03 -0600, Christoph Lameter wrote:
> > > On Thu, 6 Nov 2008, Peter Zijlstra wrote:
> > > 
> > > > Also, you just introduced per-cpu allocations for each thread-group,
> > > > while Christoph is reworking the per-cpu allocator, with one unfortunate
> > > > side-effect - its going to have a limited size pool. Therefore this will
> > > > limit the number of thread-groups we can have.
> > > 
> > > Patches exist that implement a dynamically growable percpu pool (using
> > > virtual mappings though). If the cost of the additional complexity /
> > > overhead is justifiable then we can make the percpu pool dynamically
> > > extendable.
> > 
> > Right, but I don't think the patch under consideration will fly anyway,
> > doing a for_each_possible_cpu() loop on every tick on all cpus isn't
> > really healthy, even for moderate sized machines.
> 
> I personally think that you're overstating this.  First, the current
> implementation walks all threads for each tick, which is simply not
> scalable and results in soft lockups with large numbers of threads.
> This patch fixes a real bug.  Second, this only happens "on every tick"
> for processes that have more than one thread _and_ that use posix
> interval timers.  Roland and I went to some effort to keep loops like
> the on you're referring to out of the common paths.
> 
> In any event, while this particular implementation may not be optimal,
> at least it's _right_.  Whatever happened to "make it right, then make
> it fast?"

Well, I'm not thinking you did it right ;-)

While I agree that the linear loop is sub-optimal, but it only really
becomes a problem when you have hundreds or thousands of threads in your
application, which I'll argue to be insane anyway.

But with your new scheme it'll be a problem regardless of how many
threads you have, as long as each running application will have at least
2 (not uncommon these days).

Furthermore, the memory requirements for your solution now also scale
with cpus instead of threads, again something not really appreciated.

Therefore I say your solution is worse than the one we had.

You should optimize for the common case, and ensure the worst case
doesn't suck. You did it backwards.

