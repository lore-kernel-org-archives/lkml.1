Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbXJ3RIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbXJ3RIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbXJ3RII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:08:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34304 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751051AbXJ3RIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:08:06 -0400
Date: Tue, 30 Oct 2007 10:07:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: Robert Hancock <hancockr@shaw.ca>, Greg KH <greg@kroah.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, akpm@linux-foundation.org,
       ak@suse.de, rajesh.shah@intel.com,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pci-disable-decode-of-io-memory-during-bar-sizing.patch
In-Reply-To: <20071030094756.779ac5c0@laptopd505.fenrus.org>
Message-ID: <alpine.LFD.0.999.0710300957260.30120@woody.linux-foundation.org>
References: <200708151919.l7FJJfUE010966@imap1.linux-foundation.org>
 <200710251622.36773.jbarnes@virtuousgeek.org> <20071026025407.GA21408@kroah.com>
 <200710260959.46811.jbarnes@virtuousgeek.org> <20071027024140.GC29039@kroah.com>
 <47267232.3020506@shaw.ca> <alpine.LFD.0.999.0710300811230.30120@woody.linux-foundation.org>
 <20071030094756.779ac5c0@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Oct 2007, Arjan van de Ven wrote:
> 
> the problem is... you're not supposed to mix both types of accesses.

You have to, anyway. Even now the MMCONFIG stuff uses CONF1 cycles for 
startup.

Also, there's reason to believe that mixing things up _has_ to work 
anyway, and if the issue is between "works in practice" and "theory says 
that you shouldn't mix", I'll take practice every time.

Especially since we *know* that the theory is broken. Right now MMCONFIG 
is effectively disabled very aggressively because it's simply unusably 
flaky. So the choice is between:

 - don't use MMCONFIG at all, because it has so many problems
 - use MMCONFIG sparingly enough to hide the problems

and what "you're supposed to do" is simply trumped by Real Life(tm). 
Because Intel screwed up so badly when they designed that piece of shit.

(Where "screwed up badly" is the usual "left it to firmware people" thing, 
of course. Dammit, Intel *could* have just made it a real PCI BAR in the 
Northbridge, and specified it as such, and we wouldn't have these 
problems! But no, it had to be another idiotic "firmware tells where it 
is" thing)

> > The fact is, CONF1 style accesses are just safer, and *work*. 
> 
> I would suggest a slight twist then: use CONF1 *until* you're using
> something above 256, and then and only then switch to MMCONFIG from
> then on for all accesses.

No.

Maybe if you do it per-device, and only *after* probing (ie we have seen 
multiple, and successful, accesses), but globally, absolutely not. That 
would be useless. The bugs we have had in this area have been exactly the 
kinds of things like "we don't know the real size of the MMCONFIG areas" 
etc.

I could easily see device driver writers probing to see if something 
works, and I absolutely don't think we should just automatically enable 
MMCONFIG from then on.

But maybe we could have a per-device flag that a driver *can* set. Ie have 
the logic be:

 - use MMCONFIG if we have to (reg >= 256)

OR

 - use MMCONFIG if the driver specifically asked us to

and then drivers that absolutely need it, and know they do, can set that 
flag. Preferably after they actually verified that it works.

That way you _can_ get the "this is how you're supposed to do it" 
behaviour, but you get it when there is a reasonable chance that it 
actually works.

And quite frankly, if you're not supposed to mix these things even across 
devices, then I think we are better off just doing what we effectively do 
now: mostly ignore the damn thing because it's too broken to use.

Maybe somebody inside Intel could just clarify the documentation, and 
change it from "you're not supposed to mix" to "mix all you want". 

		Linus
