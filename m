Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbYFZH0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbYFZH0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 03:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbYFZH0I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 03:26:08 -0400
Received: from smtp-out.google.com ([216.239.33.17]:45515 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbYFZH0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 03:26:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=iwoCnF8rBzwZIzNcm7LvXIxMrvg32M1ujBd0jo99hwFgSkqLT6mNSs1AK1gAVTvj8
	x+PkGq/cG/c9ajm13+gaA==
Message-ID: <6599ad830806260025u27458a47j47175ad778ca48a9@mail.gmail.com>
Date: Thu, 26 Jun 2008 00:25:57 -0700
From: "Paul Menage" <menage@google.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: v2.6.26-rc7/cgroups: circular locking dependency
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Paul Jackson" <pj@sgi.com>
In-Reply-To: <48609441.2030901@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080621173859.GA6846@damson.getinternet.no>
	 <2f11576a0806220834m3572ee80i72229cb9a1613558@mail.gmail.com>
	 <1214149823.3223.313.camel@lappy.programming.kicks-ass.net>
	 <48609441.2030901@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 11:29 PM, Max Krasnyansky <maxk@qualcomm.com> wrote:
> Peter Zijlstra wrote:
>> On Mon, 2008-06-23 at 00:34 +0900, KOSAKI Motohiro wrote:
>>> CC'ed Paul Jackson
>>>
>>> it seems typical ABBA deadlock.
>>> I think cpuset use cgrou_lock() by mistake.
>>>
>>> IMHO, cpuset_handle_cpuhp() sholdn't use cgroup_lock() and
>>> shouldn't call rebuild_sched_domains().
>>
>> Looks like Max forgot to test with lockdep enabled...
> Hmm, I don't think I actually changed any lock nesting/dependencies. Did I ?
> Oh, I see rebuild_sched_domains() is now called from cpuset hotplug handler.
> I just looked at the comment for rebuild_sched_domains() and it says
> " * Call with cgroup_mutex held. ..." that's why I thought it's safe and it
> worked on the test stations.
>
> Anyway, we need definitely need to make rebuild_sched_domains() work from the
> hotplug handler.

In that case the obvious solution would be to nest inside
cgroup_lock() inside cpuhotplug.lock. i.e. require that
update_sched_domains() be called inside get_online_cpus(), and call
get_online_cpus() prior to calling cgroup_lock() in any code path that
might call update_sched_domains(). That's basically:

cpuset_write_u64()
cpuset_write_s64()
cpuset_destroy()
common_cpu_hotplug_unplug()
cpuset_write_resmask()

i.e. almost all the cpuset userspace APIs. A bit ugly, but probably
not a big deal given how infrequently CPU hotplug/hotunplug occurs?

Probably simplest with a wrapper function such as:

static bool cpuset_lock_live_cgroup(struct cgroup *cgrp)
{
  get_online_cpus();
  if (cgroup_lock_live_cgroup())
    return true;
  put_online_cpus();
  return false;
}

static void cpuset_unlock()
{
  cgroup_unlock();
  put_online_cpus();
}

and use those in the relevant entry points in place of
cgroup_lock_live_group()/cgroup_unlock()

Oh, except that cpuset_destroy() is called firmly inside cgroup_mutex,
and hence can't nest the call to cgroup_lock() inside the call to
get_online_cpus().

Second idea - can we just punt the call to rebuild_sched_domains() to
a workqueue thread if it's due to a flag or cpumask change? Does it
matter if the call doesn't happen synchronously? The work handler
could easily nest the cgroup_lock() call inside get_online_cpus() and
then call rebuild_sched_domains()

Paul
