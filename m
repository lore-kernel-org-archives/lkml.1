Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbYHZC3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbYHZC3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 22:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbYHZC3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 22:29:39 -0400
Received: from smtp-out.google.com ([216.239.33.17]:32767 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbYHZC3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 22:29:38 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=YKQIG9BL5G89qmBzCtGTASV3VjjwTdKVXjF42tXsHJk2oMCvXRO2tzmQHf+rFphMb
	xg2VNjP5myLCjqoC7P8Lw==
Message-ID: <6599ad830808251929p10dfc9d2ub11e4db0cd4f9f3@mail.gmail.com>
Date: Mon, 25 Aug 2008 19:29:27 -0700
From: "Paul Menage" <menage@google.com>
To: "Lai Jiangshan" <laijs@cn.fujitsu.com>
Subject: Re: [PATCH] cgroup(fix critical bug): new handling for tasks file
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.linux-foundation.org>
In-Reply-To: <48B360CE.2010501@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48B360CE.2010501@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 6:47 PM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> In original code, we kmalloc a lot of memory when we open cgroup.tasks.
> _This memory is allocated by kmalloc_, So this memory is not statistical
> for this process or this user. This is a critical bug.

It's true that this does represent a way for an untrusted user to
consume a big chunk of memory on a machine. It's been around since
cpusets was introduced. I'm not sure that it's more serious than say,
a fork bomb or allocating lots of memory via lots of sockets with huge
network buffers. I don't see how this can cause an oops - slab.c and
slub.c both appear to just return NULL in that case, from a quick
inspection.

But improving the current code has been on my todo list for a while.
My thought on the best way to fix it is to use a proper seq_file -
that would remove the issues that you have currently with the
"unconsumed" portion of the output.

Using a seq_file iterator with your single pid array per cgroup might
work quite nicely - but isn't there still a problem that with a really
large cgroup we can overflow the kmalloc() limit for a single pid
array?

My original thoughts for solving this involved using a prio_heap to
ensure that every task in the cgroup was seen once:

1) similar to cgroup_scan_tasks, fill a prio_heap with the first N (by
task start time) tasks in the cgroup
2) sort these tasks by pid
3) report these by seq_file
4) once all the pids in the heap have been reported, update the
minimum task start time to be greater than the last task start time in
the reported group, and goto 1

This way we never have to allocate more than a single prio_heap per
open file; the downside is that we have more overhead when reporting
on really large cgroups since we have to make multiple scans of the
cgroup's task list.

Paul
