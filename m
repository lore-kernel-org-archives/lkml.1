Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbYI2I2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbYI2I2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 04:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYI2I2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 04:28:13 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56123 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbYI2I2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 04:28:11 -0400
Date: Mon, 29 Sep 2008 10:27:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] markers: fix unregister bug and reenter bug
Message-ID: <20080929082722.GB18663@elte.hu>
References: <48E08B05.7030802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E08B05.7030802@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> unregister bug:
> 
> codes using makers are typically calling marker_probe_unregister()
> and then destroying the data that marker_probe_func needs(or
> unloading this module). This is bug when the corresponding
> marker_probe_func is still running(on other cpus),
> it is using the destroying/ed data.
> 
> we should call synchronize_sched() after marker_update_probes().
> 
> reenter bug:
> 
> marker_probe_register(), marker_probe_unregister() and
> marker_probe_unregister_private_data() are not reentrant safe
> functions. these 3 functions release markers_mutex and then
> require it again and do "entry->oldptr = old; ...", but entry->oldptr
> maybe is using now for these 3 functions may reenter when markers_mutex
> is released.
> 
> we use synchronize_sched() instead of call_rcu_sched() to fix
> this bug. actually we can do:
> "
> if (entry->rcu_pending)
> 		rcu_barrier_sched();
> "
> after require markers_mutex again. but synchronize_sched()
> is better and simpler. For these 3 functions are not critical path.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

applied to tip/tracing/markers, thanks!

Mathieu, i've reactivated tip/tracing/markers for linux-next 
integration, it propagates into auto-ftrace-next. Tracepoints are what 
we use in the scheduler/etc. in tip/master, but until there's marker use 
elsewhere there's no reason not to apply fix patches.

	Ingo
