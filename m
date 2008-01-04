Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbYADWYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbYADWYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 17:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbYADWYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 17:24:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:55367 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbYADWYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 17:24:32 -0500
Date: Fri, 4 Jan 2008 23:26:37 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Russell Leidich <rml@google.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       valdis.kletnieks@vt.edu, thockin@google.com
Subject: Re: [PATCH] AMD Thermal Interrupt Support
Message-ID: <20080104222637.GA19248@one.firstfloor.org>
References: <20071227233419.d1adf3f3.akpm@linux-foundation.org> <3f1a065b0712281240p14c8223agfe83db0ac26aca4c@mail.gmail.com> <p731w9410yc.fsf@bingen.suse.de> <3f1a065b0801021143y5fc15e29r4201ac19bc7c1daa@mail.gmail.com> <20080102200039.GA13784@one.firstfloor.org> <3f1a065b0801021312w6f823cbeh9ea6b73d2b0c46c8@mail.gmail.com> <64bb37e0801021333g3cccff81k68df75463e4a21d0@mail.gmail.com> <3f1a065b0801021350x7fd065fbj9680ce1a4f3c6538@mail.gmail.com> <20080102215433.GB13784@one.firstfloor.org> <3f1a065b0801041333x579d0a8fs9c5535f95dd56015@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f1a065b0801041333x579d0a8fs9c5535f95dd56015@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As to the question of Athlon RevG, it turns out that it has the same
> thermal erratum as RevF.  Therefore the fact that this code only works
> with Barcelona and up is not a defficiency.

Thanks.

> 
> There are 2 pending issues, to which I have received insufficient feedback:
> 
> 1. Andi would like to eliminate the trampoline in mce_thermal.c, but
> no one has responded to my proposed disgusting hack on entry_64.S in
> order to do so.

There are two ways to do it: 

either duplicate the entry point in entry_64.S and set different
vectors or let the asm glue jump through a call vector (use 
apicinterrupt ...,*thermal_vector(%rip) ) Later is probably better.

> 
> 2. Ingo pointed out that a given config file did not build.  But when

The patch that was in git-x86 didn't build on 32bit. Perhaps it was a 
32bit config file? Run it under "linux32" or equivalent on your distro.

> +	 */
> +	if (therm_throt_process(1))
> +		mce_log_therm_throt_event(cpu, 1);
> +	/*
> +	 * We'll still get subsequent interrupts even if we don't clear the
> +	 * status bit in THERM_CTL_F3X64.  Take advantage of this fact to avoid
> +	 * touching PCI space.  (If this assumption fails at some point, we'll
> +	 * need to schedule_work() in order to enter a process context, so that
> +	 * PCI locks can be asserted for proper access.  This requirement, in

PCI locks are spinlocks so they don't need process context. In PREEMPT-RT
kernels they can sleep, but there the handler will be likely already
a thread. Touching config space from interrupt context is legal, although
not very popular because it tends to be slow (but a few drivers do it) 

> +	/*
> +	 * If any of the northbridges has PCI ID 0x1103, then its thermal
> +	 * hardware suffers from an erratum which prevents this code from
> +	 * working, so abort.

Please add 

 * This implies it only works on Family 10h aka AMD Quad Core.

Otherwise I can just see the support questions of people asking why this
doesn't work for them.

Anyways I'm unsure about the blacklist here -- white list would
probably have been better. k8_northbridges[] will certainly include
Griffin northtbridges and who knows if TT will work there or not.
[sorry for mentioning that not earlier]


-Andi
