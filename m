Return-Path: <linux-kernel-owner+w=401wt.eu-S1752381AbZGTGwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbZGTGwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 02:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbZGTGv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 02:51:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63779 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbZGTGv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 02:51:56 -0400
Message-ID: <4A6413AB.2050807@cn.fujitsu.com>
Date: Mon, 20 Jul 2009 14:50:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: fweisbec@gmail.com
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Pull up the might_sleep() check into
 cond_resched()
References: <1247725694-6082-6-git-send-email-fweisbec@gmail.com> <tip-613afbf83298efaead05ebcac23d2285609d7160@git.kernel.org>
In-Reply-To: <tip-613afbf83298efaead05ebcac23d2285609d7160@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Commit-ID:  613afbf83298efaead05ebcac23d2285609d7160
> Gitweb:     http://git.kernel.org/tip/613afbf83298efaead05ebcac23d2285609d7160
> Author:     Frederic Weisbecker <fweisbec@gmail.com>
> AuthorDate: Thu, 16 Jul 2009 15:44:29 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat, 18 Jul 2009 15:51:44 +0200
> 
> sched: Pull up the might_sleep() check into cond_resched()
> 
> might_sleep() is called late-ish in cond_resched(), after the
> need_resched()/preempt enabled/system running tests are
> checked.
> 
> It's better to check the sleeps while atomic earlier and not
> depend on some environment datas that reduce the chances to
> detect a problem.
> 
> Also define cond_resched_*() helpers as macros, so that the
> FILE/LINE reported in the sleeping while atomic warning
> displays the real origin and not sched.h
> 

I guess it's this patch that causes lots of "BUG"

BUG: sleeping function called from invalid context at fs/jbd/commit.c:902        
in_atomic(): 0, irqs_disabled(): 0, pid: 64, name: kjournald                     
INFO: lockdep is turned off.                                                     
Pid: 64, comm: kjournald Tainted: GF          2.6.31-rc3-tip #15                 
Call Trace:                                                                      
 [<c042cbd1>] __might_sleep+0xda/0xdf                                            
 [<c053e9f4>] journal_commit_transaction+0xb03/0xc5f                             
 [<c043ecc4>] ? try_to_del_timer_sync+0x48/0x4f                                  
 [<c0541394>] kjournald+0xcf/0x1fe                                               
 [<c0448998>] ? autoremove_wake_function+0x0/0x34                                
 [<c05412c5>] ? kjournald+0x0/0x1fe                                              
 [<c0448708>] kthread+0x6b/0x70                                                  
 [<c044869d>] ? kthread+0x0/0x70                                                 
 [<c040364b>] kernel_thread_helper+0x7/0x10                                      
BUG: sleeping function called from invalid context at fs/dcache.c:512            
in_atomic(): 0, irqs_disabled(): 0, pid: 2005, name: bash                        
INFO: lockdep is turned off.                                                     
Pid: 2005, comm: bash Tainted: GF          2.6.31-rc3-tip #15                    
Call Trace:                                                                      
 [<c042cbd1>] __might_sleep+0xda/0xdf                                            
 [<c04cae29>] __shrink_dcache_sb+0x208/0x27a                                     
 [<c04cb038>] shrink_dcache_parent+0x2c/0xcf                                     
 [<c04f8371>] proc_flush_task+0xa7/0x194                                         
 [<c0437553>] release_task+0x29/0x3b4                                            
 [<c0437fe0>] wait_consider_task+0x702/0xa91                                     
 [<c043844d>] do_wait+0xde/0x276                                                 
 [<c0430f6e>] ? default_wake_function+0x0/0x12                                   
 [<c0438672>] sys_wait4+0x8d/0xa6                                                
 [<c04a3c65>] ? might_fault+0x85/0x87                                            
 [<c04386a3>] sys_waitpid+0x18/0x1a                                              
 [<c0402ab8>] sysenter_do_call+0x12/0x36                       
...
...

> Changes in v2:
> 
>  - Call __might_sleep() directly instead of might_sleep() which
>    may call cond_resched()
> 
>  - Turn cond_resched() into a macro so that the file:line
>    couple reported refers to the caller of cond_resched() and
>    not __cond_resched() itself.
> 
> Changes in v3:
> 
>  - Also propagate this __might_sleep() pull up to
>    cond_resched_lock() and cond_resched_softirq()
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <1247725694-6082-6-git-send-email-fweisbec@gmail.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
