Return-Path: <linux-kernel-owner+w=401wt.eu-S938315AbXG0W7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938315AbXG0W7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 18:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763560AbXG0W6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 18:58:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38496 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752680AbXG0W6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 18:58:48 -0400
Date: Fri, 27 Jul 2007 15:57:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       david@lang.hm, Andrew Morton <akpm@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [2.6 patch] let SUSPEND select HOTPLUG_CPU
In-Reply-To: <20070727222503.GB15129@stusta.de>
Message-ID: <alpine.LFD.0.999.0707271545220.3442@woody.linux-foundation.org>
References: <200707251238.50218.lenb@kernel.org> <200707262117.26353.rjw@sisk.pl>
 <alpine.LFD.0.999.0707261255380.3442@woody.linux-foundation.org>
 <200707262248.09187.rjw@sisk.pl> <alpine.LFD.0.999.0707261351430.3442@woody.linux-foundation.org>
 <20070727222503.GB15129@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Jul 2007, Adrian Bunk wrote:
> 
> The dependency of SUSPEND_SMP on HOTPLUG_CPU is quite unintuitive, so 
> what about something like the patch below?

Yeah, this looks reasonable.

May I suggest another level of indirection, though:

> +config SUSPEND_SMP_POSSIBLE
> +	bool
> +	depends on (X86 && !X86_VOYAGER) || (PPC64 && (PPC_PSERIES || PPC_PMAC))
> +	depends on SMP
> +	default y

How about making this a bit more split up, and do it as

	# SMP suspend is possible on ..
	config SUSPEND_SMP_POSSIBLE
		bool
		depends on (X86 && !X86_VOYAGER) || (PPC64 && (PPC_PSERIES || PPC_PMAC))
		default y

	# UP suspend is possible on ..
	config SUSPEND_UP_POSSIBLE
		bool
		depends on X86 || PPC64_SWSUSP || FRV || PPC32
		default y 

	# Can we suspend?
	config SUSPEND_POSSIBLE
		bool
		depends on (SMP && SUSPEND_SMP_POSSIBLE) || (SUSPEND_UP_POSSIBLE && !SMP)
		default y

and then we have just a

	config SOFTWARE_SUSPEND
		bool "Software Suspend (Hibernation)"
		depends on PM && SWAP
		depends on SUSPEND_POSSIBLE

	config SUSPEND_SMP
		bool
		depends on SOFTWARE_SUSPEND && SMP
		select HOTPLUG_CPU
		default y

and now each of the config options looks pretty simple and describe one 
thing.

[ For extra bonus points: the SUSPEND_POSSIBLE thing is still pretty 
  complicated, and it might actually be a better idea to make it a 
  per-arch config option, and just make the x86/arch say

	config SUSPEND_POSSIBLE
		bool
		depends on !(X86_VOYAGER && SMP)
		default y

  instead: since SUSPEND_POSSIBLE is always true on x86 regardless of SMP 
  or not, just not on X86_VOYAGER. Then, each architecture can have its 
  own private rules for whether that architecture has SUSPEND_POSSIBLE or 
  not, so on ppc, it might look like

	config SUSPEND_POSSIBLE
		bool
		depends on (PPC64 && (PPC_PSERIES || PPC_PMAC)) || PPC_SWSUSP
		bool y

  or something, but the point is, now the complexity is a per-architecture 
  thing, so other architectures simply don't have to care any more! ]

And the user only ever sees one single question: the one for 
"SOFTWARE_SUSPEND". All the others would directly flow either from the 
architecture choice, or from that.

Anybody willing to rewrite it that way?

			Linus
