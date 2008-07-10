Return-Path: <linux-kernel-owner+w=401wt.eu-S1756444AbYGJDPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444AbYGJDPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 23:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbYGJDPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 23:15:03 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:37852 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753598AbYGJDPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 23:15:01 -0400
To: linux-kernel@vger.kernel.org
Subject: Mysterious high wakeups-from-idle per second
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1KGmcV-0003Z0-4z@closure.thunk.org>
Date: Wed, 09 Jul 2008 23:14:59 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm not sure when this started happening, as I haven't needed to run on
battery a lot, but I recently noticed (using a 2.6.26-rc9 kernel) that my
power utilization is 2-3 watts on my laptop higher than normal.  Running
powertop I see:

     PowerTOP version 1.11      (C) 2007 Intel Corporation

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        (20.8%)         1.61 Ghz     1.5%
C0                0.0ms ( 0.0%)         1.60 Ghz     0.0%
C1 mwait          0.0ms ( 0.0%)         1200 Mhz     0.0%
C2 mwait          0.0ms ( 0.0%)          800 Mhz    98.5%
C4 mwait          0.2ms (79.2%)

Wakeups-from-idle per second : 3269.9   interval: 10.0s
Power usage (ACPI estimate): 13.2W (4.1 hours)

Top causes for wakeups:
  41.5% ( 20.5)           firefox : futex_wait (hrtimer_wakeup) 
  15.6% (  7.7)       <interrupt> : extra timer interrupt
  13.0% (  6.4)      <kernel IPI> : Rescheduling interrupts
   6.7% (  3.3)       <interrupt> : acpi
   3.2% (  1.6)    gnome-terminal : schedule_timeout (process_timeout)
   2.2% (  1.1)       <interrupt> : eth0
   2.2% (  1.1)              Xorg : schedule_timeout (process_timeout)
   2.0% (  1.0)              ntpd : do_setitimer (it_real_fn)
   2.0% (  1.0)    cpufreq-applet : schedule_timeout (process_timeout)
   2.0% (  1.0)         nm-applet : schedule_timeout (process_timeout)
   2.0% (  1.0)            dhcdbd : schedule_timeout (process_timeout)
   1.0% (  0.5)             cupsd : schedule_timeout (process_timeout)
   1.0% (  0.5)          trackerd : e1000_intr_msi (e1000_watchdog)
   1.0% (  0.5)        uml_switch : do_setitimer (it_real_fn)
   0.6% (  0.3)   gnome-power-man : schedule_timeout (process_timeout)
   0.6% (  0.3)     <kernel core> : neigh_table_init_no_netlink (neigh_periodic_
   0.6% (  0.3)       gnome-panel : schedule_timeout (process_timeout)
   0.4% (  0.2)          events/0 : __netdev_watchdog_up (dev_watchdog)
   0.4% (  0.2)          nautilus : schedule_timeout (process_timeout)
   0.4% (  0.2)       gvfsd-trash : futex_wait (hrtimer_wakeup)
   0.4% (  0.2)   update-notifier : schedule_timeout (process_timeout)
   0.2% (  0.1)              ntpd : do_adjtimex (sync_cmos_clock)
   0.2% (  0.1)              mutt : schedule_timeout (process_timeout)
   0.2% (  0.1)     <kernel core> : neigh_add_timer (neigh_timer_handler)
   0.2% (  0.1)              hald : schedule_timeout (process_timeout)
   0.2% (  0.1)     <kernel core> : inet_twsk_schedule (inet_twdr_hangman)

See the wakeups-from-idle per second.  Sometimes it is high as 10,000.
With the AC mains plugged back in:

     PowerTOP version 1.11      (C) 2007 Intel Corporation

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        (52.1%)         1.61 Ghz    13.0%
C0                0.0ms ( 0.0%)         1.60 Ghz     0.0%
C1 mwait          0.0ms ( 0.0%)         1200 Mhz     0.0%
C2 mwait          0.0ms ( 0.0%)          800 Mhz    87.0%
C3 mwait          0.0ms (47.9%)

Wakeups-from-idle per second : 11005.6  interval: 10.0s
Power usage (5 minute ACPI estimate) :   3.2 W (16.9 hours left)

Top causes for wakeups:
  29.3% ( 36.7)       <interrupt> : PS/2 keyboard/mouse/touchpad 
  24.0% ( 30.1)      <kernel IPI> : Rescheduling interrupts 
  23.7% ( 29.7)           firefox : futex_wait (hrtimer_wakeup) 
  13.1% ( 16.4)       <interrupt> : extra timer interrupt 
   1.0% (  1.2)              Xorg : schedule_timeout (process_timeout)
   0.9% (  1.1)       <interrupt> : eth0
   0.8% (  1.0)         nm-applet : schedule_timeout (process_timeout)
   0.8% (  1.0)              ntpd : do_setitimer (it_real_fn)
   0.8% (  1.0)            dhcdbd : schedule_timeout (process_timeout)
   0.8% (  1.0)    cpufreq-applet : schedule_timeout (process_timeout)
   0.6% (  0.7)    gnome-terminal : schedule_timeout (process_timeout)
   0.4% (  0.5)          trackerd : e1000_intr_msi (e1000_watchdog)
   0.4% (  0.5)     <kernel core> : __enqueue_rt_entity (sched_rt_period_timer)
   0.4% (  0.5)        uml_switch : do_setitimer (it_real_fn)
   0.3% (  0.4)              Xorg : do_setitimer (it_real_fn)
   0.3% (  0.4)             emacs : schedule_timeout (process_timeout)
   0.2% (  0.3)     <kernel core> : neigh_table_init_no_netlink (neigh_periodic_
   0.2% (  0.3)               top : schedule_timeout (process_timeout)
   0.2% (  0.3)       gnome-panel : schedule_timeout (process_timeout)
   0.2% (  0.3)   gnome-power-man : schedule_timeout (process_timeout)
   0.2% (  0.2)          events/0 : __netdev_watchdog_up (dev_watchdog)
   0.2% (  0.2)          nautilus : schedule_timeout (process_timeout)
   0.2% (  0.2)       gvfsd-trash : futex_wait (hrtimer_wakeup)
   0.2% (  0.2)   update-notifier : schedule_timeout (process_timeout)
   0.1% (  0.1)              mutt : schedule_timeout (process_timeout)
   0.1% (  0.1)          metacity : hrtick_set (hrtick)
   0.1% (  0.1)               top : hrtick_set (hrtick)
   0.1% (  0.1)          metacity : schedule_timeout (process_timeout)
   0.1% (  0.1)          events/0 : queue_delayed_work (delayed_work_timer_fn)
   0.1% (  0.1)          gconfd-2 : schedule_timeout (process_timeout)
   0.1% (  0.1)             emacs : do_setitimer (it_real_fn)


Note the C0 (cpu running) at 50%, and the 11,000 wakeups-per-idle.

However, top shows not much is running, with an almos 0 idle.

top - 23:13:30 up  1:05,  4 users,  load average: 0.06, 0.06, 0.10
Tasks: 153 total,   2 running, 146 sleeping,   5 stopped,   0 zombie
Cpu(s):  4.2%us,  2.1%sy,  0.0%ni, 93.3%id,  0.3%wa,  0.0%hi,  0.0%si,  0.0%st
Mem:   3975080k total,  1102168k used,  2872912k free,    46252k buffers
Swap:  4000176k total,        0k used,  4000176k free,   447544k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 6617 root      20   0  396m  36m 8732 R   13  0.9   3:01.99 Xorg               
 9370 tytso     20   0  346m 201m  26m S    5  5.2   9:52.76 firefox            
 9700 tytso     20   0 53632  26m  10m S    3  0.7   0:20.80 emacs              
 7764 tytso     20   0 75272  18m  10m S    3  0.5   0:18.22 gnome-terminal     
 7431 tytso     20   0 18988 9420 7676 S    2  0.2   0:17.61 metacity           
 7424 tytso     20   0 17260 2600 1728 S    1  0.1   0:16.63 gnome-screensav    
13561 root      20   0  2304 1136  844 R    1  0.0   0:00.64 top                
  166 root      15  -5     0    0    0 S    0  0.0   0:05.80 kondemand/0        
 7408 tytso     20   0 33784 9.8m 7760 S    0  0.3   0:02.09 gnome-settings-    
 7437 tytso     20   0 91436  25m  13m S    0  0.6   0:02.70 nautilus           
    1 root      20   0  2840 1688  540 S    0  0.0   0:01.55 init               
    2 root      15  -5     0    0    0 S    0  0.0   0:00.00 kthreadd           
    3 root      RT  -5     0    0    0 S    0  0.0   0:00.82 migration/0        
    4 root      15  -5     0    0    0 S    0  0.0   0:00.46 ksoftirqd/0        
    5 root      RT  -5     0    0    0 S    0  0.0   0:00.00 watchdog/0         
    6 root      RT  -5     0    0    0 S    0  0.0   0:00.03 migration/1        
    7 root      15  -5     0    0    0 S    0  0.0   0:01.18 ksoftirqd/1        
    8 root      RT  -5     0    0    0 S    0  0.0   0:00.00 watchdog/1         
    9 root      15  -5     0    0    0 S    0  0.0   0:01.48 events/0           
   10 root      15  -5     0    0    0 S    0  0.0   0:00.87 events/1           
   11 root      15  -5     0    0    0 S    0  0.0   0:00.01 khelper            
   49 root      15  -5     0    0    0 S    0  0.0   0:00.12 kblockd/0          
   50 root      15  -5     0    0    0 S    0  0.0   0:00.05 kblockd/1          
   52 root      15  -5     0    0    0 S    0  0.0   0:00.07 kacpid             
   53 root      15  -5     0    0    0 S    0  0.0   0:00.03 kacpi_notify       
  142 root      15  -5     0    0    0 S    0  0.0   0:00.00 kseriod     
....

This doesn't make any sense.  I'd say it was a bug in Powertop, except
that my power utilization does seem to be higher than normal.

I'm not seeing any large number of interrupts in /proc/interrupts, so I
don't think it is an interrupt storm.

Does anyone see any explanation?

						- Ted
