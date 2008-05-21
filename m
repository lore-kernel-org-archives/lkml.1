Return-Path: <linux-kernel-owner+w=401wt.eu-S1764782AbYEUWiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764782AbYEUWiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 18:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757106AbYEUWiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 18:38:06 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:50786 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757063AbYEUWiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 18:38:04 -0400
Date: Thu, 22 May 2008 00:38:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, PaulMackerraspaulus@samba.org
Subject: Re: [PATCH] Fix Immediate Values x86_64 support old gcc (v2)
Message-ID: <20080521223842.GE15136@uranus.ravnborg.org>
References: <20080516124811.GC4226@Krystal> <482DFD65.10300@zytor.com> <20080521133122.GA18084@Krystal> <48344239.9070003@zytor.com> <20080521160217.GA26974@Krystal> <20080521170150.GA29428@Krystal> <20080521203743.GA12982@uranus.ravnborg.org> <20080521212809.GE6158@Krystal> <20080521214608.GA15136@uranus.ravnborg.org> <20080521215756.GA9869@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521215756.GA9869@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 05:57:56PM -0400, Mathieu Desnoyers wrote:
> * Sam Ravnborg (sam@ravnborg.org) wrote:
> 
> > Same with USE_IMMEDIATE - as USE_IMMEDIATE is only used in a x86 Makefile.
> > Or did I miss sothing?
> > 
> 
> Given that I want to change every use of CONFIG_IMMEDIATE into
> USE_IMMEDIATE, both in architecture specific and independant C files and
> also in arch spec. and indep. Makefiles, I will have to define
> USE_IMMEDIATE on other arch too.
> 
> Here is the updated patch. It applies on top of the sched-devel.git
> tree.
> 
> Fix Immediate Values x86_64 support old gcc
> 
> GCC < 4, on x86_64, does not accept symbol+offset operands for "i" constraints
> asm statements. Fallback on generic immediate values if this compiler is
> detected.
> 
> Changelog :
> - USE_IMMEDIATE must now be used in lieue of CONFIG_IMMEDIATE in Makefiles and
>   in C code.
> - Every architecture implementing immediate values must declare USE_IMMEDIATE
>   in their Makefile.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Sam Ravnborg <sam@ravnborg.org>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: Jeremy Fitzhardinge <jeremy@goop.org>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: David Miller <davem@davemloft.net>
> CC: Paul Mackerras paulus@samba.org
> ---
>  Makefile                     |    5 +++++
>  arch/powerpc/Makefile        |    2 ++
>  arch/powerpc/kernel/Makefile |    2 +-
>  arch/x86/Makefile            |    5 +++++
>  arch/x86/kernel/Makefile     |    2 +-
>  arch/x86/kernel/traps_32.c   |    4 ++--
>  include/linux/immediate.h    |    2 +-
>  include/linux/module.h       |    4 ++--
>  kernel/Makefile              |    2 +-
>  kernel/module.c              |    8 ++++----
>  10 files changed, 24 insertions(+), 12 deletions(-)
> 
> Index: linux-2.6-sched-devel/arch/x86/Makefile
> ===================================================================
> --- linux-2.6-sched-devel.orig/arch/x86/Makefile	2008-05-21 09:04:52.000000000 -0400
> +++ linux-2.6-sched-devel/arch/x86/Makefile	2008-05-21 14:18:16.000000000 -0400
> @@ -43,6 +43,7 @@
>  
>          # temporary until string.h is fixed
>          KBUILD_CFLAGS += -ffreestanding
> +	export USE_IMMEDIATE := $(CONFIG_IMMEDIATE)
tabs has a special sematic purpose in makefiles so do not
use tabs for indent.

>  else
>          BITS := 64
>          UTS_MACHINE := x86_64
> @@ -78,6 +79,10 @@
>                  "$(CC)" -fstack-protector-all )
>  
>          KBUILD_CFLAGS += $(stackp-y)
> +
> +	# x86_64 gcc 3.x has problems with passing symbol+offset in
> +	# asm "i" constraint.
> +	export USE_IMMEDIATE := $(call cc-ifversion, -ge, 0400, $(CONFIG_IMMEDIATE))
tabs -> spaces again.

Other than that I like this patch much better.

Thanks,
	Sam
