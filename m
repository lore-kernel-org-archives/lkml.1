Return-Path: <linux-kernel-owner+w=401wt.eu-S1767717AbXCJBzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767717AbXCJBzU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 20:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767721AbXCJBzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 20:55:20 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:51741 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767717AbXCJBzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 20:55:18 -0500
Date: Sat, 10 Mar 2007 07:32:20 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, ebiederm@xmission.com,
       sam@vilain.net, akpm@linux-foundation.org, pj@sgi.com, dev@sw.ru,
       xemul@sw.ru, containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070310020220.GE21661@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070301133543.GK15509@in.ibm.com> <6599ad830703061832w49179e75q1dd975369ba8ef39@mail.gmail.com> <20070307173031.GC2336@in.ibm.com> <20070307174346.GA19521@sergelap.austin.ibm.com> <20070307180055.GC17151@in.ibm.com> <20070307205846.GB7010@sergelap.austin.ibm.com> <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com> <20070309163430.GN6504@in.ibm.com> <6599ad830703091409s3d233829gb8f0afbfd2883b15@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830703091409s3d233829gb8f0afbfd2883b15@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think maybe I didnt communicate what I mean by a container here
(although I thought I did). I am referring to a container in a vserver
context (set of tasks which share the same namespace).

On Fri, Mar 09, 2007 at 02:09:35PM -0800, Paul Menage wrote:
> >2. Regarding space savings, if 100 tasks are in a container (I dont know
> >   what is a typical number) -and- lets say that all tasks are to share
> >   the same resource allocation (which seems to be natural), then having
> >   a 'struct container_group *' pointer in each task_struct seems to be not
> >   very efficient (simply because we dont need that task-level granularity 
> >   of
> >   managing resource allocation).
> 
> I think you should re-read my patches.
> 
> Previously, each task had N pointers, one for its container in each
> potential hierarchy. The container_group concept means that each task
> has 1 pointer, to a set of container pointers (one per hierarchy)
> shared by all tasks that have exactly the same set of containers (in
> the various different hierarchies).

Ok, let me see if I can convey what I had in mind better:

	    uts_ns pid_ns ipc_ns
		\    |    /
		---------------
	       | nsproxy  	|
	        ----------------
                 /  |   \    \ <-- 'nsproxy' pointer
		T1  T2  T3 ...T1000
		|   |   |      | <-- 'containers' pointer (4/8 KB for 1000 task)
	       -------------------
	      | container_group	  |
	       ------------------	
		/
	     ----------
	    | container |
	     ----------
		|
	     ----------
	    | cpu_limit |
	     ---------- 

(T1, T2, T3 ..T1000) are part of a vserver lets say sharing the same
uts/pid/ipc_ns. Now where do we store the resource control information
for this unit/set-of-tasks in your patches?

	(tsk->containers->container[cpu_ctlr.hierarchy] + X)->cpu_limit 

(The X is to account for the fact that cotainer structure points to a
'struct container_subsys_state' embedded in some other structure. Its
usually zero if the structure is embedded at the top)

I understand that container_group also points directly to
'struct container_subsys_state', in which case, the above is optimized
to:

	(tsk->containers->subsys[cpu_ctlr.subsys_id] + X)->cpu_limit

Did I get that correct?

Compare that to:

	     			   -----------
				  | cpu_limit |
	    uts_ns pid_ns ipc_ns   ----------
		\    |    /	    |
		------------------------
	       | 	nsproxy  	|
	        ------------------------
                 /  |   \	 |
		T1  T2  T3 .....T1000

We save on 4/8 KB (for 1000 tasks) by avoiding the 'containers' pointer
in each task_struct (just to get to the resource limit information).

So my observation was (again note primarily from a vserver context): given that 
(T1, T2, T3 ..T1000) will all need to be managed as a unit (because they are 
all sharing the same nsproxy pointer), then having the '->containers' pointer 
in -each- one of them to tell the unit's limit is not optimal. Instead store 
the limit in the proper unit structure (in this case nsproxy - but
whatever else is more suitable vserver datastructure (pid_ns?) which
represent the fundamental unit of res mgmt in vservers).

(I will respond to remaining comments later ..too early in the morning now!)

-- 
Regards,
vatsa
