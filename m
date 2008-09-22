Return-Path: <linux-kernel-owner+w=401wt.eu-S1752855AbYIVIGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbYIVIGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 04:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYIVIGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 04:06:37 -0400
Received: from mail.atheros.com ([12.36.123.2]:39779 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbYIVIGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 04:06:35 -0400
Date: Mon, 22 Sep 2008 01:06:32 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Steven Noonan <steven@uplinklabs.net>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Senthilkumar Balasubramanian 
	<Senthilkumar.Balasubramanian@atheros.com>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       Johannes Berg <johannes@sipsolutions.net>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27
	(rc5, rc6, probably others)
Message-ID: <20080922080632.GA20446@tesla>
References: <f488382f0809200821m6fe355feu2d9fb99ac3c7f712@mail.gmail.com> <43e72e890809201357y1413a151r85aad7cc16440cf4@mail.gmail.com> <1221944338.3023.8.camel@johannes.berg> <43e72e890809201403w2c4511fdv2fe26bbcf49ccdd7@mail.gmail.com> <f488382f0809201422rdabeff4g435bf3d4a7e9fa3@mail.gmail.com> <43e72e890809201426x61c94bfej2dcda1c178be81b@mail.gmail.com> <f488382f0809201448l21434f11n12311e308f9952d7@mail.gmail.com> <f488382f0809201848w1e59cc19i8235c7c74c44fc10@mail.gmail.com> <20080922065453.GD19580@tesla> <f488382f0809220026u9afa355g1ff2cc7a3fe88333@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f488382f0809220026u9afa355g1ff2cc7a3fe88333@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 12:26:02AM -0700, Steven Noonan wrote:
> On Sun, Sep 21, 2008 at 11:54 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Sat, Sep 20, 2008 at 06:48:05PM -0700, Steven Noonan wrote:
> >>
> >> OK, here's the time index at which it b0rked:
> >>
> >> 18:28:42          sum   1155.00
> >> 18:28:43          sum   1339.00
> >> 18:28:44          sum  18355.00
> >> 18:28:45          sum  17845.45
> >>
> >> And the entire log of the minute 18:28 is here:
> >> http://www.uplinklabs.net/~tycho/linux/18.28.00-59.log.gz
> >>
> >> It looks pretty crazy.
> >
> > Thanks, I'll take a look when I get a chance (remember aggretion
> > is in the queue too) unless someone beats me to it.
> >
> 
> You may want to take a quick look at it now. 

Its Sunday night and I am looking at it :)

> I certainly don't mean
> you should push aggregation aside, 

Trust me I want to get this resolved too ;)

> but the log looks kind of screwy at
> 18:28:43 (look at line 4972 to see what I mean). It looks as though it
> did printk()s from multiple threads with no locking mechanism. It's
> possible I will need to re-capture the error, and I'd like to know if
> this log will help or not.

At first glance I see tons of MIB interrupts being spewed, besides the
ackward prints you see too my main concern so far is the MIB interrupts
as we don't handle ANI. My initial thought is because don't hanld ANI
yet we are letting MIB interrupts to continue to spew out.

  Luis

Please test the following patch.

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index c262ef2..9a51739 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -681,10 +681,12 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	 * Enable MIB interrupts when there are hardware phy counters.
 	 * Note we only do this (at the moment) for station mode.
 	 */
+#if 0
 	if (ath9k_hw_phycounters(ah) &&
 	    ((sc->sc_ah->ah_opmode == ATH9K_M_STA) ||
 	     (sc->sc_ah->ah_opmode == ATH9K_M_IBSS)))
 		sc->sc_imask |= ATH9K_INT_MIB;
+#endif
 	/*
 	 * Some hardware processes the TIM IE and fires an
 	 * interrupt when the TIM bit is set.  For hardware
