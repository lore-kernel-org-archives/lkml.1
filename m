Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbYDYCRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbYDYCRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 22:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbYDYCRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 22:17:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755098AbYDYCRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 22:17:22 -0400
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 34/37] LTTng instrumentation ipc
References: <20080424150324.802695381@polymtl.ca>
	<20080424151407.622943449@polymtl.ca>
	<20080424230238.GA11699@martell.zuzino.mipt.ru>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Thu, 24 Apr 2008 22:15:27 -0400
In-Reply-To: <20080424230238.GA11699@martell.zuzino.mipt.ru> (Alexey Dobriyan's message of "Fri, 25 Apr 2008 03:02:38 +0400")
Message-ID: <y0mve26r874.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alexey Dobriyan <adobriyan@gmail.com> writes:

> [...]
> Can I write
> 	if (rv < 0)
> 		trace_mark(foo, "rv %d", rv);

Sure.

> Looks like i could. But people want also want to see success, so what?
> Two markers per exit?
>
> 	rv = ipc_get(...);
> 	if (rv < 0)
> 		trace_marker(foo_err, ...);
> 	trace_marker(foo_all, ...);

That seems excessive.  Just pass "rv" value and let the consumer
decide whether they care about < 0.

You seem to be operating under the mistaken assumption that marker
consumers will simply have to pass on the full firehose flow without
filtering.  That is not so.  I suspect lttng can do it, but I know
that with systemtap, it's trivial to encode conditions on the marker
parameters and other state (e.g., recent events of interest), so that
only finely tuned events actually get sent to the end user.


> Also everything inserted so far is static. Sometimes only one bit in
> mask is interesting and to save time to parse nibbles people do:
> 	printk("foo = %d\n", !!(mask & foo));
> And interesting bits vary.

OK, perhaps pass both mask & foo, and let the consumer perform the
arithmetic they deem appropriate.


> Again, all events aren't interesting:
> 	if (file && file->f_op == &shm_file_operations)
> 		printk("%s: file = %p: START\n", __func__, file);
> Can I write this with markers?

Of course, if you really want to.

> So what is proposed? Insert markers at places that look strategic? 

"strategic" is the wrong term.  Choose those places that reflect
internal occurrences that are useful but difficult to reverse-engineer
from other visible interface points like system calls.  Data that
helps answer questions like "Why did (subtle internal phenomenon)
happen?" in a live system.


> mm/ patch is full if "file %p". Do you realize that pointers are
> only sometimes interesting and sometimes you want dentry (not pointer,
> but name!):
> 	printk("file = '%s'\n", file->f_dentry->d_name.name);

It may not be excessive to put both file and the dname.name as marker
parameters.


> So, let me say even more explicitly. Looking at proposed places elite
> enough to be blessed with marker...
>
> Those which are close enough to system call boundary are essentially
> strace(1).

Those may not sound worthwhile to put a marker for, BUT, you're
ignoring the huge differences of impact and scope.  A system-wide
marker-based trace (filtered a la systemtap if desired) can be done
with a tiny fraction of system load and none of the disruption caused
by an strace of all the processes.


> [...]  Markers points won't be removed, only accumulated -- somebody
> _might_ be interested in this information.

We all (data producers and consumers) need to use good judgment and
accept moderate change.


- FChE
