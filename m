Return-Path: <linux-kernel-owner+w=401wt.eu-S933154AbZLJGNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbZLJGNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 01:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933064AbZLJGNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 01:13:49 -0500
Received: from RELAY.ANDREW.CMU.EDU ([128.2.10.212]:55312 "EHLO
	relay.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914AbZLJGNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 01:13:49 -0500
Date: Thu, 10 Dec 2009 01:13:32 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, Paul Menage <menage@google.com>,
       bblum@andrew.cmu.edu
Subject: Re: [RFC] [PATCH 1/5] cgroups: revamp subsys array
Message-ID: <20091210061332.GC11893@andrew.cmu.edu>
Mail-Followup-To: Li Zefan <lizf@cn.fujitsu.com>,
	linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
	akpm@linux-foundation.org, Paul Menage <menage@google.com>
References: <20091204085349.GA18867@andrew.cmu.edu> <20091204085508.GA18912@andrew.cmu.edu> <4B1E0283.70108@cn.fujitsu.com> <20091209055016.GA12342@andrew.cmu.edu> <4B1F3EB9.6080502@cn.fujitsu.com> <20091209082729.GA14114@andrew.cmu.edu> <4B20686E.3070907@cn.fujitsu.com> <20091210051912.GA11893@andrew.cmu.edu> <4B208E7D.8020306@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B208E7D.8020306@cn.fujitsu.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 02:00:29PM +0800, Li Zefan wrote:
> Yes, but it doesn't mean we should use rw lock or rw semaphore is
> preferable than plain mutex.
> 
> - the read side of subsys_mutex is mainly at mount/remount/umount,
>   the write side is in cgroup_load_subsys() and cgroup_unload_subsys().
>   None is in critical path.
> 
> - In most callsites, cgroup_mutex is held just after acquiring
>   subsys_mutex.
> 
> So what does it gain us to use this rw_sem?
> 
> >> And why not just use cgroup_mutex to protect the subsys[] array?
> >> The adding and spreading of subsys_mutex looks ugly to me.
> > 
> > The reasoning for this is that there are various chunks of code that
> > need to be protected by a mutex guarding subsys[] that aren't already
> > under cgroup_mutex - like parse_cgroupfs_options, or the first stage
> > of cgroup_load_subsys. Do you think those critical sections are small
> > enough that sacrificing reentrancy for simplicity of code is worth it?
> > 
> 
> Except parse_cgroupfs_options() which is called without cgroup_mutex
> held, in all other callsites, cgroup_mutex is held right after acquiring
> subsys_mutex.
> 
> So yes, I don't think use cgroup_mutex will harm scalibility.
> 
> In contrast, this subsys_mutex is quite ugly and deadlock-prone.

to be fair the deadlock case would still be as much to worry about
if we were protecting subsys[] with cgroup_mutex instead.

> For example, see this:
> 
> static int cgroup_remount(struct super_block *sb, int *flags, char *data)
> {
> 	...
>         lock_kernel();
>         mutex_lock(&cgrp->dentry->d_inode->i_mutex);
>         down_read(&subsys_mutex);
>         mutex_lock(&cgroup_mutex);
> 	...
> }
> 
> Four locks here!
> 
> 

if we really don't care about performance in those places, it doesn't
really gain anything. when I presented the previous patch series, one
guy (at google) asked me if anything could be done about the "big ugly
cgroup_mutex" and that he wished most of cgroups could be less all under
one single lock. so, I wrote this with that in mind...

anyway, I think the best solution here is - whichever lock ends up being
used for this - have parse_cgroupfs_options and rebind_subsystems each
take the lock when they are called and drop before returning, instead of
having their calling functions hold the lock between calls. division of
labour would be that parse_cgroupfs_options takes the module refcounts,
and that rebind_subsystems drops them.
