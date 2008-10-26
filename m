Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbYJZTgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbYJZTgW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 15:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYJZTgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 15:36:14 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:53441 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbYJZTgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 15:36:13 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 26 Oct 2008 12:35:55 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: kerneloops.org: 2.6.28-rc regression in epoll (list corruption)
In-Reply-To: <alpine.LFD.2.00.0810261141350.5200@nehalem.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0810261225220.19212@alien.or.mcafeemobile.com>
References: <20081026112920.28e7dccc@infradead.org>
 <alpine.LFD.2.00.0810261141350.5200@nehalem.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Oct 2008, Linus Torvalds wrote:

> 
> 
> On Sun, 26 Oct 2008, Arjan van de Ven wrote:
> >
> > This one is upcoming fast (and I just hit it as well)
> > 
> > http://www.kerneloops.org/searchweek.php?search=ep_poll_callback
> > 
> > seems epoll grew some list corruption....
> 
> It sounds very much like f337b9c58332bdecde965b436e47ea4c94d30da0 ("epoll: 
> drop unnecessary test") deleted a test that wasn't so unnecessary after 
> all..
> 
> That ep_poll_callback() code is:
> 
>         /* If this file is already in the ready list we exit soon */
>         if (ep_is_linked(&epi->rdllink))
>                 goto is_linked;
> 
>         list_add_tail(&epi->rdllink, &ep->rdllist);
> 
> and the unnecessary test that was removed looks _very_ much like that kind 
> of code.

No, the test was in the re-insertion loop. This is the patch that fixes it:

---
 fs/eventpoll.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: linux-2.6.mod/fs/eventpoll.c
===================================================================
--- linux-2.6.mod.orig/fs/eventpoll.c	2008-10-17 15:51:09.000000000 -0700
+++ linux-2.6.mod/fs/eventpoll.c	2008-10-17 15:54:14.000000000 -0700
@@ -930,8 +930,15 @@
 	 * inside the main ready-list here.
 	 */
 	for (nepi = ep->ovflist; (epi = nepi) != NULL;
-	     nepi = epi->next, epi->next = EP_UNACTIVE_PTR)
-		list_add_tail(&epi->rdllink, &ep->rdllist);
+	     nepi = epi->next, epi->next = EP_UNACTIVE_PTR) {
+		/*
+		 * If the above loop quit with errors, the epoll item might still
+		 * be linked to "txlist", and the list_splice() done below will
+		 * take care of those cases.
+		 */
+		if (!ep_is_linked(&epi->rdllink))
+			list_add_tail(&epi->rdllink, &ep->rdllist);
+	}
 	/*
 	 * We need to set back ep->ovflist to EP_UNACTIVE_PTR, so that after
 	 * releasing the lock, events will be queued in the normal way inside



> And if somebody knows how to reproduce this reliably, it would be really 
> good to hear if doing a revert on that thing just fixed it. It should 
> revert cleanly - it's the only change to fs/eventpoll.c since 2.6.27.

That's 100% due to the removed test that went in when you sucked up Andrew 
bits after .27.
Patch has been confirmed by me and bug submitters.




> I'm somewhat inclined to revert it without even getting confirmation, 
> since I wanted to do an early -rc2 today with all the brown-paper-bag 
> fixes that have accumulated. But it would be good to get some 
> confirmation.

No need to revert, since one of the removed tests is really un-needed.




> Btw, that whole logic in ep_send_events() sounds a bit scary. It says:
> 
> 	We can loop without lock because this is a task private list.
> 
> and it's true that "txlist" is a private list, but it still seems to 
> depend on the fact that none of the "struct epitem"s on that list can be 
> reached by any other means. And that whole thing depends on the magic 
> behaviour of 'ep->ovflist', but there are a lot of code sequences that do 
> *not* seem to test that at all.
> 
> Maybe the rqace/bug has always been there (ie some sequence that works 
> with an "epi->rdllink" without checking ovflist), but the "unnecessary" 
> test protected us from seeing it in practice.

No. Bug was introduced by the removed test. Thomas contacted me telling 
that such test was un-needed, and at first sight it looked OK to drop it 
(since during the loop time the callback inserts into 'ep->ovflist').
But we didn't notice that a premature loop exit might leave items linked 
to 'txlist', that the splice below takes care of re-insert them.
You can speed up things by sucking the patch directly, w/out waiting 
Andrew's pull.




- Davide


