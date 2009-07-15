Return-Path: <linux-kernel-owner+w=401wt.eu-S932133AbZGOQSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbZGOQSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 12:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbZGOQSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 12:18:38 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49076 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbZGOQSh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 12:18:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=JFHTMp+gg1xOjyuTwYN5GOCwXJCHHTFNLRVbccuc7WK0wteaurqTkjCuARVe2LSvo
	UfrjOtjFsFh4c1DkiehWg==
MIME-Version: 1.0
In-Reply-To: <m1ocrm73cu.fsf@fess.ebiederm.org>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	 <2f86c2480907021817o79fce75yd9785aab682f7bb4@mail.gmail.com>
	 <20090702190845.0cafc46a.akpm@linux-foundation.org>
	 <6599ad830907022116n7a711c7fs52ff9b400ec8797f@mail.gmail.com>
	 <20090702235527.7ddc873c.akpm@linux-foundation.org>
	 <6599ad830907030911m6176dc59id3a7d897b03d2bd@mail.gmail.com>
	 <20090703095000.cf46ad19.akpm@linux-foundation.org>
	 <6599ad830907031054x74d90149y38aae60afa403d58@mail.gmail.com>
	 <20090703111016.ceb28541.akpm@linux-foundation.org>
	 <m1ocrm73cu.fsf@fess.ebiederm.org>
Date: Wed, 15 Jul 2009 09:18:33 -0700
Message-ID: <6599ad830907150918r5ed6f2cevde9dbc9ef304fb2b@mail.gmail.com>
Subject: Re: [PATCH 1/2] Adds a read-only "procs" file similar to "tasks" that 
	shows only unique tgids
From: Paul Menage <menage@google.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Blum <bblum@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, lizf@cn.fujitzu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 1:33 AM, Eric W. Biederman<ebiederm@xmission.com> wrote:
>
> I think guaranteeing a truly atomic snapshot is likely to be a
> horrible idea requiring all kinds of nasty locking,

We don't guarantee a truly atomic snapshot unless you manage to read
the entire file with a single read() call.

> and smp
> scalability issues.  So please walk the list of pids and
> just return those that belong to your cgroup.

The downside with that is that scanning any cgroup takes O(n) in the
number of threads on the machine, so scanning them all becomes O(n^2).
We've definitely seen problems (on older kernels using cpusets, which
did something similar, i.e. walking the tasklist) where we have lots
of small cpusets and a few huge ones, and this blew up the cost of
accessing any of them.

But having said that, the idea of being able to maintain just a cursor
is something that would definitely be nice.

Here's another idea that might work:

Currently, each cgroup has a list running through the attached css_set
objects, and each css_set has a list running through its tasks; we
iterate through these lists of lists to produce the cgroup's task list

Since this list isn't sorted in any way, there's no convenient way to
save/restore your position between seq_file invocations; this is why
we currently generate a sorted snapshot, so that even if the snapshot
is updated by someone else before our next read, we know where to pick
up from (the next pid above the last one that we returned).

Instead, we could actually store cursor objects in the list itself
whenever we need to pause/resume iterating through a large cgroup (due
to hitting the limits of a single seq_file read, i.e. probably after
every 700 threads).

Then we'd just need to teach cgroup_iter_next() to distinguish between
real tasks and cursors, and skip the latter. Simple way to do that
would be to change the existing declarations in task_struct:

#ifdef CONFIG_CGROUPS
        /* Control Group info protected by css_set_lock */
        struct css_set *cgroups;
        /* cg_list protected by css_set_lock and tsk->alloc_lock */
        struct list_head cg_list;
#endif

and instead define these two fields together as a struct
cgroup_css_list_elem. A cursor can just be a cgroup_css_list_elem
whose cgroups field points to a distinguishing address that identifies
it as a cursor.

So we're guaranteed to hit all threads that are in the cgroup before
we start, and stay there until we finish; there are no guarantees
about threads that move into or out of the cgroup while we're
iterating

It's a bit more complex than just iterating over the machine's entire
pid list, but I think it scales better.

Paul
