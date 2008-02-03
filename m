Return-Path: <linux-kernel-owner+w=401wt.eu-S936368AbYBCHx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936368AbYBCHx3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 02:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759479AbYBCHxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 02:53:20 -0500
Received: from relay2.sgi.com ([192.48.171.30]:40284 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759002AbYBCHxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 02:53:20 -0500
Date: Sun, 3 Feb 2008 01:53:15 -0600
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, mingo@elte.hu,
       srostedt@redhat.com, ghaskins@novell.com
Subject: Re: Integrating cpusets and cpu isolation [was Re: [CPUISOL] CPU
 isolation extensions]
Message-Id: <20080203015315.6053d3dd.pj@sgi.com>
In-Reply-To: <47A557E3.4080206@qualcomm.com>
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>
	<1201511305.6149.30.camel@lappy>
	<20080128085910.7d38e9f5.pj@sgi.com>
	<479E20DA.2080403@qualcomm.com>
	<20080128130637.60db148e.pj@sgi.com>
	<47A21C53.2010502@qualcomm.com>
	<20080202001612.98354ff2.pj@sgi.com>
	<47A557E3.4080206@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max wrote:
> Paul, I actually mentioned at the beginning of my email that I did read that thread
> started by Peter. I did learn quite a bit from it :)

Ah - sorry - I missed that part.  However, I'm still getting the feeling
that there were some key points in that thread that we have not managed
to communicate successfully.

> Sounds like at this point we're in agreement that sched_load_balance is not suitable
> for what I'd like to achieve.

I don't think we're in agreement; I think we're in confusion ;)

Yes, sched_load_balance does not *directly* have anything to do with
this.

But indirectly it is a critical element in what I think you'd like to
achieve.  It affects how the cpuset code sets up sched_domains, and
if I understand correctly, you require either (1) some sched_domains to
only contain RT tasks, or (2) some CPUs to be in no sched_domain at all.

Proper configuration of the cpuset hierarchy, including the setting of
the per-cpuset sched_load_balance flag, can provide either of these
sched_domain partitions, as desired.

> But how about making cpusets aware of the cpu_isolated_map ?

No.  That's confusing cpusets and the scheduler again.

The cpu_isolated_map is a file static variable known only within
the kernel/sched.c file; this should not change.

Presently, the boot parameter isolcpus= is just used to initialize
what CPUs are isolated at boot, and then the sched_domain partitioning,
as done in kernel/sched.c:partition_sched_domains() (the hook into
the sched code that cpusets uses) determines which CPUs are isolated
from that point forward.  I doubt that this should change either.

In that thread referenced above, did you see the part where RT is
achieved not by isolating CPUs from any scheduler, but rather by
polymorphically having several schedulers available to operate on each
sched_domain, and having RT threads self-select the RT scheduler?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
