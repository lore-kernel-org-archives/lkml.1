Return-Path: <linux-kernel-owner+w=401wt.eu-S1751754AbZJWF2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbZJWF2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 01:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbZJWF2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 01:28:36 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47829 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbZJWF2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 01:28:35 -0400
Date: Thu, 22 Oct 2009 22:30:01 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, Oren Laadan <orenl@librato.com>,
       Daniel Lezcano <daniel.lezcano@free.fr>, randy.dunlap@oracle.com,
       arnd@arndb.de, linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, kosaki.motohiro@jp.fujitsu.com,
       hpa@zytor.com, mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Message-ID: <20091023053001.GA24972@us.ibm.com>
References: <20091020005125.GG27627@count0.beaverton.ibm.com> <m1vdiad9jd.fsf@fess.ebiederm.org> <20091020040315.GA26632@us.ibm.com> <m1iqeauyvl.fsf@fess.ebiederm.org> <20091020183329.GB22646@us.ibm.com> <m1r5sxsw7w.fsf@fess.ebiederm.org> <20091021062021.GA2667@us.ibm.com> <m1eioxrtsb.fsf@fess.ebiederm.org> <20091023004253.GA7915@us.ibm.com> <m1bpjyrkep.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bpjyrkep.fsf@fess.ebiederm.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman [ebiederm@xmission.com] wrote:
| > | +	if (target < RESERVED_PIDS)
| >
| > Should we replace RESERVED_PIDS with 0 ? We currently allow new
| > containers to have pids 1..32K in the first pass and in subsequent
| > passes assign starting at RESERVED_PIDS.
| 
| If it is a preexisting namespace pid namespace removing the RESERVED_PIDS
| check removes most if not all of the point of RESERVED_PIDS.
| 
| In a new fresh pid namespace I have no problem with not performing
| the RESERVED_PIDS check.

In that case can we do this

	if (target_pid < RESERVED_PIDS && !pid_ns->level)
		return -EINVAL;

instead ?
| 
| So I guess that makes the check.
| 
| if ((target < RESERVED_PIDS) && pid_ns->last_pid >= RESERVED_PIDS)
|    return -EINVAL;

I am just wondering if there is a small corner case where C/R would randomly
fail because of this sequence:

	- C/R code calls clone() or clone3() say about RESERVED_PIDS-1
	  times and ->last_pid == RESERVED_PIDS-1.

	- C/R code calls normal fork()/alloc_pidmap() for a short-lived
	  child - its pid == ->last_pid == RESERVED_PIDS

	- C/R code then calls clone3()/set_pidmap() to set the pid of
	  a new child to RESERVED_PID but fails (i.e it fails to restore
	  a pid even when the pid is not in use).

We could argue that mixing alloc_pidmap() and set_pidmap() during restart
is bad since set_pidmap() may fail.

The C/R developer could argue that we are forcing them to specify a pid
even for a short lived process that they wait()s on and thus ensure that
pid is not in use.

Anyway, is RESERVED_PIDS meant for initial kernel-threads/daemons - if so
would it be ok enforce it only in init_pid_ns ?

Sukadev
