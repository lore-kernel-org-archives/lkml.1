Return-Path: <linux-kernel-owner+w=401wt.eu-S1757264AbXFLRzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264AbXFLRzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 13:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755280AbXFLRzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 13:55:05 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:58706 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496AbXFLRzD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 13:55:03 -0400
Date: Tue, 12 Jun 2007 19:56:06 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: Re: [PATCH] x86: fix improper .init-type section references
Message-ID: <20070612175606.GB15329@uranus.ravnborg.org>
References: <466E6BDF.76E4.0078.0@novell.com> <a781481a0706120414g385ccfe8j82b5b18d96d064f2@mail.gmail.com> <a781481a0706120509k89c331ela81f57ad0f0e29eb@mail.gmail.com> <466EB12B.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466EB12B.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 02:43:55PM +0200, Jan Beulich wrote:
> >> The cacheinfo_cpu_notifier itself is called out from _cpu_down() which
> >> is ... yep, *not* __cpuinit (and obviously *cannot* be so). _cpu_down()
> >> is called from cpu_down() which is (thankfully!) protected inside
> >> #ifdef CONFIG_HOTPLUG_CPU, so we've /just about/ escaped trouble
> >> so far, but another of it's callers is disable_nonboot_cpus() which does
> >> *not* depend on HOTPLUG_CPU, but is #ifdef'ed inside SUSPEND_SMP
> >> (gargh!) instead, and ... is _not_ __cpuinit either (obviously, again).
> >
> >Wait, SUSPEND_SMP again depends on HOTPLUG_CPU, so there
> >are no issues here in marking cache_remove_dev() __cpuexit
> >(which effectively simply becomes #ifdef HOTPLUG_CPU) as all
> >callsites that call out the notifier with CPU_DEAD/FROZEN are also
> >going to be disabled. [ Ok, looks like using __cpuexit as this kind of
> >pseudo-#ifdef HOTPLUG_CPU is a standard practice? ]
> >
> >But modpost will still complain (bogus warning) about calling __exit
> >from __init (when HOTPLUG_CPU=n) for cacheinfo_cpu_callback()
> >calling cache_remove_dev(), no?
> 
> No, it doesn't, at least not for me. And from a purely theoretical
> perspective I don't think such references should be considered bad -
> .exit.* should be discarded together with .init.* if unloading is
> impossible (built-in or configured off), not before module/kernel
> initialization. This is specifically because init code may want to utilize
> exit code in case of initialization failure.

For the builtin case some arch's drop exit code during link time
so using function marked __exit from __init will cause a
linker bug. For i386 __exit is discarded at runtime - but dunno when in the
init sequence.

	Sam
