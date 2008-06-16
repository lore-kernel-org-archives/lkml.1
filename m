Return-Path: <linux-kernel-owner+w=401wt.eu-S1758673AbYFPDvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673AbYFPDvR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 23:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYFPDvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 23:51:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:60705 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbYFPDvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 23:51:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AJNPqH2hwk5HHqfpOW9DknjXEWP3qyzWCbOhgx7382jHmeaLUx+xkrw6KnwGrNC/IW
         k31gCo53y1nvaZM/j/MDZOTmlxG0xXNJTAZpgZcwUVgF+qIalKhH9IeffXDYvZipAu2s
         wMG5jJZJyMND4fw3YW9gKix5qEol4SYaICMKs=
Date: Mon, 16 Jun 2008 07:46:59 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Adrian Bunk <bunk@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug #10815] 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Message-ID: <20080616034659.GA7600@martell.zuzino.mipt.ru>
References: <20080614181212.GB26421@linux.vnet.ibm.com> <20080614194338.GA4820@martell.zuzino.mipt.ru> <20080615033001.GE26421@linux.vnet.ibm.com> <20080615162150.GA8289@martell.zuzino.mipt.ru> <20080615181710.GA17915@linux.vnet.ibm.com> <alpine.LFD.1.10.0806151323101.2949@woody.linux-foundation.org> <20080615232754.GD17915@linux.vnet.ibm.com> <alpine.LFD.1.10.0806151633290.2949@woody.linux-foundation.org> <20080616030154.GA7445@martell.zuzino.mipt.ru> <20080616033126.GF17915@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080616033126.GF17915@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2008 at 08:31:26PM -0700, Paul E. McKenney wrote:
> On Mon, Jun 16, 2008 at 07:01:54AM +0400, Alexey Dobriyan wrote:
> > On Sun, Jun 15, 2008 at 04:38:24PM -0700, Linus Torvalds wrote:
> > > On Sun, 15 Jun 2008, Paul E. McKenney wrote:
> > > >
> > > > If that is the right thing to do.  I would feel better about it if I
> > > > could reproduce the failure.
> > > 
> > > Is there some configuration thing that might make it happen for Alexey but 
> > > not for you? The only obvious one is the normal PREEMPT thing, but 
> > > PREEMPT_RCU obviously depends on that, so there must be something else.
> > > 
> > > CONFIG_SMP? CONFIG_NO_HZ? CONFIG_[RT|FAIR]_GROUP_SCHED? There's a number 
> > > of config options that change scheduling details..
> > 
> > The only way I can "fix" rcutorture here is SMP=n (not maxcpus=1!).
> 
> I am running SMP=y without seeing the problem.
> 
> > Among things tried and do not matter are NO_HZ, HIGH_RES_TIMERS, turning off
> > debugging options (one by one and in bulk), DEBUG_PER_CPU_MAPS, HZ tweaks,
> > SCHED_MC.
> > 
> > All of this doesn't help, but SMP=n does.
> 
> Attached is the compressed config file I used for a run on a POWER
> machine.  I have used similar config files for x86.  For this run, I built
> LTP, installed it, started rcutorture, ran LTP, then ended rcutorture.
> 
> The only other thing I can think of is that Alexey's machines are
> somehow managing to nest NMIs or something.  I can produce a fix for
> that, but have no way of testing it.

No NMIs here according to /proc/interrupts .

           CPU0       CPU1       
  0:         42          0   IO-APIC-edge      timer
  1:          8          0   IO-APIC-edge      i8042
  8:          1          0   IO-APIC-edge      rtc
  9:          0          0   IO-APIC-fasteoi   acpi
 16:          0          0   IO-APIC-fasteoi   ahci, uhci_hcd:usb1
 17:         35          0   IO-APIC-fasteoi   pata_jmicron, uhci_hcd:usb2
 18:          0          0   IO-APIC-fasteoi   ehci_hcd:usb3, uhci_hcd:usb6
 19:       6238          0   IO-APIC-fasteoi   ata_piix, ata_piix, uhci_hcd:usb5
 22:        278          0   IO-APIC-fasteoi   HDA Intel
 23:       2802          0   IO-APIC-fasteoi   uhci_hcd:usb4, ehci_hcd:usb7, eth1
319:       5126          0   PCI-MSI-edge      eth0
NMI:          0          0   Non-maskable interrupts
LOC:      66777      66036   Local timer interrupts
RES:       3031       3403   Rescheduling interrupts
CAL:         17         62   function call interrupts
TLB:        671        900   TLB shootdowns
TRM:          0          0   Thermal event interrupts
THR:          0          0   Threshold APIC interrupts
SPU:          0          0   Spurious interrupts
ERR:          0

