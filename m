Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab0BRCae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 21:30:34 -0500
Received: from smtp.knology.net ([24.214.63.101]:47825 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932496Ab0BRCab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 21:30:31 -0500
Subject: Re: [PATCH net-next 14/15] drivers/net/typhoon.c: Use
 (pr|netdev)_<level> macro helpers
From: David Dillow <dave@thedillows.org>
To: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net
In-Reply-To: <1266459504.8446.201.camel@Joe-Laptop.home>
References: <cover.1266454575.git.joe@perches.com>
	 <40a714d7757b0c24f3f0737f028d0242853f935b.1266454576.git.joe@perches.com>
	 <1266458370.5719.43.camel@obelisk.thedillows.org>
	 <1266459504.8446.201.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Feb 2010 21:30:21 -0500
Message-ID: <1266460221.5719.60.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-17 at 18:18 -0800, Joe Perches wrote:
> On Wed, 2010-02-17 at 20:59 -0500, David Dillow wrote:
> > On Wed, 2010-02-17 at 17:02 -0800, Joe Perches wrote:
> > > Use pr_<level>
> > > Use netdev_<level>
> > 
> > The way the driver uses tp->name, most of the pr_<level> changes add an
> > extraneous "typhoon:" to the front of the messages, which is not
> > desirable. Your absolute change-over from PFX/ERR_PFX to pr_fmt()
> > KBUILD_MODNAME misses the distinction between the message where the
> > prefix is needed, and where it isn't.
> 
> Doesn't that mean that "%s: ...", tp->name should be removed?

No, because the routines that use tp->name are called both before and
after the netdev is registered. Prior to that time, it contains the PCI
slot name -- "00:01.0" etc -- so that the user can determine which card
is acting up. Once the card is registered, it has "ethX" to use a
commonly expected name for the card.

> > The netdev_<level> changes are much more palatable to me than the
> > pr_<level> ones. I have no problem getting behind those.
> > 
> > > Coalesce long formats
> > 
> > I don't like these changes very much, either. I tend to work in 80 char
> > terminals, and the wrap of a few characters is usually annoying.
> 
> Linus prefers formats not be split across multiple lines.
> http://lkml.org/lkml/2008/2/23/251
> I can change it back if you want, no matter to me.

I'd prefer it, but I don't think it is really worth the effort now.

> > These __func__ conversions need to go.
> > 
> > > @@ -1901,16 +1898,16 @@ typhoon_sleep(struct typhoon *tp, pci_power_t state, __le16 events)
> > >  	xp_cmd.parm1 = events;
> > >  	err = typhoon_issue_command(tp, 1, &xp_cmd, 0, NULL);
> > >  	if(err < 0) {
> > > -		printk(KERN_ERR "%s: typhoon_sleep(): wake events cmd err %d\n",
> > > -				tp->name, err);
> > > +		pr_err("%s: %s(): wake events cmd err %d\n",
> > > +		       tp->name, __func__, err);
> > >  		return err;
> > >  	}
> 
> why?  It makes it harder to get the function name wrong if
> it's rewritten.

This driver is rarely touched, except for API changes and such cleanups
people like to make from time to time. It is unlikely to be renamed,
adds code, and looks ugly. It may make sense for other printks in
functions that are in flux, but not here.

> How about something like this (on top of previous)?

The version change is fine, but you shouldn't get rid of tp->name.


