Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbYA2Mg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbYA2Mg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 07:36:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYA2Mgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 07:36:46 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44641 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751403AbYA2Mgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 07:36:46 -0500
Date: Tue, 29 Jan 2008 06:36:38 -0600
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, vatsa@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       ebiederm@xmission.com, akpm@linux-foundation.org, sgrubb@redhat.com,
       rostedt@goodmis.org, ghaskins@novell.com, dmitry.adamushko@gmail.com,
       tong.n.li@intel.com, tglx@linutronix.de, menage@google.com,
       rientjes@google.com
Subject: Re: scheduler scalability - cgroups, cpusets and load-balancing
Message-Id: <20080129063638.874b38ef.pj@sgi.com>
In-Reply-To: <1201608457.28547.130.camel@lappy>
References: <1201600428.28547.87.camel@lappy>
	<20080129040130.7b2904b6.pj@sgi.com>
	<1201603816.28547.94.camel@lappy>
	<20080129051353.4628c9eb.pj@sgi.com>
	<1201606284.28547.114.camel@lappy>
	<20080129055318.5b669847.pj@sgi.com>
	<1201608457.28547.130.camel@lappy>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, responding to Paul:
> > I really doubt we'd want to have such systems triggering the hard RT
> > scheduler on whatever CPUs were in the batch schedulers big cpuset
> > that didn't happened to have an active job currently assigned to them.
> 
> My turn to be confused..
> 
> If SD_LOAD_BALANCE is only set on the smaller, per-job, sets, how will
> the RT balancer trigger on the large set?

What 'sched_load_balance' does now is help you setup a -partial-
covering of non-overlappping sched domains.  In the batch scheduler
example, those CPUs that were:
 1) being managed by the batch scheduler, but
 2) were not assigned to any active job at the moment
would -not- be in any sched domain.

It's not a question of the SC_LOAD_BALANCE flag.  It's a question
of whether a given CPU is even included in any sched domain.

If we did as you are suggesting (if I understand) then instead of
leaving these CPUs out of any sched domain, rather we'd setup a new
kind of sched domain for these CPUs, marked for hard real time load
balancing, rather than the somewhat more scalable, but softer normal
load balancing.

We want no load balancing on those CPUs, not realtime load balancing.
Indeed, I suspect, we especially do not want realtime load balancing
on those CPUs as that kind of load balancing is (I'm suspecting) more
expensive and less scalable than normal load balancing.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
