Return-Path: <linux-kernel-owner+w=401wt.eu-S1763543AbYHFDYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763543AbYHFDYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 23:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbYHFDYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 23:24:42 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55565 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbYHFDYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 23:24:40 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5354"; a="5180227"
Message-ID: <48991973.90109@qualcomm.com>
Date: Tue, 05 Aug 2008 20:24:35 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, menage@google.com,
       a.p.zijlstra@chello.nl, vegard.nossum@gmail.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
 (2.6.27-rc1)
References: <1217631552-22129-1-git-send-email-maxk@qualcomm.com>	<20080802063900.6615e5ca.pj@sgi.com>	<48948C3A.6050805@qualcomm.com>	<20080802225127.2b0d138b.pj@sgi.com>	<4895F3ED.4020805@qualcomm.com>	<20080804010033.0d1b0549.pj@sgi.com>	<48977E81.4040207@qualcomm.com>	<20080804225636.541527e8.pj@sgi.com>	<4898B873.6000308@qualcomm.com> <20080805180521.be7010e1.pj@sgi.com>
In-Reply-To: <20080805180521.be7010e1.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Max wrote:
>> It could I guess. But the questions is why ?
>> I mean the only reason we've introduced workqueue is because lock 
>> nesting got too complicated. Otherwise in all those paths we're already 
>> in a process context and there is no need to schedule a workqueue.
> 
> My priorities are different than yours.
> 
> You look at a code path that, in some cases, is more involved than
> necessary, and recommend providing an alternative code path, for
> the cases that can get by executing (significantly) fewer CPU cycles.
> 
> I look at the number of code paths, lines of code, duplicated code
> and number of tests and conditions in the source code, and ask how
> to reduce them.  I want the least amount of source code, the fewest
> alternative paths through that code, the smallest number of logical
> tests and code variants, the least amount of code duplication.
> 
> The key in this case is that I prefer having just one code path by
> which all rebuilds of sched domains are done.  Since that rebuild must
> be asynchronous for some cases (to avoid ABBA lock nesting problems)
> therefore let all sched domains be done by that async path.
> 
> The fewer the number of code path variants, the easier it is to
> understand the code, and the harder it is to break the code.
> 
> Except for frequently executed code paths, which this surely is not,
> minimizing software maintenance costs is far more important to me than
> minimizing CPU cycles.

Actually I was not really trying to minimize cpu cycles or anything. But it
does seem like an overkill to schedule a workqueue just because we do not
want to expose the fact that rebuild_sched_domains() depends get_online_cpus().

More importantly though if you think about it I'm actually not introducing
any new alternative paths (besides async_rebuild_sched_domains() itself).
Code paths in question have been synchronous since day one, and have been
tested that way. Now you're saying lets make them asynchronous. Peter already
had a concern about async rebuilds from within the cpuset itself. I think those
are fine but I definitely do not want to make domain rebuilds in the cpu hotplug
path asynchronous.

So I'd argue that async_rebuild_domains() is the new path which we have to
make async due to lock nesting issues. The other paths (cpu hotplug, topology
updates, SMT and MC power settings updates) are already synchronous and have
no lock nesting issues and therefore do not need to change (async vs sync).
Also IMO it makes sense to keep both CONFIG_CPUSETS and !CONFIG_CPUSETS
handling as similar as possible to avoid surprises. With your proposal when
cpusets are disabled arch_reinit_sched_domain() will be synchronous, when
they are enabled it will asynchronous.

If you feel strongly about this we can discuss this some more and try it out.
But I really do not see those maintenance saving in this case. We'd actually
be changing more things.

Max
