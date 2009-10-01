Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbZJAIQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbZJAIQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755839AbZJAIQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:16:19 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:42010 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842AbZJAIQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:16:17 -0400
Date: Thu, 1 Oct 2009 13:46:16 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to
	get to performance counters
Message-ID: <20091001081616.GA3636@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090925122556.2f8bd939@infradead.org> <y0mhbuplmlr.fsf@fche.csb> <20090926183246.GA4141@in.ibm.com> <20090926204848.0b2b48d2@infradead.org> <20091001072518.GA1502@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091001072518.GA1502@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 09:25:18AM +0200, Ingo Molnar wrote:
> 
> * Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > On Sun, 27 Sep 2009 00:02:46 +0530
> > "K.Prasad" <prasad@linux.vnet.ibm.com> wrote:
> > 
> > > On Sat, Sep 26, 2009 at 12:03:28PM -0400, Frank Ch. Eigler wrote:
> > 
> > > > For what it's worth, this sort of thing also looks useful from 
> > > > systemtap's point of view.
> > > 
> > > Wouldn't SystemTap be another user that desires support for 
> > > multiple/all CPU perf-counters (apart from hw-breakpoints as a 
> > > potential user)? As Arjan pointed out, perf's present design would 
> > > support only a per-CPU or per-task counter; not both.
> > 
> > I'm sorry but I think I am missing your point. "all cpu counters" 
> > would be one small helper wrapper away, a helper I'm sure the 
> > SystemTap people are happy to submit as part of their patch series 
> > when they submit SystemTap to the kernel.
> 
> Yes, and Frederic wrote that wrapper already for the hw-breakpoints 
> patches. It's a non-issue and does not affect the design - we can always 
> gang up an array of per cpu perf events, it's a straightforward use of 
> the existing design.
> 

Such a design (iteratively invoking a per-CPU perf event for all desired
CPUs) isn't without issues, some of which are noted here:
(apart from http://lkml.org/lkml/2009/9/14/298).

- It breaks the abstraction that a user of the exported interfaces would
  enjoy w.r.t. having all CPU (or a cpumask of CPU) breakpoints.

- (Un)Availability of debug registers on every requested CPU is not
  known until request for that CPU fails. A failed request should be
  followed by a rollback of the partially successful requests.

- Any breakpoint exceptions generated due to partially successful
  requests (before a failed request is encountered) must be treated as
  'stray' and be ignored (by the end-user? or the wrapper code?).

- Any CPUs that become online eventually have to be trapped and
  populated with the appropriate debug register value (not something
  that the end-user of breakpoints should be bothered with).

- Modifying the characteristics of a kernel breakpoint (including the
  valid CPUs) will be equally painful.

- Races between the requests (also leading to temporary failure of
  all CPU requests) presenting an unclear picture about free debug
  registers (making it difficult to predict the need for a retry).

So we either have a perf event infrastructure that is cognisant of
many/all CPU counters, or make perf as a user of hw-breakpoints layer
which already handles such requests in a deft manner (through appropriate
book-keeping).

Thanks,
K.Prasad

