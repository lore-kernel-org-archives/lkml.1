Return-Path: <linux-kernel-owner+w=401wt.eu-S1753995AbYIIDvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbYIIDvp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 23:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYIIDvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 23:51:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33616
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbYIIDvf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 23:51:35 -0400
Date: Mon, 08 Sep 2008 20:51:28 -0700 (PDT)
Message-Id: <20080908.205128.192725776.davem@davemloft.net>
To: david-b@pacbell.net
Cc: James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org, alessandro.zummo@towertech.it
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
From: David Miller <davem@davemloft.net>
In-Reply-To: <200809082017.24152.david-b@pacbell.net>
References: <200809081755.26148.david-b@pacbell.net>
	<20080908.195235.200905674.davem@davemloft.net>
	<200809082017.24152.david-b@pacbell.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <david-b@pacbell.net>
Date: Mon, 8 Sep 2008 20:17:23 -0700

> On Monday 08 September 2008, David Miller wrote:
> > 
> > > > int update_persistent_clock(struct timespec now)
> > > > {
> > > >     struct rtc_device *rtc = rtc_class_open("rtc0");
> 
> One more point:  that should probably use CONFIG_RTC_HCTOSYS_DEVICE
> instead of hard-wiring to "rtc0".  Yeah, I'm sure your SPARCs have
> lots of RTCs to choose from -- not! -- but I'd like to see you end
> up with code that many folk can reuse/recycle/pirate.  ;)

Can you be more specific?  Oh, you want me to use the string defined
by that config option.  Ok :-)

But as far as I can tell this will only be set of RTC_HCTOSYS and
users currently are allowed to not set that.

If this code goes somewhere generic you would need to ifdef test on
that, depending upon where you'd want to put it and how it would
be provided generically.

> > > 
> > > I'd be tempted to cache that ... notice how you never
> > > close it, too.  That will goof lots of refcounts...
> > 
> > Well if I cache it then we'll hold it forever and that's not
> > so nice right?
> 
> Why wouldn't it be, so long as it's eventually closed
> to prevent leakage?  Other code can rtc_class_open() too;
> unlike a userspace open("/dev/rtc0", ...) this isn't an
> exclusive operation.

When would be "eventually closed" if I open it here and remember
the pointer in a static local variable, and don't close it?

I guess you need to be more specific about what you mean by
caching :)

> If you're concerned about stuff like "rmmod my-i2c-rtc-driver"
> losing (or "rmmod my-i2c-rtc-driver's-i2c-adapter") ... what's
> supposed to happen is that you start getting an -ENODEV return
> from your rtc_set_mmss() call, and then you close and null your
> cached handle to free up its memory.

I see... god that's ugly.  If you want to do this in the generic
RTC layer helper routines, that's fine, but I don't feel like
adding all sorts of stuff like that to the sparc specific routine
at the moment.

I'm trying to do things that are practical and that I can check
into sparc-next-2.6 right now.
