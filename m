Return-Path: <linux-kernel-owner+w=401wt.eu-S1753204AbZJUHzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbZJUHzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 03:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbZJUHzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 03:55:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55980 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbZJUHy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 03:54:59 -0400
Date: Mon, 19 Oct 2009 23:36:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org, Louis.Rilling@kerlabs.com, roland@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
       linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: Re: [RFC][v8][PATCH 10/10]: Document clone3() syscall
Message-ID: <20091019213636.GB1482@ucw.cz>
References: <20091013044925.GA28181@us.ibm.com> <20091013045556.GJ28435@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013045556.GJ28435@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> This gives a brief overview of the clone3() system call.  We should

Thanks!

> eventually describe more details in existing clone(2) man page or in
> a new man page.

M. Kerrisk (see MAINTAINERS) maintains man pages...

> Changelog[v8]:
> 	- clone2() is already in use in IA64. Rename syscall to clone3()
...
> Index: linux-2.6/Documentation/clone2
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/Documentation/clone2	2009-10-12 19:54:38.000000000 -0700

clone3?

> +struct clone_struct {
> +	u64 flags;
> +	u64 child_stack;

u64 seems wrong  on 32 bit platforms. ulong?

> +	u32 nr_pids;

So nr_pids is either 1 or 2?

> +	u32 reserved1;
> +	u64 parent_tid;
> +	u64 child_tid;
> +	u64 reserved2;
> +};
> +


> +	See CLONE_NEWPID section of clone(2) man page for details about pid
> +	namespaces.
> +
> +	The order pids in @pids corresponds to the nesting order of pid-
> +	namespaces, with @pids[0] corresponding to the init_pid_ns.

Ok, so I'm confused.

> +	If a pid in the @pids list is 0, the kernel will assign the next
> +	available pid in the pid namespace, for the process.
> +
> +	If a pid in the @pids list is non-zero, the kernel tries to assign
> +	the specified pid in that namespace.  If that pid is already in use
> +	by another process, the system call fails with -EBUSY.
...
> +	On failure, clone3() returns -1 and sets 'errno' to one of following
> +	values (the child process is not created).

Inconsistent with above. Syscalls really return -ERRCODE, errno is
glibc magic.

> +Example:
> +
> +	pid_t pids[] = { 77, 99 };
> +	struct clone_struct cs;
> +
> +	cs.flags = (u64) SIGCHLD;
> +	cs.child_stack = (u64) setup_child_stack();
> +	cs.nr_pids = 2;
> +	cs.parent_tid = 0LL;
> +	cs.child_tid = 0LL;
> +
> +	rc = syscall(__NR_clone3, &cs, pids);

Hmm, is there reason why pids are not at the end of struct
clone_struct? Passing most parameters in special structure, then pids
separately is strange...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
