Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbXJXORU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbXJXORU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbXJXORL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:17:11 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:35756 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbXJXORK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:17:10 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [HP ProLiant WatchDog driver] hpwdt HP WatchDog Patch <resend>
Date: Wed, 24 Oct 2007 14:16:14 -0000
Message-ID: <66ED1F0546CFFE4BABB226CD6633D4A6016D9BD6@G3W0635.americas.hpqcorp.net>
In-Reply-To: <200710231431.15267.bjorn.helgaas@hp.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [HP ProLiant WatchDog driver] hpwdt HP WatchDog Patch <resend>
Thread-Index: AcgVtAgMrw6FpQ93QV+G6hfJ3GzxPAAlDH6w
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: "Helgaas, Bjorn" <bjorn.helgaas@hp.com>
Cc: <linux-kernel@vger.kernel.org>, "Wim Van Sebroeck" <wim@iguana.be>
X-OriginalArrivalTime: 24 Oct 2007 14:16:16.0075 (UTC) FILETIME=[707CE9B0:01C81648]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As I stated before, we will never have more than one ilO2 device on a
system. Also, this device will only be used on x86 and x86_64
architectures. I will check in the dev_warn changes asap.

Tom 

-----Original Message-----
From: Helgaas, Bjorn 
Sent: Tuesday, October 23, 2007 3:31 PM
To: Mingarelli, Thomas
Cc: linux-kernel@vger.kernel.org; Wim Van Sebroeck
Subject: Re: [HP ProLiant WatchDog driver] hpwdt HP WatchDog Patch
<resend>

On Monday 22 October 2007 05:09:51 pm thomas.mingarelli@hp.com wrote:
> +config HP_WATCHDOG
> +        tristate "Hewlett-Packard watchdog"
> +        depends on WATCHDOG && X86

I wouldn't be surprised if this device someday turned up on non-x86
systems.  I know there's some x86 firmware stuff in there that clearly
requires x86.  But it'd be nice if the rest of the driver compiled and
worked (minus the x86 firmware functionality) on other architectures.
For example, you could wrap all the event logging code in "#ifdef
CONFIG_X86" and provide a null implementation for !X86.

> +asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
> +			       unsigned long *pRomEntry)
> +{
> +#ifdef CONFIG_X86_64
> +	asm("pushq      %rbp            \n\t"
> +	    "movq       %rsp, %rbp      \n\t"
> +	    "pushq      %rax            \n\t"
> +	    "pushq      %rbx            \n\t"
> +	    "pushq      %rdx            \n\t"
> +	    "pushq      %r12            \n\t"
> +	    "pushq      %r9             \n\t"
> +	    "movq       %rsi, %r12      \n\t"
> +	    "movq       %rdi, %r9       \n\t"
> +	    "movl       4(%r9),%ebx     \n\t"
> +	    "movl       8(%r9),%ecx     \n\t"
> +	    "movl       12(%r9),%edx    \n\t"
> +	    "movl       16(%r9),%esi    \n\t"
> +	    "movl       20(%r9),%edi    \n\t"
> +	    "movl       (%r9),%eax      \n\t"
> +	    "call       *%r12           \n\t"
> +	    "pushfq                     \n\t"
> +	    "popq        %r12           \n\t"
> +	    "popfq                      \n\t"
> +	    "movl       %eax, (%r9)     \n\t"
> +	    "movl       %ebx, 4(%r9)    \n\t"
> +	    "movl       %ecx, 8(%r9)    \n\t"
> +	    "movl       %edx, 12(%r9)   \n\t"
> +	    "movl       %esi, 16(%r9)   \n\t"
> +	    "movl       %edi, 20(%r9)   \n\t"
> +	    "movq       %r12, %rax      \n\t"
> +	    "movl       %eax, 28(%r9)   \n\t"
> +	    "popq       %r9             \n\t"
> +	    "popq       %r12            \n\t"
> +	    "popq       %rdx            \n\t"
> +	    "popq       %rbx            \n\t"
> +	    "popq       %rax            \n\t"
> +	    "leave                      \n\t" "ret");
> +#endif

This is more dangerous than using the gcc assembler operand syntax,
because it assumes things about how the parameters are put on the stack.

> +static int __devinit hpwdt_init_one(struct pci_dev *dev,
> +				    const struct pci_device_id *ent) {
> +	int retval;
> +
> +	if (pci_enable_device(dev)) {
> +		printk(KERN_WARNING
> +		       "hpwdt: Not possible to enable PCI Device\n");

You might consider using dev_printk(), dev_warn(), etc, instead of most
of your printk calls.  Then you get the device ID and driver name
automatically.

> +		return -ENODEV;
> +	}
> +	pci_enable = 1;

The driver assumes only a single instance of the device.  But PCI being
what it is, it's often possible to have multiple cards, so you might
want some protection in case you trip over more than one.

