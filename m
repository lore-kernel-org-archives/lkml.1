Return-Path: <linux-kernel-owner+w=401wt.eu-S1753754AbYHRUEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbYHRUEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 16:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYHRUDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 16:03:54 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48850 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbYHRUDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 16:03:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>
References: <200808160326.m7G3QR1G012726@terminus.zytor.com>
	<86802c440808152342m772d5eabs59a9c93ffe4cf557@mail.gmail.com>
	<1218898238.3940.6.camel@localhost.localdomain>
	<20080816163945.74d487e9@lxorguk.ukuu.org.uk>
	<1218903209.3940.14.camel@localhost.localdomain>
	<86802c440808161156rf48f23ai9d77ce3cab36f02a@mail.gmail.com>
	<1218918341.3940.49.camel@localhost.localdomain>
	<86802c440808161334q75a7d019ofade0b6cabf3f74d@mail.gmail.com>
	<1218919547.3940.57.camel@localhost.localdomain>
	<86802c440808161517y1eaa5a4eo817b8a1bf75945be@mail.gmail.com>
	<1218928162.3940.62.camel@localhost.localdomain>
Date: Mon, 18 Aug 2008 12:59:58 -0700
In-Reply-To: <1218928162.3940.62.camel@localhost.localdomain> (James
	Bottomley's message of "Sat, 16 Aug 2008 18:09:22 -0500")
Message-ID: <m14p5i2iwx.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;James Bottomley <James.Bottomley@HansenPartnership.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4815]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] pci: change msi-x vector to 32bit
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> On Sat, 2008-08-16 at 15:17 -0700, Yinghai Lu wrote:
>> On Sat, Aug 16, 2008 at 1:45 PM, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>> >> > What I still don't quite get is the benefit of large IRQ spaces ...
>> >> > particularly if you encode things the system doesn't really need to know
>> >> > in them.
>> >>
>> >> then set nr_irqs = nr_cpu_ids * NR_VECTORS))
>> >> and count down for msi/msi-x?
>> >
>> > No, what I mean is that msis can trip directly to CPUs, so this is an
>> > affinity thing (that MSI is directly bound to that CPU now), so in the
>> > matrixed way we display this in show_interrupts() with the CPU along the
>> > top and the IRQ down the side, it doesn't make sense to me to encode IRQ
>> > affinity in the irq number again.   So it makes more sense to assign the
>> > vectors based on both the irq number and the CPU affinity so that if the
>> > PCI MSI for qla is assigned to CPU4 you can reassign it to CPU5 and so
>> > on.
>> 
>> msi-x entry index, cpu_vector, irq number...
>> 
>> you want to different cpus have same vector?
>
> Obviously I'm not communicating very well.  Your apparent assumption is
> that irq number == vector.  

Careful.  There are two entities termed vector in this conversation.
There is the MSI-X vector which can hold up to 4096 entries per device.
There is the idt vector which has 256 entries per cpu.

> What I'm saying is that's not what we've
> done for individually vectored CPU interrupts in other architectures.
> In those we did (cpu no, irq) == vector.  i.e. the affinity and the irq
> number identify the vector.  For non-numa systems, this is effectively
> what you're interested in doing anyway.  For numa systems, it just
> becomes a sparse matrix.

I believe assign_irq_vector on x86_64 and soon on x86_32 does this already.

The number that was being changed was the irq number of for the
msi-x ``vectors'' from some random free irq number to roughly
bus(8 bits):device+function(8 bits):msix-vector(12 bits) so that we
could have a stable irq number for msi irqs.

Once pci domain is considered it is hard to claim we have enough bits.
I expect we need at least pci domains to have one per NUMA node, in
the general case.

The big motivation for killing NR_IRQS sized arrays comes from 2 directions.
msi-x which allows up to 4096 irqs per device and nic vendors starting
to produce cards with 256 queues, and from large SGI systems that don't do
I/O and want to be supported with the same kernel build as smaller systems.
A kernel built to handle 4096*32 irqs which is more or less reasonable if
the system was I/O heavy is a ridiculously sized array on smaller machines.

So a static irq_desc is out.  And since with the combination of msi-x hotplug
we can not tell how many irq sources and thus irq numbers the machine is going
to have we can not reasonably even have a dynamic array at boot time.  Further
we also want to allocate the irq_desc entries in node-local memory on NUMA
machines for better performance.  Which means we need to dynamically allocate
irq_desc entries and have some lookup mechanism from irq# to irq_desc entry.

So once we have all of that.  It becomes possible to look at assigning a static
irq number to each pci (bus:device:function:msi-x vector) pair so the system
is more reproducible.

Eric
