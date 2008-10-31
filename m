Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbYJaJmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbYJaJmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 05:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbYJaJmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 05:42:06 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:34975 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbYJaJmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 05:42:04 -0400
Subject: Re: nohz regression with upstream git
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20081031020030.GA4506@linux-os.sc.intel.com>
References: <20081031020030.GA4506@linux-os.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 31 Oct 2008 10:43:28 +0100
Message-Id: <1225446208.30838.4.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tor, 30 10 2008 kl. 19:00 -0700, skrev Venki Pallipadi:
> Thomas,
> 
> I am seeing a nohz regression on one of my dual core mobile test boxes.
> With 2.6.27 tickless idle works fine.
> With latest git, I see ~2000 interrupts per second (HZ=1000), even when idle.
> 
> git bisect points towards
> 
> commit fb02fbc14d17837b4b7b02dbb36142c16a7bf208
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Fri Oct 17 10:01:23 2008 +0200
> 
>     NOHZ: restart tick device from irq_enter()
> 
> 
> And good powertop data
> 
> PowerTOP 1.10    (C) 2007, 2008 Intel Corporation 
> 
> Collecting data for 15 seconds 
> 
> 
> Cn	          Avg residency
> C0 (cpu running)        ( 0.1%)
> polling		  0.0ms ( 0.0%)
> C1		  0.0ms ( 0.0%)
> C3		 18.6ms (99.9%)
> P-states (frequencies)
>   2.21 Ghz     0.0%
>   2.21 Ghz     0.0%
>   1.60 Ghz     0.0%
>    800 Mhz   100.0%
> Wakeups-from-idle per second : 53.9	interval: 15.0s
> no ACPI power usage estimate available
> Top causes for wakeups:
>   65.5% ( 32.6)       <interrupt> : extra timer interrupt 
>   16.7% (  8.3)      <kernel IPI> : Rescheduling interrupts 
>    3.3% (  1.7)            kacpid : schedule_timeout (process_timeout) 
>    2.8% (  1.4)       <interrupt> : ata_piix, uhci_hcd:usb4 
>    2.3% (  1.1)       <interrupt> : eth1 
>    2.0% (  1.0)     <kernel core> : enqueue_task_rt (sched_rt_period_timer) 
>    1.9% (  0.9)     <kernel core> : schedule_delayed_work_on (delayed_work_timer_fn) 
>    1.1% (  0.5)     <kernel core> : neigh_table_init_no_netlink (neigh_periodic_timer) 
>    1.1% (  0.5)     <kernel core> : e1000_intr_msi (e1000_watchdog) 
>    0.7% (  0.3)      <kernel IPI> : Function call interrupts 
>    0.4% (  0.2)          events/1 : __netdev_watchdog_up (dev_watchdog) 
>    0.4% (  0.2)          sendmail : schedule_timeout (process_timeout) 
>    0.4% (  0.2)     <kernel core> : page_writeback_init (wb_timer_fn) 
>    0.3% (  0.1)        kerneloops : schedule_timeout (process_timeout) 
>    0.3% (  0.1)        kerneloops : do_nanosleep (hrtimer_wakeup) 
>    0.1% (  0.1)              sshd : sk_reset_timer (tcp_write_timer) 
>    0.1% (  0.1)          events/1 : queue_delayed_work (delayed_work_timer_fn) 
>    0.1% (  0.1)             mount : start_this_handle (commit_timeout) 
>    0.1% (  0.1)     <kernel core> : queue_delayed_work (delayed_work_timer_fn) 
>    0.1% (  0.1)   hald-addon-stor : schedule_timeout (process_timeout) 
>    0.1% (  0.1)     <kernel core> : neigh_add_timer (neigh_timer_handler) 
>    0.1% (  0.1)     <kernel core> : sk_reset_timer (tcp_delack_timer) 
> 
> 
> 
> and bad powertop data
> 
> 
> PowerTOP 1.10    (C) 2007, 2008 Intel Corporation 
> 
> Collecting data for 15 seconds 
> 
> 
> Cn	          Avg residency
> C0 (cpu running)        ( 5.6%)
> polling		  0.0ms ( 0.0%)
> C1		  1.2ms ( 0.0%)
> C3		  0.5ms (94.4%)
> P-states (frequencies)
>   2.21 Ghz     0.0%
>   2.21 Ghz     0.0%
>   1.60 Ghz     0.0%
>    800 Mhz   100.0%
> Wakeups-from-idle per second : 1919.6	interval: 15.0s
> no ACPI power usage estimate available
> Top causes for wakeups:
>   99.0% (1902.4)       <interrupt> : extra timer interrupt 
>    0.3% (  6.1)      <kernel IPI> : Rescheduling interrupts 
>    0.3% (  5.6)       <interrupt> : acpi 
>    0.1% (  1.4)       <interrupt> : ata_piix, uhci_hcd:usb4 
>    0.1% (  1.1)       <interrupt> : ata_piix, ehci_hcd:usb1, uhci_hcd:usb6 
>    0.1% (  1.1)       <interrupt> : eth1 
>    0.1% (  1.0)     <kernel core> : enqueue_task_rt (sched_rt_period_timer) 
>    0.0% (  0.9)     <kernel core> : schedule_delayed_work_on (delayed_work_timer_fn) 
>    0.0% (  0.5)    NetworkManager : e1000_intr_msi (e1000_watchdog) 
>    0.0% (  0.5)     <kernel core> : neigh_table_init_no_netlink (neigh_periodic_timer) 
>    0.0% (  0.2)     <kernel core> : page_writeback_init (wb_timer_fn) 
>    0.0% (  0.2)          events/1 : __netdev_watchdog_up (dev_watchdog) 
>    0.0% (  0.2)          sendmail : schedule_timeout (process_timeout) 
>    0.0% (  0.1)        kerneloops : schedule_timeout (process_timeout) 
>    0.0% (  0.1)          events/0 : sk_reset_timer (tcp_delack_timer) 
>    0.0% (  0.1)              sshd : sk_reset_timer (tcp_write_timer) 
>    0.0% (  0.1)          events/0 : neigh_add_timer (neigh_timer_handler) 
>    0.0% (  0.1)          rsyslogd : schedule_timeout (process_timeout) 
>    0.0% (  0.1)           rpcbind : schedule_timeout (process_timeout) 
>    0.0% (  0.1)             mount : start_this_handle (commit_timeout) 
>    0.0% (  0.1)              hald : schedule_timeout (process_timeout) 
>    0.0% (  0.1)             crond : do_nanosleep (hrtimer_wakeup) 
>    0.0% (  0.1)     <kernel core> : queue_delayed_work (delayed_work_timer_fn) 
>    0.0% (  0.1)   hald-addon-stor : schedule_timeout (process_timeout) 
> 
> 
> Not sure what is so specific about this platform that causes this problem.
> Its a regular Centrino 2 development box.
> 
> I will poke more at this tomorrow. But, wanted to pass the info on to you
> before calling it a night.
> 
> Let me know if you need any more info on this.

Theodore Tso hit the same commit and found that reverting it solved his
problem. See "[REGRESSION 2.6.28-rc2-git3] lots of extra timer
interrupts costing 2W" (http://lkml.org/lkml/2008/10/30/602).


Simon Holm Thøgersen

