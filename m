Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994AbZIJP2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbZIJP2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 11:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbZIJP2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 11:28:31 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:35978 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbZIJP23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 11:28:29 -0400
Date: Thu, 10 Sep 2009 08:26:59 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: Re: [RFC][v6][PATCH 9/9]: Document clone_with_pids() syscall
Message-Id: <20090910082659.033ab8fd.randy.dunlap@oracle.com>
In-Reply-To: <20090910061413.GH25883@us.ibm.com>
References: <20090910060627.GA24343@us.ibm.com>
	<20090910061413.GH25883@us.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt016.oracle.com [141.146.116.25]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4AA91AC7.014E:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009 23:14:13 -0700 Sukadev Bhattiprolu wrote:

> 
> Subject: [RFC][v6][PATCH 9/9]: Document clone_with_pids() syscall
> 
> This gives a brief overview of the clone_with_pids() system call.  We should
> eventually describe more details either in clone(2) or in a new man page.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@vnet.linux.ibm.com>
> ---
>  Documentation/clone-with-pids |   58 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 58 insertions(+)
> 
> Index: linux-2.6/Documentation/clone-with-pids
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/Documentation/clone-with-pids	2009-09-09 21:53:30.000000000 -0700
> @@ -0,0 +1,58 @@
> +
> +struct pid_set {
> +	unsigned int num_pids;
> +	pid_t pids[];
> +};
> +
> +clone_with_pids(int flags, void *child_stack_base, int *parent_tid_ptr,
> +			int *child_tid_ptr, NULL, struct pid_set *pid_setp)
> +
> +	The clone_with_pids() system call is identical to clone(), except
> +	that it allows the user to specify a pid for the child process
> +	in each of the child processes' pid name spaces.
> +
	                                    namespaces.  {as below}

> +	This system call is meant to be used when restarting an application
> +	from an earlier checkpoint. When restarting the application, the
> +	processes in the application must get the same pids they had at the
> +	time of the checkpoint.
> +
> +	The 'pid_setp' parameter defines a set of pids to use, one for each
> +	pid-namespace of the child process.  The order pids in '->pids[]'

	                                         order of pids

> +	corresponds to the nesting order of pid-namespaces, with ->pids[0]
> +	corresponding to the init_pid_ns.
> +
> +	If a pid in the ->pids list is 0, the kernel will assign the next
> +	available pid in the pid namespace, for the process.
> +
> +	If a pid in the ->pids[] list is non-zero, the kernel tries to assign
> +	the specified pid in that namespace.  If that pid is already in use
> +	by another process, the system call fails with -EBUSY.
> +
> +	On success, the system call returns the pid of the child process in
> +	the parent's active pid namespace.
> +
> +	On failure, clone_with_pids() returns -1 and sets 'errno' to one of
> +	following values (the child process is not created).
> +
> +	EPERM	Caller does not have the SYS_ADMIN privilege needed to excute

		                                                       execute

> +		this call.
> +
> +	EINVAL	The number of pids specified in 'pid_set.num_pids' exceeds
> +		the current nesting level of parent process
> +
> +	EBUSY	A requested 'pid' is in use by another process in that name
> +		space.
> +
> +Example:
> +
> +	struct pid_set pid_set { 3, {0, 99, 177} };
> +	void *child_stack = malloc(STACKSIZE);
> +
> +	/* set up child_stack, like with clone() */
> +	rc = clone_with_pids(clone_flags, child_stack, NULL, NULL, &pid_set);
> +
> +	if (rc < 0) {
> +		perror("clone_with_pids()");
> +		exit(1);
> +	}

What happens when one of the pids is busy?  Say the last one in the
example above [177].  Are the first 2 children already cloned
or are all pids checked for availability before cloning?
If the latter, is there a race there?
and what value is returned?

---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
