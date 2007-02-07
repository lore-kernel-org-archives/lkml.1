Return-Path: <linux-kernel-owner+w=401wt.eu-S933300AbXBGCJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300AbXBGCJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 21:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965223AbXBGCJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 21:09:30 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59086 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933300AbXBGCJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 21:09:29 -0500
Date: Tue, 6 Feb 2007 18:09:07 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
In-Reply-To: <1170808679.29759.1081.camel@pmac.infradead.org>
Message-ID: <Pine.LNX.4.64.0702061757420.8424@woody.linux-foundation.org>
References: <1170801484.29759.1000.camel@pmac.infradead.org> 
 <Pine.LNX.4.64.0702061451560.8424@woody.linux-foundation.org> 
 <1170803515.29759.1032.camel@pmac.infradead.org> 
 <Pine.LNX.4.64.0702061516110.8424@woody.linux-foundation.org> 
 <1170804983.29759.1051.camel@pmac.infradead.org> 
 <Pine.LNX.4.64.0702061550010.8424@woody.linux-foundation.org> 
 <1170806622.29759.1063.camel@pmac.infradead.org> 
 <Pine.LNX.4.64.0702061615480.8424@woody.linux-foundation.org>
 <1170808679.29759.1081.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Feb 2007, David Woodhouse wrote:
> 
> I think 'make oldconfig_noselect' is the way forward. We can both have
> what we want.

Actually, I think there might be an even more interesting schenario.

The Kconfig language right not is ternary, which is fine as an arithmetic, 
but the problem *may* be that we actually want it to be more expressive.

If instead of a ternary "y/m/n" calculus, we would use a "Y/y/m/n/N" 
quinary logic, where "Y" and "N" are like "force on/off", you might have 
the following:

	"y + depends on => n"
	"Y + depends on => Y, and the depends on to Y too"
	"n/N + depends on => n"

	"y/Y + selected => y"
	"n + select => y"
	"N + select => N, and the select to N"

In other words, "Y" means "force to Y, even if it has a dependency (which 
we'll also have to force", while "N" means "force to N, even if it is 
getting selected, in which case the selection will also be forced to N").

So then you can say things like

 - edit .config, and set *any* value to "Y", and it will force-enable 
   anything that that depends on when you run "make oldconfig", even if it 
   was an "depends on"

 - edit .config, and set *any* value to "N", and it fill force-disable 
   anything that selects that when you you run "make oldconfig"

The problem here is that:

 - you can get inconsistent situations ("but he wanted to both force that 
   on *and* off!")

 - "select" actually is much nicer, in that it unambiguously selects one 
   other symbol. But "depends on" is very hard to force, because you may 
   have something like (totally made up)

	depends on X86 || (ALPHA && PCI)

   which is impossible to force (*which* one do you force?) on.

but something like this would be nice for both the text-based "make 
oldconfig" kind of thing *and* for any graphical configuration things 
("dammit, I want this OFF, when I press the force-off-buffon you turn 
anything off that needs it!")

But the two problems above might make it impractical..

			Linus
