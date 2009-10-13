Return-Path: <linux-kernel-owner+w=401wt.eu-S933148AbZJMJkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148AbZJMJkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 05:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbZJMJkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 05:40:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:43199 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754623AbZJMJkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 05:40:10 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/Cma06nwHC9c39qYH2jpZhOUmoM8lxTub3bPvZoz
	SOcwCyt33ANSfb
Subject: Re: hackbench regression with kernel 2.6.32-rc1
From: Mike Galbraith <efault@gmx.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1255403522.3684.57.camel@ymzhang>
References: <1255079943.25078.23.camel@ymzhang>
	 <1255084986.8802.46.camel@laptop>  <1255331120.3684.43.camel@ymzhang>
	 <1255357264.10420.15.camel@twins>  <1255403522.3684.57.camel@ymzhang>
Content-Type: text/plain
Date: Tue, 13 Oct 2009 11:39:00 +0200
Message-Id: <1255426740.9958.95.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-13 at 11:12 +0800, Zhang, Yanmin wrote:

> NEXT_BUDDY has no help on volanoMark and tbench.

Vmark is mostly about preemption and affinity.  Increases in wakeup
preemption or load balancing will bring it down.  The affinity bit
applies heavily to mysql+oltp too, though it loves wakeup preemption.

test test test...

My conclusion for results _here_ is load balancing changes are harming
cache wise.  GENTLE_FAIR_SLEEPERS harms short term fairness, but despite
GENTLE_FAIR_SLEEPERS, we're still wakeup preempting too much, likely
doing more cache harm.

(even for the desktop, overly aggressive wakeup preemption can do harm)

I'd suggest trying the settings below.

vmark 

 92143 stock settings
 96396 -SD_BALANCE_NEWIDLE
 99403 -SD_WAKE_BALANCE
121821 min_granularity+wakeup_granularity *= 2
128795 NO_WAKEUP_PREEMPT (and back on, just checking fairness)
 97193 NO_FAIR_SLEEPERS (vmark likes fairness, max out fairness)
107519 FAIR_SLEEPERS NO_GENTLE_FAIR_SLEEPERS (over-preempt again, so..)
123721 min_granularity+wakeup_granularity *= 2
131290 NO_WAKEUP_PREEMPT (and back on, just checking fairness)
123464 NEXT_BUDDY (no effect)
vs stock 1.339

tbench 8 with these settings.

752.249 MB/sec 8 procs
747.010 MB/sec 8 procs NO_NEXT_BUDDY
753.177 MB/sec 8 procs min_granularity+wakeup_granularity /= 2
749.518 MB/sec 8 procs GENTLE_FAIR_SLEEPERS
753.051 MB/sec 8 procs min_granularity+wakeup_granularity /= 2
734.772 MB/sec 8 procs +SD_WAKE_BALANCE
733.683 MB/sec 8 procs +SD_BALANCE_NEWIDLE (we are at stock)
vs stock 1.025

Turns off netfilter, stock settings

903.304 MB/sec 8 procs
900.656 MB/sec 8 procs -SD_BALANCE_NEWIDLE
928.914 MB/sec 8 procs -SD_WAKE_BALANCE
930.591 MB/sec 8 procs min_granularity+wakeup_granularity *= 2
926.836 MB/sec 8 procs NO_GENTLE_FAIR_SLEEPERS
931.148 MB/sec 8 procs min_granularity+wakeup_granularity *= 2
vs stock 1.030

vmark

146264
116559 stock
vs stock 1.254

