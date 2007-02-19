Return-Path: <linux-kernel-owner+w=401wt.eu-S932690AbXBSVX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690AbXBSVX5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 16:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932702AbXBSVX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 16:23:57 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2836 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690AbXBSVX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 16:23:56 -0500
Date: Mon, 19 Feb 2007 21:23:47 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jose Goncalves <jose.goncalves@inov.pt>
Cc: Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: Serial related oops
Message-ID: <20070219212347.GA4258@flint.arm.linux.org.uk>
Mail-Followup-To: Jose Goncalves <jose.goncalves@inov.pt>,
	Frederik Deweerdt <deweerdt@free.fr>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20070220132909.GD566@slug> <20070219134539.GA27370@flint.arm.linux.org.uk> <20070220142442.GF566@slug> <20070219143520.GB27370@flint.arm.linux.org.uk> <20070220144814.GJ566@slug> <20070219150508.GD27370@flint.arm.linux.org.uk> <45D9D073.7020701@inov.pt> <20070219164200.GF27370@flint.arm.linux.org.uk> <45D9E46C.4030408@inov.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D9E46C.4030408@inov.pt>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 05:54:52PM +0000, Jose Goncalves wrote:
> Russell King wrote:
> Result is attached.

Right... in depth analysis follows.

[15423.650518] [] uart_startup+0x63/0xf4 equates to 0xc01ba49a, which
is indeed the instruction after the call to port->ops->startup.

The important code leading up to this is:

c01ba437 <uart_startup>:
c01ba437:  55              push   %ebp
c01ba438:  57              push   %edi
c01ba439:  56              push   %esi
c01ba43a:  53              push   %ebx
c01ba43b:  8b 7c 24 14     mov    0x14(%esp),%edi  @ load state
c01ba43f:  31 d2           xor    %edx,%edx
c01ba441:  8b 5f 10        mov    0x10(%edi),%ebx  @ load state->info
c01ba444:  8b 77 14        mov    0x14(%edi),%esi  @ load state->port

c01ba493:  8b 46 64        mov    0x64(%esi),%eax  @ load port->ops
c01ba496:  56              push   %esi             @ push "port" onto stack
c01ba497:  ff 50 24        call   *0x24(%eax)      @ ops->startup(port)

c01bd74b <serial8250_startup>:
c01bd74b:  55              push   %ebp
c01bd74c:  57              push   %edi
c01bd74d:  56              push   %esi
c01bd74e:  53              push   %ebx
c01bd74f:  8b 5c 24 14     mov    0x14(%esp),%ebx

Comparing this with the stack dump:

Stack:
 c02fae70
 00000005
 c74304e0 <- %ebx (pushed by serial8250_startup)
 c02fae70 <- %esi (pushed by serial8250_startup)
 c128d5e4 <- %edi (pushed by serial8250_startup)
 c7a69a80 <- %ebp (pushed by serial8250_startup)
 c01ba49a <- uart_startup+0x63/0xf4 (pushed by function called by
		ops->startup, iow serial8250_startup)
 c02fae70 <- pushed on by "push %esi" at c01ba496, this is "port"
 c128d5e4 <- %ebx (pushed by uart_startup)
 00000000 <- %esi (pushed by uart_startup)
 c7a69a80 <- %edi (pushed by uart_startup)
 c7a69a80 <- %ebp (pushed by uart_startup)
 c01bbaa0 <- probably uart_open+0xaa/0xec

Once the instruction at c01bd74f completes, we have pushed into the stack
the structure commented above, but not the first two uncommented values.
%ebx contains the value of "port" at this point.  We're looking for some
place in the code which pushes a value of '5' and '%ebx' on to the stack,
and the CPUs registers contain values which correspond with the values
provided in your oops.

The code corresponding with the buggy uart check is as follows.  Comments
interspersed:

c01bd910:  9c                      pushf
c01bd911:  5d                      pop    %ebp
c01bd912:  fa                      cli

This code pushes the processors flag register onto the stack, pops it off
into the %ebp register, and then disables interrupts.

Your oops dump contained "ebp: 00000202" which is a reasonable value for
x86 processors flags, which have been saved into the ebp register by the
above code sequence (according to Wikipedia).

c01bd937:  ff 73 58                pushl  0x58(%ebx)
c01bd93a:  53                      push   %ebx
c01bd93b:  e8 7f fd ff ff          call   c01bd6bf <serial8250_set_mctrl>
c01bd940:  6a 02                   push   $0x2
c01bd942:  6a 01                   push   $0x1
c01bd944:  53                      push   %ebx
c01bd945:  e8 f6 eb ff ff          call   c01bc540 <serial_out>	@ write IER
c01bd94a:  6a 05                   push   $0x5
c01bd94c:  53                      push   %ebx
c01bd94d:  e8 a6 eb ff ff          call   c01bc4f8 <serial_in>	@ reads LSR
c01bd952:  89 c7                   mov    %eax,%edi		@ saves result in %edi
c01bd954:  6a 02                   push   $0x2
c01bd956:  53                      push   %ebx
c01bd957:  e8 9c eb ff ff          call   c01bc4f8 <serial_in>	@ reads IIR
c01bd95c:  83 c4 24                add    $0x24,%esp
c01bd95f:  89 c6                   mov    %eax,%esi		@ saves result in %esi

This is the code corresponding with part of the buggy uart check - you can
see the call to serial8250_set_mctrl() there which confirms this.  The
sequence at c01bd94a pushes "5" and "port" (%ebx) onto the stack, but
this isn't the right place because before this we pushed "2", "1", and
"port" on the stack, and those are not present in the stack dump.

However, the reason for showing this is that a little while later, we
have:

c01bd96e:  83 e7 40                and    $0x40,%edi
c01bd971:  74 1c                   je     c01bd98f <serial8250_startup+0x244>
c01bd973:  83 e6 01                and    $0x1,%esi
c01bd976:  74 17                   je     c01bd98f <serial8250_startup+0x244>

The normal value we would read from the LSR (stored in %edi) would be
0x60, and if a transmit interrupt was pending (which is what the test
is trying to find out) the IIR (%esi) would be 0x02.

The above code sequence which involves masking these values would
therefore give:
 0x40 & 0x60 (%edi) -> 0x40 in %edi
 0x01 & 0x02 (%esi) -> 0x00 in %esi

>From your oops dump "edi: 00000040" and "esi: 00000000" - that ties up,
so we know that the place we got to must be after this point.

We eventually come to this sequence.  The words previously pushed onto
the stack have been removed at this point, and %ebp, %edi nor %esi have
been touched by any other code since they were last commented on above.

c01bd9c6:  6a 05                   push   $0x5
c01bd9c8:  53                      push   %ebx
c01bd9c9:  e8 2a eb ff ff          call   c01bc4f8 <serial_in>

Here, we push "5" and "port" on the stack - that ties up with the stack
dump in the oops.  It's a call to read the LSR again, and it returns a
value in the '%eax' register.  From your oops report "eax: 00000060"
which as previously mentioned is the expected value of the LSR at this
point.

The C code this corresponds with the above assembly is the first
serial_inp (which is just an alias of serial_in) of:

        /*
         * And clear the interrupt registers again for luck.
         */
        (void) serial_inp(up, UART_LSR);
        (void) serial_inp(up, UART_RX);
        (void) serial_inp(up, UART_IIR);
        (void) serial_inp(up, UART_MSR);

        return 0;

At this point, we have:

1. a stack layout that looks identical to the one in your oops.
2. %eax, %esi, %edi, %ebp all tie up between your oops and the values
   we would expect at this point.
3. %ebx contains zero which we don't expect (it was containing our
   value of "port"), %ecx we don't have any way to determine (it's not
   touched by this function).

One final value is left unexplained - "edx: 000002fd".  I suggest your
dump was from a session using ttyS3, and %edx contains the base address
+ register offset (5) which gives 0x2fd.

So I believe that this is the place in serial8250_startup() where badness
is happening, and it's after that check for buggy uarts.

Moreover, I suspect taht the exact point is towards the end of the
serial_in() function, after the read of the LSR completed, and things
started to go wrong when serial_in() tried to return to it's caller -
when it was popping values off the stack including the return address
instead of reading the correct return address of the stack, it read
zero.

It would be good if someone who understands x86 assembly better than
me had a look at this and confirmed my suspicions though.

Can I ask that you try something - can you try adding a "msleep(10);"
just before the "And clear the interrupt registers again for luck."
comment and see what effect that has please?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
