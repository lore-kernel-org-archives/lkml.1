Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbYDJVnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbYDJVnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 17:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757514AbYDJVn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 17:43:26 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:57318 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010AbYDJVnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 17:43:25 -0400
Date: Fri, 11 Apr 2008 00:43:22 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Mark Lord <lkml@rtr.ca>
cc: David Miller <davem@davemloft.net>, yoshfuji@linux-ipv6.org,
       Jeff Garzik <jeff@garzik.org>, rjw@sisk.pl,
       LKML <linux-kernel@vger.kernel.org>, linux-net@vger.kernel.org,
       Netdev <netdev@vger.kernel.org>
Subject: Re: 2.6.25-rc8: FTP transfer errors
In-Reply-To: <47FE8107.4050400@rtr.ca>
Message-ID: <Pine.LNX.4.64.0804110008290.27813@wrl-59.cs.helsinki.fi>
References: <47FCF9DD.6080007@rtr.ca> <20080410.023045.16227424.yoshfuji@linux-ipv6.org>
 <47FD138B.2060801@rtr.ca> <20080409.152933.132174258.davem@davemloft.net>
 <47FD590C.5020003@rtr.ca> <Pine.LNX.4.64.0804101147070.24841@wrl-59.cs.helsinki.fi>
 <47FE8107.4050400@rtr.ca>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-696208474-1308487018-1207863802=:27813"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-1308487018-1207863802=:27813
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 10 Apr 2008, Mark Lord wrote:

> Ilpo Järvinen wrote:
>
> > I might help if would add netdev on cc list in case you really want to reac
> > net developers, otherwise they might just end up "ignoring it"... ;-)
> ..
> 
> Oh.. I didn't know about that list.  How does that differ from linux-net ?
> (Thanks)

(Somebody please correct me if I'm wrong) if I've understood it correctly, 
linux-net is meant for users discussions while the developers hang at
netdev, some do read lkml but not all. And in fact, I wouldn't have 
noticed this thread for some time except that I was currently trying to 
see if there are some new tcp warn_on reports showing up.

...In case you have a regression, bug etc. related to networking, netdev 
should definately be included.

> > > reducing the mountain of commits to a big handful or two.
> > 
> > Those touching fin/close are mostly whitespace/move things, so I doubt that
> > you find these useful but in case you insist, here's the list:
> >
> > 056834d9f6f6eaf4cc7268569e53acab957aac27 [TCP]: cleanup tcp_{in,out}put.c
> > style
> > 058dc3342b71ffb3531c4f9df7c35f943f392b8d [TCP]: reduce tcp_output's
> > indentation levels a bit
> > 490d5046930276aae50dd16942649bfc626056f7 [TCP]: Uninline tcp_set_state
> > 
> > In addition, there's this one (...though I have read it number of times
> > through and still cannot catch something that would cause the wrongness
> > you're seeing):
> > 
> > e870a8efcddaaa3da7e180b6ae21239fb96aa2bb [TCP]: Perform setting of common
> > control fields in one place
> > 
> > There's very little really on interesting side I can think of, mostly thinks
> > are congestion control related changes... ...maybe either one of these could
> > cause something unpleasant in some corner case:
> > 
> > bd515c3e48ececd774eb3128e81b669dbbd32637 [TCP]: Fix TSO deferring
> > 0e3a4803aa06cd7bc2cfc1d04289df4f6027640a [TCP]: Force TSO splits to MSS
> > boundaries
> > 
> > ...e.g., if the latter causes a return with zero limit under some
> > conditions, tso_fragment might generate, well, interesting packets and never
> > finish if the condition persists but.
> ..
> That matches my own assessment there, too: lot's of whitespace changes,
> and not much real code difference on most paths.  Bummer.  :)

...I just got tired of seeing all those braindamaged line splits and
other "legacy" formatting over and over again... :-) Much of those things 
predate even 2.4, luckily there isn't yet an agency which would prevent 
changing lines of code with that long historic encumbrance :-).

That last TSO change seem the most potential one from the list of
all net/ipv4/tcp*.c include/net/tcp.h touching commits, trying
0e3a4803aa06cd7bc2cfc1d04289df4f6027640a^ might be worthwhile
(^ = a commit before the "quoted one") and you would be able to reuse
its result anyway if there's a need to bisect it because that commit is
around the halfway.


-- 
 i.
---696208474-1308487018-1207863802=:27813--
