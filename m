Return-Path: <linux-kernel-owner+w=401wt.eu-S1758712AbZCOEQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712AbZCOEQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 00:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZCOEQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 00:16:09 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:45016 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751411AbZCOEQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 00:16:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gBWNoGPxuQ11o2ZCY4GdjBla2tXlLcHWuOBXvdFhJfUrUvUlRAD170f81Zuqeg+nVvKJQldOzdkcdd2DIsvbK7LiCJ+g0NNFZGs6hjstglX6DWux/JRf4ZdNtho7apWKMPf7VEm0TQBknTJXt3C2775Vo5eFME4GyzZyoKQVS60=  ;
X-YMail-OSG: yNVbsRUVM1l.VnmU84DQk3gdU4LK8WPBndo6NHxv.q_rBPtolgwUL7A8rlJE75GrRry5mLcIWjxXARgkBsPUWHw6FRUIw1AZEXrQQQHdS3iC905r0.W7UCvYSjSjFiSJ87VjZAS6dNZTu3E_p7KMAiMk
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.29-rc7 regulator-next] regulator: init fixes
Date: Sat, 14 Mar 2009 21:16:03 -0700
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200903111743.34708.david-b@pacbell.net> <200903111932.16317.david-b@pacbell.net> <20090312120119.GB24376@sirena.org.uk>
In-Reply-To: <20090312120119.GB24376@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903142116.03901.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 March 2009, Mark Brown wrote:
> On Wed, Mar 11, 2009 at 06:32:15PM -0800, David Brownell wrote:
> 
> > Make the regulator setup code cope more consistently with
> > regulators undesirably left enabled by the bootloader.
> 
> First up I'd just like to make it absolutely clear that I agree that
> this is a feature we should have - it's obviously useful.

Feature being "consistency".  I'd say "essential", not
merely "useful" ... this is bugfix territory.

There are things that just can't work with the current
regulator framework, because its handling of this routine
scenario is so inconsistent.  It's not necessarily going
to be safe to force every (!!) driver into that dance you
had described (enable-it-then-disable-it), just to force
all regulators into the kind of self-consistent state that
framework users always expect to start with.

Especially:  RIGHT AFTER INITIALIZATION!!!  There's no
excluse to be self-inconsistent that early, even if
there were an excuse later on.

The "v4" patch I posted resolves that inconsistency in
about the simplest way I can find; but unlike this patch
it doesn't solve the "force this regulator off" problem.


> It is a particular problem for multi-function devices like pcf50633
> which not only register all their regulators by default but also embed
> constraints within the general pcf50633 platform data.

The pcf50633 driver didn't *need* to register all regulators;
and I don't see what the issue would be with platform_data.
Its MFD core could easily check the regulator init data and
skip regulators that didn't initialize a key field.


> If the user 
> simply turns on the regulator driver in their config they'll get this
> behavior if they don't edit the code.  Even with regulator code I'd not
> be surprised if people were bitten by this for things like the memory or
> a CPU core without regulator based DVFS.

That would be part of why the twl4030 regulators are only
registered on request!  Not only will a given board tend to
not use all those regulators, but a number of them really
aren't intended to be managed by Linux.  (And then there
are board options, like what various control signals do.)

Similar things could happen with a system using pcf50633.
There's no reason one of the LDOs or switching regulators
shouldn't be managed exclusively by another I2C master on
that bus ... they each have dedicated registers, and its
not uncommon to dedicate a microcontroller to managing just
one part of a system (and its resources).


> You've addressed some of the use cases for this by providing devmode but

I think it's pretty ugly myself, but you did say something about
wanting explicit support for reverse engineering.  The "v4" patch
which I just sent uses a simpler approach; such support doesn't
need to be explicit in order to work.
