Return-Path: <linux-kernel-owner+w=401wt.eu-S1755442AbXIJCcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442AbXIJCcZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 22:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbXIJCcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 22:32:17 -0400
Received: from [218.94.60.124] ([218.94.60.124]:52902 "EHLO
	nj-server.nj.cpsecure.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753542AbXIJCcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 22:32:16 -0400
X-Greylist: delayed 1974 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Sep 2007 22:32:16 EDT
X-CSG-FAST-BLOCK: Enabled
Message-ID: <46E4A51D.2050804@nj.cpsecure.com>
Date: Mon, 10 Sep 2007 09:59:57 +0800
From: Dong_Wei <Dong_Wei@nj.cpsecure.com>
Reply-To: Dong_Wei@nj.cpsecure.com
Organization: CPsecure Inc
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: dynamically use the irqbalance
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all.
   I want to dynamically use irqbalance on X86 processor. My design is 
like the following:
   1) if we boot kernel with "noirqbalance", then irqbalance is always 
disabled.
   2) if we boot kernel without "noirqbalance", we can enable/disable 
irqbalance in runtime.

I create a proc_fs entry /proc/sys/kernel/irqbalance
This symbol I adding is in file arch/i386/kernel/io_apic.c
/proc/sys/kernel/irqbalance = 0 /* disable irqbalance in runtime */
/proc/sys/kernel/irqbalance = 1 /* enable irqbalance in runtime */

The core function is like the following:
irqbalance_irq_flag = -1; /* this is the last time irqbalance used */
irqbalance_enable = 1; /* set it to enable by default */
static int balanced_irq(void *unused)
{
     int i;
     unsigned long prev_balance_time = jiffies;
     long time_remaining = balanced_irq_interval;

     daemonize("kirqd");

     /* push everything to CPU 0 to give us a starting point.  */
     for (i = 0 ; i < NR_IRQS ; i++) {
         irq_desc[i].pending_mask = cpumask_of_cpu(0);
         set_pending_irq(i, cpumask_of_cpu(0));
     }

     for ( ; ; ) {
         time_remaining = schedule_timeout_interruptible(time_remaining);
         try_to_freeze();
         if(irqbalance_enable) {
              if (time_after(jiffies, 
prev_balance_time+balanced_irq_interval)) {
                  preempt_disable();
                  do_irq_balance();
                  prev_balance_time = jiffies;
                  time_remaining = balanced_irq_interval;
                  preempt_enable();
                  irqbalance_irq_flag = 1;
              }
          } else if (irqbalance_irq_flag != 0) {
              /* Is it SAFE to do so? */
              for (i = 0 ; i < NR_IRQS ; i++)
                  set_pending_irq(i, cpumask_of_cpu(0));
              irqbalance_irq_flag = 0;
          }
      }
      return 0;
}

When we change /proc/sys/kernel/irqbalance from 1 to 0, I move all the 
irqs to CPU#0, Is it safe to do so? or will lead to some very dangerous 
thing?

Please help me to review my design, thanks in advance.

BTW: I can't join the linux-kernel maillist, for our mail server now has 
  some problems. If anyone replies my mail. Pls CC to me.


