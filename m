Return-Path: <linux-kernel-owner+w=401wt.eu-S1752954AbZGTIMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbZGTIMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 04:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbZGTIMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 04:12:17 -0400
Received: from mail-qy0-f198.google.com ([209.85.221.198]:60390 "EHLO
	mail-qy0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbZGTIMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 04:12:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gJI0ZKj1CQoTqmypkklyEV/mI63wzorT5rILwTmmxvMkOFD1e159YP2gFcbDo0NPWM
         p7ul9C1+bPOYBnIbTfAkO4R74cOpT2JOkcOFw8xHVmut3YEhNTQCDuBTD8viZ5IBF5Eq
         vXdNFRomPNe0JYx02CuCjn7mv0vct8/w3nMLc=
Date: Mon, 20 Jul 2009 04:12:12 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Pull up the might_sleep() check into
	cond_resched()
Message-ID: <20090720081210.GA5309@nowhere>
References: <1247725694-6082-6-git-send-email-fweisbec@gmail.com> <tip-613afbf83298efaead05ebcac23d2285609d7160@git.kernel.org> <4A6413AB.2050807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6413AB.2050807@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 02:50:19PM +0800, Li Zefan wrote:
> > Commit-ID:  613afbf83298efaead05ebcac23d2285609d7160
> > Gitweb:     http://git.kernel.org/tip/613afbf83298efaead05ebcac23d2285609d7160
> > Author:     Frederic Weisbecker <fweisbec@gmail.com>
> > AuthorDate: Thu, 16 Jul 2009 15:44:29 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sat, 18 Jul 2009 15:51:44 +0200
> > 
> > sched: Pull up the might_sleep() check into cond_resched()
> > 
> > might_sleep() is called late-ish in cond_resched(), after the
> > need_resched()/preempt enabled/system running tests are
> > checked.
> > 
> > It's better to check the sleeps while atomic earlier and not
> > depend on some environment datas that reduce the chances to
> > detect a problem.
> > 
> > Also define cond_resched_*() helpers as macros, so that the
> > FILE/LINE reported in the sleeping while atomic warning
> > displays the real origin and not sched.h
> > 
> 
> I guess it's this patch that causes lots of "BUG"
> 
> BUG: sleeping function called from invalid context at fs/jbd/commit.c:902        
> in_atomic(): 0, irqs_disabled(): 0, pid: 64, name: kjournald                     
> INFO: lockdep is turned off.                                                     
> Pid: 64, comm: kjournald Tainted: GF          2.6.31-rc3-tip #15                 
> Call Trace:                                                                      
>  [<c042cbd1>] __might_sleep+0xda/0xdf                                            
>  [<c053e9f4>] journal_commit_transaction+0xb03/0xc5f                             
>  [<c043ecc4>] ? try_to_del_timer_sync+0x48/0x4f                                  
>  [<c0541394>] kjournald+0xcf/0x1fe                                               
>  [<c0448998>] ? autoremove_wake_function+0x0/0x34                                
>  [<c05412c5>] ? kjournald+0x0/0x1fe                                              
>  [<c0448708>] kthread+0x6b/0x70                                                  
>  [<c044869d>] ? kthread+0x0/0x70                                                 
>  [<c040364b>] kernel_thread_helper+0x7/0x10                                      
> BUG: sleeping function called from invalid context at fs/dcache.c:512            
> in_atomic(): 0, irqs_disabled(): 0, pid: 2005, name: bash                        
> INFO: lockdep is turned off.                                                     
> Pid: 2005, comm: bash Tainted: GF          2.6.31-rc3-tip #15                    
> Call Trace:                                                                      
>  [<c042cbd1>] __might_sleep+0xda/0xdf                                            
>  [<c04cae29>] __shrink_dcache_sb+0x208/0x27a                                     
>  [<c04cb038>] shrink_dcache_parent+0x2c/0xcf                                     
>  [<c04f8371>] proc_flush_task+0xa7/0x194                                         
>  [<c0437553>] release_task+0x29/0x3b4                                            
>  [<c0437fe0>] wait_consider_task+0x702/0xa91                                     
>  [<c043844d>] do_wait+0xde/0x276                                                 
>  [<c0430f6e>] ? default_wake_function+0x0/0x12                                   
>  [<c0438672>] sys_wait4+0x8d/0xa6                                                
>  [<c04a3c65>] ? might_fault+0x85/0x87                                            
>  [<c04386a3>] sys_waitpid+0x18/0x1a                                              
>  [<c0402ab8>] sysenter_do_call+0x12/0x36                       


Hm, I can read that in fs/dcache.c:512

/* dentry->d_lock was dropped in prune_one_dentry() */
cond_resched_lock(&dcache_lock);

Isn't it a mususe of cond_resched_lock() ?
In this case, dcache.c should be fixed.

Anyway a generic fix could be the following.
Can you tell me if this works for you?

Thanks!
---
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] sched: Check if the spinlock is locked in cond_resched_lock()

Some uses of cond_resched_lock() might involve an
unlocked spinlock, resulting in spurious sleep in
atomic warnings.
Check whether the spinlock is actually locked and
take that into account in the might_sleep() check.

Reported-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/include/linux/sched.h b/include/linux/sched.h
index cb070dc..2789658 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2294,9 +2294,10 @@ extern int _cond_resched(void);
 
 extern int __cond_resched_lock(spinlock_t *lock);
 
-#define cond_resched_lock(lock) ({				\
-	__might_sleep(__FILE__, __LINE__, PREEMPT_OFFSET);	\
-	__cond_resched_lock(lock);				\
+#define cond_resched_lock(lock) ({				  \
+	__might_sleep(__FILE__, __LINE__, spin_is_locked(lock) ?  \
+					  PREEMPT_OFFSET : 0);	  \
+	__cond_resched_lock(lock);				  \
 })
 
 extern int __cond_resched_softirq(void);


