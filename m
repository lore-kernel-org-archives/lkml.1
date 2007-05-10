Return-Path: <linux-kernel-owner+w=401wt.eu-S1762481AbXEJVXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762481AbXEJVXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759652AbXEJVXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:23:17 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4619 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635AbXEJVXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:23:16 -0400
Date: Thu, 10 May 2007 22:23:03 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: cw@f00f.org, linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: (hacky) [PATCH] silence MODPOST section mismatch warnings
Message-ID: <20070510212303.GG29713@flint.arm.linux.org.uk>
Mail-Followup-To: David Miller <davem@davemloft.net>, cw@f00f.org,
	linux-kernel@vger.kernel.org, sam@ravnborg.org
References: <20070510203417.GA23019@tuatara.stupidest.org> <20070510.135147.55726615.davem@davemloft.net> <20070510205427.GF29713@flint.arm.linux.org.uk> <20070510.140725.99616053.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510.140725.99616053.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 02:07:25PM -0700, David Miller wrote:
> From: Russell King <rmk+lkml@arm.linux.org.uk>
> Date: Thu, 10 May 2007 21:54:27 +0100
> 
> > I've not had one accurate one on ARM yet.
> > 
> > Here's another example:
> > 
> > WARNING: init/built-in.o - Section mismatch: reference to .init.text:
> >  from .text between 'rest_init' (at offset 0x4c) and 'run_init_process'
> > 
> > from init/main.c:
> > 
> > static void noinline rest_init(void)
> >         __releases(kernel_lock)
> > 
> > static void run_init_process(char *init_filename)
> > 
> > Clearly, it just does _not_ work.
> 
> Russell, the symbols are where the reference to an .init.text
> section are coming from, they are not the .init.text function
> being referenced itself.
> 
> It is saying that something between rest_init and run_init_processes,
> which are not .init.text, are referencing an .init.text object.

Ah, so they aren't supposed to be the two objects themselves.  Now
that I understand what the message means, I can make some headway
into investigating what's up.

> It's unfortunate that the .init.text object being referenced for some
> reason can't get the symbol printed out properly on ARM, it does get
> printed out on other platforms, but once you fix that it will be very
> easy for you to decode these messages.

Well, I guess it's because of the way the ARM ABI works.  We have
literal pools mixed in with the text:

Disassembly of section .text:

00000000 <rest_init>:
...
  14:   e59f0030        ldr     r0, [pc, #48]   ; 4c <.text+0x4c>
  18:   ebfffffe        bl      0 <kernel_thread>
                        18: R_ARM_PC24  kernel_thread
...
  4c:   000007a0        andeq   r0, r0, r0, lsr #15
                        4c: R_ARM_ABS32 .init.text
        ...
                        50: R_ARM_ABS32 kthreadd
                        54: R_ARM_ABS32 kthreadd_task

00000058 <run_init_process>:

Disassembly of section .init.text:

000007a0 <kernel_init>:

It looks like we're going to have to jump through hoops to get the
right symbols on ARM - to get at the right symbol being referenced
you need to take account of the relocation type and therefore the
properties of the relocation, and add any offset found at the
reference address.

IOW, you need to resolve the relocation (if possible) and see which
symbol you end up pointing at.

I'm sorely lacking in detailed understanding of the ARM binutils
(it's been 12 years since I touched it), especially after the
advent of ARM EABI, so I guess I need to find someone willing in
the ARM community prepared to resolve this.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
