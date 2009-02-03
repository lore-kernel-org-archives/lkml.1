Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbZBCTDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbZBCTDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 14:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbZBCTDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 14:03:39 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751525AbZBCTDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 14:03:38 -0500
Date: Tue, 3 Feb 2009 11:03:04 -0800 (PST)
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
In-Reply-To: <alpine.LFD.2.00.0902031033310.3247@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0902031047320.3247@localhost.localdomain>
References: <200901261904.n0QJ4Q9c016709@hera.kernel.org> <200902031804.26752.rjw@sisk.pl> <alpine.LFD.2.00.0902030955370.3247@localhost.localdomain> <200902031032.26771.jesse.barnes@intel.com> <alpine.LFD.2.00.0902031033310.3247@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Feb 2009, Linus Torvalds wrote:
>
> That said, we've also never had much reason to _care_ deeply, so it's also 
> possible that we do mask things over some path. I didn't actually walk 
> _all_ the paths, and the logic for irq handling has changed enough over 
> the years that I don't know all the paths any more. Maybe we do that 
> explicit mask in some path I missed. We _shouldn't_, but who knows..

Ok, so I decided to actually try to walk it all. Better look at the actual 
code.

Hmm. The _normal_ simple irq handler does this the way I described, but 
for some reason the "handle_edge_irq()" does not. And the reason is 
actually a buglet: it needs to mask things for the "recursive interrupt" 
case.

But that literally just looks like a small implementation detail (the code 
decided to share the code for IRQ_INPROGRESS and IRQ_DISABLED). We should 
fix it, so that you _can_ disable irqs and not have to worry about this 
all.

I'm really not sure why that handle_edge_irq thing uses "ack_and_mask()" 
instead of just "desc->chip->ack()"? I'm also totally flummoxed as to why 
it feels it needs to go all the way out to the device to mask things, 
instead of just masking at an apic level, which is much simpler and faster 
(especially since masking should never happen in practice anyway).

			Linus
