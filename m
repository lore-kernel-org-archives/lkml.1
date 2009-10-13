Return-Path: <linux-kernel-owner+w=401wt.eu-S934036AbZJMSgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934036AbZJMSgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 14:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760125AbZJMSgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 14:36:40 -0400
Received: from smtp151.iad.emailsrvr.com ([207.97.245.151]:57634 "EHLO
	smtp151.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298AbZJMSgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 14:36:39 -0400
Message-ID: <4AD4C88D.7040008@librato.com>
Date: Tue, 13 Oct 2009 14:35:57 -0400
From: Oren Laadan <orenl@librato.com>
Organization: Librato
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, Louis.Rilling@kerlabs.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       kosaki.motohiro@jp.fujitsu.com, hpa@zytor.com, mingo@elte.hu,
       linux-api@vger.kernel.org, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 7/10]: Check invalid clone flags
References: <20091013044925.GA28181@us.ibm.com> <20091013045234.GG28435@us.ibm.com>
In-Reply-To: <20091013045234.GG28435@us.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sukadev Bhattiprolu wrote:
> 
> Subject: [RFC][v8][PATCH 7/10]: Check invalid clone flags
> 
> As pointed out by Oren Laadan, we want to ensure that unused bits in the
> clone-flags remain unused and available for future. To ensure this, define
> a mask of clone-flags and check the flags in the clone() system calls.
> 
> Changelog[v8]:
> 	- New patch in set
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> 
> ---
>  include/linux/sched.h |   10 ++++++++++
>  kernel/fork.c         |    3 +++
>  2 files changed, 13 insertions(+)
> 
> Index: linux-2.6/include/linux/sched.h
> ===================================================================
> --- linux-2.6.orig/include/linux/sched.h	2009-10-02 18:53:55.000000000 -0700
> +++ linux-2.6/include/linux/sched.h	2009-10-02 19:58:21.000000000 -0700
> @@ -29,6 +29,16 @@
>  #define CLONE_NEWNET		0x40000000	/* New network namespace */
>  #define CLONE_IO		0x80000000	/* Clone io context */
>  
> +#define VALID_CLONE_FLAGS	(CSIGNAL | CLONE_VM | CLONE_FS | CLONE_FILES |\
> +				 CLONE_SIGHAND | CLONE_PTRACE | CLONE_VFORK  |\
> +				 CLONE_PARENT | CLONE_THREAD | CLONE_NEWNS   |\
> +				 CLONE_SYSVSEM | CLONE_SETTLS                |\
> +				 CLONE_PARENT_SETTID | CLONE_CHILD_CLEARTID  |\
> +				 CLONE_DETACHED | CLONE_UNTRACED             |\
> +				 CLONE_CHILD_SETTID | CLONE_STOPPED          |\
> +				 CLONE_NEWUTS | CLONE_NEWIPC | CLONE_NEWUSER |\
> +				 CLONE_NEWPID | CLONE_NEWNET| CLONE_IO)
> +
>  /*
>   * Scheduling policies
>   */
> Index: linux-2.6/kernel/fork.c
> ===================================================================
> --- linux-2.6.orig/kernel/fork.c	2009-10-02 19:00:08.000000000 -0700
> +++ linux-2.6/kernel/fork.c	2009-10-02 19:57:36.000000000 -0700
> @@ -942,6 +942,9 @@ static struct task_struct *copy_process(
>  	struct task_struct *p;
>  	int cgroup_callbacks_done = 0;
>  

We can safely apply these tests to clone3(), because it is a new syscall.

However, I don't know if applying it to clone() can break existing
application that may already be (incorrectly) using invalid flags ?

Oren.

> +	if (clone_flags & ~VALID_CLONE_FLAGS)
> +		return ERR_PTR(-EINVAL);
> +
>  	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
>  		return ERR_PTR(-EINVAL);
>  
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
