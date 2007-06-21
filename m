Return-Path: <linux-kernel-owner+w=401wt.eu-S1754420AbXFUCf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420AbXFUCf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 22:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbXFUCfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 22:35:20 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45049 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751419AbXFUCfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 22:35:19 -0400
Date: Wed, 20 Jun 2007 19:35:20 -0700
From: Paul Jackson <pj@sgi.com>
To: vatsa@linux.vnet.ibm.com
Cc: clameter@sgi.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, akpm@linux-foundation.org
Subject: Re: cpuset attach_task to touch per-cpu kernel threads?
Message-Id: <20070620193520.73c6dbcb.pj@sgi.com>
In-Reply-To: <20070621014935.GF10980@linux.vnet.ibm.com>
References: <20070621014935.GF10980@linux.vnet.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa wrote:
	# move all tasks from top cpuset to 'foo' cpuset
	sed -nu p < /dev/cpuset/tasks > /dev/cpuset/foo/tasks

Aha - that won't work very well, as you noticed.

In looking through my past email archives, I can see where I have
recommended this trick to move things -into- the top cpuset, but
not to move them -out-of- the top cpuset.  I would not (except by
mistake) recommend using the above trick to move tasks out of the
top cpuset, for the very reason you note.

I do have code to move tasks out of the top cpuset in bulk, but it
is written in C, as part of some SGI proprietary product (though
it relies mostly on some LGPL licensed bitmask and cpuset libraries
that I have written for SGI.)

The basic idea is to avoid moving the threads whose 'Cpus_allowed'
value in their /proc/<pid>/status file is a strict subset of (less
than, but -not- equal to) the set of online cpus.  The kernel threads
that you don't want to move are those that are pinned to specific
cpus or nodes; they are where they must be for their purposes.
Kernel threads that are not pinned can be moved just as readily
as user threads; they just need to be someplace.

I don't know any easy way to script this.  We just don't have the
tools in shell script to conveniently work with sets or bit masks.
... not yet anyway ... see below.

Checking whether a tasks Cpus_allowed is a strict subset of the
set of online cpus may not always be the check needed, depending
on what one is doing.  But it matched my needs, and from the looks
of what you're doing in that script, making the sys and test cpusets,
it might well match your needs as well, as your needs look rather
similar to what mine were.

> But I am wondering if attach_task() should leave kernel threads alone and
> act only upon user-space threads. Or maybe allow movement if it doesn't
> result in changing kernel-threads's cpu affinity.

I tend to favor minimizing kernel support, where user level support
is sufficient.  This was especially important in the early years of
Linux 2.6 cpuset kernel work, when it was vital for its acceptance to
minimize the kernel footprint of cpusets as much as I was able.

I would tend to favor encouraging further development of the user
level support for such work, over special cases in the kernel calls
just because we had not yet provided the user code to conveniently
make a certain test, but could well enough do so if need be.

Hopefully, in a few months, when I got off this other, non-cpuset
related, task that I'm on, I will get some time to publish the user
level LGPL licensed library code that makes working with bitmasks and
cpusets convenient in user level C code.  The code is in excellent
shape, if I do say so myself.

The next step, which I have fond dreams of getting to, but which is so
low on my managers priority list that there is nearly zero chance of
it happening, would be to provide a scriptable interface to the bitmask
code.  I'd probably do that as a Python module, integrating it with
Python sets.  This would take little more than some routines to import
and export Python sets to the couple of commonly used ascii
representations of bitmasks, which are those formed by the kernels
lib/bitmap.c bitmap_scnprintf() and bitmap_scnlistprintf() routines.
Such work is sufficiently generic that it might even be acceptable as
a patch to the mainline Python release.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
