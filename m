Return-Path: <linux-kernel-owner+w=401wt.eu-S1757595AbYKUWRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595AbYKUWRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 17:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757402AbYKUWRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 17:17:24 -0500
Received: from h4.dl5rb.org.uk ([81.2.74.4]:58733 "EHLO
	ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757378AbYKUWRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 17:17:23 -0500
Date: Fri, 21 Nov 2008 22:16:19 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Daney <ddaney@caviumnetworks.com>, gcc@gcc.gnu.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-mips <linux-mips@linux-mips.org>, linux-kernel@vger.kernel.org,
       Adam Nemet <anemet@caviumnetworks.com>
Subject: Re: [PATCH] MIPS: Make BUG() __noreturn.
Message-ID: <20081121221619.GB28154@linux-mips.org>
References: <49260E4C.8080500@caviumnetworks.com> <20081121100035.3f5a640b@lxorguk.ukuu.org.uk> <Pine.LNX.4.64.0811211126420.26004@anakin> <4926E499.4070706@caviumnetworks.com> <Pine.LNX.4.64.0811211940450.29539@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811211940450.29539@anakin>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 07:46:43PM +0100, Geert Uytterhoeven wrote:

> > up with a couple of options:
> > 
> > 1) Enhance the _builtin_trap() function so that we can specify the
> >   break code that is emitted.  This would allow us to do something
> >   like:
> > 
> > static inline void __attribute__((noreturn)) BUG()
> > {
> > 	__builtin_trap(0x200);
> > }

I had suggested this one before ...

> > 2) Create a new builtin '__builtin_noreturn()' that expands to nothing
> >   but has no CFG edges leaving it, which would allow:
> > 
> > static inline void __attribute__((noreturn)) BUG()
> > {
> > 	__asm__ __volatile__("break %0" : : "i" (0x200));
> > 	__builtin_noreturn();
> > }
> 
> Now I remember, yes, __builtin_trap() is how we fixed it on m68k:

I like this interface.

> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e8006b060f3982a969c5170aa869628d54dd30d8
> 
> Of course, if you need a different trap code than the default, you're in
> trouble.

MIPS ISA newer than MIPS I also have conditional break codes allowing
something like this:

#define BUG_ON(condition)                                               \
do {                                                                    \
        __asm__ __volatile__("tne $0, %0, %1"                           \
                             : : "r" (condition), "i" (BRK_BUG));       \
} while (0)

that is test of condition and the trap as a single instruction.  Note there
are break and trap instructions on MIPS and they are basically doing the
same job ...

  Ralf
