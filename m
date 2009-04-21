Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbZDUQo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbZDUQo4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:44:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757685AbZDUQo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:44:29 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:45377 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650AbZDUQo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:44:27 -0400
X-IronPort-AV: E=Sophos;i="4.40,225,1238976000"; 
   d="scan'208";a="174698545"
Date: Tue, 21 Apr 2009 09:42:23 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jamie Lokier <jamie@shareable.org>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090421164223.GA8251@cuplxvomd02.corp.sa.net>
References: <20090420234006.GA1958@cuplxvomd02.corp.sa.net> <20090421064346.GB8020@elte.hu> <20090421063549.3b71881d@infradead.org> <20090421135034.GA30114@elte.hu> <20090421140533.GA6375@shareable.org> <20090421142627.GA18129@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421142627.GA18129@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-3; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 04:26:27PM +0200, Ingo Molnar wrote:
> 
> * Jamie Lokier <jamie@shareable.org> wrote:
> 
> > Ingo Molnar wrote:
...
> > > What i'm saying is: instead of "wait 2000 msecs, maybe it works 
> > > out" hack, there should be a proper sleep+event based approach 
> > > to the same. With perhaps a _timeout_ for the "no console 
> > > arrived" negative case as well. (which timeout can be set to 
> > > zero in the "I _know_ there's no console around".)
> > 
> > Isn't the proposed code doing exactly that?  It sleeps waiting for 
> > a console, with a timeout of X msecs.  If a console arrives before 
> > that, doesn't it wake immediately?
> 
> Yes - except that the timeout is aspecific. I.e. we'll time out even 
> if the delay happens not due to a device arriving too late (or not 
> arriving at all), but due to some earlier init step taking an 
> unexpectedly long time.

I agree, but this is also a pretty good description of why things actually
worked before--it just so happened that work intervening between starting
USB enumeration and the opening of /dev/console was long enough that
USB serial devices were initialized. So, no, it's not good. But it's a
pretty close equivalent to previous behavior.

That being said, I'm also thinking that the timeout interval should start when
bus initialization is started. The point between the start of USB
initialization and when a particular device is initialized should be, as
a practical matter and for a particular hardware configuration, more or
less constant, and so more predictable for users.

Basing the wait interval from the start of bus initialization has the
additional advantage that we can also implement similar timers, such as one
for network devices, off the same base time. Since the ip= kernel parameter
is similarly broken, I've been looking at what it would take to get it
working again, too. Or at least, with deference to the constraints of USB and
acknowledging the importance of luck, working as well as it used to.

> Also, if we end up doing this - the patch, as proposed right now, 
> appears to add a default 1000 msecs sleep to every __tty_open() 
> call:
> 
> +config PRINTK_CONSOLE_WAIT
> +       int "Default number of milliseconds to wait for console device"
> +       default 1000
> 
> Does this only delay init during a console-less bootup - or are 
> there other later apps that might trigger the delay?

Sleeping and polling for an event, rather than using a suitable notification
primitive, causes me existential anguish. Seriously, I *hate* code like that
and systems that make you do such brutish things. Linux is not one of those
throwbacks, so as soon as a console shows up, we continue. Thus, we only wait
the whole interval if the console device is very slow to initialize or if
there is no console device, at all.
--
David VomLehn
