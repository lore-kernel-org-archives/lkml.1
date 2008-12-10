Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbYLJM2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbYLJM2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 07:28:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYLJM1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 07:27:52 -0500
Received: from ozlabs.org ([203.10.76.45]:50696 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbYLJM1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 07:27:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: setup_arch/arch_get_boot_command_line changes
Date: Wed, 10 Dec 2008 22:57:42 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, Richard Henderson <rth@twiddle.net>,
       Russell King <rmk@arm.linux.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Bryan Wu <cooloney@kernel.org>, Mikael Starvik <starvik@axis.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Tony Luck <tony.luck@intel.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@uclinux.org>, Ralf Baechle <ralf@linux-mips.org>,
       linux-parisc@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Jeff Dike <jdike@addtoit.com>,
       Ingo Molnar <mingo@redhat.com>, Chris Zankel <chris@zankel.net>
References: <200812100850.26728.rusty@rustcorp.com.au> <alpine.LFD.2.00.0812091553250.3340@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0812091553250.3340@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812102257.44195.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 December 2008 10:24:11 Linus Torvalds wrote:
> This looks really invasive, with absolutely zero explanations of what the 
> point of it all is.
> 
> What?

Sorry, it's a cleanup.  I wanted start_kernel(const char *cmdline), but that
was even more invasive.

Justification: there are about five command line parsing systems in the
kernel at the moment, and about the same number of copies of the command
line.  Here's how it works at the moment:

1) setup_arch(char **cmdlinep) is called.  This copies the command line
   into boot_command_line, and also returns a pointer in cmdlinep.  That
   pointer is not usually boot_command_line, but an arch-internal cmdline
   which for some archs have deleted already-parsed options.  Some archs
   do strstr parsing of the command line here.

2) parse_early_param() is called by some archs from setup_arch.  This copies
   boot_command_line into an __initdata temporary to parse for early_param().
   early_param() look like foo[=bar] and go for a generic callback: they
   are usually sloppily parsed but simple.

   Other archs don't call this, so we call it again later in start_kernel.

   (parse_early_param() can't be called before setup_arch because we don't
   know the command line yet, but many archs need the parsing done to
   complete setup_arch.)

3) setup_command_line() copies boot_command_line into saved_command_line,
   because boot_command_line is __initdata, and we need to save it for proc.
   It also copies the cmdlinep returned from setup_arch into
   static_command_line, because cmdlinep may point to initdata, and
   traditionally command line callbacks are allowed to keep pointers to
   their args so we need to keep the (mangled) cmdline around.

4) We parse the command line again, matching for core_param, module_param
   and __setup.  module_param is the standard modname.arg, and core_param
   is just 'arg'.  They both can (optionally) make the args read/writable
   in sysfs, and are trivial and typesafe to use.  __setup() is a generic
   prefix-matching callback which has been around forever.

5) IA64 needs machvec= processed before any of the other early_param()
   calls, so it grabs this manually.  It leaves it in the command line, so
   it seems that init gets a $machvec in its environment if this was set.

6) Arm uses __early_param which is arm-specific.  This is like early_param,
   only different.

New code:
1) arch_get_boot_command_line() just gets the command-line at the start of
   setup_arch.  Making copies etc. is all in generic code.
2) early_param and core_param are parsed just after, so you can rely
   on the results in setup_arch(), which no longer does any command line
   stuff.
3) Three copies of command line total: char __initdata boot_command_line[]
   since we can't alloc, char *saved_command_line for proc, and static char *
   static_command_line for __setup/module_param to keep references to.
4) Some archs still have working copies of the command line, but they don't
   need to and I put in FIXMEs.
5) IA64 still has to handle machvec= manually.  AFAICT it's the only one, so
   not worth putting in a boutique pre-early_param for that.

It's a nice cleanup, but it's not a revolutionary improvement IMHO.

Rusty.
