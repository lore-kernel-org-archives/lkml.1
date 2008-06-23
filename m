Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbYFWMDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbYFWMDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 08:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752787AbYFWMDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 08:03:35 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52903 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752188AbYFWMDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 08:03:35 -0400
Date: Mon, 23 Jun 2008 07:02:23 -0500
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Gautham R Shenoy <ego@in.ibm.com>
Cc: kosaki.motohiro@jp.fujitsu.com, vegard.nossum@gmail.com, menage@google.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       maxk@qualcomm.com
Subject: Re: v2.6.26-rc7/cgroups: circular locking dependency
Message-Id: <20080623070223.eaa8e130.pj@sgi.com>
In-Reply-To: <1214149823.3223.313.camel@lappy.programming.kicks-ass.net>
References: <20080621173859.GA6846@damson.getinternet.no>
	<2f11576a0806220834m3572ee80i72229cb9a1613558@mail.gmail.com>
	<1214149823.3223.313.camel@lappy.programming.kicks-ass.net>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC'd Gautham R Shenoy <ego@in.ibm.com>.

I believe that we had the locking relation between what had been
cgroup_lock (global cgroup lock which can be held over large stretches
of non-performance critical code) and callback_mutex (global cpuset
specific lock which is held over shorter stretches of more performance
critical code - though still not on really hot code paths.)  One can
nest callback_mutex inside cgroup_lock, but not vice versa.

The callback_mutex guarded some CPU masks and Node masks, which might
be multi-word and hence don't change atomically.  Any low level code
that needs to read these these cpuset CPU and Node masks, needs to
hold callback_mutex briefly, to keep that mask from changing while
being read.

There is even a comment in kernel/cpuset.c, explaining how an ABBA
deadlock must be avoided when calling rebuild_sched_domains():

/*
 * rebuild_sched_domains()
 *
 * ...
 *
 * Call with cgroup_mutex held.  May take callback_mutex during
 * call due to the kfifo_alloc() and kmalloc() calls.  May nest
 * a call to the get_online_cpus()/put_online_cpus() pair.
 * Must not be called holding callback_mutex, because we must not
 * call get_online_cpus() while holding callback_mutex.  Elsewhere
 * the kernel nests callback_mutex inside get_online_cpus() calls.
 * So the reverse nesting would risk an ABBA deadlock.

This went into the kernel sometime around 2.6.18.

Then in October and November of 2007, Gautham R Shenoy submitted
"Refcount Based Cpu Hotplug" (http://lkml.org/lkml/2007/11/15/239)

This added cpu_hotplug.lock, which at first glance seems to fit into
the locking hierarchy about where callback_mutex did before, such as
being invocable from rebuild_sched_domains().

However ... the kernel/cpuset.c comments were not updated to describe
the intended locking hierarchy as it relates to cpu_hotplug.lock, and
it looks as if cpu_hotplug.lock can also be taken while invoking the
hotplug callbacks, such as the one here that is handling a CPU down
event for cpusets.

Gautham ... you there?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
