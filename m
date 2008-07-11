Return-Path: <linux-kernel-owner+w=401wt.eu-S1756780AbYGKAdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780AbYGKAdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 20:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbYGKAc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:32:56 -0400
Received: from smtp-out.google.com ([216.239.33.17]:51079 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbYGKAcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:32:55 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=lJ3DqhVu9Ms2VRMGi3oKU5W3YqHNGtJx+Z7euk9Qd0vAceFe/9TzyCgfdBfxiA4oh
	Brs3sm8gvauz5Vr5Hp+Gw==
Message-ID: <6599ad830807101732w43e09514t281455861da53bad@mail.gmail.com>
Date: Thu, 10 Jul 2008 17:32:30 -0700
From: "Paul Menage" <menage@google.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: [RFC][PATCH] CGroups: Add a per-subsystem hierarchy lock
Cc: a.p.zijlstra@chello.nl, pj@sgi.com, vegard.nossum@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <486C59BE.3020400@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080627075912.92AE43D6907@localhost>
	 <6599ad830806271702y2c1df2edh3a75dda75336ddad@mail.gmail.com>
	 <486AFC33.7010901@qualcomm.com>
	 <6599ad830807021531r16013460re28f813be8293d6c@mail.gmail.com>
	 <486C59BE.3020400@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2008 at 9:46 PM, Max Krasnyansky <maxk@qualcomm.com> wrote:
>
> mkdir /dev/cpuset
> mount -t cgroup -o cpuset cpuset /dev/cpuset
> mkdir /dev/cpuset/0
> mkdir /dev/cpuset/1
> echo 0-2 > /dev/cpuset/0/cpuset.cpus
> echo 3   > /dev/cpuset/1/cpuset.cpus
> echo 0 > /dev/cpuset/cpuset.sched_load_balance
> echo 0 > /sys/devices/system/cpu/cpu3/online
>

OK, I still can't reproduce this, on a 2-cpu system using one cpu for
each cpuset.

But the basic problem seemns to be that we have cpu_hotplug.lock taken
at the outer level (when offlining a CPU) and at the inner level (via
get_online_cpus() called from the guts of partition_sched_domains(),
if we didn't already take it at the outer level.

While looking at the code trying to figure out a nice way around this,
it struck me that we have the call path

cpuset_track_online_nodes() ->
  common_cpu_mem_hotplug_unplug() ->
    scan_for_empty_cpusets() ->
      access cpu_online_map with no calls to get_online_cpus()

Is that allowed? Maybe we need separate versions of
scan_for_empty_cpusets() that look at memory and cpus?

I think that we're going to want eventually a solution such pushing
the locking of cpuset_subsys.hierarchy_mutex down into the first part
of partition_sched_domains, that actually walks the cpuset tree

Paul
