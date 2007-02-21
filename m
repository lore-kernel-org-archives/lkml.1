Return-Path: <linux-kernel-owner+w=401wt.eu-S1751235AbXBUMTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235AbXBUMTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 07:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751237AbXBUMTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 07:19:12 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:22775 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbXBUMTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 07:19:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=fCzQmsmy9IuIL3Ke+yP4qAasGV0t8u7qU8WUhsIdrg98+SnsSLHE1T2cieFmfHmN7sMfBez1laiMiU5RVoMt2rV81FLNFMY+Uk+fYJIbKgiQy22rEJDyuKGPeueyjt2IFOz2+hFIvk7QHgZ0Dmo/KkSo2lVgB882/gQlejE+2uI=
Message-ID: <45DC38B2.1000208@googlemail.com>
Date: Wed, 21 Feb 2007 13:18:58 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: Alex Riesen <fork0@users.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: 2.6.20-git13 kernel BUG at /mnt/md0/devel/linux-git/kernel/time/tick-sched.c:168
References: <45D61632.1020105@googlemail.com>	 <1171660939.30834.102.camel@localhost.localdomain>	 <20070217144752.GA2503@steel.home>	 <1171725257.30834.120.camel@localhost.localdomain>	 <20070217164652.GA2579@steel.home> <6bffcb0e0702171441i6ac69ac0yb1c46dbf8f43dc2e@mail.gmail.com>
In-Reply-To: <6bffcb0e0702171441i6ac69ac0yb1c46dbf8f43dc2e@mail.gmail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Piotrowski napisał(a):
> On 17/02/07, Alex Riesen <fork0@users.sourceforge.net> wrote:
>> Thomas Gleixner, Sat, Feb 17, 2007 16:14:17 +0100:
>> > On Sat, 2007-02-17 at 15:47 +0100, Alex Riesen wrote:
>> > > > > 164             if (need_resched())
>> > > > > 165                     goto end;
>> > > > > 166
>> > > > > 167             cpu = smp_processor_id();
>> > > > > 168             BUG_ON(local_softirq_pending());
>> > > >
>> > > > Hmm, the BUG_ON is inside of an interrupt disabled region, so we
>> should
>> > > > have bailed out early in the need_resched() check above (because
>> we are
>> > > > in the idle task context according to the stack trace).
>> > > >
>> > > > Is this reproducible ?
>> > >
>> > > Seen this too (Ubuntu, P4/ht-SMT, SATA, typed from screen):
>> >
>> > Can you please apply the patch below, so we can at least see, which
>> > softirq is pending. This should trigger independently of hrtimers and
>> > dynticks. You can keep it compiled in and disable it at the kernel
>> > commandline with "nohz=off" and / or "highres=off"
>>
>> It did, only one time:
>>
>> Idle: local softirq pending: 0020<6>USB Universal Host Controller
>> Interface driver v3.0
>>
> 
> sudo cat /var/log/messages | grep Idle
> Feb 17 17:35:34 bitis-gabonica kernel: Idle: local softirq pending:
> 0020<6>hdd: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache,
> UDMA(33)
> Feb 17 19:20:01 bitis-gabonica kernel: Idle: local softirq pending:
> 0020<3>Idle: local softirq pending: 0020<3>Idle: local softirq
> pending: 0020<7>PM: Removing info for No Bus:vcs7
> 
> cat /proc/interrupts
>           CPU0       CPU1
>  0:     232838          0   IO-APIC-edge      timer
>  1:        401          0   IO-APIC-edge      i8042
>  7:          0          0   IO-APIC-edge      parport0
>  8:          1          0   IO-APIC-edge      rtc
>  9:          1          0   IO-APIC-fasteoi   acpi
>  12:          4          0   IO-APIC-edge      i8042
>  14:        319          0   IO-APIC-edge      ide0
>  15:       1612          0   IO-APIC-edge      ide1
>  16:      16494          0   IO-APIC-fasteoi   uhci_hcd:usb3, libata
>  17:       4670          0   IO-APIC-fasteoi   uhci_hcd:usb1, uhci_hcd:usb4
>  18:          0          0   IO-APIC-fasteoi   uhci_hcd:usb2
>  19:          2          0   IO-APIC-fasteoi   ehci_hcd:usb5
>  20:       2822          0   IO-APIC-fasteoi   Intel ICH5
>  21:       2881          0   IO-APIC-fasteoi   eth1
>  22:         58          0   IO-APIC-fasteoi   eth0
> NMI:          0          0
> LOC:     232562     232846
> ERR:          0
> MIS:          0
> 
> I can confirm that this is ICH5 SATA controller problem.

Here is something interesting

cat /var/log/messages | tail -n 300 | grep NOHZ
Feb 20 20:09:39 bitis-gabonica kernel: NOHZ: local_softirq_pending 20
Feb 20 20:09:39 bitis-gabonica kernel: NOHZ: local_softirq_pending 20
Feb 20 21:10:01 bitis-gabonica kernel: NOHZ: local_softirq_pending 20
Feb 20 23:20:01 bitis-gabonica kernel: NOHZ: local_softirq_pending 20
Feb 21 05:10:28 bitis-gabonica kernel: NOHZ: local_softirq_pending 02
Feb 21 05:10:46 bitis-gabonica kernel: NOHZ: local_softirq_pending 02
								^^^^^^^^^

Feb 21 05:10:57 bitis-gabonica kernel: NOHZ: local_softirq_pending 20
Feb 21 05:11:48 bitis-gabonica kernel: NOHZ: local_softirq_pending 02
Feb 21 05:12:02 bitis-gabonica kernel: NOHZ: local_softirq_pending 20
Feb 21 05:12:02 bitis-gabonica kernel: NOHZ: local_softirq_pending 20
Feb 21 05:12:23 bitis-gabonica kernel: NOHZ: local_softirq_pending 02
Feb 21 05:12:29 bitis-gabonica kernel: NOHZ: local_softirq_pending 20
Feb 21 05:13:27 bitis-gabonica kernel: NOHZ: local_softirq_pending 20
Feb 21 05:13:49 bitis-gabonica kernel: NOHZ: local_softirq_pending 02
Feb 21 05:13:54 bitis-gabonica kernel: NOHZ: local_softirq_pending 20
Feb 21 05:14:48 bitis-gabonica kernel: NOHZ: local_softirq_pending 02
Feb 21 05:15:11 bitis-gabonica kernel: NOHZ: local_softirq_pending 20
Feb 21 05:15:13 bitis-gabonica kernel: NOHZ: local_softirq_pending 20
Feb 21 05:15:16 bitis-gabonica kernel: NOHZ: local_softirq_pending 02
Feb 21 05:16:18 bitis-gabonica kernel: NOHZ: local_softirq_pending 20
Feb 21 05:16:31 bitis-gabonica kernel: NOHZ: local_softirq_pending 02
Feb 21 05:17:03 bitis-gabonica kernel: NOHZ: local_softirq_pending 02
Feb 21 05:17:06 bitis-gabonica kernel: NOHZ: local_softirq_pending 20
Feb 21 05:17:09 bitis-gabonica kernel: NOHZ: local_softirq_pending 20
Feb 21 05:17:12 bitis-gabonica kernel: NOHZ: local_softirq_pending 02
Feb 21 05:17:17 bitis-gabonica kernel: NOHZ: local_softirq_pending 20
Feb 21 05:17:18 bitis-gabonica kernel: NOHZ: local_softirq_pending 02
       ^^^^^^^^
23 times in 7 minutes.


Regards,
Michal

--
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
