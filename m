Return-Path: <linux-kernel-owner+w=401wt.eu-S1761436AbYEXTxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761436AbYEXTxm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 15:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbYEXTxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 15:53:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48276 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752693AbYEXTxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 15:53:34 -0400
Date: Sat, 24 May 2008 12:53:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC PATCH] kconfig: introduce KCONFIG_* symbols for .c files
Message-Id: <20080524125316.4b969936.akpm@linux-foundation.org>
In-Reply-To: <20080524192540.GA28067@uranus.ravnborg.org>
References: <20080524192540.GA28067@uranus.ravnborg.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 May 2008 21:25:40 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:

> We have many places in the kernel that looks like
> the following:
> 
> #ifdef CONFIG_FOO
> 	...
> #endif
> 
> Which has the disadvantage that the code denoted '...'
> are not even built if CONFIG_FOO is not selected in
> the current configuration.
> 
> We know that gcc do simple code-elimination for
> conditionals which is always true/false and
> thus the above code could be turned into:
> 
> 	if (CONFIG_FOO)
> 		...
> 
> One line smaller and we follow the normal flow in the program.
> The code is always build but we do not waste space as gcc will
> do proper code-elimination for us.
> 
> Today this is not possible because kconfig will only
> define CONFIG_FOO if selected and FOO is not a module.
> 
> The following patch implement a new set of defines in
> the KCONFIG_* namespace.
> 
> For a tristate symbol the following are defined:
> 
> FOO not selected: 
> #define KCONFIG_FOO        0
> #define KCONFIG_FOO_MODULE 0
> 
> FOO is built-in ('y')
> #define KCONFIG_FOO        1
> #define KCONFIG_FOO_MODULE 0
> 
> FOO is a module ('m'):
> #define KCONFIG_FOO        1
> #define KCONFIG_FOO_MODULE 1
> 
> In other words KCONFIG_FOO will say if the
> symbol is selected and KCONFIG_FOO_MODULE
> will say if it is a module.
> 
> With the above included we can now do:
> 
> 	if (KCONFIG_FOO)
> 		...
> 
> This is not a replacement for the CONFIG_*
> defines but a pleasant supplement.
> Using KCONFIG_FOO will also give us a nice
> error message the day that FOO is no longer part
> of the configuration.

It could help to get us out of the occasional sticky situation, but it
does seem a bit risky.  What happens with Kconfig variables which are
just not known about at all with some .configs?

Silly example, one could add

	if (KCONFIG_DVB_VES1820)

to kernel/sched.c and that would work happily until someone sets DVB=n,
in which case I assume KCONFIG_DVB_VES1820 doesn't get defined
anywhere?

A more realistic example might be using an x86-only KCONFIG_* in non-x86
code.

