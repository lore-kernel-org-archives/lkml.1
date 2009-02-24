Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbZBXOx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbZBXOx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 09:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757131AbZBXOxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 09:53:11 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:38107 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689AbZBXOwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 09:52:55 -0500
Date: Tue, 24 Feb 2009 08:52:50 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: debugging threaded apps running under a clone(CLONE_NEWPID)
Message-ID: <20090224145250.GB15751@us.ibm.com>
References: <499EE0D1.1010001@fr.ibm.com> <20090223182153.GD13151@us.ibm.com> <49A3C314.6010806@fr.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A3C314.6010806@fr.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Cedric Le Goater (clg@fr.ibm.com):
> Serge E. Hallyn wrote:
> > Quoting Cedric Le Goater (clg@fr.ibm.com):
> >> Hello !
> >>
> >> to debug threaded apps, gdb uses a special libthread_db which seeks in the
> >> symbols of the exec the list of running threads. This list contains the glibc 
> >> 'struct pthread' descriptor with pids and tids which values are relative 
> >> to the namespace in which the threads were created.  
> >>
> >> unless you run gdb in the same pid namespace, gdb will not see any thread
> >> in the debugged app. this is frustrating for some scenarios and some 
> >> support from the kernel would be needed to address this issue. Here
> >> are some ideas :
> >>
> >>    . enter a pid namespace. hard.  
> >>
> >>    . expose the pid numbers of a task in its pid namespaces, through some 
> >>      ways like /proc/self/stat or /proc/self/pids and modify gdb to make 
> >>      the conversion.
> >>
> >> How would you do it ? 
> > 
> > perhaps a /proc/$$/vpid which prints out
> > 	task_pid_nr_ns(tsk, current->nsproxy->pidns)
> 
> yes something like below, which prints out too much values.
> 
> > then each thread opens an fd for /proc/self/vpid and passes it
> > over an af_unix socket to the parent gdb, which then reads it
> > to get the pid in its own ns?
> 
> if we suppose that gdb is running in a parent namespace, i'd fix 
> the libthread_db to convert the pids of the threads in the child
> namespace to the pids of the threads in the parent namespace using 
> the new /proc file. this can be done with LD_PRELOAD but gdb also 
> offers a framework to load operations interacting with threads. 
> 
> This needs more studies, specially on the gdb side, but I think we 

Right - conceptually I think it's nice (and your patch is nice and
short), but I don't know if it fits into how gdb works.  Of course
it should be able to force the traced tasks through ptrace to open
the file and pass the fd, but maybe that isn't gdb-ish or something.
(I assume you're looking at gdb code, but if you are not/don't have
time let me know and I'll take a look)

thanks,
-serge

> will need a way to convert pid values between parent and child 
> namespace if we don't want to change the all the thread support in
> gdb. 
> 
> C.
> 
> 
> Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
> ---
>  fs/proc/base.c |   19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> Index: 2.6.27-mcr.git/fs/proc/base.c
> ===================================================================
> --- 2.6.27-mcr.git.orig/fs/proc/base.c
> +++ 2.6.27-mcr.git/fs/proc/base.c
> @@ -2444,6 +2444,23 @@ static int proc_tgid_io_accounting(struc
>  }
>  #endif /* CONFIG_TASK_IO_ACCOUNTING */
> 
> +static int proc_pid_vpids(struct task_struct *task, char *buffer)
> +{
> +	struct pid_namespace *pid_ns = task->nsproxy->pid_ns;
> +
> +	return sprintf(buffer, "%6d %6d %6d %6d %6d %6d %6d %6d %6d %6d\n",
> +		       task_pid_nr_ns(task, pid_ns), // pid
> +		       task_pid_nr(task),
> +		       task_tgid_nr_ns(task, pid_ns), // tgid
> +		       task_tgid_nr(task),
> +		       task_tgid_nr_ns(task->real_parent, pid_ns), // ppid
> +		       task_tgid_nr(task->real_parent),
> +		       task_pgrp_nr_ns(task, pid_ns), // pgid
> +		       task_pgrp_nr(task),
> +		       task_session_nr_ns(task, pid_ns), // sid
> +		       task_session_nr(task));
> +}
> +
>  /*
>   * Thread groups
>   */
> @@ -2519,6 +2536,7 @@ static const struct pid_entry tgid_base_
>  #ifdef CONFIG_TASK_IO_ACCOUNTING
>  	INF("io",	S_IRUGO, tgid_io_accounting),
>  #endif
> +	INF("vpids",	S_IRUGO, pid_vpids),
>  };
> 
>  static int proc_tgid_base_readdir(struct file * filp,
> @@ -2854,6 +2872,7 @@ static const struct pid_entry tid_base_s
>  #ifdef CONFIG_TASK_IO_ACCOUNTING
>  	INF("io",	S_IRUGO, tid_io_accounting),
>  #endif
> +	INF("vpids",	S_IRUGO, pid_vpids),
>  };
> 
>  static int proc_tid_base_readdir(struct file * filp,
