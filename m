Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbYDBQjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbYDBQjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757008AbYDBQjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:39:35 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1293 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358AbYDBQjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:39:35 -0400
Date: Wed, 2 Apr 2008 18:37:31 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: John Stultz <johnstul@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] Introduce CLOCK_MONOTONIC_RAW
In-Reply-To: <1207152111.6211.13.camel@jstultz-laptop>
Message-ID: <Pine.LNX.4.64.0804021820370.26791@localhost.localdomain>
References: <1205878279.28128.114.camel@localhost>  <1205878420.28128.117.camel@localhost>
  <Pine.LNX.4.64.0804021340290.26791@localhost.localdomain>
 <1207152111.6211.13.camel@jstultz-laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2 Apr 2008, John Stultz wrote:

> > +	u64 raw_nsec;
> > +	long raw_sec;
> 
> 
> So, with the raw_sec being stored in the clocksource, and there not
> being a monotonic_raw value, doesn't this mean the MONOTONIC_RAW value
> will clear to zero on clocksource changes? 

It's copied during the clock change.

> > @@ -215,6 +218,8 @@ static inline void clocksource_calculate
> > 
> >  	/* Go back from cycles -> shifted ns, this time use ntp adjused mult */
> >  	c->xtime_interval = (u64)c->cycle_interval * c->mult;
> > +	c->raw_interval = ((u64)c->cycle_interval * c->mult_orig) <<
> > +			  (NTP_SCALE_SHIFT - c->shift);
> >  }
> 
> Could you explain further how this extra shift scaling is beneficial?

The value has a constant scale, which allows a few optimizations, e.g. 
look at update_wall_time(), where the 64bit-shift and 64bit-compare 
has become a simple 32bit-compare, as it's now very easy to extract the 
full nanosecond part and to drop the fraction part.

> (Additionally, if we're using it for more then just NTP's shift, we
> might want to change its name).

I don't mind.

bye, Roman
