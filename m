Return-Path: <linux-kernel-owner+w=401wt.eu-S1759513AbZKKWiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513AbZKKWiw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 17:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759452AbZKKWiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 17:38:50 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:57436 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759320AbZKKWit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 17:38:49 -0500
Date: Wed, 11 Nov 2009 14:39:07 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: mtk.manpages@googlemail.com, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, matthltc@suka.localdomain,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       linux-api@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
       roland@redhat.com, Pavel Emelyanov <xemul@openvz.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [v12][PATCH 2/9] Have alloc_pidmap() return actual error code
Message-ID: <20091111223907.GC24988@suka>
References: <20091111043440.GA9377@suka> <20091111044313.GB11393@suka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111044313.GB11393@suka>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: LKML

Sukadev Bhattiprolu [sukadev@linux.vnet.ibm.com] wrote:
| 
| Subject: [v12][PATCH 2/9] Have alloc_pidmap() return actual error code
| 
| alloc_pidmap() can fail either because all pid numbers are in use or
| because memory allocation failed.  With support for setting a specific
| pid number, alloc_pidmap() would also fail if either the given pid
| number is invalid or in use.
| 
| Rather than have callers assume -ENOMEM, have alloc_pidmap() return
| the actual error.
| 
| Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
| Acked-by: Serge Hallyn <serue@us.ibm.com>
| Reviewed-by: Oren Laadan <orenl@cs.columbia.edu>
| ---
|  kernel/fork.c |    5 +++--
|  kernel/pid.c  |   14 +++++++++-----
|  2 files changed, 12 insertions(+), 7 deletions(-)
| 
| diff --git a/kernel/fork.c b/kernel/fork.c
| index 4c20fff..93626b2 100644
| --- a/kernel/fork.c
| +++ b/kernel/fork.c
| @@ -1156,10 +1156,11 @@ static struct task_struct *copy_process(unsigned long clone_flags,
|  		goto bad_fork_cleanup_io;
| 
|  	if (pid != &init_struct_pid) {
| -		retval = -ENOMEM;
|  		pid = alloc_pid(p->nsproxy->pid_ns);
| -		if (!pid)
| +		if (IS_ERR(pid)) {
| +			retval = PTR_ERR(pid);
|  			goto bad_fork_cleanup_io;
| +		}
| 
|  		if (clone_flags & CLONE_NEWPID) {
|  			retval = pid_ns_prepare_proc(p->nsproxy->pid_ns);
| diff --git a/kernel/pid.c b/kernel/pid.c
| index 7d4bb6e..c4d9914 100644
| --- a/kernel/pid.c
| +++ b/kernel/pid.c
| @@ -150,7 +150,7 @@ static int alloc_pidmap_page(struct pidmap *map)
|  static int alloc_pidmap(struct pid_namespace *pid_ns)
|  {
|  	int i, offset, max_scan, pid, last = pid_ns->last_pid;
| -	int rc;
| +	int rc = -EAGAIN;
|  	struct pidmap *map;
| 
|  	pid = last + 1;
| @@ -189,12 +189,14 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
|  		} else {
|  			map = &pid_ns->pidmap[0];
|  			offset = RESERVED_PIDS;
| -			if (unlikely(last == offset))
| +			if (unlikely(last == offset)) {
| +				rc = -EAGAIN;
|  				break;
| +			}
|  		}
|  		pid = mk_pid(pid_ns, map, offset);
|  	}
| -	return -1;
| +	return rc;
|  }
| 
|  int next_pidmap(struct pid_namespace *pid_ns, int last)
| @@ -263,8 +265,10 @@ struct pid *alloc_pid(struct pid_namespace *ns)
|  	struct upid *upid;
| 
|  	pid = kmem_cache_alloc(ns->pid_cachep, GFP_KERNEL);
| -	if (!pid)
| +	if (!pid) {
| +		pid = ERR_PTR(-ENOMEM);
|  		goto out;
| +	}
| 
|  	tmp = ns;
|  	for (i = ns->level; i >= 0; i--) {
| @@ -299,7 +303,7 @@ out_free:
|  		free_pidmap(pid->numbers + i);
| 
|  	kmem_cache_free(ns->pid_cachep, pid);
| -	pid = NULL;
| +	pid = ERR_PTR(nr);
|  	goto out;
|  }
| 
| -- 
| 1.6.0.4
| 
| _______________________________________________
| Containers mailing list
| Containers@lists.linux-foundation.org
| https://lists.linux-foundation.org/mailman/listinfo/containers
