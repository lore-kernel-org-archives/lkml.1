Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbZI1S5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbZI1S5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 14:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZI1S5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 14:57:06 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:60120 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbZI1S5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 14:57:04 -0400
Subject: Re: [tip:timers/urgent] clocksource: Resume clocksource without
 taking the clocksource mutex
From: john stultz <johnstul@us.ibm.com>
To: mschmidt@redhat.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       tglx@linutronix.de, xtfeng@gmail.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-89133f93508137231251543d1732da638e6022e1@git.kernel.org>
References: <20090924172952.49697825@mschwide.boeblingen.de.ibm.com>
	 <tip-89133f93508137231251543d1732da638e6022e1@git.kernel.org>
Content-Type: text/plain
Date: Mon, 28 Sep 2009 11:55:14 -0700
Message-Id: <1254164114.7977.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-25 at 06:20 +0000, tip-bot for Martin Schwidefsky wrote:
> Commit-ID:  89133f93508137231251543d1732da638e6022e1
> Gitweb:     http://git.kernel.org/tip/89133f93508137231251543d1732da638e6022e1
> Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
> AuthorDate: Thu, 24 Sep 2009 17:29:52 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 24 Sep 2009 22:37:53 +0200
> 
> clocksource: Resume clocksource without taking the clocksource mutex
> 
> git commit 75c5158f70c065b9 converted the clocksource spinlock to a
> mutex. This causes the following BUG:
> 
> BUG: sleeping function called from invalid context at
> kernel/mutex.c:280 in_atomic(): 0, irqs_disabled(): 1, pid: 2473,
> name: pm-suspend 2 locks held by pm-suspend/2473:
>  #0:  (&buffer->mutex){......}, at: [<ffffffff8115ab13>]
> sysfs_write_file+0x3c/0x137
>  #1:  (pm_mutex){......}, at: [<ffffffff810865b5>]
> enter_state+0x39/0x130 Pid: 2473, comm: pm-suspend Not tainted 2.6.31
> #1 Call Trace:
>  [<ffffffff810792f0>] ? __debug_show_held_locks+0x22/0x24
>  [<ffffffff8104a2ef>] __might_sleep+0x107/0x10b
>  [<ffffffff8141fca9>] mutex_lock_nested+0x25/0x43
>  [<ffffffff81073537>] clocksource_resume+0x1c/0x60
>  [<ffffffff81072902>] timekeeping_resume+0x1e/0x1c8
>  [<ffffffff812aee62>] __sysdev_resume+0x25/0xcf
>  [<ffffffff812aef79>] sysdev_resume+0x6d/0xae
>  [<ffffffff810864f8>] suspend_devices_and_enter+0x12b/0x1af
>  [<ffffffff8108665b>] enter_state+0xdf/0x130
>  [<ffffffff81085dc3>] state_store+0xb6/0xd3
>  [<ffffffff81204c73>] kobj_attr_store+0x17/0x19
>  [<ffffffff8115abd2>] sysfs_write_file+0xfb/0x137
>  [<ffffffff811057d2>] vfs_write+0xae/0x10b
>  [<ffffffff81208392>] ? __up_read+0x1a/0x7f
>  [<ffffffff811058ef>] sys_write+0x4a/0x6e
>  [<ffffffff81011b82>] system_call_fastpath+0x16/0x1b
> 
> clocksource_resume is called early in the resume process, there is
> only one cpu, no processes are running and the interrupts are
> disabled. It is therefore possible to resume the clocksources
> without taking the clocksource mutex.

Should a comment to this effect be included in the code?

thanks
-john



> Reported-by: Xiaotian Feng <xtfeng@gmail.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Tested-by: Michal Schmidt <mschmidt@redhat.com>
> Cc: Xiaotian Feng <xtfeng@gmail.com>
> Cc: John Stultz <johnstul@us.ibm.com>
> LKML-Reference: <20090924172952.49697825@mschwide.boeblingen.de.ibm.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  kernel/time/clocksource.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index 0911334..5e18c6a 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -394,15 +394,11 @@ void clocksource_resume(void)
>  {
>  	struct clocksource *cs;
> 
> -	mutex_lock(&clocksource_mutex);
> -
>  	list_for_each_entry(cs, &clocksource_list, list)
>  		if (cs->resume)
>  			cs->resume();
> 
>  	clocksource_resume_watchdog();
> -
> -	mutex_unlock(&clocksource_mutex);
>  }
> 
>  /**

