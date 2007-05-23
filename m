Return-Path: <linux-kernel-owner+w=401wt.eu-S1761769AbXEWXFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761769AbXEWXFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 19:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbXEWXFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 19:05:25 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:44854 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797AbXEWXFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 19:05:23 -0400
Date: Wed, 23 May 2007 17:04:58 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard
 resources
In-reply-to: <alpine.LFD.0.98.0705231257050.3890@woody.linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Olivier Galibert <galibert@pobox.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Message-id: <4654C89A.9000604@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <4635510D.4060103@shaw.ca>
 <200705221738.09571.jbarnes@virtuousgeek.org> <46539378.6000508@shaw.ca>
 <200705231152.57796.jbarnes@virtuousgeek.org>
 <alpine.LFD.0.98.0705231257050.3890@woody.linux-foundation.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Wed, 23 May 2007, Jesse Barnes wrote:
>> Fixed it (finally).  I don't think moving the 64 bit probing around 
>> would make a difference, since we'd restore its original value anyway 
>> before moving on to the 32 bit probe which is where I think the problem 
>> is.
> 
> Well, the thing is, I'm pretty sure there is at least one northbridge that 
> stops memory accesses from the CPU when you turn off the MEM bit on it. 
> Oops, you just killed the machine.

Which is retarded, since the command bits are only supposed to be for 
memory ranges that are part of the BARs, it's not supposed to completely 
kill the device function. Unless somehow the memory on that system is 
accessed through the PCI bus or something. Anyway, it's something we 
have to deal with.

> 
> Looking at the 925X datasheet (which I happened to have around in my 
> google search history because of the discussions of the sky2 DMA 
> problems), it looks like at least that one just hardcodes the MEM bit to 
> be 1, and thus writing to it is a total no-op.
> 
> But I really think that clearing the MEM bit for at least the host bridge 
> is conceptually quite wrong, even if it might turn out that all chipsets 
> end up just saying (like Intel) "screw it, the user is insane, we're not 
> going to actually do what he asks us to do".
> 
> Do we really want to be that insane? Turn off memory accesses when probing 
> the CPU host bridge?
> 
> So at a _minimum_ I would say that that thing needs to be more careful 
> about host bridges. Maybe it's not needed, who knows? 

I think we should likely avoid disabling the command bits on host 
bridges (maybe any bridge) due to this risk of disabling something that 
will break things. Ideally we can get around this without doing any 
disabling at all, as noted in my last email.

> 
>> Linus, since you were the one concerned about breaking working setups, 
>> what do you think?  Should we use this approach, or specifically quirk 
>> out cases where mmconfig space might conflict with BAR probing?
> 
> So see above. I think at a minimum, we should consider the host bridge 
> special.
> 
> I also suspect that we'd be simply better off if we didn't use mmconfig at 
> all unless we _have_ to. Why use mmconfig for the standard BAR accesses? 
> Is there really any reason? I can understand using it for extended config 
> space, since then the old-fashioned approach won't work. But for normal 
> accesses? What's the point, really?

Why not? Either you trust that the MMCONFIG is working or you don't. If 
you trust it, you might as well use it for everything, and if you don't, 
you can't risk using it for anything. If there are problems that show up 
  only with MMCONFIG, doing what you propose would simply cover them up 
until somebody actually tried accessing extended config space.

> mmconfig seems to be fundamentally designed to be impossible to bootstrap 
> off, so there's no way you can have a machine that _only_ supports 
> mmconfig. So why do people seem to think it's so wonderful? Please fill me 
> in on this fundamental mystery.

Sure you can bootstrap off it, you just need to have some way to know 
where to find it (either ACPI or some other system-specific mechanism).

> 
> Quite frankly, if we just didn't use mmconfig, the whole issue would go 
> away. Isn't _that_ the much better solution?

I don't think that is going to be viable in the long run now that 
Windows Vista is out and MS is actually encouraging HW developers to 
allow using that config space..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

