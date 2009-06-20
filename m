Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbZFTFlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbZFTFlH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 01:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbZFTFkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 01:40:55 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58442 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZFTFky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 01:40:54 -0400
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Jan Beulich <JBeulich@novell.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Len Brown <lenb@kernel.org>,
       "the arch\/x86 maintainers" <x86@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs  justbecause there's no local APIC
References: <4A329CF8.4050502@goop.org>
	<alpine.LFD.2.00.0906181206190.4213@localhost.localdomain>
	<4A3A9220.4070807@goop.org> <m1zlc5jqac.fsf@fess.ebiederm.org>
	<4A3A99FB.7070807@goop.org> <m1vdmtgtt2.fsf@fess.ebiederm.org>
	<4A3AC0C4.6060508@goop.org>
	<86802c440906182232r31088e4fh3613a8da6f8903f7@mail.gmail.com>
	<4A3B5FCD0200007800006AC0@vpn.id2.novell.com>
	<m1my84bpuq.fsf@fess.ebiederm.org>
	<86802c440906192058v78746acft161d74720c01a6a7@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 19 Jun 2009 22:40:44 -0700
In-Reply-To: <86802c440906192058v78746acft161d74720c01a6a7@mail.gmail.com> (Yinghai Lu's message of "Fri\, 19 Jun 2009 20\:58\:24 -0700")
Message-ID: <m1bpojv4wz.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: yhlu.kernel@gmail.com, hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@redhat.com, xen-devel@lists.xensource.com, tglx@linutronix.de, x86@kernel.org, lenb@kernel.org, jeremy@goop.org, JBeulich@novell.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <yhlu.kernel@gmail.com> writes:

> On Fri, Jun 19, 2009 at 1:16 AM, Eric W. Biederman<ebiederm@xmission.com> wrote:
>> "Jan Beulich" <JBeulich@novell.com> writes:
>>
>>>>>> Yinghai Lu <yhlu.kernel@gmail.com> 19.06.09 07:32 >>>
>>>>doesn't XEN support per cpu irq vector?
>>>
>>> No.
>>>
>>>>got sth from XEN 3.3 / SLES 11
>>>>
>>>>igb 0000:81:00.0: PCI INT A -> GSI 95 (level, low) -> IRQ 95
>>>>igb 0000:81:00.0: setting latency timer to 64
>>>>igb 0000:81:00.0: Intel(R) Gigabit Ethernet Network Connection
>>>>igb 0000:81:00.0: eth9: (PCIe:2.5Gb/s:Width x4) 00:21:28:3a:d8:0e
>>>>igb 0000:81:00.0: eth9: PBA No: ffffff-0ff
>>>>igb 0000:81:00.0: Using MSI-X interrupts. 4 rx queue(s), 4 tx queue(s)
>>>>vendor=8086 device=3420
>>>>(XEN) irq.c:847: dom0: invalid pirq 94 or vector -28
>>>>igb 0000:81:00.1: PCI INT B -> GSI 94 (level, low) -> IRQ 94
>>>>igb 0000:81:00.1: setting latency timer to 64
>>>>(XEN) physdev.c:87: dom0: map irq with wrong vector -28
>>>>map irq failed
>>>>(XEN) physdev.c:87: dom0: map irq with wrong vector -28
>>>>map irq failed
>>>>
>>>>the system need a lot of MSI-X normally.. with current mainline tree
>>>>kernel, it will need about 360 irq...
>>>
>>> Do you mean 360 connected devices, or just 360 IO-APIC pins (most of
>>> which are usually unused)? In the latter case, devices using MSI (i.e. not
>>> using high numbered IO-APIC pins) should work, while devices connected
>>> to IO-APIC pins numbered 256 and higher won't work in SLE11 as-is.
>>> This limitation got fixed recently in the 3.5-unstable tree, though. The
>>> 256 active vectors limit, however, continues to exist, so the former case
>>> would still not be supported by Xen.
>
> 5 io-apic controllers, so total pins like 5x24
>
>>
>> Good question.  I know YH had a system a few years ago that exceeded 256 vectors.
> that was in SimNow.
>
> This time is real.
> think about system: 24 pcie cards and every one has two functions. and
> one function will use 16 or 20 MSIX
> like 24 * 2 * 16

I'm not too surprised.  I saw the writing on the wall when I implement
per irq vector, and MSIX was one the likely candidates.

I'm curious what kind of pcie card do you have plugged in?  Looks like
you have a irq or two per cpu.

Eric
