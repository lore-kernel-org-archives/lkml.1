Return-Path: <linux-kernel-owner+w=401wt.eu-S1161531AbXDXJzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161531AbXDXJzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 05:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932290AbXDXJzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 05:55:22 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:10183 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932286AbXDXJzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 05:55:21 -0400
Message-ID: <462DD3C1.1080803@openvz.org>
Date: Tue, 24 Apr 2007 13:54:09 +0400
From: Kirill Korotaev <dev@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: roland@redhat.com
CC: Alexey Dobriyan <adobriyan@sw.ru>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Devel] [PATCH -mm] utrace: fix double free re	__rcu_process_callbacks()
References: <20070424091023.GA10539@localhost.sw.ru>
In-Reply-To: <20070424091023.GA10539@localhost.sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland,

can you please help with it?
current utrace state is far from being stable,
RHEL5 and -mm kernels can be quite easily crashed with some of the exploits
we collected so far.
Alexey can help you with any information needed - call traces, test cases,
but without your help we can't fix it all ourselfes :/

Thanks,
Kirill

Alexey Dobriyan wrote:
> The following patch fixes double free manifesting itself as crash in
> __rcu_process_callbasks():
> http://marc.info/?l=linux-kernel&m=117518764517017&w=2
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=229112
> 
> The problem is with check_dead_utrace() conditionally scheduling
> "struct utrace" for freeing but not cleaning struct task_struct::utrace
> pointer leaving it reachable:
> 
> 	tsk->utrace_flags = flags;
> 	if (flags)
> 		spin_unlock(&utrace->lock);
> 	else
> 		rcu_utrace_free(utrace);
> 
> OTOH, utrace_release_task() first clears ->utrace pointer, then frees
> struct utrace itself:
> 
> Roland inserted some debugging into 2.6.21-rc6-mm1 so that aforementined
> double free couldn't be reproduced without seeing
> BUG at kernel/utrace.c:176 first. It triggers if one struct utrace were
> passed to rcu_utrace_free() second time.
> 
> With patch applied I no longer see¹ BUG message and double frees on
> 2-way P3, 8-way ia64, Core 2 Duo boxes. Testcase is at the first link.
> 
> I _think_ it adds leak if utrace_reap() takes branch without freeing
> but, well, I hope Roland will give me some clue on how to fix it too.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> ---
> 
>  kernel/utrace.c |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> ¹ But I see whole can of other bugs! I think they were already lurking
>   but weren't easily reproducable without hitting double-free first.
>   FWIW, it's
>   	BUG_ON(!list_empty(&tsk->ptracees));
> 	oops at the beginning of remove_engine()
> 	NULL ->report_quiesce call which is absent in ptrace utrace ops
> 	BUG_ON(tracehook_check_released(p));
> 
> --- a/kernel/utrace.c
> +++ b/kernel/utrace.c
> @@ -205,7 +205,6 @@ utrace_clear_tsk(struct task_struct *tsk
>  	if (utrace->u.live.signal == NULL) {
>  		task_lock(tsk);
>  		if (likely(tsk->utrace != NULL)) {
> -			rcu_assign_pointer(tsk->utrace, NULL);
>  			tsk->utrace_flags &= UTRACE_ACTION_NOREAP;
>  		}
>  		task_unlock(tsk);
> @@ -305,10 +304,7 @@ check_dead_utrace(struct task_struct *ts
>  	}
>  
>  	tsk->utrace_flags = flags;
> -	if (flags)
> -		spin_unlock(&utrace->lock);
> -	else
> -		rcu_utrace_free(utrace);
> +	spin_unlock(&utrace->lock);
>  
>  	/*
>  	 * Now we're finished updating the utrace state.
> 
> _______________________________________________
> Devel mailing list
> Devel@openvz.org
> https://openvz.org/mailman/listinfo/devel
> 

