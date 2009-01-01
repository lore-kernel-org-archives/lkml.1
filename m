Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbZAANlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbZAANlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 08:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbZAANlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 08:41:06 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:48185 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169AbZAANlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 08:41:05 -0500
Date: Thu, 1 Jan 2009 14:41:00 +0100
From: Andreas Mohr <andi@lisas.de>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, Andreas Mohr <andi@lisas.de>,
       ath5k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org
Subject: Re: [ath5k-devel] Bugs on aspire one A150
Message-ID: <20090101134100.GA4819@rhlx01.hs-esslingen.de>
References: <1230641016.5770.5.camel@maxim-laptop> <20081231091845.GA2516@rhlx01.hs-esslingen.de> <20081231140308.GA26600@hash.localnet> <1230742291.26499.22.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230742291.26499.22.camel@maxim-laptop>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Dec 31, 2008 at 06:51:31PM +0200, Maxim Levitsky wrote:
> On Wed, 2008-12-31 at 09:03 -0500, Bob Copeland wrote:
> > On Wed, Dec 31, 2008 at 10:18:45AM +0100, Andreas Mohr wrote:
> > > Hi,
> > > 
> > > > Sure, will test, I am also sure that this will work.
> > > 
> > > A110L, 2.6.28, success (also inverted here, traffic blanks it).
> > 
> > Thanks for testing.
> > 
> > By inverted, do you mean that it is off when it should be on and
> > vice-versa?  If so, you can change it to 'sc->led_on = 0' instead
> > of 1.  Let me know if I should make that change in the patch.
> > 
> 
> Actually, I even thought that this is right behavior, here on iwl3945
> led is always on, and blinks while traffic is send, also same on
> windows, but feel free to invert the polarity.

It's not:
Inversion of the led_on flag does make LED state work properly
and is the right thing to do since an LED
_as seen by the authoritative LED layer_
__has__ to have proper on/off configuration,
regardless of whether having a WLAN LED on-by-default and
off-on-traffic _in the WLAN layer_ is desireable.
(witness wrong state of default-on and heartbeat triggers)

Or, IOW: logical state has to be maintained properly,
at _each layer_ that is involved.

> What does bother me is, that led state gets inverted dynamically, that
> is system starts with default 'led always on', but after some time
> switches to 'always led off' and after sometime again switches back.
> This does seem to be software problem, at least according to sysfs
> interace.

linux/net/mac80211/led.c/ieee80211_led_rx() does simple on/off alternation
via a counter increment modulo, thus somewhat weird LED state toggling
does seem a natural outcome given the current implementation.

I believe the 80211 layer itself should provide some generic LED
handling which then provide for reliable and _identical_ displaying of
WLAN LEDs. It's not a good idea to have individual drivers
mess with custom rssi-indicating LED type implementations,
this should be centralized to have one template for an RSSI LED.

More notes:
. checks of AR5K_NUM_GPIO most certainly are buggy: off-by-1
  (range sems to be 0-5, _not_ 1-6)
. prepend "Acer" to "Aspire One" in this patch
  since Acer is major AR5007EG customer
. testing GPIOs other than 3 (0-6) didn't succeed in making the other
  LED work - what is the behaviour with Linpus, is there an rfkill LED
  there?

Andreas Mohr
