Return-Path: <linux-kernel-owner+w=401wt.eu-S1423123AbXD3Hkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423123AbXD3Hkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 03:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423124AbXD3Hkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 03:40:45 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423123AbXD3Hko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 03:40:44 -0400
Date: Mon, 30 Apr 2007 00:39:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Dan Kruchinin" <dubalom@gmail.com>, linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.21-rc7-mm2 suspend bug. [kernel/kthread.c]
Message-Id: <20070430003946.b4d856b4.akpm@linux-foundation.org>
In-Reply-To: <200704292227.45215.rjw@sisk.pl>
References: <a8f16e2b0704291251l69c1b02ahb9b22370bc468fa1@mail.gmail.com>
	<200704292227.45215.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2007 22:27:44 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday, 29 April 2007 21:51, Dan Kruchinin wrote:
> > Hi all.
> > 
> > There is a problem on my macbook core duo with suspend.
> > after suspending when i'm trying to 'wake up' my notebook, it seems
> > that it works, but i don't see anything at my monitor. So i have to
> > reboot it to continue my work.
> 
> What exactly do you do to suspend?
> 

This is due to _cpu_down() calling kthread_bind() in state TASK_RUNNING.

So I was sent the below, including worrisome changelog.




From: Gautham R Shenoy <ego@in.ibm.com>

We are anyway kthread_stop()ping other per-cpu kernel threads after
move_task_off_dead_cpu(), so we can do it with the stop_machine_run thread
as well.

I just checked with Vatsa if there was any subtle reason why they
had put in the kthread_bind() in cpu.c. Vatsa cannot seem to recollect
any and I can't see any. So let us just remove the kthread_bind.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |    4 ----
 1 files changed, 4 deletions(-)

diff -puN kernel/cpu.c~remvoe-kthread_bind-call-from-_cpu_down kernel/cpu.c
--- a/kernel/cpu.c~remvoe-kthread_bind-call-from-_cpu_down
+++ a/kernel/cpu.c
@@ -175,10 +175,6 @@ static int _cpu_down(unsigned int cpu)
 	/* This actually kills the CPU. */
 	__cpu_die(cpu);
 
-	/* Move it here so it can run. */
-	kthread_bind(p, get_cpu());
-	put_cpu();
-
 	/* CPU is completely dead: tell everyone.  Too late to complain. */
 	if (raw_notifier_call_chain(&cpu_chain, CPU_DEAD, hcpu) == NOTIFY_BAD)
 		BUG();
_

