Return-Path: <linux-kernel-owner+w=401wt.eu-S1754062AbZA1Ej2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbZA1Ej2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 23:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbZA1EjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 23:39:19 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46378 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751874AbZA1EjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 23:39:18 -0500
Message-Id: <1233117557.4227.1297131583@webmail.messagingengine.com>
X-Sasl-Enc: LmINaFHcZjbQ5J6sA4I5I5zhdUTbMK1y6BJNKuc+IJvX 1233117557
From: "Bron Gondwana" <brong@fastmail.fm>
To: "Davide Libenzi" <davidel@xmailserver.org>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Greg KH" <gregkh@suse.de>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <alpine.DEB.1.10.0901271949070.20262@alien.or.mcafeemobile.com>
References: <20090128033824.GA1662@brong.net>
 <59410684d947bc68862a4f5d6c2a5bb1f29519ee.1233114169.git.brong@fastmail.fm>
 <alpine.DEB.1.10.0901271949070.20262@alien.or.mcafeemobile.com>
Subject: Re: [PATCH 1/3] epoll: increase default max_user_instances to 1024
Date: Wed, 28 Jan 2009 15:39:17 +1100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 20:00 -0800, "Davide Libenzi" <davidel@xmailserver.org> wrote:
> On Wed, 28 Jan 2009, Bron Gondwana wrote:
> 
> > Both Postfix and Apache use an epoll instance per child, which
> > leads to significant scalability issues with max_user_instances
> > set so low.  Bump the default to 1024 so medium sized sites are
> > not impacted.
> 
> NACK. Epoll allocates globally about 100 to 160 bytes (32/64 bit) for
> each 
> file added to the interface:
> 
> 	for i 1..1024
> 		for j 1..1024
> 			if i!=j
> 				add j -> i
> 
> That's (N^2 * {100, 160}) = 100MB to 160MB of pinned kernel memory, 
> explotable by simple users with untouched NFILES.

So if you are running a big multi user system and you don't trust
your users not to do shit like this, then you can tune the default
down.  Easy-peasy.

> This is the reason such limit was introduced in the first place. Again, 
> for the 10th time, if you have a loaded server with multiple processes 
> using epoll:

Would you take a patch that doesn't apply the limit to root then?  That
would avoid my postfix issue at least - not sure about Apache, it might
be forking from a user that's not root.

> $ echo NN > /proc/sys/fs/epoll/max_user_instances
> 
> Note that NN does not consume any resource "per se", so if you feel 
> threatened by such limit, you can go wild with it.

What about patch number 2, that allows you to set it to '0' if you feel
the need to go wild and not set an arbitrary limit that you might hit
later?  Usages change over time.

What about patch number 3, that gives you a chance to actually see what
the usage is before your production service suddenly hits it.

That's EVERY linux Apache or Postfix machine out there, using the epoll
interface that's supposed to be scalable, via the API that has been
trumpeted as the way to make things scalable in Linuxland for a while
now.  With a tuneable that got added later and set much lower than
actual production workloads that are in the wild.

Because sometimes systems grow over time more than you expect, and then
hit the limit, and things start going weird and you have no idea why.

Being able to query limits is important!  Especially if they're lower
than real world daemons currently use.  You don't appear to be allowing
either:

a) a default that's high enough not to cause _lots_ of sites problems
   when they upgrade; or

b) a way to tell the system that you don't want these checks at all
  (the == 0 patch); or

c) a way to know when you're getting close to the limit.

So you just expect sites to hit the limit, curse you roundly, and then
up there tuneables?  With no way to know ahead of time that they're
approaching the limit?

You know, I didn't even know that Postfix created an epoll instance per
daemon until I found out about this the hard way by seeing epoll failures
in the log file.  I certainly wasn't aware that this limit has snuck in
during a stable series.

Bron.
-- 
  Bron Gondwana
  brong@fastmail.fm

