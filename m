Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbYJZS6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbYJZS6a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 14:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbYJZS6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 14:58:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752964AbYJZS6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 14:58:22 -0400
Date: Sun, 26 Oct 2008 11:58:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davidel@xmailserver.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: kerneloops.org: 2.6.28-rc regression in epoll (list
 corruption)
In-Reply-To: <20081026112920.28e7dccc@infradead.org>
Message-ID: <alpine.LFD.2.00.0810261141350.5200@nehalem.linux-foundation.org>
References: <20081026112920.28e7dccc@infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 26 Oct 2008, Arjan van de Ven wrote:
>
> This one is upcoming fast (and I just hit it as well)
> 
> http://www.kerneloops.org/searchweek.php?search=ep_poll_callback
> 
> seems epoll grew some list corruption....

It sounds very much like f337b9c58332bdecde965b436e47ea4c94d30da0 ("epoll: 
drop unnecessary test") deleted a test that wasn't so unnecessary after 
all..

That ep_poll_callback() code is:

        /* If this file is already in the ready list we exit soon */
        if (ep_is_linked(&epi->rdllink))
                goto is_linked;

        list_add_tail(&epi->rdllink, &ep->rdllist);

and the unnecessary test that was removed looks _very_ much like that kind 
of code.

Thomas? Davide?

And if somebody knows how to reproduce this reliably, it would be really 
good to hear if doing a revert on that thing just fixed it. It should 
revert cleanly - it's the only change to fs/eventpoll.c since 2.6.27.

I'm somewhat inclined to revert it without even getting confirmation, 
since I wanted to do an early -rc2 today with all the brown-paper-bag 
fixes that have accumulated. But it would be good to get some 
confirmation.

Btw, that whole logic in ep_send_events() sounds a bit scary. It says:

	We can loop without lock because this is a task private list.

and it's true that "txlist" is a private list, but it still seems to 
depend on the fact that none of the "struct epitem"s on that list can be 
reached by any other means. And that whole thing depends on the magic 
behaviour of 'ep->ovflist', but there are a lot of code sequences that do 
*not* seem to test that at all.

Maybe the rqace/bug has always been there (ie some sequence that works 
with an "epi->rdllink" without checking ovflist), but the "unnecessary" 
test protected us from seeing it in practice.

			Linus
