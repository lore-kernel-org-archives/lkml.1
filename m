Return-Path: <linux-kernel-owner+w=401wt.eu-S1759410AbYDAWZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbYDAWZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 18:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbYDAWZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 18:25:51 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:61566 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902AbYDAWZu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 18:25:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArYFAFZT8kdMQWoK/2dsb2JhbACBWqsX
Date: Tue, 1 Apr 2008 18:25:48 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for 2.6.25] Markers - use synchronize_sched()
Message-ID: <20080401222547.GA23175@Krystal>
References: <20080331131609.GA22207@Krystal> <20080401133017.9484a35b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20080401133017.9484a35b.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:14:04 up 32 days, 18:25,  3 users,  load average: 0.59, 0.79,
	0.90
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Mon, 31 Mar 2008 09:16:09 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Use synchronize_sched before calling call_rcu in CONFIG_PREEMPT_RCU until we
> > have call_rcu_sched and rcu_barrier_sched in mainline. It will slow down the
> > marker operations in CONFIG_PREEMPT_RCU, but it fixes the current race against
> > the preempt_disable/enable() protected code paths.
> 
> A better changelog would have described the bug which is being fixed.
> 

Hi Andrew,

Right, this could be appended to the changelog then :

Markers do not mix well with CONFIG_PREEMPT_RCU because it uses
preempt_disable/enable() and not rcu_read_lock/unlock for minimal
intrusiveness. We would need call_sched and sched_barrier primitives.

Currently, the modification (connection and disconnection) of probes
from markers requires changes to the data structure done in RCU-style :
a new data structure is created, the pointer is changed atomically, a
quiescent state is reached and then the old data structure is freed.

The quiescent state is reached once all the currently running
preempt_disable regions are done running. We use the call_rcu mechanism
to execute kfree() after such quiescent state has been reached. However,
the new CONFIG_PREEMPT_RCU version of call_rcu and rcu_barrier does not
guarantee that all preempt_disable code regions have finished, hence the
race.

The "proper" way to do this is to use rcu_read_lock/unlock, but we don't
want to use it to minimize intrusiveness on the traced system. (we do
not want the marker code to call into much of the OS code, because it
would quickly restrict what can and cannot be instrumented, such as the
scheduler).

The temporary fix, until we get call_rcu_sched and rcu_barrier_sched in
mainline, is to use synchronize_sched before each call_rcu calls, so we
wait for the quiescent state in the system call code path. It will slow
down batch marker enable/disable, but will make sure the race is gone.

Thanks,

Mathieu

> > Paul, is this ok ? It would be good to get this in for 2.6.25 final.
> 
> Paul seems to have nodded off.  I'll merge it.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
