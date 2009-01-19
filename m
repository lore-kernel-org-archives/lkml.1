Return-Path: <linux-kernel-owner+w=401wt.eu-S1759933AbZASJzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759933AbZASJzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 04:55:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759461AbZASJzD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 04:55:03 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52613 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617AbZASJzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 04:55:00 -0500
Date: Mon, 19 Jan 2009 10:54:59 +0100
From: Pavel Machek <pavel@suse.cz>
To: Paul Clements <paul.clements@steeleye.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: nbd: add locking to nbd_ioctl
Message-ID: <20090119095459.GA11187@atrey.karlin.mff.cuni.cz>
References: <20090116115512.GA10771@elf.ucw.cz> <4970A696.9070307@steeleye.com> <20090116153603.GD2022@elf.ucw.cz> <4970B59A.9090807@steeleye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4970B59A.9090807@steeleye.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Pavel Machek wrote:
> >On Fri 2009-01-16 10:24:06, Paul Clements wrote:
> >>Pavel Machek wrote:
> >>>The code was written with "oh big kernel lock, please protect me from
> >>>all the evil" mentality: it does not locks its own data structures, it
> >>>just hopes that big kernel lock somehow helps.
> >>>
> >>>It does not. (My fault).
> >>>
> >>>So this uses tx_lock to protect data structures from concurrent use
> >>>between ioctl and worker threads.
> >>What is the particular problem that this fixes? I thought we had already  
> >>been careful to take tx_lock where necessary to protect data structures.  
> >>  Perhaps there is something I missed?
> >
> >for example lo->sock / lo->file are written to without holding any
> >lock in current code. (lo->xmit_timeout has similar problem, and other
> >fields, too).
> 
> lo->sock is only modified under tx_lock (except for SET_SOCK, where the 
> device is being initialized, in which case it's impossible for any other 
> thread to be accessing the device)

Well, unless the user is evil or confused? :-).

> no one else uses lo->file except for the ioctls
> 
> I agree that if you really misuse the ioctls you could potentially get 
> yourself in trouble with the xmit_timeout (the timer not being deleted 
> or initialized properly if you hit the correct window). Taking tx_lock 
> would prevent this.

Good.

> As for other fields, I assume you're talking about blksize, et al. 
> Taking tx_lock doesn't prevent you from screwing yourself if you modify 
> those while the device is active. You'd need to disallow those ioctls 
> when the device is active (check lo->file). Again, this is only going to 
> happen if you really misuse the ioctls.

Ok, I'll take a look at the missing checks. I'd really like to make
this "stable" -- no ammount of misuse should crash the kernel.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
