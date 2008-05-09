Return-Path: <linux-kernel-owner+w=401wt.eu-S1761091AbYEIPY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761091AbYEIPY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 11:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbYEIPYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 11:24:49 -0400
Received: from web32608.mail.mud.yahoo.com ([68.142.207.235]:43508 "HELO
	web32608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752673AbYEIPYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 11:24:46 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 May 2008 11:24:46 EDT
X-YMail-OSG: beHdaBQVM1lq8MyYx22e3KXzSzSdlxlOyXD7pdEoIA0uQrAHPaSqt1i8M_Spl1DIEQA05RXShsdDLXDiaemKKDC3ElNDg2lVOBULx_g_.6s.rRrZI3ybYkFwt2LSu6_7e0eLFuf7kjLgcdDYJ7rTf6NgcyUfpdUxZHn0JWc-
X-Mailer: YahooMailRC/975.23 YahooMailWebService/0.7.185
Date: Fri, 9 May 2008 08:18:05 -0700 (PDT)
From: Martin Knoblauch <knobi@knobisoft.de>
Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from 2.6.24)
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       linux-kernel@vger.kernel.org, hmh@hmh.eng.br
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <202865.14949.qm@web32608.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----

> From: Martin Knoblauch <spamtrap@knobisoft.de>
> To: Thomas Gleixner <tglx@linutronix.de>
> Cc: Gabriel C <nix.or.die@googlemail.com>; Bart Van Assche <bart.vanassche@gmail.com>; linux-kernel@vger.kernel.org; hmh@hmh.eng.br
> Sent: Friday, May 9, 2008 3:01:10 PM
> Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from 2.6.24)
> 
> ----- Original Message ----
> 
> > From: Thomas Gleixner 
> > To: Martin Knoblauch 
> > Cc: Gabriel C ; Bart Van Assche 
> ; linux-kernel@vger.kernel.org; hmh@hmh.eng.br
> > Sent: Thursday, May 8, 2008 4:13:55 PM
> > Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from 
> 2.6.24)
> > 
> > On Thu, 8 May 2008, Martin Knoblauch wrote:
> > > on two different systems running 2.6.25.2:
> > > 
> > > ibm x3650(2xDualCore)
> > > -------------------------------------
> > > [root@lpsdm60 ~]# cat 
> > /sys/devices/system/clocksource/clocksource0/available_clocksource
> > > tsc hpet acpi_pm jiffies
> > > [root@lpsdm60 ~]# cat 
> > /sys/devices/system/clocksource/clocksource0/current_clocksource
> > > tsc
> > > 
> > > HP Proliant DL-380G4 (2xSingleCore)
> > > ------------------------------------------------------------
> > > [root@lpsdm52 ~]# cat 
> > /sys/devices/system/clocksource/clocksource0/available_clocksource
> > > tsc hpet acpi_pm jiffies
> > > [root@lpsdm52 ~]# cat 
> > /sys/devices/system/clocksource/clocksource0/current_clocksource
> > > tsc
> > > 
> > > and on the DL380G4 running 2.6.24:
> > > ---------------------------------------------------------
> > > [root@lpsdm52 ~]# cat 
> > /sys/devices/system/clocksource/clocksource0/available_clocksource
> > > hpet acpi_pm jiffies tsc
> > > [root@lpsdm52 ~]# cat 
> > /sys/devices/system/clocksource/clocksource0/current_clocksource
> > > hpet
> > 
> > So on 2.6.24 the TSC is declared unstable at some point and 2.6.25
> > thinks it works fine. Is this the same kernel config (aside of the 24/25 fuzz) 
> ?
> > 
> > Thanks,
> >     tglx
> 
> hah. I love open source :-)
> 
> Between 2.6.24 and 2.6.25 there was some patching in "kernel/printk.c". 
> Especially this is interesting:
> 
> 
> @@ -680,7 +742,7 @@
>                                         loglev_char = default_message_loglevel
>                                                 + '0';
>                                 }
> -                               t = printk_clock();
> +                               t = cpu_clock(printk_cpu);
>                                 nanosec_rem = do_div(t, 1000000000);
>                                 tlen = sprintf(tbuf,
>                                                 "<%c>[%5lu.%06lu] ",
> 
> 
> Where "prink_clock()" basically translates into "sched_clock()" in 2.6.24. If I 
> change the 2.6.25 version to directly call "sched_clock()", the timestamps are 
> back to the expected values and are no longer jumping back and forth. So, 
> something in "cpu_clock()" is fishy.
> 

 so, I added the "/printk_cpu#" to the printk timestamp. It seems that the jumping is depends on which CPU is used in the call to cpu_clock(). They seem to run at different speeds.

[    0.000000/0] TSC calibrated against PM_TIMER
[    0.000003/0] time.c: Detected 2327.507 MHz processor.
[    0.002112/0] Console: colour VGA+ 80x25
[    0.002119/0] console [tty0] enabled
[    0.002147/0] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.002148/0] ... MAX_LOCKDEP_SUBCLASSES:    8
[    0.002149/0] ... MAX_LOCK_DEPTH:          48
[    0.002151/0] ... MAX_LOCKDEP_KEYS:        2048
[    0.002152/0] ... CLASSHASH_SIZE:           1024
[    0.002153/0] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.002154/0] ... MAX_LOCKDEP_CHAINS:      16384
[    0.002156/0] ... CHAINHASH_SIZE:          8192
[    0.002157/0]  memory used by lock dependency info: 1712 kB
[    0.002158/0]  per task-struct memory footprint: 3456 bytes
[    0.002161/0] Checking aperture...
[    0.002170/0] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.004000/0] Placing software IO TLB between 0x15093000 - 0x19093000
[    0.004000/0] Memory: 8110260k/9437184k available (2945k kernel code, 277728k reserved, 1568k data, 796k init)
[    0.004000/0] CPA: page pool initialized 1 of 1 pages preallocated
[    0.004000/0] hpet clockevent registered
[    0.080008/0] Calibrating delay using timer specific routine.. 4660.35 BogoMIPS (lpj=9320712)
[    0.080104/0] Security Framework initialized
[    0.080110/0] SELinux:  Initializing.
[    0.080150/0] SELinux:  Starting in permissive mode
[    0.080157/0] selinux_register_security:  Registering secondary module capability
[    0.080159/0] Capability LSM initialized as secondary
[    0.080904/0] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.085951/0] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.088684/0] Mount-cache hash table entries: 256
[    0.089128/0] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.089130/0] CPU: L2 cache: 4096K
[    0.089133/0] CPU 0/0 -> Node 0
[    0.089135/0] CPU: Physical Processor ID: 0
[    0.089136/0] CPU: Processor Core ID: 0
[    0.089142/0] CPU0: Thermal monitoring enabled (TM2)
[    0.089144/0] using mwait in idle threads.
[    0.089152/0] Freeing SMP alternatives: 22k freed
[    0.089171/0] ACPI: Core revision 20070126
[    0.135354/0] Using local APIC timer interrupts.
[    0.136010/0] APIC timer calibration result 20781297
[    0.136012/0] Detected 20.781 MHz APIC timer.
[    0.136435/0] lockdep: fixing up alternatives.
[    0.136478/0] Booting processor 1/4 APIC 0x1
[    0.004000/1] Initializing CPU#1
[    0.004000/1] Calibrating delay using timer specific routine.. 4655.08 BogoMIPS (lpj=9310168)
[    0.004000/1] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000/1] CPU: L2 cache: 4096K
[    0.004000/1] CPU 1/1 -> Node 0
[    0.004000/1] CPU: Physical Processor ID: 0
[    0.004000/1] CPU: Processor Core ID: 1
[    0.004000/1] CPU1: Thermal monitoring enabled (TM2)
[    0.004000/1] Intel(R) Xeon(R) CPU            5140  @ 2.33GHz stepping 06
[    0.224558/0] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.228357/0] lockdep: fixing up alternatives.
[    0.228392/0] Booting processor 2/4 APIC 0x6
[    0.004000/2] Initializing CPU#2
[    0.004000/2] Calibrating delay using timer specific routine.. 4655.12 BogoMIPS (lpj=9310252)
[    0.004000/2] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000/2] CPU: L2 cache: 4096K
[    0.004000/2] CPU 2/6 -> Node 0
[    0.004000/2] CPU: Physical Processor ID: 3
[    0.004000/2] CPU: Processor Core ID: 0
[    0.004000/2] CPU2: Thermal monitoring enabled (TM2)
[    0.004000/2] Intel(R) Xeon(R) CPU            5140  @ 2.33GHz stepping 06
[    0.316632/0] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.320292/0] lockdep: fixing up alternatives.
[    0.320325/0] Booting processor 3/4 APIC 0x7
[    0.004000/3] Initializing CPU#3
[    0.004000/3] Calibrating delay using timer specific routine.. 4655.13 BogoMIPS (lpj=9310270)
[    0.004000/3] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000/3] CPU: L2 cache: 4096K
[    0.004000/3] CPU 3/7 -> Node 0
[    0.004000/3] CPU: Physical Processor ID: 3
[    0.004000/3] CPU: Processor Core ID: 1
[    0.004000/3] CPU3: Thermal monitoring enabled (TM2)
[    0.004000/3] Intel(R) Xeon(R) CPU            5140  @ 2.33GHz stepping 06
[    0.408625/0] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.412054/0] Brought up 4 CPUs
[    0.412168/0] CPU0 attaching sched-domain:
[    0.412170/0]  domain 0: span 03
[    0.412172/0]   groups: 01 02
[    0.412175/0]   domain 1: span 0f
[    0.412176/0]    groups: 03 0c
[    0.412179/0]    domain 2: span 0f
