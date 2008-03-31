Return-Path: <linux-kernel-owner+w=401wt.eu-S1757819AbYCaUqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbYCaUqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 16:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755462AbYCaUqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 16:46:43 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:7258 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbYCaUqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 16:46:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=TE9dPd52ZLqOkioyl7jPI2Hu16uvTpdHxk3J+/jl0IZm2JI15kCbHW22OLg1y2fSpABbev4j1EkgnVYJ2jk/4xOBPdBsGC+UIlipS42bVh6sY/osINw7pajDMRHf4S5z8nGy8G/2hb9Pue4Q6OJhCAR3fl/NmmiGx8eOxshB8n0=
Date: Mon, 31 Mar 2008 16:46:26 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bj?rn Steinbrink <B.Steinbrink@gmx.de>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] evdev: Release eventual input device grabs when getting
	disconnected
Message-ID: <20080331163935.ZZRA012@mailhub.coreip.homeip.net>
References: <20080330184259.GB21375@atjola.homenet> <alpine.LFD.1.00.0803301448190.14670@woody.linux-foundation.org> <20080330222228.GA2419@kroah.com> <20080330224203.GA22498@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080330224203.GA22498@atjola.homenet>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On Mon, Mar 31, 2008 at 12:42:03AM +0200, Bj?rn Steinbrink wrote:
> On 2008.03.30 15:22:28 -0700, Greg KH wrote:
> > On Sun, Mar 30, 2008 at 02:51:02PM -0700, Linus Torvalds wrote:
> > > On Sun, 30 Mar 2008, Bj?rn Steinbrink wrote:
> > > > I can't reproduce the bug on my UP box and currently can't afford
> > > > crashing my SMP box (all the oopses seem to come from SMP kernels, so I
> > > > guess it needs SMP to crash), so while this doesn't show any new
> > > > problems, I can't tell whether it actually fixes anything. Testers
> > > > welcome!
> > > 
> > > Ok, I applied this because I will do an -rc8 today or tomorrow, but I 
> > > really really hope somebody can figure out what made this all start to 
> > > trigger. It does smell like some core device layer change, because we do 
> > > not seem to have a lot of changes since 2.6.24 in evdev.c and input.c that 
> > > seem relevant.
> > > 
> > > Greg, are there any refcounting changes that would cause the input devices 
> > > to be free'd earlier or something?
> > 
> > Earlier?  No, not that I know of at all, as long as the reference
> > counting logic was correct originally.  All of the problems we have been
> > fixing were ones where we accidentally were grabbing too many references
> > and then wondering why things were not getting cleaned up properly as
> > the kobject rework exposed these problems making them more obvious.
> 
> Not freeing the input device at all would of course also hide any
> access-after-free problems :-) So if that's the case, that might explain
> the sudden exposure of the problem. IMHO, my patch is the right thing to
> do anyway, because releasing a grab on the underlying input device from
> within evdev clearly needs to happen before we release that device. So
> AFAICT we're really just looking for "why do we see that bug now?" and
> "is there another bug?"
> 

If device is being disconnected (rdestroyed) then we dont really need to
release grab since there won't be any input events coming through anyway,
so there is no "another bug". I am considering removing the call to
release device once we sort out the issue with lifetime rules change,
since it is not needed.

-- 
Dmitry
