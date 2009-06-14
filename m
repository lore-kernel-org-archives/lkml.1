Return-Path: <linux-kernel-owner+w=401wt.eu-S1762557AbZFNTev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762557AbZFNTev (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 15:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbZFNTen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 15:34:43 -0400
Received: from waste.org ([66.93.16.53]:52746 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbZFNTem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 15:34:42 -0400
Subject: Re: issue with /dev/random? gets depleted very quick
From: Matt Mackall <mpm@selenic.com>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090614190417.GC7272@vanheusden.com>
References: <20090614125138.GZ7272@vanheusden.com>
	 <1244994669.4496.229.camel@calx>  <20090614190417.GC7272@vanheusden.com>
Content-Type: text/plain
Date: Sun, 14 Jun 2009 14:34:15 -0500
Message-Id: <1245008055.4496.255.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-14 at 21:04 +0200, Folkert van Heusden wrote:
> > [cc:ed to lkml]
> 
> > > On an idle system (no gui, no daemons, nothing) system, /dev/random gets
> > > empty in a matter of 20 seconds with a 2.6.26 kernel.
> > > My test:
> > > add 1000 bits to the device:
> > > zolder:/tmp# cat test-RNDADDENTROPY.c 
> ...
> > > }
> > > and then check whayt is in it:
> > > zolder:/tmp# ./a.out ; while true ; do echo `date` `cat /proc/sys/kernel/random/entropy_avail` ; sleep 1 ; done
> > > 0
> > > Sun Jun 14 14:50:44 CEST 2009 1117
> ...
> > > Sun Jun 14 14:50:55 CEST 2009 157
> > > Is there something wrong with it?
> > Does it go below 128? If not, that's the behavior of something depleting
> > the pool down to the anti-starvation threshold via either /dev/urandom
> > or get_random_bytes.
> 
> No, it stays above 128. Sometimes around 13x, sometimes 151, so not
> always close to 128.
> 
> > On my system, I'm seeing that behavior as well. fuser reports a bunch of
> > processes hold /dev/urandom open, but stracing them doesn't reveal a
> > culprit. Which means there's now probably something in the kernel
> > calling get_random_bytes continuously.
> 
> Yes. On the systems I tried, nothing had /dev/*random open, also no
> cronjobs that could use it. And still it gets lower.
> 
> > Is this a problem? It really shouldn't be. Everyone should be
> > using /dev/urandom anyway. And the anti-starvation threshold guarantees
> 
> Well, if I understood correctly how /dev/*random works, urandom is fed
> by /dev/random. So if there's almost nothing left in the main pool and
> urandom demands bits then we have an issue.
> Also, if you frequently want to generate keys (thing gpg, ssl), I think
> you want bits from /dev/random and not urandom.

There is really no difference.

In an ideal world, we could accurately estimate input entropy and thus
guarantee that we never output more than we took in. But it's pretty
clear we don't have a solid theoretical basis for estimating the real
entropy in most, if not all, of our input devices. In fact, I'm pretty
sure they're all significantly more observable than we're giving them
credit for. And without that basis, we can only make handwaving
arguments about the relative strength of /dev/random vs /dev/urandom.

So if you're running into /dev/random blocking, my advice is to delete
the device and symlink it to /dev/urandom.

Also note that if something in the kernel is rapidly consuming entropy
but not visibly leaking it to the world, it is effectively not consuming
it. The simplest case is:

get_random_bytes(...);
memset(...); /* clear previous result */

In this case, if no one hears the tree fall, it hasn't actually fallen.
There is exactly as much 'unknown' data in the entropy pool as before.
If anything, the pool contents are now harder to guess because it's been
mixed more.

-- 
http://selenic.com : development and support for Mercurial and Linux


