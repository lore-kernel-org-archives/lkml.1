Return-Path: <linux-kernel-owner+w=401wt.eu-S1752060AbYBCFLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbYBCFLz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 00:11:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYBCFLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 00:11:47 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:46684 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbYBCFLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 00:11:46 -0500
Date: Sun, 03 Feb 2008 00:11:33 -0500
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [BUG] 2.6.24 refuses to boot - ATA problem?
In-reply-to: <20080203044428.GA10139@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jeff Garzik <jeff@garzik.org>, Chris Rankin <rankincj@yahoo.com>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Message-id: <200802030011.34086.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <745427.71265.qm@web52907.mail.re2.yahoo.com>
 <200802022243.13710.gene.heskett@gmail.com> <20080203044428.GA10139@elte.hu>
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 February 2008, Ingo Molnar wrote:
>* Gene Heskett <gene.heskett@gmail.com> wrote:
>> I think that one came from me, but it also gets over 14,000 hits on
>> google.
>>
>> Now Jeff, here is the strange part.  That error was killing me, many
>> times an hour and eventually crashing completely, repeatedly.
>>
>> I applied that kernel argument acpi_use_timer_override once and have
>> not had the error since, and that includes one test of a full let it
>> cool for a minute powerdown reboot to see if it would come back, which
>> it did not.
>>
>> That argument causes the kernel to log this as its responding to that
>> command:
>>
>> [   27.097095] ENABLING IO-APIC IRQs
>> [   27.097287] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
>> [   27.107291] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
>> [   27.107343] ...trying to set up timer (IRQ0) through the 8259A ... 
>> failed. [   27.107346] ...trying to set up timer as Virtual Wire IRQ...
>> failed. [   27.117353] ...trying to set up timer as ExtINT IRQ... works.
>>
>> The last 4 lines above are not logged without that argument.  So my
>> theory ATM is that this forced the kernel to initialize something in
>> the boards registers that it does not initialize without that command,
>> and that its going fubar as shown in the msg quoted above is a totally
>> random thing, perhaps dependent on the phase of one of jupiters moons
>> as to what state it powers up in.  And I got lucky, so far in that my
>> single powerdown reset didn't trigger it again...  And you _know_ what
>> that knocking sound is by now. :)
>
>that's weird. Could you try the hack below and _remove_ the
>acpi_use_timer_override flag? The change should artificially cause the
>above 4 lines to appear again, in all cases.
>
>This would test the following aspects of your theory: is this unknown
>side-effect of the the acpi_use_timer_override flag related to the timer
>setup sequence in io_apic_32.c? If not, then the difference most likely
>lies in the different ACPI setup sequence.
>
>	Ingo
>
>---
> arch/x86/kernel/io_apic_32.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>Index: linux/arch/x86/kernel/io_apic_32.c
>===================================================================
>--- linux.orig/arch/x86/kernel/io_apic_32.c
>+++ linux/arch/x86/kernel/io_apic_32.c
>@@ -2208,7 +2208,7 @@ static inline void __init check_timer(vo
> 		 * Ok, does IRQ0 through the IOAPIC work?
> 		 */
> 		unmask_IO_APIC_irq(0);
>-		if (timer_irq_works()) {
>+		if (timer_irq_works() && 0) {
> 			if (nmi_watchdog == NMI_IO_APIC) {
> 				disable_8259A_irq(0);
> 				setup_nmi();

I believe its the same, but lemme paste it for sure, yes:
[   26.339926] ENABLING IO-APIC IRQs
[   26.340119] ..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
[   26.350129] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
[   26.350182] ...trying to set up timer (IRQ0) through the 8259A ...  failed.
[   26.350185] ...trying to set up timer as Virtual Wire IRQ... failed.
[   26.360186] ...trying to set up timer as ExtINT IRQ... works.

The third line is the only line that makes it to the screen during the boot 
trace.

Now, what does this tell us?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
As far as the laws of mathematics refer to reality, they are not
certain, and as far as they are certain, they do not refer to reality.
		-- Albert Einstein
