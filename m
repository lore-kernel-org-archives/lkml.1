Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbZLWQ2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbZLWQ2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 11:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbZLWQ2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 11:28:16 -0500
Received: from mail.atheros.com ([12.36.123.2]:13582 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756360AbZLWQ2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 11:28:15 -0500
Date: Wed, 23 Dec 2009 08:28:13 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: mac80211 suspend corner case (was: Asus eeepc 1008HA suspend
 issue and mac80211 suspend corner) case
Message-ID: <20091223162813.GB2609@tux>
References: <20091222022355.GA32508@bombadil.infradead.org>
 <20091222193010.GB30201@bombadil.infradead.org>
 <1261570081.25008.1.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1261570081.25008.1.camel@johannes.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 04:08:01AM -0800, Johannes Berg wrote:
> On Tue, 2009-12-22 at 14:30 -0500, Luis R. Rodriguez wrote:
> 
> > Johannes, any preferences how to handle this? The patch below avoids
> > the Interrupt being turned off but its not enough given that we still
> > could be associated according to userspace. If the hardware is
> > unresponsive maybe it is best to just let the IRQ go disabled, not
> > sure, but its likely not what happens in all cases.
> > 
> > Trimming out the irrelevant parts below.
> 
> > http://bombadil.infradead.org/~mcgrof/logs/2.6.31-with-2.6.32-wireless
> > /irq-disabled.txt
> > > 
> > > This can be fixed by something like the following:
> > > 
> > > diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> > > index e6c08da..63d42fa 100644
> > > --- a/net/mac80211/util.c
> > > +++ b/net/mac80211/util.c
> > > @@ -1031,7 +1031,14 @@ int ieee80211_reconfig(struct ieee80211_local
> > *local)
> > >  
> > >  	/* restart hardware */
> > >  	if (local->open_count) {
> > > +		/*
> > > +		 * Upon resume hardware can sometimes be goofy due to
> > > +		 * various platform issues, so restarting the device may
> > > +		 * at times not work immediately. Propagate the error.
> > > +		 */
> > >  		res = drv_start(local);
> > > +		if (res)
> > > +			return res;
> > >  
> > >  		ieee80211_led_radio(local, true);
> > >  	}
> > > 
> > > But this isn't enough. And since we cannot exactly talk to hardware
> > > we can't try to send a deassoc as harware would be unresponsive. I
> > > also don't see us handling such cases before either on cfg80211 or
> > > mac80211, so curious what we should do.
> 
> Well it seems to me that if the driver determines that the hardware is
> unreachable or not responding, it would unregister it from mac80211,
> which would clean up all user-visible state, obviously.

The drivers would not know this until it fails on the first call
from mac80211 which would be start().

> The patch above seems ok to me, but basically papers over the problem.
> If the start there fails, the driver will have to unregister the hw
> since any subsequent start will fail as well.

How about just having mac80211 do that for drivers where the start()
fails and we are resuming? I can give that a shot.

> The way I see it, it's like a USB unplug while suspended/hibernated ...
> the driver notices that and remo

I see, in this case though I'd prefer if mac80211 could do more of
the work instead of requiring each driver to treat start() failures
by unregistering themselves, specially since we don't inform drivers
they are coming back from resume on start().

  Luis
