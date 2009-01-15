Return-Path: <linux-kernel-owner+w=401wt.eu-S1760240AbZAODfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240AbZAODfZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 22:35:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZAODfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 22:35:06 -0500
Received: from ozlabs.org ([203.10.76.45]:45198 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbZAODfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 22:35:04 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18798.44766.734357.560006@cargo.ozlabs.ibm.com>
Date: Thu, 15 Jan 2009 14:34:54 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH] perf_counter: Add support for pinned and exclusive
	counter groups
In-Reply-To: <20090114095743.GA1389@elte.hu>
References: <18797.44875.470975.535175@cargo.ozlabs.ibm.com>
	<20090114095743.GA1389@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> (btw., the percpu allocation code seems to have bitrotten a bit - the 
> logic around perf_reserved_percpu looks wrong and somewhat complicated.)

Yes, it has.  I don't think it was ever fixed to apply only to
hardware counters when software counters were added.

Side question - were you intending to make the various software
counters able to act as interrupting counters?  That will mean
e.g. that anything that increments current->maj_flt or
current->min_flt (i.e. do_page_fault, __get_user_pages) will need to
check if that causes any counter to overflow, which could be a bit
invasive.

> hm, i guess this could be improved: by queueing pinned counters in front 
> of the list and unpinned counters to the tail.

Yes - and there are other little optimizations we could do too, such
as recording the number of hardware counters in the group leader's
struct perf_counter.

> > What this doesn't handle is when a pinned counter gets inherited and 
> > goes into error state in the child.  The sensible thing would be to put 
> > the parent counter into error state in __perf_counter_exit_task, but 
> > that might mean taking it off the PMU on some other CPU, and I was 
> > nervous about doing anything substantial to parent_counter.  Maybe what 
> > we need instead of an error value for counter->state is a separate error 
> > flag that can be set atomically by exiting children. BTW, I think we 
> > need an smp_wmb after updating parent_counter->count, so that when the 
> > parent sees the child has exited it is guaranteed to see the updated 
> > ->count value.
> 
> Yeah. Such artifacts at inheritance stem from the reduction in utility 
> that comes from any exclusive-resource-usage scheme, and are expected.

Hmmm, I don't see pinning as being about exclusivity, and the reason
my patch didn't handle it was because I haven't completely got my head
around the relevant lifetime and locking rules.

> For example, right now it works just fine to nest 'timec' in itself [there 
> is a reduction in statistical value if we start round-robining, but 
> there's still full utility]. If it used exclusive or pinned counters that 
> might not work.

Should be fine with pinned counters, and even with exclusive counters
as long as the counters are in one group.

> Again, which restrictions users/developers are more willing to live with 
> will be shown in actual usage of these facilities.

Indeed.

Regards,
Paul.
