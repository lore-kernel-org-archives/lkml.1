Return-Path: <linux-kernel-owner+w=401wt.eu-S1753020AbZJWTQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbZJWTQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 15:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbZJWTQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 15:16:51 -0400
Received: from smtp171.iad.emailsrvr.com ([207.97.245.171]:54458 "EHLO
	smtp171.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbZJWTQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 15:16:50 -0400
Message-ID: <4AE20124.4010108@librato.com>
Date: Fri, 23 Oct 2009 15:16:52 -0400
From: Oren Laadan <orenl@librato.com>
Organization: Librato
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Matt Helsley <matthltc@us.ibm.com>,
       Daniel Lezcano <daniel.lezcano@free.fr>, randy.dunlap@oracle.com,
       arnd@arndb.de, linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, kosaki.motohiro@jp.fujitsu.com,
       hpa@zytor.com, mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
References: <20091020005125.GG27627@count0.beaverton.ibm.com> <m1vdiad9jd.fsf@fess.ebiederm.org> <20091020040315.GA26632@us.ibm.com> <m1iqeauyvl.fsf@fess.ebiederm.org> <20091020183329.GB22646@us.ibm.com> <m1r5sxsw7w.fsf@fess.ebiederm.org> <20091021062021.GA2667@us.ibm.com> <m1eioxrtsb.fsf@fess.ebiederm.org> <20091023004253.GA7915@us.ibm.com> <m1bpjyrkep.fsf@fess.ebiederm.org> <20091023053001.GA24972@us.ibm.com>
In-Reply-To: <20091023053001.GA24972@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sukadev Bhattiprolu wrote:
> Eric W. Biederman [ebiederm@xmission.com] wrote:
> | > | +	if (target < RESERVED_PIDS)
> | >
> | > Should we replace RESERVED_PIDS with 0 ? We currently allow new
> | > containers to have pids 1..32K in the first pass and in subsequent
> | > passes assign starting at RESERVED_PIDS.
> | 
> | If it is a preexisting namespace pid namespace removing the RESERVED_PIDS
> | check removes most if not all of the point of RESERVED_PIDS.
> | 
> | In a new fresh pid namespace I have no problem with not performing
> | the RESERVED_PIDS check.
> 
> In that case can we do this
> 
> 	if (target_pid < RESERVED_PIDS && !pid_ns->level)
> 		return -EINVAL;
> 
> instead ?
> | 
> | So I guess that makes the check.
> | 
> | if ((target < RESERVED_PIDS) && pid_ns->last_pid >= RESERVED_PIDS)
> |    return -EINVAL;
> 
> I am just wondering if there is a small corner case where C/R would randomly
> fail because of this sequence:
> 
> 	- C/R code calls clone() or clone3() say about RESERVED_PIDS-1
> 	  times and ->last_pid == RESERVED_PIDS-1.
> 
> 	- C/R code calls normal fork()/alloc_pidmap() for a short-lived
> 	  child - its pid == ->last_pid == RESERVED_PIDS
> 
> 	- C/R code then calls clone3()/set_pidmap() to set the pid of
> 	  a new child to RESERVED_PID but fails (i.e it fails to restore
> 	  a pid even when the pid is not in use).

Not only for short-lived children. The problem is restart will succeed
or fail depending on the order in which tasks were checkpointed. If
task with pid 290 is restarted after pid 305, restart will fail.

And because chekcpoint scans the task tree in a DFS manner, this is
more likely to happen than not.

I wonder why you'd like to restrict a pid-specific clone like that ?
It is already a privileged syscall, so it could be exempt. I suggest
that only regular clones will be constrained.

Oren.


