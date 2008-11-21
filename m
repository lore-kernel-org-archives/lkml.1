Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbYKUSqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbYKUSqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 13:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYKUSqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 13:46:47 -0500
Received: from winston.telenet-ops.be ([195.130.137.75]:57524 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbYKUSqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:46:46 -0500
Date: Fri, 21 Nov 2008 19:46:43 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Daney <ddaney@caviumnetworks.com>
cc: gcc@gcc.gnu.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-mips <linux-mips@linux-mips.org>, linux-kernel@vger.kernel.org,
       Adam Nemet <anemet@caviumnetworks.com>
Subject: Re: [PATCH] MIPS: Make BUG() __noreturn.
In-Reply-To: <4926E499.4070706@caviumnetworks.com>
Message-ID: <Pine.LNX.4.64.0811211940450.29539@anakin>
References: <49260E4C.8080500@caviumnetworks.com> <20081121100035.3f5a640b@lxorguk.ukuu.org.uk>
 <Pine.LNX.4.64.0811211126420.26004@anakin> <4926E499.4070706@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008, David Daney wrote:
> Geert Uytterhoeven wrote:
> > On Fri, 21 Nov 2008, Alan Cox wrote:
> > > On Thu, 20 Nov 2008 17:26:36 -0800
> > > David Daney <ddaney@caviumnetworks.com> wrote:
> > > 
> > > > MIPS: Make BUG() __noreturn.
> > > > 
> > > > Often we do things like put BUG() in the default clause of a case
> > > > statement.  Since it was not declared __noreturn, this could sometimes
> > > > lead to bogus compiler warnings that variables were used
> > > > uninitialized.
> > > > 
> > > > There is a small problem in that we have to put a magic while(1); loop
> > > > to
> > > > fool GCC into really thinking it is noreturn.  
> > > That sounds like your __noreturn macro is wrong.
> > > 
> > > Try using __attribute__ ((__noreturn__))
> > > 
> > > if that works then fix up the __noreturn definitions for the MIPS and gcc
> > > you have.
> > 
> > Nope, gcc is too smart:
> > 
> > $ cat a.c
> > 
> > int f(void) __attribute__((__noreturn__));
> > 
> > int f(void)
> > {
> > }
> > 
> > $ gcc -c -Wall a.c
> > a.c: In function f:
> > a.c:6: warning: `noreturn' function does return
> > $ 
> 
> That's right.
> 
> I was discussing this issue with my colleague Adam Nemet, and we came
> up with a couple of options:
> 
> 1) Enhance the _builtin_trap() function so that we can specify the
>   break code that is emitted.  This would allow us to do something
>   like:
> 
> static inline void __attribute__((noreturn)) BUG()
> {
> 	__builtin_trap(0x200);
> }
> 
> 2) Create a new builtin '__builtin_noreturn()' that expands to nothing
>   but has no CFG edges leaving it, which would allow:
> 
> static inline void __attribute__((noreturn)) BUG()
> {
> 	__asm__ __volatile__("break %0" : : "i" (0x200));
> 	__builtin_noreturn();
> }

Now I remember, yes, __builtin_trap() is how we fixed it on m68k:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=e8006b060f3982a969c5170aa869628d54dd30d8

Of course, if you need a different trap code than the default, you're in
trouble.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
