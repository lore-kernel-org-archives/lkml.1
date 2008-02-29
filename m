Return-Path: <linux-kernel-owner+w=401wt.eu-S933842AbYB2VyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933842AbYB2VyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761503AbYB2VyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:54:06 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43142 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761550AbYB2VyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:54:04 -0500
Date: Fri, 29 Feb 2008 15:53:57 -0600
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, tglx@linutronix.de, oleg@tv-sign.ru, rostedt@goodmis.org,
       maxk@qualcomm.com, linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Message-Id: <20080229155357.97cee748.pj@sgi.com>
In-Reply-To: <1204319674.6243.145.camel@lappy>
References: <20080227222103.673194000@chello.nl>
	<1204311351.6243.130.camel@lappy>
	<20080229145516.4d96aeaa.pj@sgi.com>
	<1204319674.6243.145.camel@lappy>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter wrote:
> IRQ are hardware notifiers and
> do all kinds of things depending on the hardware.

So some of these irqs might have very particular node affinity then,
right?  If my thingamajig board is attached to node 72, then I might
want its interrupts going to a CPU on node 72, right?

In which case, putting that irq in my boot cpuset that only has nodes
0-3 would be harmful to the performance of my thingamajig board, right?

I'm suspecting here that you don't want a small 'boot' cpuset
(usually a small cpuset running legacy Unix stuff) holding the irqs,
but rather you want a big 'system' cpuset, which has -all-but- a few
nodes dedicated to hard real time or other isolated (there's that
word again) purposes.

That way, most irqs can go to most CPUs, depending on their specific
needs.

Unfortunately, I don't think the cpuset hierarchy and conventions admit
of both a big 'system' cpuset (all but a few isolated nodes) and a small
overlapping 'boot' cpuset.

> We don't support mv on cgroups, right? To easily create
> common parents...

The only mv supported is simple rename, preserving parentage.

And if one could and did a tree reshaping mv near the top of the
hierarchy, it would confuse the heck out of existing uses and users.

> I might just be new-fangled, but I have a /cgroup mount.
> but I guess that's just different mount-point of cgroup, right?

All cgroups mount beneath /cgroup.  For backwards compatibility,
one can also "mount -t cpuset cpuset /dev/cpuset", and just get
the cpuset interface, with a couple of legacy hooks to make it behave
just like good old fashioned cpusets, rather than new fangled cgroups.

> I'm fine with whatever, I saw a ',' in the bitmap stuff, not really sure
> how that ended up being a ' ' in the patch I send out... :-)

Yes - that's another commonly supported form.  If that's a better
presentation, then you'd probably want to rework your code, to take
in and display the entire vector of irq numbers in one line, using
a comma-separated list of irqs and ranges of irqs.

See further bitmap_scnprintf(), bitmap_parse_user(),
bitmap_scnlistprintf() and bitmap_parselist(), in bitmap.c.

Given that you don't have an pre-existing bitmap of irqs (that I know
of) and that you might have a distinct error code for each irq that you
try to attach to a different cpuset, I'm guessing you want to stick
with the single irq per write on input, single irq per line on output,
paradigm, similar to what the 'tasks' file uses for task pids.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
