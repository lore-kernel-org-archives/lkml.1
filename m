Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbYFITZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbYFITZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbYFITZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:25:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54026 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbYFITZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:25:37 -0400
Date: Mon, 9 Jun 2008 21:24:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, Daniel Barkalow <barkalow@iabervon.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>, Matthew Wilcox <matthew@wil.cx>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NetDev <netdev@vger.kernel.org>,
       e1000-list <e1000-devel@lists.sourceforge.net>,
       linux-pci maillist <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>, Greg KH <greg@kroah.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [patch] e1000=y && e1000e=m regression fix
Message-ID: <20080609192457.GA28816@elte.hu>
References: <20080411112653.GC9205@elte.hu> <20080411113644.GA7767@infradead.org> <20080411121606.GA25661@elte.hu> <47FF9060.5040202@intel.com> <20080411164542.GA4066@infradead.org> <alpine.LFD.1.00.0804111028540.3143@woody.linux-foundation.org> <alpine.LNX.1.00.0804111700550.19665@iabervon.org> <alpine.LFD.1.00.0804111556200.3143@woody.linux-foundation.org> <47FFF7B5.3000609@garzik.org> <alpine.LFD.1.00.0804131410340.2982@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0804131410340.2982@woody.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 11 Apr 2008, Jeff Garzik wrote:
> > Linus Torvalds wrote:
> > > .. but that said, I think your patch is certainly better than what we have
> > > now (or what Ingo was complaining about for the next merge window). I
> > > certainly could live with it. I would just suggest against ever then
> > > removing that "generic E1000" choice.
> > 
> > You mean never ever remove PCI-E support from e1000?
> 
> No. I mean never ever remove the *configure* level thinking that 
> "e1000 is e1000".
> 
> There is no sense in *ever* showing it as two drivers to users, 
> because users do not see them as separate chipsets. They look 
> identical, down to the part names.
> 
> If it's a single family, and users can't even easily tell whether they 
> have version 1 or version 2 (PCI vs PCI-E), you shouldn't even ask 
> them. You should literally ask them: "do you want e1000 support".
> 
> That's it.
> 
> Once you have asked them that, you can then decide "ok, if you 
> *really* know what version of the chip you have, you can decide to 
> only get limited driver support".
> 
> But that's a secondary thing from a user perspective.
> 
> See the patch I already sent out.

btw., in the last 2-3 months i've hit this bug about a dozen times, on 
various test-systems i have. And i just hit it a minute ago again, 
reminding me of this open issue, with such a config:

 CONFIG_E1000=y
 # CONFIG_E1000_NAPI is not set
 CONFIG_E1000_DISABLE_PACKET_SPLIT=y
 CONFIG_E1000E=y
 CONFIG_E1000E_ENABLED=y

Every time this bug hits i lose about 30 minutes of testing (sometimes 
hours of it, because my testing stalls) and once it took half an hour of 
head-scratching to notice that the bl**dy CONFIG_E1000E_ENABLED=y again 
was killing the e1000 driver i rely on having.

With up to 10 test-systems and a healthy mix of old and new distros it's 
just not realistic to reconfigure all those distros to use e1000e. 
(Also, i frequently have to bisect back into older kernels and have 
scripting to make this work most of the time - if i standardized on 
e1000e i'd lose the ability to do automated bisection.)

i have a patch that undoes this e1000 damage but sometimes i forget to 
apply it and then the bug can hit me. Whoever thinks that this isnt a 
problem in practice hasnt been doing a lot of systematic testing. It's 
quite a PITA and it's still not fixed upstream. (and it's not eligible 
for the v2.6.26 regression list anymore as it got introduced in v2.6.25)

	Ingo
