Return-Path: <linux-kernel-owner+w=401wt.eu-S1765340AbXJFVKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765340AbXJFVKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 17:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764151AbXJFVJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 17:09:58 -0400
Received: from smtp-out.google.com ([216.239.45.13]:6346 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764290AbXJFVJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 17:09:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=yovzuK8SufZg18gEu7ai+tJ+xwIncBQeKMcMRDpx3vq96/CdRzaX4Xb0+RJuaX9kT
	RcDVtIBEK8QPcTliTdsYg==
Message-ID: <6599ad830710061409p2dcaa1c8u8c6864beaaafb149@mail.gmail.com>
Date: Sat, 6 Oct 2007 14:09:52 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH] task containersv11 add tasks file interface fix for cpusets
Cc: "David Rientjes" <rientjes@google.com>, akpm@linux-foundation.org,
       nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl, serue@us.ibm.com,
       clg@fr.ibm.com, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       svaidy@linux.vnet.ibm.com, xemul@openvz.org, containers@lists.osdl.org,
       balbir@linux.vnet.ibm.com
In-Reply-To: <20071006125904.a26ed99f.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071003084241.24279.62099.sendpatchset@jackhammer.engr.sgi.com>
	 <6599ad830710030851jb44f00ft9634f9381218b6e9@mail.gmail.com>
	 <20071003105817.7adf6516.pj@sgi.com>
	 <6599ad830710031110r1a74eafej56f20cc33e72ac81@mail.gmail.com>
	 <20071003131632.fed4b848.pj@sgi.com>
	 <6599ad830710031331h15d35e90lc63d845efd2de6f5@mail.gmail.com>
	 <20071006012437.c0fd3a8a.pj@sgi.com>
	 <alpine.DEB.0.9999.0710061047400.24311@chino.kir.corp.google.com>
	 <20071006125904.a26ed99f.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/6/07, Paul Jackson <pj@sgi.com> wrote:
> David wrote:
> > It would probably be better to just save references to the tasks.
> >
> >       struct cgroup_iter it;
> >       struct task_struct *p, **tasks;
> >       int i = 0;
> >
> >       cgroup_iter_start(cs->css.cgroup, &it);
> >       while ((p = cgroup_iter_next(cs->css.cgroup, &it))) {
> >               get_task_struct(p);
> >               tasks[i++] = p;
> >       }
> >       cgroup_iter_end(cs->css.cgroup, &it);
>
> Hmmm ... guess I'd have to loop over the cgroup twice, once to count
> them (the 'count' field is not claimed to be accurate) and then again,
> after I've kmalloc'd the tasks[] array, filling in the tasks[] array.
>
> On a big cgroup on a big system, this could easily be thousands of
> iteration loops.

But if userspace has to do it, the effect will be far more expensive.

>
> If I need to close the window all the way, completely solving the race
> condition, then I have the code in kernel/cpuset.c:update_nodemask(),
> which builds an mmarray[] using two loops and some retries if newly
> forked tasks are showing up too rapidly at the same time.  The first of
> the two loops is hidden in the cgroup_task_count() call.

In general, the loop inside cgroup_task_count() will only have a
single iteration. (It's iterating across the shared css_set objects,
not across member tasks.

What's wrong with:

  allocate a page of task_struct pointers
again:
  need_repeat = false;
  cgroup_iter_start();
  while (cgroup_iter_next()) {
    if (p->cpus_allowed != new_cpumask) {
      store p;
      if (page is full) {
        need_repeat = true;
        break;
      }
    }
  }
  for each saved task p {
    set_cpus_allowed(p, new_cpumask);
    release p;
  }
  if (need_repeat)
    goto again;

Advantages:

- no vmalloc needed
- just one iteration in the case where a cgroup has fewer than 512 members
- additional iterations only need to deal with tasks that don't have
the right cpu mask
- automatically handles fork races


Another option would be to have a cpuset fork callback that forces
p->cpus_allowed to its cpuset's cpus_allowed if another thread is in
the middle of update_cpumask(). Then you don't need to worry about
fork races at all, since all new threads will get the right cpumask.

> Or, if there is a good reason that must remain a spinlock, then the
> smallest amount of new code, and the easiest code to write, would
> perhaps be adding another cgroup callback, called only by cgroup attach
> () requests back to the same group.  Then code that wants to do
> something odd, such as cpusets, for what seems like a no-op, can do so.

I'd much rather not perpetuate that broken API requirement. The fact
that cpusets wants this odd behaviour is based on a nasty hack.

Paul
