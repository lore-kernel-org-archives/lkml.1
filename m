Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbYEHNx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbYEHNx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 09:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYEHNxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 09:53:48 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:34931 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbYEHNxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 09:53:47 -0400
Message-ID: <482305E5.6070107@linux.vnet.ibm.com>
Date: Thu, 08 May 2008 19:23:41 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] on CONFIG_MM_OWNER=y, kernel panic is possible. take2
References: <20080506153943.AC69.KOSAKI.MOTOHIRO@jp.fujitsu.com> <6599ad830805062037n221ef8e2n9ee7ac33417ab499@mail.gmail.com> <20080508083808.4A78.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080508083808.4A78.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>> I'd word it as
>>
>> /*
>>  * "owner" points to a task that is regarded as the canonical
>>  * user/owner of this mm. All of the following must be true in
>>  * order for it to be changed:
>>  *
>>  * current == mm->owner
>>  * current->mm != mm
>>  * new_owner->mm == mm
>>  * new_owner->alloc_lock is held
>>  */
> 
> Wow, Thank you a lot!
> new version attached.
> 
> Cheers!
> 
> 
> -----------------------------------------------------------
> When mm destruct happend, We should pass mm_update_next_owner() 
> old mm.
> but unfortunately new mm is passed in exec_mmap().
> 
> thus, kernel panic is possible when multi thread process use exec().
> 
> 
> and, owner member comment description is wrong.
> mm->owner don't not necessarily point to thread group leader.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Balbir Singh <balbir@linux.vnet.ibm.com>
> CC: "Paul Menage" <menage@google.com>
> CC: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
> 
> ---
>  fs/exec.c                |    2 +-
>  include/linux/mm_types.h |   13 +++++++++++--
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> Index: b/fs/exec.c
> ===================================================================
> --- a/fs/exec.c	2008-05-04 22:57:09.000000000 +0900
> +++ b/fs/exec.c	2008-05-06 15:40:35.000000000 +0900
> @@ -735,7 +735,7 @@ static int exec_mmap(struct mm_struct *m
>  	tsk->active_mm = mm;
>  	activate_mm(active_mm, mm);
>  	task_unlock(tsk);
> -	mm_update_next_owner(mm);
> +	mm_update_next_owner(old_mm);
>  	arch_pick_mmap_layout(mm);
>  	if (old_mm) {
>  		up_read(&old_mm->mmap_sem);
> Index: b/include/linux/mm_types.h
> ===================================================================
> --- a/include/linux/mm_types.h	2008-05-08 09:20:13.000000000 +0900
> +++ b/include/linux/mm_types.h	2008-05-08 09:22:13.000000000 +0900
> @@ -231,8 +231,17 @@ struct mm_struct {
>  	rwlock_t		ioctx_list_lock;	/* aio lock */
>  	struct kioctx		*ioctx_list;
>  #ifdef CONFIG_MM_OWNER
> -	struct task_struct *owner;	/* The thread group leader that */
> -					/* owns the mm_struct.		*/
> +        /*
> +         * "owner" points to a task that is regarded as the canonical
> +         * user/owner of this mm. All of the following must be true in
> +         * order for it to be changed:
> +         *
> +         * current == mm->owner
> +         * current->mm != mm
> +         * new_owner->mm == mm
> +         * new_owner->alloc_lock is held
> +         */
> +	struct task_struct *owner;
>  #endif
> 
>  #ifdef CONFIG_PROC_FS
> 

Looks good to me, but I've not tested it

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
