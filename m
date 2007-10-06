Return-Path: <linux-kernel-owner+w=401wt.eu-S1760652AbXJFIYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbXJFIYy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 04:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbXJFIYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 04:24:45 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53123 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751940AbXJFIYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 04:24:44 -0400
Date: Sat, 6 Oct 2007 01:24:37 -0700
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: akpm@linux-foundation.org, nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl,
       serue@us.ibm.com, clg@fr.ibm.com, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, rientjes@google.com, svaidy@linux.vnet.ibm.com,
       xemul@openvz.org, containers@lists.osdl.org, balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] task containersv11 add tasks file interface fix for
 cpusets
Message-Id: <20071006012437.c0fd3a8a.pj@sgi.com>
In-Reply-To: <6599ad830710031331h15d35e90lc63d845efd2de6f5@mail.gmail.com>
References: <20071003084241.24279.62099.sendpatchset@jackhammer.engr.sgi.com>
	<6599ad830710030851jb44f00ft9634f9381218b6e9@mail.gmail.com>
	<20071003105817.7adf6516.pj@sgi.com>
	<6599ad830710031110r1a74eafej56f20cc33e72ac81@mail.gmail.com>
	<20071003131632.fed4b848.pj@sgi.com>
	<6599ad830710031331h15d35e90lc63d845efd2de6f5@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> What was wrong with my suggestion from a couple of emails back? Adding
> the following in cpuset_attach():
> 
> struct cgroup_iter it;
> struct task_struct *p;
> cgroup_iter_start(cs->css.cgroup, &it);
> while ((p = cgroup_iter_next(cs->css.cgroup, &it)))
>        set_cpus_allowed(p, cs->cpus_allowed);
> cgroup_iter_end(cs->css.cgroup, &it);

This isn't working for me.

The key kernel routine for updating a tasks cpus_allowed
cannot be called while holding a spinlock.

But the above loop holds a spinlock, css_set_lock, between
the cgroup_iter_start and the cgroup_iter_end.

I end up generating complaints of:
	BUG: scheduling while atomic
when I invoke the set_cpus_allowed() above.

Should css_set_lock be a mutex?  Locking changes like that
can be risky.

Or perhaps there should be another callback, called only by
attach() requests back to the same group.  Likely cpusets would
be the only subsystem interested in plugging that callback.

That, or my original patch, which calls the attach routine
even if re-attaching to the current cgroup ...

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
