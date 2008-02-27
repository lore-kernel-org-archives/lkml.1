Return-Path: <linux-kernel-owner+w=401wt.eu-S932135AbYB0Xkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135AbYB0Xkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 18:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759820AbYB0XkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 18:40:05 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58048 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754801AbYB0XkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 18:40:04 -0500
Date: Wed, 27 Feb 2008 17:39:58 -0600
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, tglx@linutronix.de, oleg@tv-sign.ru, rostedt@goodmis.org,
       maxk@qualcomm.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [RFC/PATCH 2/4] cpuset: system sets
Message-Id: <20080227173958.c6ffb32a.pj@sgi.com>
In-Reply-To: <20080227222542.311184000@chello.nl>
References: <20080227222103.673194000@chello.nl>
	<20080227222542.311184000@chello.nl>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter wrote:
> A system set will be one that caters the
> general purpose OS. This patch provides the infrastructure, but doesn't
> actually provide any new functionality.
> 
> Typical functionality would be setting the IRQ affinity of unbound IRQs to
> within the system set. And setting the affinity of unbounded kernel threads to
> within the system set.

"one that caters the general purpose OS" ... a tad terse on the
documentation ;).

I guess what you have is a new cpumask_t cpu_system_map, which is the
union of the CPUs of all the cpusets marked 'system', where to a rough
approximation the CPUs -not- in that cpumask are what we would have
called the isolated CPUs by the old code?

In any case, if this patch survives its birth, it will need an added
change for some file in the Documentation directory.

Could we get the term 'cpu' in the name 'system' somehow?  Perhaps call
this new cpuset flag 'cpus_system' or some such.  Cpusets handles both
CPU and memory configuration, and I make some effort to mark per-cpuset
specific attributes that apply to only one of these with a prefix
indicating to which they apply.  The per-cpuset flag name 'system', by
itself, would mean little to someone just listing the files in a cpuset
directory.

In the rebuild_system_map() code, you have:
+	if (cpus_empty(*new_system_map))
+		BUG();

... what's to prevent simply turning off the 'system' (aka cpus_system)
in the top cpuset, on a system with only that one cpuset, and hitting
this BUG()?

Overall I like this approach.  I suspect you made a good choice in
marking the non-isolated (aka system) CPUs, rather than the isolated
CPUs.  It seems clearer that way, in understanding the affects of
overlapping cpusets with various markings.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
