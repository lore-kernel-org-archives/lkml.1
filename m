Return-Path: <linux-kernel-owner+w=401wt.eu-S1752605AbZGJDHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbZGJDHb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 23:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbZGJDHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 23:07:24 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56137 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZGJDHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 23:07:23 -0400
Date: Thu, 9 Jul 2009 22:07:23 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       David Howells <dhowells@redhat.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm_for_maps: take ->cred_guard_mutex to fix the
	race with exec
Message-ID: <20090710030723.GB11280@us.ibm.com>
References: <20090710012740.GA395@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090710012740.GA395@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> The problem is minor, but without ->cred_guard_mutex held we can race
> with exec() and get the new ->mm but check old creds.
> 
> Now we do not need to re-check task->mm after ptrace_may_access(), it
> can't be changed to the new mm under us.
> 
> Strictly speaking, this also fixes another very minor problem. Unless
> security check fails or the task exits mm_for_maps() should never
> return NULL, the caller should get either old or new ->mm.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
> 
>  fs/proc/base.c |   22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> --- WAIT/fs/proc/base.c~2_CRED_MUTEX	2009-07-10 02:05:14.000000000 +0200
> +++ WAIT/fs/proc/base.c	2009-07-10 03:23:01.000000000 +0200
> @@ -234,19 +234,19 @@ static int check_mem_permission(struct t
> 
>  struct mm_struct *mm_for_maps(struct task_struct *task)
>  {
> -	struct mm_struct *mm = get_task_mm(task);
> +	struct mm_struct *mm;
> 
> -	if (mm && mm != current->mm) {
> -		/*
> -		 * task->mm can be changed before security check,
> -		 * in that case we must notice the change after.
> -		 */
> -		if (!ptrace_may_access(task, PTRACE_MODE_READ) ||
> -		    mm != task->mm) {
> -			mmput(mm);
> -			mm = NULL;
> -		}
> +	if (mutex_lock_killable(&task->cred_guard_mutex))
> +		return NULL;
> +
> +	mm = get_task_mm(task);
> +	if (mm && mm != current->mm &&
> +			!ptrace_may_access(task, PTRACE_MODE_READ)) {
> +		mmput(mm);
> +		mm = NULL;
>  	}
> +	mutex_unlock(&task->cred_guard_mutex);
> +
>  	return mm;
>  }
> 
