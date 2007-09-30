Return-Path: <linux-kernel-owner+w=401wt.eu-S1758653AbXI3SIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653AbXI3SIQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 14:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758061AbXI3SIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 14:08:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39910 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757773AbXI3SH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 14:07:59 -0400
Date: Sun, 30 Sep 2007 11:07:53 -0700
From: Paul Jackson <pj@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@linux-foundation.org, menage@google.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, cpw@sgi.com, mingo@elte.hu
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag
Message-Id: <20070930110753.19b03388.pj@sgi.com>
In-Reply-To: <200709300521.03356.nickpiggin@yahoo.com.au>
References: <20070930104403.24828.48263.sendpatchset@jackhammer.engr.sgi.com>
	<200709300521.03356.nickpiggin@yahoo.com.au>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick wrote:
> The user should just be able to specify exactly the partitioning of
> tasks required, and cpusets should ask the scheduler to do the best
> job of load balancing possible.

If the cpusets which have 'sched_load_balance' enabled are disjoint
(their 'cpus' cpus_allowed masks don't overlap) then you get exactly
what you're asking for.  In that case there is exactly one sched domain
for the 'cpus' allowed by each cpuset that has sched_load_balanced
enabled.

But there is another case in which one does not want what you ask for.

That case involves the situation where one is running a third part
batch scheduler on part of ones big system, and doing other stuff
(perhaps Ingo's realtime stuff) on another part of the system.

In that case, the system admin will be advised to turn off
sched_load_balance on the top cpuset.  But in that case the system
admin will -not- know from moment to moment what jobs the batch
scheduler is running on the cpus assigned to its control.  Only the
batch scheduler knows that.

The batch scheduler is code that was written by someone else, in
some other company, some other time.  That code does not get to
control the overall sched domain partitioning of the entire system.
The batch scheduler gets to say, in affect:

  Here's where I need load balancing to occur, in the normal fashion,
  and here's where I don't need it.

In short, you insisting that only a single administrative point of
control determine the systems sched domains.  Sometimes that fits
the way the system is managed, and my patch lets you do that.  But
sometimes this is a shared responsibility, between a piece of third
party software and the system admin, and my patch allows for that
case as well.

This is a typical sort of situation that arises from having hierarchical
cpuset definitions, and highlights the reason (and the use case,
involving third party batch schedulers) that I went with a hierarchical
cpuset architecture in the first place.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
