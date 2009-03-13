Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbZCMKY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbZCMKY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 06:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbZCMKYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 06:24:13 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:43777 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbZCMKYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 06:24:12 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] perfcounters: Make s/w counters in a group only count
 when group is on
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <18873.48668.562126.113618@cargo.ozlabs.ibm.com>
References: <18873.48668.562126.113618@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 11:23:36 +0100
Message-Id: <1236939816.22914.3714.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-13 at 12:59 +1100, Paul Mackerras wrote:
> Impact: bug fix
> 
> If one has a group that has one or more hardware counters in it and also
> a software counter, the software counter should count only when the
> hardware counters are on the PMU.  At present, the software counters
> count all the time, even when the hardware counters can't go on the PMU.
> 
> Fundamentally, the problem is that currently we are using sched-out for
> two distinct things: one is "take the counters off because this task
> is being taken off the CPU" and the other is "take the counters off
> because this group can't go on, or because we're changing things around".

> In the first case we need the software counters to keep counting, and in
> the second case we need them to stop, but currently we use sched_out
> functions for both.

I'm not getting it.

The latter case first -- we seem to agree on that:

In group_sched_in() we first call hw_perf_group_sched_in(), which can
validate if the group is at all schedulable.

Then we simply iterate the group counter list and add each counter, if
one, for whatever reason, fails, we simply remove all counters of that
group we scheduled in.

So we either schedule a full group or non of them.


The former case however, you seem to say we should keep software
counters active even though their associated task is scheduled out? That
doesn't appear to make sense to me.

Why would you want to do that?


