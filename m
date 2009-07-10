Return-Path: <linux-kernel-owner+w=401wt.eu-S1752165AbZGJDGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbZGJDGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 23:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750782AbZGJDGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 23:06:35 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:52653 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZGJDGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 23:06:34 -0400
Date: Thu, 9 Jul 2009 22:06:33 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       David Howells <dhowells@redhat.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm_for_maps: shift down_read(mmap_sem) to the
	caller
Message-ID: <20090710030633.GA11280@us.ibm.com>
References: <20090710012738.GA392@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090710012738.GA392@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> mm_for_maps() takes ->mmap_sem after security checks, this looks
> strange and obfuscates the locking rules. Move this lock to its
> single caller, m_start().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Looks sane.

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
> 
>  fs/proc/task_mmu.c   |    1 +
>  fs/proc/task_nommu.c |    1 +
>  fs/proc/base.c       |    8 +++-----
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 
> --- WAIT/fs/proc/task_mmu.c~1_MOVE_MMAP_SEM	2009-05-03 17:15:27.000000000 +0200
> +++ WAIT/fs/proc/task_mmu.c	2009-07-10 02:00:56.000000000 +0200
> @@ -119,6 +119,7 @@ static void *m_start(struct seq_file *m,
>  	mm = mm_for_maps(priv->task);
>  	if (!mm)
>  		return NULL;
> +	down_read(&mm->mmap_sem);
> 
>  	tail_vma = get_gate_vma(priv->task);
>  	priv->tail_vma = tail_vma;
> --- WAIT/fs/proc/task_nommu.c~1_MOVE_MMAP_SEM	2009-04-09 00:39:09.000000000 +0200
> +++ WAIT/fs/proc/task_nommu.c	2009-07-10 02:01:25.000000000 +0200
> @@ -189,6 +189,7 @@ static void *m_start(struct seq_file *m,
>  		priv->task = NULL;
>  		return NULL;
>  	}
> +	down_read(&mm->mmap_sem);
> 
>  	/* start from the Nth VMA */
>  	for (p = rb_first(&mm->mm_rb); p; p = rb_next(p))
> --- WAIT/fs/proc/base.c~1_MOVE_MMAP_SEM	2009-07-09 17:56:27.000000000 +0200
> +++ WAIT/fs/proc/base.c	2009-07-10 02:05:14.000000000 +0200
> @@ -235,9 +235,8 @@ static int check_mem_permission(struct t
>  struct mm_struct *mm_for_maps(struct task_struct *task)
>  {
>  	struct mm_struct *mm = get_task_mm(task);
> -	if (!mm)
> -		return NULL;
> -	if (mm != current->mm) {
> +
> +	if (mm && mm != current->mm) {
>  		/*
>  		 * task->mm can be changed before security check,
>  		 * in that case we must notice the change after.
> @@ -245,10 +244,9 @@ struct mm_struct *mm_for_maps(struct tas
>  		if (!ptrace_may_access(task, PTRACE_MODE_READ) ||
>  		    mm != task->mm) {
>  			mmput(mm);
> -			return NULL;
> +			mm = NULL;
>  		}
>  	}
> -	down_read(&mm->mmap_sem);
>  	return mm;
>  }
> 
