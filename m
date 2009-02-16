Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbZBPJZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbZBPJZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 04:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbZBPJZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 04:25:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46028 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbZBPJZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 04:25:09 -0500
Date: Mon, 16 Feb 2009 10:25:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Damien Wyart <damien.wyart@free.fr>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12650] Strange load average and ksoftirqd behavior with
	2.6.29-rc2-git1
Message-ID: <20090216092503.GI6182@elte.hu>
References: <rjPbZ5GRJPO.A.1kE.ur0lJB@chimera> <20090215080941.GA2295@localhost.localdomain> <20090215090026.GA31147@elte.hu> <20090215095128.GA3234@localhost.localdomain> <20090215101351.GA23274@elte.hu> <20090215103445.GA2335@localhost.localdomain> <20090215110104.GB31351@elte.hu> <20090215180355.GA2273@localhost.localdomain> <20090215193102.GA16873@elte.hu> <20090216084223.GA2641@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216084223.GA2641@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Damien Wyart <damien.wyart@free.fr> wrote:

> > Also, could you send the output of:
> 
> >   http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
> 
> > Run it while you can see the ksoftirqd anomaly.
> 
> In fact I see it all the time when the machine is idle. When something 
> runs (spamd for example), the running time of ksoftirqd stops 
> increasing, and it goes back to increasing like crazy when idle state 
> comes back.

here's the ksoftirqd stats from your data:

top - 08:09:20 up 2 min,  1 user,  load average: 0.95, 0.35, 0.13
Tasks: 100 total,   1 running,  99 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.4%us,  1.3%sy,  0.0%ni, 89.2%id,  0.0%wa,  0.0%hi,  9.0%si,  0.0%st
Mem:   2074980k total,   236544k used,  1838436k free,     5032k buffers
Swap:  1212896k total,        0k used,  1212896k free,    66016k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND            
 2280 root      15  -5     0    0    0 S   22  0.0   0:06.39 [ksoftirqd/1]      
 2452 root      20   0  2400 1132  888 R    1  0.1   0:00.02 top -H -c -b -d 1 -
    1 root      20   0  2100  688  588 S    0  0.0   0:00.48 init [2]           
    2 root      15  -5     0    0    0 S    0  0.0   0:00.00 [kthreadd]         

ksoftirqd really seems to be active (according to scheduler stats), and 
has gathered more than 6 seconds of runtime after 2 minutes of uptime - 
that is clearly anomalous.

The main method how softirqs get generated are hardirqs, but the hardirq 
is low on your box (as expected):

-- interrupts: --
           CPU0       CPU1       
  0:        155          0   IO-APIC-edge      timer
  1:          2          0   IO-APIC-edge      i8042
  7:          0          0   IO-APIC-edge      parport0
  8:          2          0   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 12:          4          0   IO-APIC-edge      i8042
 14:          0          0   IO-APIC-edge      ata_piix
 15:        132          0   IO-APIC-edge      ata_piix
 16:        213          0   IO-APIC-fasteoi   uhci_hcd:usb2, uhci_hcd:usb5
 18:       6908          0   IO-APIC-fasteoi   ata_piix, uhci_hcd:usb4
 19:        221          0   IO-APIC-fasteoi   uhci_hcd:usb3
 20:       1072          0   IO-APIC-fasteoi   eth0
 21:          0          0   IO-APIC-fasteoi   EMU10K1
 23:          4          0   IO-APIC-fasteoi   ehci_hcd:usb1
NMI:          0          0   Non-maskable interrupts
LOC:      79306      74184   Local timer interrupts
CNT:          0          0   Performance counter interrupts
RES:      32672      13541   Rescheduling interrupts
CAL:          8         40   Function call interrupts
TLB:        235        591   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          0
MIS:          0

about 200K irqs - most of which are lapic timer irqs. Thus 6 seconds of 
ksoftirqd runtime is way too much.

	Ingo
