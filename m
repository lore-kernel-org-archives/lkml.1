Return-Path: <linux-kernel-owner+w=401wt.eu-S1945901AbXBUXFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945901AbXBUXFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945906AbXBUXFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:05:23 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2916 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945901AbXBUXFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:05:21 -0500
Date: Wed, 21 Feb 2007 23:05:03 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jose Goncalves <jose.goncalves@inov.pt>
Cc: Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
Message-ID: <20070221230503.GA28156@flint.arm.linux.org.uk>
Mail-Followup-To: Jose Goncalves <jose.goncalves@inov.pt>,
	Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20070219134539.GA27370@flint.arm.linux.org.uk> <20070220142442.GF566@slug> <20070219143520.GB27370@flint.arm.linux.org.uk> <20070220144814.GJ566@slug> <20070219150508.GD27370@flint.arm.linux.org.uk> <45D9D073.7020701@inov.pt> <20070219164200.GF27370@flint.arm.linux.org.uk> <45D9E46C.4030408@inov.pt> <20070219212347.GA4258@flint.arm.linux.org.uk> <45DC537B.6020108@inov.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DC537B.6020108@inov.pt>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 02:13:15PM +0000, Jose Goncalves wrote:
> <1>[18840.304048] Unable to handle kernel NULL pointer dereference at virtual address 00000012
> <1>[18840.313046]  printing eip:
> <4>[18840.321687] c01bfa7a
> <1>[18840.321714] *pde = 00000000
> <0>[18840.331287] Oops: 0000 [#1]
> <4>[18840.340687] Modules linked in:
> <0>[18840.349749] CPU:    0
> <4>[18840.349767] EIP:    0060:[<c01bfa7a>]    Not tainted VLI
> <4>[18840.349782] EFLAGS: 00010202   (2.6.16.41-mtm5-debug1 #1) 
> <0>[18840.377277] EIP is at serial_in+0xa/0x4a
> <0>[18840.387221] eax: 00000060   ebx: 00000000   ecx: 00000000   edx: 00000000
> <0>[18840.397805] esi: 00000000   edi: 00000040   ebp: c728fe1c   esp: c728fe18
> <0>[18840.408579] ds: 007b   es: 007b   ss: 0068
> <0>[18840.419624] Process gp_position (pid: 11629, threadinfo=c728e000 task=c7443a90)
> <0>[18840.420509] Stack: <0>00000000 00000000 c01c0f88 00000000 00000000 c031fef0 00000005 00000202 
> <0>[18840.445655]        c7161a1c c031fef0 c124b510 c728fe60 c01bd97d c031fef0 c124b510 c124b510 
> <0>[18840.460540]        00000000 c773dbcc c728fe7c c01befe7 c124b510 00000000 ffffffed c773dbcc 

Okay, this one is even more plainly "not a coding error".

> <0>[18840.566645]  [<c01c0f88>] serial8250_startup+0x28f/0x2a9

The code around this point (with the return point marked) is:

> c01c0f78:	6a 05                	push   $0x5
> c01c0f7a:	53                   	push   %ebx
> c01c0f7b:	e8 f0 ea ff ff       	call   c01bfa70 <serial_in>
> c01c0f80:	6a 00                	push   $0x0
> c01c0f82:	53                   	push   %ebx
> c01c0f83:	e8 e8 ea ff ff       	call   c01bfa70 <serial_in>
> c01c0f88<<<	6a 02                	push   $0x2
> c01c0f8a:	53                   	push   %ebx
> c01c0f8b:	e8 e0 ea ff ff       	call   c01bfa70 <serial_in>

and corresponds with this C code:

        (void) serial_inp(up, UART_LSR);
        (void) serial_inp(up, UART_RX);
        (void) serial_inp(up, UART_IIR);

Now let's look at the words pushed on the stack around this code:

  00000000
  00000000
  c01c0f88 <- return address for serial_in (serial8250_startup+0x28f/0x2a9)
  00000000 <- from push %ebx at c01c0f82
  00000000 <- from push $0x0 at c01c0f80
  c031fef0 <- from push %ebx at c01c0f7a
  00000005 <- from push %0x5 at c01c0f78

Plainly, %ebx changed across the call to serial_in() at c01c0f7b.
First thing to notice is this violates the C code - "up" can not
change.

Now let's look at serial_in:

c01bfa70:       55                      push   %ebp
c01bfa71:       89 e5                   mov    %esp,%ebp
c01bfa73:       53                      push   %ebx
...
c01bfab7:       5b                      pop    %ebx
c01bfab8:       5d                      pop    %ebp
c01bfab9:       c3                      ret

This code tells the CPU to preserves %ebx and %ebp.  But we know %ebx
_wasn't_ preserved.  Ergo, your CPU is plainly not doing what the code
told it to do.

Moreover, serial_in() has preserved %ebx in the past otherwise we'd
never got past all the other serial_in()s in serial8250_startup().

So I think it's very demonstrably a hardware fault, and not software
related.

For all we know, it could be a one-off fault on the hardware you
happen to have - other identical units may not behave the same (can
you check?)

If it is a one off case, you are welcome to patch that test out in
your kernel build to remove the problem, and if it's an isolated case
I encourage you to do this.  This is one of the great advantages of
open source - if you hit such a problem rather than throwing the
hardware away you can work around such issues.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
