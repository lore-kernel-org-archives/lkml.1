Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbYEFGdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbYEFGdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 02:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbYEFGdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 02:33:07 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:38120 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbYEFGdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 02:33:05 -0400
Message-ID: <481FFB6B.2000305@linux.vnet.ibm.com>
Date: Tue, 06 May 2008 12:02:11 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>
Subject: Re: on CONFIG_MM_OWNER=y, kernel panic is possible.
References: <20080506142255.AC5D.KOSAKI.MOTOHIRO@jp.fujitsu.com> <481FF115.8030503@linux.vnet.ibm.com> <20080506150213.AC63.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080506150213.AC63.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>> That is not possible. If you look at where mm_update_next_owner() is called
>> from, we call it from
>>
>> exit_mm() and exec_mmap()
>>
>> In both cases, we ensure that the task's mm has changed (to NULL and the new mm
>> respectively), before we call mm_update_next_owner(), hence c->mm can never be
>> equal to p->mm.
> 
> if so, following patch is needed instead.
> 
> 
> 
> ---
>  fs/exec.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/fs/exec.c
> ===================================================================
> --- a/fs/exec.c 2008-05-04 22:57:09.000000000 +0900
> +++ b/fs/exec.c 2008-05-06 15:40:35.000000000 +0900
> @@ -735,7 +735,7 @@ static int exec_mmap(struct mm_struct *m
>         tsk->active_mm = mm;
>         activate_mm(active_mm, mm);
>         task_unlock(tsk);
> -       mm_update_next_owner(mm);
> +       mm_update_next_owner(old_mm);
>         arch_pick_mmap_layout(mm);
>         if (old_mm) {
>                 up_read(&old_mm->mmap_sem);
> 
> 

Yes, good catch.

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

I'll go ahead and do some more testing on top of it. CC'ing Paul Menage as well.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
