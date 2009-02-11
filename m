Return-Path: <linux-kernel-owner+w=401wt.eu-S1755197AbZBKI7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197AbZBKI7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 03:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbZBKI67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 03:58:59 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:42735 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275AbZBKI66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 03:58:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugEAKshkklMQWt2/2dsb2JhbACBbtF0hBoG
Date: Wed, 11 Feb 2009 03:58:52 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090211085852.GA14973@Krystal>
References: <20090206130640.GB10918@linux.vnet.ibm.com> <20090206163432.GF10918@linux.vnet.ibm.com> <20090208224419.GA19512@Krystal> <20090209041153.GR7120@linux.vnet.ibm.com> <20090209045352.GA28653@Krystal> <20090209051737.GA29254@Krystal> <20090209070317.GA31583@Krystal> <20090209153305.GA6802@linux.vnet.ibm.com> <20090210191731.GA20867@Krystal> <49925D31.6050006@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <49925D31.6050006@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 03:50:17 up 41 days,  8:48,  3 users,  load average: 0.14, 0.34,
	0.25
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Lai Jiangshan (laijs@cn.fujitsu.com) wrote:
> Mathieu Desnoyers wrote:
> > 
> > I just did a mb() version of the urcu :
> > 
> > (uncomment CFLAGS=+-DDEBUG_FULL_MB in the Makefile)
> > 
> > Time per read : 48.4086 cycles
> > (about 6-7 times slower, as expected)
> > 
> 
> I had read many papers of Paul.
> (http://www.rdrop.com/users/paulmck/RCU/)
> and I know Paul did his endeavor to remove memory barrier in
> RCU read site in kernel. His work is of consequence.
> 
> But, I think,
> 1) Userspace RCU's read site can pay for the latency of
> memory barrier(include atomic operator).
>    Userspace does not access to shared data so frequently as kernel.
> and userspace's read site is not so fast as kernel.
> 
> 2) Userspace uses RCU is for RCU's excellence, not saving a little cpu cycles
>    (http://lwn.net/Articles/263130/)
>    One of the most important excellence is lock-free.
> 
> 
> If my thinking is right, the following opinion has some meaning too.
> 
> Use All-SYSTEM 's RCU for Userspace RCU.
> 
> All-SYSTEM 's RCU is QRCU which is implemented by Paul.
> http://lwn.net/Articles/223752/
> 
> Any system which has mechanisms equivalent to atomic_op,
> __wait_event, wake_up, mutex, This system can also implement QRCU.
> So most system can implement QRCU, and I say QRCU is All-SYSTEM 's RCU.
> 
> Obviously, we can implement a portable QRCU highly simply in NPTL.
> and read lock is:
> 	for (;;) {
> 		int idx = qp->completed & 0x1;
> 		if (likely(atomic_inc_not_zero(qp->ctr + idx)))
> 			return idx;
> 	}
> "atomic_inc_not_zero" is called once likely, it's fast enough.
> 

Hi Lai,

There are a few reasons why we need rcu in userspace for tracing :

- We need very fast per-cpu read-side synchronization for data structure
  handling. Updates are rare (enabling/disabling tracing). Therefore,
  your argument about userspace not needing "fast" rcu does not hold in
  this case. Note that LTTng has the performance it has today in the
  kernel because I made sure to use no memory barriers when unnecessary
  and because I used the minimal amount of atomic operations required.
  Those represent costly synchronization primitives on quite a few
  architectures.
- Being lock-free (atomic). To trace code executed in signal handlers,
  we need to be able to nest over any user code. With the solution you
  propose above, the busy-loop in the read-lock does not seems to be
  signal-safe : if it nests over a writer, it could busy-loop forever.

Mathieu

> Lai.
> 
> 
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
