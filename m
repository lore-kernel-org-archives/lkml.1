Return-Path: <linux-kernel-owner+w=401wt.eu-S1423209AbXDYBXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423209AbXDYBXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 21:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423019AbXDYBW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 21:22:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:8996 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161832AbXDYBW4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 21:22:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,448,1170662400"; 
   d="scan'208";a="78656951"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [REPORT] cfs-v4 vs sd-0.44
Date: Tue, 24 Apr 2007 18:22:53 -0700
Message-ID: <5FD5754DDBA0B1499B5A0B4BB5419485F72D3C@fmsmsx411.amr.corp.intel.com>
In-Reply-To: <20070424212717.GR31925@holomorphy.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [REPORT] cfs-v4 vs sd-0.44
Thread-Index: AceGt02nA9Q8ceu3RyiA5oqJvUJogQAA6iaQ
From: "Li, Tong N" <tong.n.li@intel.com>
To: "William Lee Irwin III" <wli@holomorphy.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Nick Piggin" <npiggin@suse.de>,
       "Juliusz Chroboczek" <jch@pps.jussieu.fr>,
       "Con Kolivas" <kernel@kolivas.org>, "ck list" <ck@vds.kolivas.org>,
       "Bill Davidsen" <davidsen@tmr.com>, "Willy Tarreau" <w@1wt.eu>,
       <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Galbraith" <efault@gmx.de>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Peter Williams" <pwil3058@bigpond.net.au>,
       "Thomas Gleixner" <tglx@linutronix.de>, <caglar@pardus.org.tr>,
       "Gene Heskett" <gene.heskett@gmail.com>
X-OriginalArrivalTime: 25 Apr 2007 01:22:55.0728 (UTC) FILETIME=[408B5700:01C786D8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Could you explain for the audience the technical definition of
fairness
> and what sorts of error metrics are commonly used? There seems to be
> some disagreement, and you're neutral enough of an observer that your
> statement would help.

The definition for proportional fairness assumes that each thread has a
weight, which, for example, can be specified by the user, or sth. mapped
from thread priorities, nice values, etc. A scheduler achieves ideal
proportional fairness if (1) it is work-conserving, i.e., it never
leaves a processor idle if there are runnable threads, and (2) for any
two threads, i and j, in any time interval, the ratio of their CPU time
is greater than or equal to the ratio of their weights, assuming that
thread i is continuously runnable in the entire interval and both
threads have fixed weights throughout the interval. A corollary of this
is that if both threads i and j are continuously runnable with fixed
weights in the time interval, then the ratio of their CPU time should be
equal to the ratio of their weights. This definition is pretty
restrictive since it requires the properties to hold for any thread in
any interval, which is not feasible. In practice, all algorithms try to
approximate this ideal scheduler (often referred to as Generalized
Processor Scheduling or GPS). Two error metrics are often used: 

(1) lag(t): for any interval [t1, t2], the lag of a thread at time t \in
[t1, t2] is S'(t1, t) - S(t1, t), where S' is the CPU time the thread
would receive in the interval [t1, t] under the ideal scheduler and S is
the actual CPU time it receives under the scheduler being evaluated.

(2) The second metric doesn't really have an agreed-upon name. Some call
it fairness measure and some call it sth else. Anyway, different from
lag, which is kind of an absolute measure for one thread, this metric
(call it F) defines a relative measure between two threads over any time
interval:

F(t1, t2) = S_i(t1, t2) / w_i - S_j(t1, t2) / w_j,

where S_i and S_j are the CPU time the two threads receive in the
interval [t1, t2] and w_i and w_j are their weights, assuming both
weights don't change throughout the interval.

The goal of a proportional-share scheduling algorithm is to minimize the
above metrics. If the lag function is bounded by a constant for any
thread in any time interval, then the algorithm is considered to be
fair. You may notice that the second metric is actually weaker than
first. In fact, if an algorithm achieves a constant lag bound, it must
also achieve a constant bound for the second metric, but the reverse is
not necessarily true. But in some settings, people have focused on the
second metric and still consider an algorithm to be fair as long as the
second metric is bounded by a constant.

> 
> On Mon, Apr 23, 2007 at 05:59:06PM -0700, Li, Tong N wrote:
> > I understand that via experiments we can show a design is reasonably
> > fair in the common case, but IMHO, to claim that a design is fair,
there
> > needs to be some kind of formal analysis on the fairness bound, and
this
> > bound should be proven to be constant. Even if the bound is not
> > constant, at least this analysis can help us better understand and
> > predict the degree of fairness that users would experience (e.g.,
would
> > the system be less fair if the number of threads increases? What
happens
> > if a large number of threads dynamically join and leave the
system?).
> 
> Carrying out this sort of analysis on various policies would help, but
> I'd expect most of them to be difficult to analyze. cfs' current
> ->fair_key computation should be simple enough to analyze, at least
> ignoring nice numbers, though I've done nothing rigorous in this area.
> 

If we can derive some invariants from the algorithm, it'd help the
analysis. An example is the deficit round-robin (DRR) algorithm in
networking. Its analysis utilizes the fact that the round each flow (in
this case, it'd be thread) goes through in any time interval differs by
at most one.

Hope you didn't get bored by all of this. :)

  tong
