Return-Path: <linux-kernel-owner+w=401wt.eu-S932503AbZHUQLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbZHUQLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 12:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbZHUQLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 12:11:12 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:40580 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbZHUQLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 12:11:11 -0400
Date: Fri, 21 Aug 2009 11:11:20 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Containers <containers@lists.linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@elte.hu,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       torvalds@linux-foundation.org, Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v4][PATCH 0/7] clone_with_pids() system call
Message-ID: <20090821161120.GA21094@us.ibm.com>
References: <20090807061103.GA19343@us.ibm.com> <m1vdks5qc8.fsf@fess.ebiederm.org> <20090813080049.GA16639@us.ibm.com> <m1vdks2iea.fsf@fess.ebiederm.org> <20090813194616.GA10493@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090813194616.GA10493@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serue@us.ibm.com):
> Quoting Eric W. Biederman (ebiederm@xmission.com):
> > Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:
> > 
> > > Eric W. Biederman [ebiederm@xmission.com] wrote:
> > > | Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:
> > > | 
> > > | > === NEW CLONE() SYSTEM CALL:
> > > | >
> > > | > To support application checkpoint/restart, a task must have the same pid it
> > > | > had when it was checkpointed.  When containers are nested, the tasks within
> > > | > the containers exist in multiple pid namespaces and hence have multiple pids
> > > | > to specify during restart.
> > > | >
> > > | > This patchset implements a new system call, clone_with_pids() that lets a
> > > | > process specify the pids of the child process.
> > > | >
> > > | > Patches 1 through 5 are helpers and we believe they are needed for application
> > > | > restart, regardless of the kernel implementation of application restart.
> > > | 
> > > | I'm not very impressed.
> > > | 
> > > | - static int alloc_pidmap(struct pid_namespace *pid_ns)
> > > | + static int alloc_pidmap(struct pid_namespace *pid_ns, int pid_max, int last_pid)
> > > | 
> > > | Do that.
> > > | 
> > > | That is pass in pid_max and last_pid, and you don't have to do weird
> > > | things in alloc_pidmap, and no set_pidmap is needed.
> > >
> > > But last_pid is from the pid_ns. Do you mean to have alloc_pidmap()
> > > take a pid_min and pid_max and when choosing a specific pid, have
> > > pid_min == pid_max == target_pid ?
> > 
> > Yes. It already takes a pid_min and a pid_max from the environment.
> > I guess the pid_min is RESERVED_PIDS by default.
> > 
> > > | No changes to copy_process are needed it already takes a struct pid
> > > | argument.
> > >
> > >
> > > I see your point about passing in both 'struct pid*' and target_pids[].
> > > But in the common case the struct pid passed into copy_process() is
> > > NULL - allocating pid in do_fork() would significantly alter the
> > > existing control flow - no ? alloc_pid() assumes any new pid namespace
> > > has been created - in copy_namespaces(). Moving the alloc_pid() to
> > > do_fork() would require parsing clone_flags in do_fork() and pulling
> > > pid namespace code out of copy_namespaces().
> > 
> > Why change do_fork?
> > 
> > > | I haven't been following closely what is gained by having a clone_with_pids
> > > | syscall?  
> > >
> > > When restarting an application from a checkpoint, the application must get
> > > the same pid it had at the time of checkpoint. clone_with_pids() would be
> > > used during restart so the child can be created with a specific set of pids.
> > 
> > That part I understand.  What I don't understand is why have that one part be
> > special and have user space do the work?
> 
> How would this be used then?  Let's say I'm recreating a process tree
> with two nested pid namespaces.  so just using clone(CLONE_NEWPID) we'd
> have P{500} creates P{1501,1} which creates P{1502,1,2} which creates
> P{1502,2,3} (1502 in top namespace, 2 in child ns, 3 in lowest pid ns).
> But now we want to create P{X, 27, 953} (i.e. X can be anything).  How
> do we specify that for pidns 2 we want pid_min=pid_max=27, and for
> pidns 3 pid_min=pid_max=953?

Eric, if you have an idea for how to do this, please let me know,
and I'll set about trying a new patchset to do it.  But as it stands
I don't see how to make your suggestion useful from userspace.

thanks,
-serge
