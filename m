Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbZDNVBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbZDNVBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZDNVBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:01:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:31835 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbZDNVBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:01:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hYCCcbPIsVZ4BoyIPdalfH047VxDBjjZA/lgAi1FEnyFEgaeJzxzy1RWzCTnEuE8XG
         XxbiCsqX2LqZUTFBWpOXjSFNHHuCaOtrUVOgzCrbD4kaH/xUkyGHECckeEpU/rEmKzta
         mihfS1nAdyaU43+DypQlx1ibdkFq4xpWUcKME=
Date: Wed, 15 Apr 2009 01:01:50 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: containers@lists.osdl.org, Dave Hansen <dave@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Creating tasks on restart: userspace vs kernel
Message-ID: <20090414210150.GA28967@x200.localdomain>
References: <49E40662.2040508@cs.columbia.edu> <20090414163633.GE27461@x200.localdomain> <49E4D89D.9060903@cs.columbia.edu> <20090414195909.GA28353@x200.localdomain> <49E4EDCD.5010406@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E4EDCD.5010406@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 04:10:53PM -0400, Oren Laadan wrote:
> 
> 
> Alexey Dobriyan wrote:
> >>> In the end correctness of chopping will be equal to how good user
> >>> understands that two task_struct's are independent of each other.
> >>>
> >>>> But it will still be a useful tool for many use cases, like batch cpu jobs,
> >>>> some servers, vnc sessions (if you want graphics) etc. Imagine you run
> >>>> 'octave' for a week and must reboot now - 'octave' wouldn't care if
> >>>> you checkpointed it and then restart with a different pid !
> >>>>
> >>>> <3> Clone with pid:
> >>>>
> >>>> To restart processes from userspace, there needs to be a way to
> >>>> request a specific pid--in the current pid_ns--for the child process
> >>>> (clearly, if it isn't in use).
> >>>>
> >>>> Why is it a disadvantage ?  to Linus, a syscall clone_with_pid()
> >>>> "sounds like a _wonderful_ attack vector against badly written
> >>>> user-land software...".  Actually, getting a specific pid is possible
> >>>> without this syscall.  But the point is that it's undesirable to have
> >>>> this functionality unrestricted.
> >>>>
> >>>> So one option is to require root privileges. Another option is to
> >>>> restrict such action in pid_ns created by the same user. Even more so,
> >>>> restrict to only containers that are being restarted.
> >>> You want to do small part in userspace and consequently end up with hacks
> >>> both userspace-visible and in-kernel.
> >> I want to extend existing kernel interface to leverage fork/clone
> >> from user space, AND to allow the flexibility mentioned above (which
> >> you conveniently ignored).
> >>
> >> All hacks are in-kernel, aren't they ?
> > 
> > mktree.c can be vieved as hack, why not?
> 
> Lol .. I meant "all kernel hacks are in-kernel" :)
> 
> > 
> > The whole existence of these requirements. You want new syscall or SET_NEX_PID
> > or /proc file or something.
> 
> Or embed it into a restart(2) call with special argument.
> 
> > 
> >> As for asking for a specific pid from user space, it can be done by:
> >> * a new syscall (restricted to user-owned-namespace or CAP_SYS_ADMIN)
> >> * a sys_restart(... SET_NEXT_PID) interface specific for restart (ugh)
> >> * setting a special /proc/PID/next_id  file which is consulted by fork
> > 
> > /proc/*/next_id was disscussed and hopefully died, but no.
> > 
> >> and in all cases, limit this so it can only allowed in a restarting
> >> container, under the proper security model (again, e.g., Serge's
> >> suggestion).
> >>
> >>> Pids aren't special, they are struct pid, dynamically allocated and
> >>> refcounted just like any other structtures.
> >>>
> >>> They _become_ special for you intended method of restart.
> >> They are special. And I allow them not to be restored, as well, if
> >> the use case so wishes.
> > 
> > The use case is to restore as much as possible to the same state as
> > equal as possible. Not going with fork_with_pid() in any form helps
> > kernel to ensure correctness of restore and helps to avoid surprise
> > failure modes from user POV.
> > 
> >>> You also have flags in nsproxy image (or where?) like "do clone with
> >>> CLONE_NEWUTS".
> >> Nope. Read the code.
> > 
> > Which code?
> > 
> > 	static int cr_write_namespaces(struct cr_ctx *ctx, struct task_struct *t)
> > 	{
> > 		...
> > 
> > 		new_uts = cr_obj_add_ptr(ctx, nsproxy->uts_ns,
> > 					&hh->uts_ref, CR_OBJ_UTSNS, 0);
> > 		if (new_uts < 0) {
> > 			ret = new_uts;
> > 			goto out;
> > 		}
> > 
> > 		hh->flags = 0;
> > 		if (new_uts)
> > 	===>		hh->flags |= CLONE_NEWUTS;
> > 
> > 		ret = cr_write_obj(ctx, &h, hh);
> > 			...
> > 
> >>> This is unneeded!
> >>>
> >>> nsproxy (or task_struct) image have reference (objref/position) to uts_ns image.
> >>>
> >>> On restart, one lookups object by reference or restore it if needed,
> >>> takes refcount and glue. Just like with every other two structures.
> >> That's exactly how it's done.
> > 
> > Not for uts_ns and future namespaces.
> > 
> > 	ret = cr_restore_utsns(ctx, hh->uts_ref, hh->flags);
> > 						 ^^^^^^^^^
> > 						 comes from disk
> 
> Where else would it come from ?  that's part of the state saved during
> checkpoint.

This is bogus part saved during checkpoint.

To restore nsproxy you only need references to uts_ns, ipc_ns, mnt_ns,
pid_ns and net_nsm, no flags.

You can try to be smart and, consequently, end up with checks where
a) flags tell to unshare uts_ns, but reference is the same, and
b) flags don't tell to unshare, but reference is different.

This is unneeded code coming from the way you restore nsproxy
incorrectly.

> That's for nested UTS namespaces,

Just to clear terminology, UTS namespaces aren't nested, only
PID namespaces are.

> where a task in container called unshare().
