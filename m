Return-Path: <linux-kernel-owner+w=401wt.eu-S1757524AbXE1LQP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524AbXE1LQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 07:16:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbXE1LQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 07:16:01 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:36168 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750724AbXE1LQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 07:16:00 -0400
Date: Mon, 28 May 2007 13:15:54 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Message-ID: <20070528111554.GF18807@elf.ucw.cz>
References: <200705272229.21263.rjw@sisk.pl> <20070527220412.GC22687@srcf.ucam.org> <1180304166.3131.66.camel@lov.localdomain> <200705280943.54312.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705280943.54312.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > What exactly is the problem we see here? The timeout of the firmware loader?
> > > > What goes wrong with frozen userspace, usually there is only a netlink
> > > > message sent from the kernel, which should be received and handled
> > > > just fine when userspace is running again.
> > > 
> > > Driver calls request_firmware in the resume method. The userspace helper 
> > > can't be run because it's been frozen, so the firmware never gets loaded 
> > > and the call times out. The driver then fails to resume. While all this 
> > > is happening, the rest of the kernel is blocking on that resume method. 
> > > The firmware can be loaded once userspace has been started again, but by 
> > > that time the driver has given up.
> > 
> > Seems, that's just the broken synchronous firmware loading interface
> > with the useless timeout handling. The nowait version of the same loader
> > doesn't time out, and should not have that problem. The sync version
> > should be removed from the kernel, it just causes all sorts of problems
> > since it exists.
> > 
> > Userspace should handle the async request just fine when it comes back
> > running, regardless of the time it was submitted.
> 
> Okay, so the solution is to convert the drivers to use
> request_firmware_nowait() instead of request_firmware() in their .resume()
> routines.

You'll just get deadlock at different level (and more rare).

Imagine disk with its firmware on NFS and NFS with its firmware on
disk.

(Or maybe firmware loader doing find /, including both disk and
NFS). Just don't call request_firmware_* from .resume().


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
