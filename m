Return-Path: <linux-kernel-owner+w=401wt.eu-S1754862AbXJCJVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbXJCJVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 05:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbXJCJVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 05:21:13 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60639 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751777AbXJCJVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 05:21:12 -0400
Date: Wed, 3 Oct 2007 02:21:08 -0700
From: Paul Jackson <pj@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: mingo@elte.hu, akpm@linux-foundation.org, menage@google.com,
       linux-kernel@vger.kernel.org, dino@in.ibm.com, cpw@sgi.com
Subject: Re: [patch] sched: fix sched-domains partitioning by cpusets
Message-Id: <20071003022108.5a8e310e.pj@sgi.com>
In-Reply-To: <200710030146.30162.nickpiggin@yahoo.com.au>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
	<20071003062240.GA19027@elte.hu>
	<20071002235615.6e8cd007.pj@sgi.com>
	<200710030146.30162.nickpiggin@yahoo.com.au>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick wrote:
> Sorry for the confusion: I only meant the sched.c part of that
> patch, not the full thing.

Ah - ok.  We're getting closer then.  Good.

Let me be sure I've got this right then.

You prefer the interface from your proposed patch, by which the
cpuset code passes sched domain requests to the scheduler code a single
cpumask that will define a sched domain:

    int partition_sched_domains(cpumask_t *partition)

and I am suggesting instead a new and different interface:

    void partition_sched_domains(int ndoms_new, cpumask_t *doms_new)

In the first API, one cpumask is passed in, and a single sched
domain is formed, taking those CPUs from any sched domain they
might have already been a member of, into this new sched domain.

In the second API, the entire flat partitioning is passed in,
giving an array of masks, one mask for each desired sched domain.
The passed in masks do not overlap, but might not cover all CPUs.

Question -- how does one turn off load balancing on some CPUs
using the first API?

    Does one do this by forming singleton sched domains of one
    CPU each?  Is there any downside to doing this?

    The simplest cpuset code to work with this would end up exposing
    this method of disabling load balancing to user space, forcing
    users to create cpusets with one CPU each to be able do disable
    load balancing.

    However a little bit of additional kernel cpuset code could hide
    this detail from user space, by recognizing when the user had
    asked to turn off load balancing on some larger cpuset, and by
    then calling partition_sched_domains() multiple times, once for
    each CPU in that cpuset.

There might be an even simpler way.  If the kernel/sched.c routines
detach_destroy_domains() and build_sched_domains() were exposed as
external routines, then the cpuset code could call them directly,
removing the partition_sched_domains() routine from sched.c entirely.
Would this be worth persuing?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
