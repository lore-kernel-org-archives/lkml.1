Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbZBCTU5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbZBCTU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 14:20:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbZBCTUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 14:20:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752239AbZBCTUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 14:20:44 -0500
Date: Tue, 3 Feb 2009 11:19:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jesse Barnes <jesse.barnes@intel.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Schwab <schwab@suse.de>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Reworking suspend-resume sequence (was: Re: PCI PM: Restore
 standard config registers of all devices early)
In-Reply-To: <alpine.LFD.2.00.0902031047320.3247@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0902031114321.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902031804.26752.rjw@sisk.pl> <alpine.LFD.2.00.0902030955370.3247@localhost.localdomain> <200902031032.26771.jesse.barnes@intel.com> <alpine.LFD.2.00.0902031033310.3247@localhost.localdomain>
 <alpine.LFD.2.00.0902031047320.3247@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Linus Torvalds wrote:
> 
> Hmm. The _normal_ simple irq handler does this the way I described, but 
> for some reason the "handle_edge_irq()" does not. And the reason is 
> actually a buglet: it needs to mask things for the "recursive interrupt" 
> case.

Btw, just to clarify: none of this happens at the actual "irq_disable()" 
time: it only happens if you get an interrupt _while_ it's disabled. Which 
obviously shouldn't happen in the shutdown/wakeup path anyway for MSI, 
since the interrupts aren't shared, but it would be good to just be extra 
safe.

I do suspect we could/should just get rid of the msi masking entirely, but 
that may be too scary a step.

For the current suspend/resume situation, maybe it's enough to know that 
it shouldn't be happening anyway, and even if it _does_ happen on a device 
that has been shut down, it's just not going to do anything. Sure, it's 
doing that "writel/readl", but if it gets lost, who really cares? Nobody.

			Linus
