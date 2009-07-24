Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbZGXUx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbZGXUx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 16:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbZGXUx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 16:53:58 -0400
Received: from smtp-out.google.com ([216.239.45.13]:52124 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694AbZGXUx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 16:53:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Gwhm3WNAAEW3O83sh7U/NOOETNQOs+Yx52FSUCs55UJS2GCDgu2pbo7ecw8j1zsVj
	2fJT4zNpJqCAsUY/8DQAw==
MIME-Version: 1.0
In-Reply-To: <6599ad830907241047w9a9fff9q4dc68f26a9544398@mail.gmail.com>
References: <20090724032033.2463.79256.stgit@hastromil.mtv.corp.google.com>
	 <20090724032200.2463.82408.stgit@hastromil.mtv.corp.google.com>
	 <20090724155041.GF5878@count0.beaverton.ibm.com>
	 <6599ad830907240901w4fc02097k83d0c1012708e6ee@mail.gmail.com>
	 <20090724172320.GH5878@count0.beaverton.ibm.com>
	 <6599ad830907241047w9a9fff9q4dc68f26a9544398@mail.gmail.com>
Date: Fri, 24 Jul 2009 13:53:53 -0700
Message-ID: <2f86c2480907241353l63818dfehb20c9d4918a3f069@mail.gmail.com>
Subject: Re: [PATCH 5/6] Makes procs file writable to move all threads by tgid 
	at once
From: Benjamin Blum <bblum@google.com>
To: Paul Menage <menage@google.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       serue@us.ibm.com, lizf@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 1:47 PM, Paul Menage<menage@google.com> wrote:
> On Fri, Jul 24, 2009 at 10:23 AM, Matt Helsley<matthltc@us.ibm.com> wrote:
>>
>> Well, I imagine holding tasklist_lock is worse than cgroup_mutex in some
>> ways since it's used even more widely. Makes sense not to use it here..
>
> Just to clarify - the new "procs" code doesn't use cgroup_mutex for
> its critical section, it uses a new cgroup_fork_mutex, which is only
> taken for write during cgroup_proc_attach() (after all setup has been
> done, to ensure that no new threads are created while we're updating
> all the existing threads). So in general there'll be zero contention
> on this lock - the cost will be the cache misses due to the rwlock
> bouncing between the different CPUs that are taking it in read mode.

Right. The different options so far are:

Global rwsem: only needs one lock, but prevents all forking when a
write is in progress. It should be quick enough, if it's just "iterate
down the threadgroup list in O(n)". In the good case, fork() slows
down by a cache miss when taking the lock in read mode.
Threadgroup-local rwsem: Needs adding a field to task_struct. Only
forks within the same threadgroup would block on a write to the procs
file, and the zero-contention case is the same as before.
Using tasklist_lock: Currently, the call to cgroup_fork() (which
starts the race) is very far above where tasklist_lock is taken in
fork, so taking tasklist_lock earlier is very infeasible. Could
cgroup_fork() be moved downwards to inside it, and if so, how much
restructuring would be needed? Even if so, this still adds stuff that
is being done (unnecessarily) while holding a global mutex.

> What happened to the big-reader lock concept from 2.4.x? That would be
> applicable here - minimizing the overhead on the critical path when
> the write operation is expected to be very rare.

Seems like a good application, but it appears to be gone in the
current kernel. Also, from my understanding, it would have to be a
global (or at least not threadgroup-local) lock, no? Were we to use
this and try to write to the procs file while a bunch of forks are in
progress, how long would the write operation have to block? (that is,
at least with a rwsem, the writing thread seems to get the lock rather
quickly when there's contention.) Depending on just how slow
write-locking one of these is, it might kill any hopes of performing a
write while forks are in progress.
