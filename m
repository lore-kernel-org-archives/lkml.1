Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbYJCStn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbYJCStn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 14:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYJCSte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 14:49:34 -0400
Received: from mail.atheros.com ([12.36.123.2]:48217 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbYJCStd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 14:49:33 -0400
Date: Fri, 3 Oct 2008 04:49:21 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Noonan <steven@uplinklabs.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k: panic on tip/master
Message-ID: <20081003114921.GG5964@tesla>
References: <f488382f0810030256x2859fbf6j3f657621c567287f@mail.gmail.com> <20081003100211.GA29841@elte.hu> <20081003153523.GC3368@tuxdriver.com> <20081003180930.GD3368@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081003180930.GD3368@tuxdriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2008 at 11:09:31AM -0700, John W. Linville wrote:
> On Fri, Oct 03, 2008 at 11:35:23AM -0400, John W. Linville wrote:
> > On Fri, Oct 03, 2008 at 12:02:11PM +0200, Ingo Molnar wrote:
> > >
> > > * Steven Noonan <steven@uplinklabs.net> wrote:
> > >
> > > > Hey folks,
> > > >
> > > > Just got a panic on tip. According to the stack trace, ath9k is what
> > > > decided to bomb.
> > > >
> > > > http://www.uplinklabs.net/~tycho/linux/ath9k_panic_tip_10.3.2008.jpg
> > > >
> > > > Note: Although it says 'sudo modprobe radeon' on the bash prompt above
> > > > the panic, I never got to hit 'enter' on that command before the panic
> > > > occurred.
> > >
> > > it appears to me that ath9k's eth_rx_input() takes a spinlock that is
> > > not initialized (or already destroyed by the allocator).
> >
> > Seems reasonable...
> >
> > > this would be consistent with an IRQ storm hitting some race in the
> > > ath9k driver init sequence. For example if request_irq() is done before
> > > all structures that the IRQ handler relies on are properly initialized.
> > >
> > > i.e. this has the signature of a genuine ath9k bug.
> >
> > Agreed, although I don't see anything specifically relating to
> > request_irq or the like.
> >
> > I think the spin_lock call may actually be in ath_ampdu_input (called
> > from ath_rx_input), which perhaps is getting called simultaneous
> > with ath_rx_node_init still running?  With no locks in between them,
> > it seems like this could be the culprit?
> >
> > Sorry to not be more immediately helpful, but I'm going to have to
> > run in a few minutes.  Perhaps this insight is helpful for someone
> > more familiar with the internals of this driver?
> 
> This is probably a dead-end...I don't think the ath_node_find
> in ath__rx_indicate will be able to find the ath_node used
> in ath_ampdu_input unless ath_rx_node_init had already complete.
> Back to square one...

Well Steven, please give this a shot, we think this is the culprit.

[PATCH] ath9k: fix oops on trying to hold the wrong spinlock

We were trying to hold the wrong spinlock due to a typo
on IEEE80211_BAR_CTL_TID_S's definition. We use this to
compute the tid number and then hold this this tid number's
spinlock during ath_bar_rx().

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 2f84093..88f4cc3 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -316,7 +316,7 @@ void ath_descdma_cleanup(struct ath_softc *sc,
 #define ATH_RX_TIMEOUT           40      /* 40 milliseconds */
 #define WME_NUM_TID              16
 #define IEEE80211_BAR_CTL_TID_M  0xF000  /* tid mask */
-#define IEEE80211_BAR_CTL_TID_S  2       /* tid shift */
+#define IEEE80211_BAR_CTL_TID_S  12      /* tid shift */
 
 enum ATH_RX_TYPE {
 	ATH_RX_NON_CONSUMED = 0,
-- 
1.5.6.3

