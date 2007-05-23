Return-Path: <linux-kernel-owner+w=401wt.eu-S1762414AbXEWUu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762414AbXEWUu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 16:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756837AbXEWUuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 16:50:14 -0400
Received: from outbound-mail-75.bluehost.com ([69.89.20.10]:38714 "HELO
	outbound-mail-75.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755148AbXEWUuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 16:50:12 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Wed, 23 May 2007 13:49:55 -0700
User-Agent: KMail/1.9.6
Cc: Robert Hancock <hancockr@shaw.ca>, Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca> <200705231152.57796.jbarnes@virtuousgeek.org> <alpine.LFD.0.98.0705231257050.3890@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705231257050.3890@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705231349.56976.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 23, 2007 1:20 pm Linus Torvalds wrote:
> On Wed, 23 May 2007, Jesse Barnes wrote:
> > Fixed it (finally).  I don't think moving the 64 bit probing around
> > would make a difference, since we'd restore its original value
> > anyway before moving on to the 32 bit probe which is where I think
> > the problem is.
>
> Well, the thing is, I'm pretty sure there is at least one northbridge
> that stops memory accesses from the CPU when you turn off the MEM bit
> on it. Oops, you just killed the machine.

Wow, that sounds like a pretty lame host bridge.

> Looking at the 925X datasheet (which I happened to have around in my
> google search history because of the discussions of the sky2 DMA
> problems), it looks like at least that one just hardcodes the MEM bit
> to be 1, and thus writing to it is a total no-op.
>
> But I really think that clearing the MEM bit for at least the host
> bridge is conceptually quite wrong, even if it might turn out that
> all chipsets end up just saying (like Intel) "screw it, the user is
> insane, we're not going to actually do what he asks us to do".
>
> Do we really want to be that insane? Turn off memory accesses when
> probing the CPU host bridge?
>
> So at a _minimum_ I would say that that thing needs to be more
> careful about host bridges. Maybe it's not needed, who knows?

I'm not sure either, but the PCI spec is pretty clear about how probing 
ought to be done, and it seems that other OSes do the disabling (though 
I'm not sure about how they handle broken host bridges like the one you 
mention).

> I also suspect that we'd be simply better off if we didn't use
> mmconfig at all unless we _have_ to. Why use mmconfig for the
> standard BAR accesses? Is there really any reason? I can understand
> using it for extended config space, since then the old-fashioned
> approach won't work. But for normal accesses? What's the point,
> really?

Yeah, it's mainly needed for extended config space and PCIe (lots of 
regular PCIe features are in the extended space and are assumed to be 
accessible).

> mmconfig seems to be fundamentally designed to be impossible to
> bootstrap off, so there's no way you can have a machine that _only_
> supports mmconfig. So why do people seem to think it's so wonderful?
> Please fill me in on this fundamental mystery.

Well, non-x86 people I think are fairly used to it, for one.

> Quite frankly, if we just didn't use mmconfig, the whole issue would
> go away. Isn't _that_ the much better solution?

Not for systems with PCIe...  and the platforms I've been having trouble 
with have PCIe slots, so I'd really like mmconfig to be used at least 
on machines with PCIe bridges.  For other machines, it probably doesn't 
matter much.  I don't know of any regular PCI devices offhand that 
really need extended config space.

Jesse
