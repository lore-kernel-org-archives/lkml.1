Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab0BQL5s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 06:57:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49429 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873Ab0BQL5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 06:57:47 -0500
Date: Wed, 17 Feb 2010 12:57:41 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Nikita V. Youshchenko" <yoush@cs.msu.su>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Extended error reporting to user space?
Message-ID: <20100217115741.GP21783@one.firstfloor.org>
References: <201002161520.26700@zigzag.lvk.cs.msu.su> <87r5ok5gl2.fsf@basil.nowhere.org> <201002171316.49165@zigzag.lvk.cs.msu.su> <20100217104343.0a1d6813@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100217104343.0a1d6813@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> Thats probably overkill. For almost any ioctl type interface the only
> thing you *need* to make more sense is the address of the field that was
> deemed invalid.

Take a look at all the return -EINVALs in net/sched/sch_cbq.c
and then tell me if you really still believe just knowing the field
is enough to diagnose those. A common issue for example
is if it depends on the current state somehow.

> actually help application code or particularly help interpreters to dig
> into the detail and act themselves to fix a problem or understand it. It
> also costs material amounts of unswappable memory and also disk storage
> for the kernel image on embedded devices.

Trading developer time for a few bytes saved is exactly the wrong
tradeoff, even on a small system.  In principle it could be CONFIGed
of course, but I suspect it wouldn't be worth it (especially
compared to all the other bloat)

> 
> Two other problems text returns bring up or ambiguity and translations -
> its almost impossible to keep them unique even within a big module. It's

For translations the "pragmatic text database" works reasonably well
I think. Also you don't necessarily need them to be unique 
(if the english string is not unique, why would the translation need to be?)

Sure text won't solve all problems either, but it's infinitely 
better than EINVAL.


> also possible to get things like typos in the returned text or
> mis-spellings that you then can't fix because some other app now has
> 
> 	if (strcmp(returned_err, "No such wombat evalueted")==0) {
> 		...
> 	}
> 
> in it. (HTTP 'referer' being a dark warning from history ...)

You could get numbers wrong too. There's really no cure against
that.

But yes it's a good point -- would need to make sure that the spelling
police would direct their efforts elsewhere as much as possible.


> 
> A lot of other systems keep message catalogues often indexed by
> module:error. Text lookups in userspace (easy to do with existing
> interfaces), and the OS providing generic, specific, and identifying
> module info.

That's the IBM approach. I have some doubts it would really work
for a distributed environment like Linux. I believe it has been
even tried already (e.g. there's a Japanese project for such
a catalog). I don't think it works that well.

I think i would prefer just text strings. In principle one
could still develop a convention inside them though.

> 
> I guess the Linux extension to that would end up as
> 
> 	extended_error(&foo->wombats, E_NOT_A_VALID_BREEDING_POPULATION);
> 
> and internally expand to include THIS_MODULE and extract the module name.

Hmm, yes including the module might be reasonable.

> There's another related problem here too - Unix style errors lack the
> ability of some OS systems to report "It worked but ....." which leads to
> interface oddities like termios where it reports "Ok" but you have to
> inpsect the returned structure to see if you got what you requested.

I suspect that's better solved in some way specific to that call.
I don't think it's all that common anyways.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
