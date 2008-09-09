Return-Path: <linux-kernel-owner+w=401wt.eu-S1751958AbYIIEP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbYIIEP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 00:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756411AbYIIEOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 00:14:06 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:38960 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756425AbYIIEOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 00:14:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ALMUCmTF4+dC6UWVWCY6eXQiNSXlxztVYwE/beFdNDR1wCjjtAoivnDr9X+QJrhykMU9tmiq1C8rU+MOlA3V4kYNQi9DGNsMuU37/8XlsUsfGQ9lcqotEnxrj35cy9QDTbniMBBfMykMyl9NvJMzTQavYEi/uL92ixFZpRFrndQ=  ;
X-YMail-OSG: SGu.bFAVM1k64PojU4f69bLvYb3YErIXzBHb4n2EMbNORrwbadVCZ4AW0U2afwxY3sJeuCmL247q13KJiloykZBByqw0lkArHvlnYA9jOA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
Date: Mon, 8 Sep 2008 21:14:00 -0700
User-Agent: KMail/1.9.9
Cc: James.Bottomley@hansenpartnership.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org, alessandro.zummo@towertech.it
References: <200809081755.26148.david-b@pacbell.net> <200809082017.24152.david-b@pacbell.net> <20080908.205128.192725776.davem@davemloft.net>
In-Reply-To: <20080908.205128.192725776.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809082114.01347.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2008, David Miller wrote:
> > > > >     struct rtc_device *rtc = rtc_class_open("rtc0");
> > 
> > One more point:  that should probably use CONFIG_RTC_HCTOSYS_DEVICE
> > instead of hard-wiring to "rtc0".  Yeah, I'm sure your SPARCs have
> > lots of RTCs to choose from -- not! -- but I'd like to see you end
> > up with code that many folk can reuse/recycle/pirate.  ;)
> 
> Can you be more specific?  Oh, you want me to use the string defined
> by that config option.  Ok :-)
> 
> But as far as I can tell this will only be set of RTC_HCTOSYS and
> users currently are allowed to not set that.
> 
> If this code goes somewhere generic you would need to ifdef test on
> that, depending upon where you'd want to put it and how it would
> be provided generically.

OK.


> > > > I'd be tempted to cache that ... notice how you never
> > > > close it, too.  That will goof lots of refcounts...
> > > 
> > > Well if I cache it then we'll hold it forever and that's not
> > > so nice right?
> > 
> > Why wouldn't it be, so long as it's eventually closed
> > to prevent leakage?  Other code can rtc_class_open() too;
> > unlike a userspace open("/dev/rtc0", ...) this isn't an
> > exclusive operation.
> 
> When would be "eventually closed" if I open it here and remember
> the pointer in a static local variable, and don't close it?
> 
> I guess you need to be more specific about what you mean by
> caching :)

I'll translate that as "-ENOPATCH".  :)

It'd suffice to fire a timer every 15 minutes or so, and
close it if the NTP logic hasn't refreshed the clock since
last time.  You're right that the simplest scheme is to just
open/close on each call.  The extra work is so infrequent it
may not be measurable.


> > If you're concerned about stuff like "rmmod my-i2c-rtc-driver"
> > losing (or "rmmod my-i2c-rtc-driver's-i2c-adapter") ... what's
> > supposed to happen is that you start getting an -ENODEV return
> > from your rtc_set_mmss() call, and then you close and null your
> > cached handle to free up its memory.
> 
> I see... god that's ugly.  If you want to do this in the generic
> RTC layer helper routines,

... when they get created ...


> 	that's fine, but I don't feel like 
> adding all sorts of stuff like that to the sparc specific routine
> at the moment.
> 
> I'm trying to do things that are practical and that I can check
> into sparc-next-2.6 right now.

OK by me.



