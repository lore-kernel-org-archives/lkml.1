Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbXHHSBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbXHHSBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 14:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935254AbXHHSB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 14:01:28 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:59596 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765440AbXHHSB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 14:01:26 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Cc: "vgoyal@in.ibm.com" <vgoyal@in.ibm.com>, Haren Myneni <hbabu@us.ibm.com>,
       "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PATCH/RFC: [kdump] fix APIC shutdown sequence
References: <46B73955.2080007@fujitsu-siemens.com>
	<20070807142928.GA18839@in.ibm.com>
	<46B8AECA.7050908@fujitsu-siemens.com>
	<m1ir7qg7kd.fsf@ebiederm.dsl.xmission.com>
	<46B986D5.2010407@fujitsu-siemens.com>
	<m1myx2dpcc.fsf@ebiederm.dsl.xmission.com>
	<46B9FEC8.20004@fujitsu-siemens.com>
Date: Wed, 08 Aug 2007 11:56:24 -0600
In-Reply-To: <46B9FEC8.20004@fujitsu-siemens.com> (Martin Wilck's message of
	"Wed, 08 Aug 2007 19:35:04 +0200")
Message-ID: <m1myx1c3lj.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Wilck <martin.wilck@fujitsu-siemens.com> writes:

> Eric W. Biederman wrote:
>
>> Ok.  Later in the thread it sounds like you have retried this and
>> irqpoll is working now.
>
> Yes. I'd give a lot to know what went wrong when I tried that in April.
> It'd have saved me many hours of work if I had discovered this workaround
> before.

Yes that is odd.

>>>> Have you done any looking at moving where the kernel initalizes
>>>> io_apics?  One of the todo items on the path is to leave
>>>> io_apic mode enabled and just startup the kernel in io_apic
>>>> mode.
>>> I have tried to recover from the "IRR set" situation in several ways by
>>> changing setup_IO_APIC_irq(). But I haven't found a way to recover from
>>> this situation once disable_IO_APIC() had been called.
>> 
>> Yes.  The long term goal is to remove the need for calling
>> disable_IO_APIC(). Because that makes the code simpler etc.
>
> I think a lot would be gained if disable_IO_APIC() would just mask the IRQs
> (like the function in my patch does), and perhaps fix the dest ID, instead of
> totally clearing the registers.

Even masked we still won't see the EOI, because then we are in i8259
mode.  So masked versus totally cleared really should make no
difference.

> Moreover, it'd be reasonable to separate out the code that restores virtual
> wire mode from disable_IO_APIC().

Possibly.  If we were to change the order probably.

>> It is quite possible.  I have observed a lot of obscure bugs in the
>> corner cases of the state machines, although it is possible
>> this is correct behavior and it is just specific to level
>> triggered interrupts which are almost exclusively not on
>> the first ioapic in a system like you describe.
>
> Even if my patch in the form in which I submitted it is unusable,
> I think the basic idea that IRQs should be masked bottom-up
> (IO-APIC first, then local APIC, then CPU) is correct.
>
> Or is there any specific reason why the current code does it vice-versa?

I haven't looked.  My guess is that in the normal case it doesn't matter
because no irqs are alive and the kexec on panic case just copied that.

I guess right now I can see work put into cleaning things up a little
or not having to call disable_IO_APIC() at all.  that was supposed
to be a short term hack, until we fixed things properly.

So far no one has been brave enough to mess with the kernel apic
initialization order so we can remove disable_IO_APIC.  If our
goal isn't to fix things properly by removing the need for
disable_IO_APIC I don't feel like putting much effort into this
code path.

Eric
