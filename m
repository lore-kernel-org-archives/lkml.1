Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbZGFUlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbZGFUlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 16:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbZGFUle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 16:41:34 -0400
Received: from mail2.shareable.org ([80.68.89.115]:58846 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbZGFUld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 16:41:33 -0400
Date: Mon, 6 Jul 2009 21:41:27 +0100
From: Jamie Lokier <jamie@shareable.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, tridge@samba.org,
       Pavel Machek <pavel@ucw.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090706204127.GD13638@shareable.org>
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <19019.16217.291678.588673@samba.org> <4A4B4D1D.8070308@panasas.com> <1246463087.3894.51.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246463087.3894.51.camel@mulgrave.site>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Wed, 2009-07-01 at 14:48 +0300, Boaz Harrosh wrote:
> > On 07/01/2009 01:50 PM, tridge@samba.org wrote:
> > > Hi Pavel,
> > > 
> > > We did of course consider that, and the changes to the patch to
> > > implement collision avoidance are relatively simple. We didn't do it
> > > as it would weaken the legal basis behind the patch. I'll leave it to
> > > John Lanza (the LF patent attorney) to expand on that if you want more
> > > information.
> > > 
> > 
> > You completely lost me here. And I thought I did understand the patent
> > and the fix.
> > 
> > what is the difference between.
> > 
> > short_name = rand(sid);
> > and
> > short_name = sid++;
> > 
> > Now if you would do
> > short_name = MD5(long_name);
> > 
> > That I understand since short_name is some function of long_name
> > but if I'm just inventing the short_name out of my hat. In what legal
> > system does it matter what is my random function I use?
> 
> We're sort of arguing moot technicalities here.  If you look at the way
> the filename is constructed, given the constraints of a leading space
> and a NULL, the need for a NULL padded leading slash extension and the
> need to put control characters in the remaining bytes, we've only got 30
> bits to play with, we're never going to avoid collisions in a space of
> up to 31 bits.

> Technically, a random function is at least as good at
> collision avoidance as any deterministic solution ...

No, it isn't.

A deterministic value based on position in the directory, or by
checking for collisions and avoiding them, will _never_ collide,
provided you limit directories to no more than 2^30 entries, which is
reasonable for FAT.

Whereas a random value can collide.
That's a fundamental technical difference.

A quick read of the Birthday Problem page on Wikipedia leads to:

    With a directory of 1000 files, not especially rare with a camera
    or MP3 players, and 30-bit random numbers:

    The probably of a collision is 0.04% [1]

    If 10000 people each have a directory of 1000 files (not
    unreasonable given the huge number of people who use FAT media),
    the probability that any of them have a collision is approximately
    100%.

    
[1] perl -e '$d = 2.0**30; $n = 1000; $x = 1; for $k (1..$n-1) { $x *= (1 - $k/$d); } printf "Probability = %f%%\n", 100*(1-$x);'

In other words, using random values you are _guaranteeing_ collisions
for a few users.

So the argument comes down to: Does it matter if there are collisions?

Tridge's testing didn't blue screen Windows XP.
Tridge's testing did run a lot of operaitons.

But Tridge isn't 10000 people doing crazy diverse things with
different devices in all sorts of systematic but different patterns
over a period of years.

Given it's technically trivial to avoid collisions completely, and
there is some risk of breakage, even though it would be rare, there
had better be a good reason for not doing it.

-- Jamie
