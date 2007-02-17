Return-Path: <linux-kernel-owner+w=401wt.eu-S2992789AbXBQWll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992789AbXBQWll (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 17:41:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992790AbXBQWll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 17:41:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:23974 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992789AbXBQWlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 17:41:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DwgdYlYtlUA+DkEfRQitRx6LykIjwoWMuNnKDzev+Gee798QwB4JYOdLziQW3J5tqYBKuIBnTnqjyIqpfoZJDhxBwJWIEv/YdSLlML4o4z91LEaljLp+Mv/YXiCVPv0V8IGDXol4luFcYh3DIu7xxWQy40CGmiLbFWfxXNOTkv4=
Message-ID: <6bffcb0e0702171441i6ac69ac0yb1c46dbf8f43dc2e@mail.gmail.com>
Date: Sat, 17 Feb 2007 23:41:38 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Alex Riesen" <fork0@users.sourceforge.net>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>
Subject: Re: 2.6.20-git13 kernel BUG at /mnt/md0/devel/linux-git/kernel/time/tick-sched.c:168
In-Reply-To: <20070217164652.GA2579@steel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45D61632.1020105@googlemail.com>
	 <1171660939.30834.102.camel@localhost.localdomain>
	 <20070217144752.GA2503@steel.home>
	 <1171725257.30834.120.camel@localhost.localdomain>
	 <20070217164652.GA2579@steel.home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/02/07, Alex Riesen <fork0@users.sourceforge.net> wrote:
> Thomas Gleixner, Sat, Feb 17, 2007 16:14:17 +0100:
> > On Sat, 2007-02-17 at 15:47 +0100, Alex Riesen wrote:
> > > > > 164             if (need_resched())
> > > > > 165                     goto end;
> > > > > 166
> > > > > 167             cpu = smp_processor_id();
> > > > > 168             BUG_ON(local_softirq_pending());
> > > >
> > > > Hmm, the BUG_ON is inside of an interrupt disabled region, so we should
> > > > have bailed out early in the need_resched() check above (because we are
> > > > in the idle task context according to the stack trace).
> > > >
> > > > Is this reproducible ?
> > >
> > > Seen this too (Ubuntu, P4/ht-SMT, SATA, typed from screen):
> >
> > Can you please apply the patch below, so we can at least see, which
> > softirq is pending. This should trigger independently of hrtimers and
> > dynticks. You can keep it compiled in and disable it at the kernel
> > commandline with "nohz=off" and / or "highres=off"
>
> It did, only one time:
>
> Idle: local softirq pending: 0020<6>USB Universal Host Controller Interface driver v3.0
>

sudo cat /var/log/messages | grep Idle
Feb 17 17:35:34 bitis-gabonica kernel: Idle: local softirq pending:
0020<6>hdd: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache,
UDMA(33)
Feb 17 19:20:01 bitis-gabonica kernel: Idle: local softirq pending:
0020<3>Idle: local softirq pending: 0020<3>Idle: local softirq
pending: 0020<7>PM: Removing info for No Bus:vcs7

cat /proc/interrupts
           CPU0       CPU1
  0:     232838          0   IO-APIC-edge      timer
  1:        401          0   IO-APIC-edge      i8042
  7:          0          0   IO-APIC-edge      parport0
  8:          1          0   IO-APIC-edge      rtc
  9:          1          0   IO-APIC-fasteoi   acpi
  12:          4          0   IO-APIC-edge      i8042
  14:        319          0   IO-APIC-edge      ide0
  15:       1612          0   IO-APIC-edge      ide1
  16:      16494          0   IO-APIC-fasteoi   uhci_hcd:usb3, libata
  17:       4670          0   IO-APIC-fasteoi   uhci_hcd:usb1, uhci_hcd:usb4
  18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb2
  19:          2          0   IO-APIC-fasteoi   ehci_hcd:usb5
  20:       2822          0   IO-APIC-fasteoi   Intel ICH5
  21:       2881          0   IO-APIC-fasteoi   eth1
  22:         58          0   IO-APIC-fasteoi   eth0
NMI:          0          0
LOC:     232562     232846
ERR:          0
MIS:          0

I can confirm that this is ICH5 SATA controller problem.

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
