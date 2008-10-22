Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbYJVL6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbYJVL6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 07:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYJVL6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 07:58:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45146 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbYJVL6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 07:58:03 -0400
Date: Wed, 22 Oct 2008 13:58:02 +0200
From: Pavel Machek <pavel@suse.cz>
To: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       burman.yan@gmail.com, pau@eslack.org
Subject: Re: [PATCH] LIS3LV02Dx Accelerometer driver (take 4)
Message-ID: <20081022115802.GA29650@atrey.karlin.mff.cuni.cz>
References: <48FA3368.1040605@tremplin-utc.net> <20081021083822.GG15782@atrey.karlin.mff.cuni.cz> <20081021114255.a7dabc2d.akpm@linux-foundation.org> <20081022102713.GA7843@atrey.karlin.mff.cuni.cz> <48FF0FB7.5070706@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48FF0FB7.5070706@tremplin-utc.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Ok, I guess you have better eyeballs. Yes, the locking was totaly
> > broken (and disabled by initing semaphore to 1 by default).
> To which value the semaphore should have been initialised? I can see
> DECLARE_MUTEX(name) declared as:
> 	struct semaphore name = __SEMAPHORE_INITIALIZER(name, 1)
> 
> (I'm still learning about the locking in the kernel. To me, it looks
> like a maze, and I couldn't find one simple document detailing all the
> mechanisms.)

It is a bit of maze.

You should not really use semaphores. They are old and tricky.

> > This strips some more code, turns semaphore into mutex, and should
> > solve more problems.
> > 
> > I killed the "power down on timer" thingie. I guess we can reintroduce
> > it when we get the basics right (and driver works just fine without
> > that... I did not detect unusual slowness).
> I inserted the timer thingie because I have a program on my laptop which
> reads the position twice per second. Using the joystick interface uses
> two much CPU (it's 20 Hz) and so it's using the sysfs interface.
> However, turning on and off the device twice per second is rather costly
> (especially due to the ACPI access). That's why I made it delayed... and
> I'd like to keep it this way.

Ultimately, we may end up doing that; but for now, I'd like to get
very small and very obvious patch merged...

(Possible workaround: sleep 100 < position should keep the
accelerometer powered up for 100 seconds, right?)

> I'll send this evening a "delayed power down" based on workqueue. Within
> the  work of a workqueue, it's not possible to use a mutex, right? Only
> semaphores are allowed?

Within workqueue, mutex and semaphores are both allowed. What you may
not do is to keep mutex locked and return control.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
