Return-Path: <linux-kernel-owner+w=401wt.eu-S1764512AbXHVSm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764512AbXHVSm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 14:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761478AbXHVSmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 14:42:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46407 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759573AbXHVSmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 14:42:16 -0400
Date: Wed, 22 Aug 2007 11:41:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stuart_Hayes@Dell.com
cc: david-b@pacbell.net, michal.k.k.piotrowski@gmail.com,
       linux-usb-devel@lists.sourceforge.net, gregkh@suse.de,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dex@dragonslave.de
Subject: RE: [linux-usb-devel] [4/4] 2.6.23-rc3: known regressions
In-Reply-To: <DFEF91B22ED07447AB6AA4B237F913F9B18F2A@ausx3mpc125.aus.amer.dell.com>
Message-ID: <alpine.LFD.0.999.0708221122180.30176@woody.linux-foundation.org>
References: <46C098FD.1030601@googlemail.com>
 <alpine.LFD.0.999.0708202201580.30176@woody.linux-foundation.org>
 <alpine.LFD.0.999.0708202255130.30176@woody.linux-foundation.org>
 <200708202334.38261.david-b@pacbell.net> <alpine.LFD.0.999.0708202348460.30176@woody.linux-foundation.org>
 <alpine.LFD.0.999.0708210016420.30176@woody.linux-foundation.org>
 <alpine.LFD.0.999.0708212026200.30176@woody.linux-foundation.org>
 <DFEF91B22ED07447AB6AA4B237F913F9B18F2A@ausx3mpc125.aus.amer.dell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 22 Aug 2007, Stuart_Hayes@Dell.com wrote:
> 
> If you were running 2.6.26-rc3, that's quite possibly because you didn't
> have the follow-up patch that fixed my original patch... it wasn't in
> 2.6.26-rc3

Well, I was running "current git", and it's never been there. So not just 
a -rc3 issue.

> That could definitely cause mouse lock-ups.  Sorry, that should have
> occurred to me yesterday when you mentioned the problem your kids were
> seeing, but it didn't for some reason.

Btw, could it have caused the USB stack to be *really* confused? Some of 
those mouse lockups ended up also locking the machine hard (ie no ping, no 
nothing), and I'm a bit worried that there was something else going on 
too..

That said, if you can actually re-create the MMF problems, could you 
please try the patch that Arjan suggested? Ie add a

	/*
	 * Some broadcom chips are buggy and can't take more than 5 usec as DMA
	 * latency; inform the rest of kernel of this.
	 */
	if (weird_broadcom_chip())
		set_acceptable_latency("ehci", 5);

to the USB driver, and then add something like

	static inline int cpufreq_acceptable_latency(struct cpufreq_policy *policy)
	{
		unsigned long latency;

		/* Policy latency in usec */
		latency = policy->cpuinfo.transition_latency / 1000;

		if (latency > system_latency_constraint())
			return -EINVAL;

		return 0;
	}

adn then add calls to this from both the "__cpufreq_set_policy()" function 
and the "__cpufreq_driver_target()" one too..

That should disable cpufreq with that broken chip, which is perhaps a big 
draconian, but it's certainly better than having the USB layer know about 
cpufreq internals directly.

In the longer run, I think we can move the "system_latency_constraint()" 
checking from the policy registration into each CPU frequency driver, so 
that it could be more dynamically decide about "can we do it right _now_" 
rather than globally saying "we can't do it with this hardware".

				Linus
