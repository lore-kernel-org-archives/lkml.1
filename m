Return-Path: <linux-kernel-owner+w=401wt.eu-S1763808AbXEWUWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763808AbXEWUWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 16:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757524AbXEWUWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 16:22:31 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:52788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757446AbXEWUWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 16:22:30 -0400
Date: Wed, 23 May 2007 13:20:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: Robert Hancock <hancockr@shaw.ca>, Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
In-Reply-To: <200705231152.57796.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LFD.0.98.0705231257050.3890@woody.linux-foundation.org>
References: <4635510D.4060103@shaw.ca> <200705221738.09571.jbarnes@virtuousgeek.org>
 <46539378.6000508@shaw.ca> <200705231152.57796.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 May 2007, Jesse Barnes wrote:
> 
> Fixed it (finally).  I don't think moving the 64 bit probing around 
> would make a difference, since we'd restore its original value anyway 
> before moving on to the 32 bit probe which is where I think the problem 
> is.

Well, the thing is, I'm pretty sure there is at least one northbridge that 
stops memory accesses from the CPU when you turn off the MEM bit on it. 
Oops, you just killed the machine.

Looking at the 925X datasheet (which I happened to have around in my 
google search history because of the discussions of the sky2 DMA 
problems), it looks like at least that one just hardcodes the MEM bit to 
be 1, and thus writing to it is a total no-op.

But I really think that clearing the MEM bit for at least the host bridge 
is conceptually quite wrong, even if it might turn out that all chipsets 
end up just saying (like Intel) "screw it, the user is insane, we're not 
going to actually do what he asks us to do".

Do we really want to be that insane? Turn off memory accesses when probing 
the CPU host bridge?

So at a _minimum_ I would say that that thing needs to be more careful 
about host bridges. Maybe it's not needed, who knows? 

> Linus, since you were the one concerned about breaking working setups, 
> what do you think?  Should we use this approach, or specifically quirk 
> out cases where mmconfig space might conflict with BAR probing?

So see above. I think at a minimum, we should consider the host bridge 
special.

I also suspect that we'd be simply better off if we didn't use mmconfig at 
all unless we _have_ to. Why use mmconfig for the standard BAR accesses? 
Is there really any reason? I can understand using it for extended config 
space, since then the old-fashioned approach won't work. But for normal 
accesses? What's the point, really?

mmconfig seems to be fundamentally designed to be impossible to bootstrap 
off, so there's no way you can have a machine that _only_ supports 
mmconfig. So why do people seem to think it's so wonderful? Please fill me 
in on this fundamental mystery.

Quite frankly, if we just didn't use mmconfig, the whole issue would go 
away. Isn't _that_ the much better solution?

		Linus
