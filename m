Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbXFYNNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbXFYNNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 09:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXFYNM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 09:12:57 -0400
Received: from mail.gmx.net ([213.165.64.20]:50499 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752615AbXFYNM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 09:12:56 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX19VpblPYlRVPbtlpJttmUfPfLgojCcGlfZDGjqfj2
	PQ3+hd54qMkP6O
Date: Mon, 25 Jun 2007 15:13:40 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch, 2.6.22-rc6] fix nmi_watchdog=2 bootup hang
Message-ID: <20070625131340.GC5118@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Rusty Russell <rusty@rustcorp.com.au>
References: <20070605094246.GA27135@elte.hu> <20070605094555.GA28097@elte.hu> <20070605095025.GA29029@elte.hu> <20070605095600.GA29270@elte.hu> <20070610181016.GA15979@atjola.homenet> <20070618121122.GA14375@elte.hu> <20070625061819.GA21874@elte.hu> <20070625065956.GA31725@elte.hu> <20070625080521.GA24333@elte.hu> <467FB7C3.1080206@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <467FB7C3.1080206@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.25 08:40:35 -0400, Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
> >* Ingo Molnar <mingo@elte.hu> wrote:
> >
> >  
> >>hm, restoring nmi.c to the v2.6.21 state does not fix the 
> >>nmi_watchdog=2 hang. I'll do a bisection run.
> >>    
> >
> >and after spending an hour on 15 bisection steps:
> >
> > git-bisect start
> > git-bisect good d1be341dba5521506d9e6dccfd66179080705bea
> > git-bisect bad a06381fec77bf88ec6c5eb6324457cb04e9ffd69
> > git-bisect bad 794543a236074f49a8af89ef08ef6a753e4777e5
> > git-bisect good 24a77daf3d80bddcece044e6dc3675e427eef3f3
> > git-bisect bad ea62ccd00fd0b6720b033adfc9984f31130ce195
> > git-bisect good 7e20ef030dde0e52dd5a57220ee82fa9facbea4e
> > git-bisect bad f19cccf366a07e05703c90038704a3a5ffcb0607
> > git-bisect good 0d08e0d3a97cce22ebf80b54785e00d9b94e1add
> > git-bisect bad 856f44ff4af6e57fdc39a8b2bec498c88438bd27
> > git-bisect bad f8822f42019eceed19cc6c0f985a489e17796ed8
> > git-bisect good 1c3d99c11c47c8a1a9ed6a46555dbf6520683c52
> > git-bisect good b239fb2501117bf3aeb4dd6926edd855be92333d
> > git-bisect good 98de032b681d8a7532d44dfc66aa5c0c1c755a9d
> > git-bisect good 42c24fa22e86365055fc931d833f26165e687c19
> >
> >the winner is ...
> >
> > f8822f42019eceed19cc6c0f985a489e17796ed8 is first bad commit
> > commit f8822f42019eceed19cc6c0f985a489e17796ed8
> > Author: Jeremy Fitzhardinge <jeremy@goop.org>
> > Date:   Wed May 2 19:27:14 2007 +0200
> >
> >    [PATCH] i386: PARAVIRT: Consistently wrap paravirt ops callsites to 
> >    make them patchable
> >
> >... our wonderful paravirt subsystem, honed to eternal perfection by the 
> >testing-machine x86_64 tree.
> >
> >reverting -git-curr's paravirt.c, paravirt.h, smp.c and tlbflush.h to 
> >before the bad commit makes the NMI watchdog work again. Patch against 
> >-rc6 is below.
> >  
> 
> Er, wow.  I've been running with this stuff for months without a 
> problem.   Do you have CONFIG_PARAVIRT enabled?  Do you still get the 
> hang if you boot with "noreplace-paravirt" to disable the patching? 

Are you running on AMD hardware? As Intel performance counters are only
32 bits wide, the wrmsrl bug should be a non-issue at least for the NMI
watchdog on Intel hardware. AMD uses 48bit wide performance counters,
which are probably less happy ;-)

Björn
