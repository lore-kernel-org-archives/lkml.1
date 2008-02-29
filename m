Return-Path: <linux-kernel-owner+w=401wt.eu-S933531AbYB2Uzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531AbYB2Uzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 15:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbYB2UzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 15:55:25 -0500
Received: from relay1.sgi.com ([192.48.171.29]:46894 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753715AbYB2UzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 15:55:24 -0500
Date: Fri, 29 Feb 2008 14:55:16 -0600
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, tglx@linutronix.de, oleg@tv-sign.ru, rostedt@goodmis.org,
       maxk@qualcomm.com, linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Message-Id: <20080229145516.4d96aeaa.pj@sgi.com>
In-Reply-To: <1204311351.6243.130.camel@lappy>
References: <20080227222103.673194000@chello.nl>
	<1204311351.6243.130.camel@lappy>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like Ingo, I like the approach.

But I am concerned it won't work, as stated.

Unfortunately, my blithering ignorance of how one might want to
distribute irq's across a system is making it difficult for me
to say for sure if this works or not.

The thing about /dev/cpuset that I am afraid will get in the way
with this use of cpusets to place irqs is that we can really only
have a single purpose hierarchy below /dev/cpuset.

For example, lets say we have:

    /dev/cpuset
        boot
	big_special_app
	a_few_isolated_rt_nodes
	batchscheduler
            batch job 1
	    batch job 2
	    ...

I guess, with your "cpuset: cpuset irq affinities" patch, we'd start
off with /dev/cpuset/irqs listing the irqs available, and we could
reasonably decide to move any or all irqs to /dev/cpuset/boot/irqs,
by writing the numbers of those irqs to that file, one irq number
per write(2) system call (as is the cpuset convention.)

Do these irqs have any special hardware affinity?  Or are they
just consumers of CPU cycles that can be jammed onto whatever CPU(s)
we're willing to let be interrupted?

If for reason of desired hardware affinity, or perhaps for some other
reason that I'm not aware of, we wanted to have the combined CPUs in
both the 'boot' and 'big_special_app' handle some irq, then we'd be
screwed.  We can't easily define, using the cpuset interface and its
conventions, a distinct cpuset overlapping boot and big_special_app,
to hold that irq.  Any such combining cpuset would have to be the
common parent of both the combined cpusets, an annoying intrusion on
the expected hierarchy.

If the actual set of CPUs we wanted to handle a particular irq wasn't
even the union of any pre-existing set of cpusets, then we'd be even
more screwed, unable even to force the issue by imposing additional
intermediate combined cpusets to meet the need.

If there is any potential for this to be a problem, then we should
examine the possibility of making irqs their own cgroup, rather than
piggy backing them on cpusets (which are now just one instance of a
cgroup module.)

Could you educate me a little, Peter, on what these irqs are and on
the sorts of ways people might want to place them across CPUs?


> +	if (s->len > 0)
> +		s->len += scnprintf(s->buf + s->len, s->buflen - s->len, " ");

The other 'vector' type cpuset file, "tasks", uses a newline '\n'
field terminator, not a space ' ' separator.  Would '\n' work here,
or is ' ' just too much the expected irq separator in such ascii lists?
My preference is toward using the exact same vector syntax in each
place, so that once someone has code that handles one, they can
repurpose that code for another with minimum breakage.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
