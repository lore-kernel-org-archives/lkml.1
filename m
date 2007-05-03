Return-Path: <linux-kernel-owner+w=401wt.eu-S1030237AbXECIuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237AbXECIuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030332AbXECIuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:50:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49715 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030237AbXECIuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:50:22 -0400
Date: Thu, 3 May 2007 10:50:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ting Yang <tingy@cs.umass.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070503085015.GA20516@elte.hu>
References: <20070501212223.GA29867@elte.hu> <4637FE0A.7090405@cs.umass.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4637FE0A.7090405@cs.umass.edu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ting Yang <tingy@cs.umass.edu> wrote:

> Authors of this paper proposed a scheduler: Earlist Eligible Virtual 
> Deadline First (EEVDF). EEVDF uses exactly the same method as CFS to 
> track the execution of each running task. The only difference between 
> EEVDF and CFS is that EEVDF tries to _deadline_ fair while CFS is 
> _start-time_ fair. [...]

Well, this is a difference but note that it's far from being the 'only 
difference' between CFS and EEVDF:

- in CFS you have to "earn" your right to be on the CPU, while EEVDF 
  gives out timeslices (quanta)

- EEVDF concentrates on real-time (SCHED_RR-alike) workloads where they
  know the length of work units - while CFS does not need any knowledge
  about 'future work', it measures 'past behavior' and makes its
  decisions based on that. So CFS is purely 'history-based'.

- thus in CFS there's no concept of "deadline" either (the 'D' from 
  EEVDF).

- EEVDF seems to be calculating timeslices in units of milliseconds, 
  while CFS follows a very strict 'precise' accounting scheme on the 
  nanoseconds scale.

- the EEVDF paper is also silent on SMP issues.

- it seems EEVDF never existed as a kernel scheduler, it was a
  user-space prototype under FreeBSD with simulated workloads. (have
  they released that code at all?).

The main common ground seems to be that both CFS and EEVDF share the 
view that the central metric is 'virtual time' proportional to the load 
of the CPU (called the 'fair clock' in CFS) - but even for this the 
details of the actual mechanism differ: EEVDF uses 1/N while CFS (since 
-v8) uses a precise, smoothed and weighted load average that is close to 
(and reuses portions of) Peter Williams's load metric used in smp-nice. 

The EEVDF mechanism could perhaps be more appropriate for real-time 
systems (the main target of their paper), while the CFS one i believe is 
more appropriate for general purpose workloads.

So i'd say there's more in common between SD and CFS than between EEVDF 
and CFS.

So ... it would certainly be interesting to try the EEVDF paper based on 
CFS (or whatever way you'd like to try it) and turn the EEVDF paper into 
a real kernel scheduler - the two mechanisms are quite dissimilar and 
they could behave wildly differently on various workloads. Depending on 
test results we could use bits of EEVDF's approaches in CFS too, if it 
manages to out-schedule CFS :-)

(your observation about CFS's fork handling is correct nevertheless!)

	Ingo
