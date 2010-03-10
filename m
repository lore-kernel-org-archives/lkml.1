Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab0CJRm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 12:42:26 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:50338 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab0CJRmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 12:42:24 -0500
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, "x86\@kernel.org" <x86@kernel.org>,
       "linuxppc-dev\@ozlabs.org" <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] irq: move some interrupt arch_* functions into struct irq_chip.
References: <1268218524.11737.68547.camel@zakaz.uk.xensource.com>
	<1268218559-26784-2-git-send-email-ijc@hellion.org.uk>
	<86802c441003100406t70dd854fx491f0ee9a6fce62b@mail.gmail.com>
	<1268225473.11737.69196.camel@zakaz.uk.xensource.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 10 Mar 2010 09:42:08 -0800
In-Reply-To: <1268225473.11737.69196.camel@zakaz.uk.xensource.com> (Ian Campbell's message of "Wed\, 10 Mar 2010 12\:51\:13 +0000")
Message-ID: <m1iq94gjkf.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: Ian.Campbell@citrix.com, linuxppc-dev@ozlabs.org, x86@kernel.org, paulus@samba.org, benh@kernel.crashing.org, jeremy@goop.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, yinghai@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell <Ian.Campbell@citrix.com> writes:

> On Wed, 2010-03-10 at 12:06 +0000, Yinghai Lu wrote:
>> On Wed, Mar 10, 2010 at 2:55 AM,  <ijc@hellion.org.uk> wrote:
>> > From: Ian Campbell <ian.campbell@citrix.com>
>> >
>> > Move arch_init_copy_chip_data and arch_free_chip_data into function
>> > pointers in struct irq_chip since they operate on irq_desc->chip_data.
>> >
>> > arch_init_chip_data cannot be moved into struct irq_chip at this time
>> > because irq_desc->chip is not known at the time the irq_desc is
>> > setup. For now rename arch_init_chip_data to arch_init_irq_desc (for
>> > PowerPC, the only other user, whose usage better matches the new name)
>> > and on x86 convert arch_init_chip_data to ioapic_init_chip_data and
>> > call this whenever the IO APIC code allocates a new IRQ.
>> >
>> > I've retained the chip_data behaviour for uv_irq although it isn't
>> > clear to me if these interrupt types support migration or how closely
>> > related to the APIC modes they really are. If it weren't for this the
>> > ioapic_{init,copy,free}_chip_data functions could be static to
>> > io_apic.c.
>> >
>> > I've tested by booting on a 64 bit system, but it's not clear to me
>> > what actions I need to take to actually exercise some of these code
>> > paths.
>> >
>> 
>> can you just add another pointer field in irq_desc?
>> 
>> some kind of *irq_info etc.
>
> I think I don't understand what you are suggesting.

YH another field doesn't make much sense.  Xen is a bizarre subarch
with an incompatible irq model.  Xen simply needs the ability to
handle the entire lifetime of an irq_chip.

All we need between the Xen and the rest of x86 is a convention
so that we never manage the same irqs.   At least for domU we are
in an either/or situation so I don't see even that being a problem.

> There is already a pointer for irq_chip specific use i.e.
> irq_desc->chip_data. This patchset is just about ensuring that the field
> really is available to any chip implementation rather than just assuming
> it is always used for the acpi chip types (on x86 at least).

Ian Xen in this sense is simply not x86.  irq_cfg is not acpi or ioapic
or anything but x86 specific.  It has everything to do with having a per
cpu vector table of 256 entries and architecturally receiving a vector
number when an interrupt is fired.

It totally makes sense for Xen to do something different because
architecturally it has a completely different irq subsystem.

At the same time let's not pretend that the reason for this is anything
except that Xen has a completely different notion of interrupt delivery
than the rest of x86 and so it is it's own bizarre subarch.

This is not a case where you simply need a driver because something is
a bit different but fits into the existing model.

So the best solution here seems to be a parameter that we pass into
irq_to_desc_alloc_node that does what is needed.  The second best
would be to have arch_init_chip_data to call something like
platfrom_init_chip_data().    But I think we can avoid that in
this case.

Eric

