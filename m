Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbZFXDGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbZFXDGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 23:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbZFXDGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 23:06:24 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38666 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbZFXDGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 23:06:24 -0400
Date: Tue, 23 Jun 2009 22:06:27 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
       Ingo Molnar <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/1] mm_for_maps: simplify, use ptrace_may_access()
Message-ID: <20090624030627.GA6459@us.ibm.com>
References: <20090507085742.GB3036@sequoia.sous-sol.org> <20090507090459.GE19133@elte.hu> <20090507092009.GC3036@sequoia.sous-sol.org> <alpine.LRH.2.00.0905071951530.29219@tundra.namei.org> <20090507102015.GB8901@elte.hu> <alpine.LRH.2.00.0905072135580.29806@tundra.namei.org> <20090623141451.GA8133@redhat.com> <20090623174918.GA24430@infradead.org> <20090623192451.GA27853@redhat.com> <20090623192532.GB27853@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623192532.GB27853@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> It would be nice to kill __ptrace_may_access(). It requires task_lock(),
> but this lock is only needed to read mm->flags in the middle.
> 
> Convert mm_for_maps() to use ptrace_may_access(), this also simplifies
> the code a little bit.
> 
> Also, we do not need to take ->mmap_sem in advance. In fact I think
> mm_for_maps() should not play with ->mmap_sem at all, the caller should
> take this lock.

Yeah I think that makes sense.

> With or without this patch, without ->cred_guard_mutex held we can race
> with exec() and get the new ->mm but check old creds.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

reasoning on the security check also makes sense.

Reviewed-by: Serge Hallyn <serue@us.ibm.com>

> --- WAIT/fs/proc/base.c~1_MM_FOR_MAPS	2009-06-17 14:11:26.000000000 +0200
> +++ WAIT/fs/proc/base.c	2009-06-23 20:16:44.000000000 +0200
> @@ -237,20 +237,19 @@ struct mm_struct *mm_for_maps(struct tas
>  	struct mm_struct *mm = get_task_mm(task);
>  	if (!mm)
>  		return NULL;
> +	if (mm != current->mm) {
> +		/*
> +		 * task->mm can be changed before security check,
> +		 * in that case we must notice the change after.
> +		 */
> +		if (!ptrace_may_access(task, PTRACE_MODE_READ) ||
> +		    mm != task->mm) {
> +			mmput(mm);
> +			return NULL;
> +		}
> +	}
>  	down_read(&mm->mmap_sem);
> -	task_lock(task);
> -	if (task->mm != mm)
> -		goto out;
> -	if (task->mm != current->mm &&
> -	    __ptrace_may_access(task, PTRACE_MODE_READ) < 0)
> -		goto out;
> -	task_unlock(task);
>  	return mm;
> -out:
> -	task_unlock(task);
> -	up_read(&mm->mmap_sem);
> -	mmput(mm);
> -	return NULL;
>  }
> 
>  static int proc_pid_cmdline(struct task_struct *task, char * buffer)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
