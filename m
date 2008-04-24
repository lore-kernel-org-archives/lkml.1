Return-Path: <linux-kernel-owner+w=401wt.eu-S1760052AbYDXQtX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052AbYDXQtX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:49:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYDXQtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:49:08 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43403 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758295AbYDXQtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:49:06 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Rene Herman <rene.herman@keyaccess.nl>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <alpine.LFD.1.10.0804240847230.2779@woody.linux-foundation.org>
	(Linus Torvalds's message of "Thu, 24 Apr 2008 08:55:23 -0700 (PDT)")
References: <20080422221733.GA16260@havoc.gtf.org>
	<alpine.LFD.1.10.0804221518520.2779@woody.linux-foundation.org>
	<480E6DE5.6010103@garzik.org>
	<alpine.LFD.1.10.0804221616280.2779@woody.linux-foundation.org>
	<480E796E.4070001@garzik.org>
	<alpine.LFD.1.10.0804221651400.2779@woody.linux-foundation.org>
	<20080423000529.GG28933@cs181133002.pp.htv.fi>
	<alpine.LFD.1.10.0804221714380.2779@woody.linux-foundation.org>
	<480F3ECC.1090809@keyaccess.nl> <480FEC1B.6040102@garzik.org>
	<alpine.LFD.1.10.0804231914270.2779@woody.linux-foundation.org>
	<m1od7zkd2s.fsf@frodo.ebiederm.org> <481066C1.1030805@garzik.org>
	<alpine.LFD.1.10.0804240806500.2779@woody.linux-foundation.org>
	<4810A9E6.1080201@garzik.org>
	<alpine.LFD.1.10.0804240847230.2779@woody.linux-foundation.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
Date: Thu, 24 Apr 2008 09:48:45 -0700
Message-ID: <m1r6cvgpw2.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [git patch] free_irq() fixes
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, 24 Apr 2008, Jeff Garzik wrote:
>> 
>> However, it does not follow that an int is what _must_ be passed around.  We
>> already have design patterns like
>> 
>> 	cookie_pointer = ioremap(raw bus resource)
>> 
>> Not that I am the one pushing for that, just noting.
>
> I do agree that we could use something more type-safe.
>
> So a "pointer" to a structure that doesn't actually exist would be fine 
> and would give us some C type checking. 
>
> But then you'd have to have some way to "printk" the information, which is 
> a very common requirement (and the printk still needs to be a number, 
> because you want to match up 'dmesg' output with the '/proc/interrupts' 
> file etc).
>
> That, in turn, would effectively force a whole new function, and then 
> you'd have things like
>
> 	printk(.. irq %d .., irq_number(irqcookie) ..)
>
> which while not ugly isn't really all that clean either. And I guarantee 
> that people would misuse that "irq_number(cookie)" exactly in the same 
> ways they'd misuse "irq" (ie not very much).
>
> Quite frankly, I'd much prefer a
>
> 	typedef int __bitwise irq_t;

Well that had better be.

	typedef unsigned int __bitwise irq_t;

Or else we have changed the historical type.

The one real advantage of a pointer cookie type is that we can remove
the confusion of dealing with irq 0.  Which is a valid irq but no
driver can use it, or our if (!irq) tests fail.

If irq 0 does not have a NULL cookie all of those problems disappear.

> and then we can use sparse to do this testing, without breaking any 
> existing use at all (because it will still be an "int" to gcc, but sparse 
> will make "irq_t" a type of its own and make sure that people pass it 
> around as such and not do arithmetic ops on it etc).

My only real concern is that it doesn't get too hard for the
implementation to go from the irq cookie to the struct irq_desc when
we kill the arrays.

Right now the irq number is very much an array index and that
property is limiting.

Even if we never export them to drivers we will need to implement
in genirq functions like:

int __must_check irq_request(struct irq_desc *irq, irq_handler_t handler,
	 unsigned long irqflags, const char *devname, void *devid);
        	
int __must_check request_irq(unsigned int irq, irq_handler_t handler,
	unsigned long irqflags, const char *devname, void *devid)
{
        return irq_request(cookie_to_desc(irq), handler, irqflags, devname, devid);
}

Or at the very least do the mapping from cookie to irq_desc at the
start of all of the genirq functions.  One valid implementation of
that cookie to desc will be the current array lookup.  But for x86
we need something less limiting.

>> > EVERYTHING else would be architecture-specific. And that is exactly what we
>> > do not want. EVER. 
>> 
>> Not true -- you have metadata/OOB data like MSI messages, where you are passed
>> a value from the PCI hardware in the PCI message, not just an "interrupt
>> asserted" condition.  Or s/value/values/ if you enable PCI MSI's multiple
>> message support.
>
> The point is, MSI *is* architecture-specific. In fact, it's even 
> motherboard-specific, in that you are going to have (for the forseeable 
> future) drivers that have to work with or witgout MSI even on the same 
> architecture.

And on x86 at least the hardware maps the MSI write into an interrupt.
So there is not an opportunity to get any metdata/OOB data from the
MSI message.  Instead we just potentially get a boatload more irq
sources.  Which is one of the things making a static NR_IRQS painful.

To be safe we have to make NR_IRQS 10x+ or so bigger then people use
today.  Just in case they decide to plug in some really irq hungry
cards.

Eric
