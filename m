Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbYKNKha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbYKNKha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 05:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbYKNKhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 05:37:20 -0500
Received: from ns.firmix.at ([62.141.48.66]:6332 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbYKNKhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 05:37:18 -0500
Subject: Re: Unix sockets via TCP on localhost: is TCP slower?
From: Bernd Petrovitsch <bernd@firmix.at>
To: Olaf van der Spek <olafvdspek@gmail.com>
Cc: David Miller <davem@davemloft.net>, jrm8005@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <b2cc26e40811140109jfc6b0f3tf33a92afbff33e46@mail.gmail.com>
References: <b2cc26e40811121520k711fa702u85e53bbc18b021a0@mail.gmail.com>
	 <3aaafc130811131619w3ba48a86u6c6e2af35f149bf1@mail.gmail.com>
	 <b2cc26e40811140051n4e821fddsc5504eedcccc9cdc@mail.gmail.com>
	 <20081114.005635.131100777.davem@davemloft.net>
	 <b2cc26e40811140109jfc6b0f3tf33a92afbff33e46@mail.gmail.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Fri, 14 Nov 2008 11:37:11 +0100
Message-Id: <1226659031.19041.45.camel@spike.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.339 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.339 required=5
X-Spam-Score: -2.339 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-14 at 10:09 +0100, Olaf van der Spek wrote:
> On Fri, Nov 14, 2008 at 9:56 AM, David Miller <davem@davemloft.net> wrote:
> >> Why would you use windowing, ACKs, flow control and encapsulation on localhost?
> >
> > So that you could firewall, shape, redirect, and make other
> > modifications to the traffic, as well as see it in tcpdumps.  That's
> > the power of Linux, and yes people do this stuff and yes people do
> > want these features to work over loopback.

ACK. Some people even patch their distributions init.d scripts so that
you have aliases (127.0.0.2 and so on) on the loopback interface. And
I'm not even in the simulation world where this probably comes erally
handy.
So as long as "lo" behaves as as normal network interface (with iptables
and whatever is available for eth, br, ...) with an IP address, any
tuning can be done.

> >> I expected the kernel to copy data directly from user-space of the
> >> sending process to a kernel buffer of the receiving process, much like
> >> UNIX sockets.
> >
> > Then all of the above features and debugging facilities go away.
> 
> So instead the recommendation is for all apps to support both TCP and
> Unix sockets?

Of course. That is simple (actually trivial IMO) and standard practice.

> If you then use Unix sockets, you still lose all of those facilities
> and as a bonus, your apps are more complex.

If your (network) app has config abilities for the IP address, the
complexity two either add two new fields (select AF_INET or AF_UNIX, a
path for AF_UNIX) or simply parse the "IP address" and if it's a path,
use AF_UNIX is neglectable.
So please *show* the complexity in adding
- very few config parameters,
- a if() somewhere, and
- the proper initialization of a "struct sockaddr_un".
Actually I see (and use) AF_UNIX as "I have an network app and it's
plain simply faster for local clients than AF_INET".

And the IMNSHO added complexity - which you fail to mention - in the
whole system (including the user) is to deal with "bug reports" like 'if
I change the IP address from 127.0.0.1 to $SOMETHING_ELSE, it behaves
quite different' or 'if I use eth0, it works, if I use "lo" not' *and*
vice versa (because the user usually doesn't know what's really
happening down below just above the TCP/IP stack) of course and similar
"weird" problems.
Or do you like apps where the documentation (and the app checks it if
you are lucky - or some feature just doesn't work) say that it can't be
used on "lo" because $FEATURE is not available there.

You plain simply violate the rule to avoid the (most) unexpected.

> I'd prefer a switch that could be enabled to use such a shortcut for TCP.
> Firewalls should still work mostly (on connect), redirect would still work.

Show numbers and propose a (tested) patch.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


