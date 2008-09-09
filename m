Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbYIIDYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbYIIDYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 23:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYIIDYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 23:24:07 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:36629 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752446AbYIIDYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 23:24:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dSMQk4pSujMLF972xM1YgGoyigqh3QD5Z9qXry0lCevj63wY9oG9l6erMnVAmJnMeQ0tLv0v6eq/W/FAcyy0f7J41DFOtqrpCxpHEpIas8c1CZwOF9HHFNkqoC3JCU8JkUYis7/RINoC4eDWVdB0TUq6AR4rr3dg5teq0RCyk58=  ;
X-YMail-OSG: O1oRCkAVM1mQMcGD2YH6GNW1YZr4ol73si2s1CNE5IAo5GmCfbFYDe5R.aHypag80ChFBRlC0eNrIlIVdMEIVZn.GMgFymnGkGpAXtOljg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
Date: Mon, 8 Sep 2008 20:17:23 -0700
User-Agent: KMail/1.9.9
Cc: James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org, alessandro.zummo@towertech.it
References: <200809081629.21125.david-b@pacbell.net> <200809081755.26148.david-b@pacbell.net> <20080908.195235.200905674.davem@davemloft.net>
In-Reply-To: <20080908.195235.200905674.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809082017.24152.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2008, David Miller wrote:
> 
> > > int update_persistent_clock(struct timespec now)
> > > {
> > >     struct rtc_device *rtc = rtc_class_open("rtc0");

One more point:  that should probably use CONFIG_RTC_HCTOSYS_DEVICE
instead of hard-wiring to "rtc0".  Yeah, I'm sure your SPARCs have
lots of RTCs to choose from -- not! -- but I'd like to see you end
up with code that many folk can reuse/recycle/pirate.  ;)


> > 
> > I'd be tempted to cache that ... notice how you never
> > close it, too.  That will goof lots of refcounts...
> 
> Well if I cache it then we'll hold it forever and that's not
> so nice right?

Why wouldn't it be, so long as it's eventually closed
to prevent leakage?  Other code can rtc_class_open() too;
unlike a userspace open("/dev/rtc0", ...) this isn't an
exclusive operation.


> I'm going to put the missing rtc_close() in there for now to
> fix the leak.
> 
> I'm happy to cache this if you think it's warranted, but then
> this is like saying that the refcount doesn't matter :-)

If you're concerned about stuff like "rmmod my-i2c-rtc-driver"
losing (or "rmmod my-i2c-rtc-driver's-i2c-adapter") ... what's
supposed to happen is that you start getting an -ENODEV return
from your rtc_set_mmss() call, and then you close and null your
cached handle to free up its memory.

The next time you go through this routine you'd see nothing
is cached and then try to get an RTC.  Maybe it's available
again; maybe not.

- Dave
