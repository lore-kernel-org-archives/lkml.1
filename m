Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbZAZQuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbZAZQuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 11:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbZAZQuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 11:50:03 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36540 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbZAZQuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 11:50:01 -0500
Date: Mon, 26 Jan 2009 17:49:59 +0100
From: Pavel Machek <pavel@suse.cz>
To: Paul Clements <paul.clements@steeleye.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: nbd: add locking to nbd_ioctl
Message-ID: <20090126164959.GB4145@atrey.karlin.mff.cuni.cz>
References: <20090116115512.GA10771@elf.ucw.cz> <4970A696.9070307@steeleye.com> <20090116153603.GD2022@elf.ucw.cz> <4970B59A.9090807@steeleye.com> <20090119095459.GA11187@atrey.karlin.mff.cuni.cz> <497494BB.3080800@steeleye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497494BB.3080800@steeleye.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Pavel Machek wrote:
> >>Pavel Machek wrote:
> >>>On Fri 2009-01-16 10:24:06, Paul Clements wrote:
> 
> >>lo->sock is only modified under tx_lock (except for SET_SOCK, where the 
> >>device is being initialized, in which case it's impossible for any other 
> >>thread to be accessing the device)
> >
> >Well, unless the user is evil or confused? :-).
> 
> Even in that case, you're just going to get EBUSY. Nothing bad will 
> happen. SET_SOCK checks for lo->file, so it cannot be called on an 
> active nbd device.
> 
> 
> >>As for other fields, I assume you're talking about blksize, et al. 
> >>Taking tx_lock doesn't prevent you from screwing yourself if you modify 
> >>those while the device is active. You'd need to disallow those ioctls 
> >>when the device is active (check lo->file). Again, this is only going to 
> >>happen if you really misuse the ioctls.
> >
> >Ok, I'll take a look at the missing checks. I'd really like to make
> >this "stable" -- no amount of misuse should crash the kernel.
> 
> Just to summarize, I don't think we need to hold tx_lock around the 
> entirety of nbd_ioctl. We do need one extra tx_lock around xmit_timeout 
> and we do need to check for lo->file and return EBUSY in all of the 
> SET_*SIZE* ioctls.

I could do that but it would be a bit too complex, and still rely on
big kernel lock. Would you agree to patch that added tx_lock around
all of it, and moved ioctl to unlocked ioctl?

You are right that errors were much less severe than I thought in the
beggining.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
