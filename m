Return-Path: <linux-kernel-owner+w=401wt.eu-S1755612AbXGGTD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbXGGTD6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 15:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbXGGTDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 15:03:51 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:35178 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbXGGTDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 15:03:50 -0400
Date: Sat, 7 Jul 2007 12:05:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Eric W Biederman <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -rc7][resend] kthread: Silence bogus section mismatch
 warning
Message-Id: <20070707120552.95a9a6aa.randy.dunlap@oracle.com>
In-Reply-To: <20070707164722.1356.52206.sendpatchset@cselinux1.cse.iitk.ac.in>
References: <20070707164722.1356.52206.sendpatchset@cselinux1.cse.iitk.ac.in>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 07 Jul 2007 22:17:22 +0530 Satyam Sharma wrote:

> This:
> 
> WARNING: kernel/built-in.o(.text+0x16910): Section mismatch:
> reference to .init.text: (between 'kthreadd' and 'init_waitqueue_head')
> 
> comes because kernel/kthread.c:kthreadd() is not __init but calls
> kthreadd_setup() which is __init. But this is ok, because kthreadd_setup()
> is only ever called at init time, and then kthreadd() proceeds into its
> "for (;;)" loop. We could mark kthreadd __init_refok, but kthreadd_setup()
> with just one callsite and 4 lines in it (it's been that small since
> 10ab825bdef8df51) doesn't need to be a separate function at all -- so let's
> just move those four lines at beginning of kthreadd() itself.
> 
> Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

> ---
> 
> First discussed in http://lkml.org/lkml/2007/6/26/274,
> and I keep getting this with:
> ...
> 
>  kernel/kthread.c |   12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
> 
> ---
> 
> diff -ruNp a/kernel/kthread.c b/kernel/kthread.c
> --- a/kernel/kthread.c	2007-06-26 06:33:08.000000000 +0530
> +++ b/kernel/kthread.c	2007-06-27 02:57:46.000000000 +0530
> @@ -214,23 +214,15 @@ int kthread_stop(struct task_struct *k)
>  }
>  EXPORT_SYMBOL(kthread_stop);
>  
> -
> -static __init void kthreadd_setup(void)
> +int kthreadd(void *unused)
>  {
>  	struct task_struct *tsk = current;
>  
> +	/* Setup a clean context for our children to inherit. */
>  	set_task_comm(tsk, "kthreadd");
> -
>  	ignore_signals(tsk);
> -
>  	set_user_nice(tsk, -5);
>  	set_cpus_allowed(tsk, CPU_MASK_ALL);
> -}
> -
> -int kthreadd(void *unused)
> -{
> -	/* Setup a clean context for our children to inherit. */
> -	kthreadd_setup();
>  
>  	current->flags |= PF_NOFREEZE;
>  


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
