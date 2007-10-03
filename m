Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbXJCG42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbXJCG42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 02:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbXJCG4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 02:56:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34315 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751761AbXJCG4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 02:56:19 -0400
Date: Tue, 2 Oct 2007 23:56:15 -0700
From: Paul Jackson <pj@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: nickpiggin@yahoo.com.au, akpm@linux-foundation.org, menage@google.com,
       linux-kernel@vger.kernel.org, dino@in.ibm.com, cpw@sgi.com
Subject: Re: [patch] sched: fix sched-domains partitioning by cpusets
Message-Id: <20071002235615.6e8cd007.pj@sgi.com>
In-Reply-To: <20071003062240.GA19027@elte.hu>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
	<200709301335.00441.nickpiggin@yahoo.com.au>
	<20071001111528.5487b4f4.pj@sgi.com>
	<200710022335.05357.nickpiggin@yahoo.com.au>
	<20071003062240.GA19027@elte.hu>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo wrote:
> i've merged your patch to my scheduler queue - see the patch below. (And 
> could you send me your SoB line too?) Paul, if we went with the patch 
> below, what else would be needed for your purposes?

Nick and I already resolved that, when he first posted this patch
in October of 2006.  The cpu_exclusive flag doesn't work for this.

Here's a copy of the key message, from Nick, near the end of that
thread in which he earlier proposed this patch, also available at:
http://lkml.org/lkml/2006/10/21/12

====================================================
    Paul Jackson wrote:
    > Nick wrote:
    > 
    >>Or, another question, how does my patch hijack cpus_allowed? In
    >>what way does it change the semantics of cpus_allowed?
    > 
    > 
    > It limits load balancing for tasks in cpusets containing
    > a superset of that cpusets cpus.
    > 
    > There are always such cpusets - the top cpuset if no other.

    Ah OK, and there is my misunderstanding with cpusets. From the
    documentation it appears as though cpu_exclusive cpusets are
    made in order to do the partitioning thing.

    If you always have other domains overlapping them (regardless
    that it is a parent), then what actual use does cpu_exclusive
    flag have?
====================================================

A couple messages later in that thread, Nick wrote:
> But even the way cpu_exclusive semantics are defined makes it not
> quite compatible with partitioning anyway, unfortunately.

I agree with Nick on this conclusion, and with his other conclusion
that the 'cpu_exclusive' flag is pretty near useless.

Some per-cpuset flag other the 'cpu_exclusive' is required to
control sched domains from cpusets.

This has specific impact on one of the key users of cpusets, the
various developers of batch schedulers.  One by one, they have
determined that the cpu_exclusive flag is incompatible with the
way they set up cpusets, and have decided they should not enable
that flag on any cpuset under their control.  It gets in their way,
and serves no useful purpose for them.  However we need someway
for them to specify where they need load balancing, so that on
large systems, they can allow the admin to avoid the cost of load
balancing over the batch schedulers entire subset of the system at
once, but rather just load balance over the smaller sets where the
batch scheduler has active jobs running that might depend on load
balancing.

Batch schedulers need to be able to specify where they need load
balancing and where they don't, and they can't use the 'cpu_exclusive'
flag.  The defining characteristic of 'cpu_exclusive' is no overlap of
CPUs with sibling cpusets.  That is incompatible with their needs.

Therefore, they need a different flag.

I must NAQ this patch, and I'm surprised to see Nick propose it
again, as I thought he had already agreed that it didn't suffice.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
