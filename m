Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbZDRNzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbZDRNzk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 09:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbZDRNzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 09:55:06 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41030 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbZDRNzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 09:55:05 -0400
Date: Sat, 18 Apr 2009 14:53:23 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: 900af0d breaks some embedded suspend/resume
Message-ID: <20090418135323.GA7148@flint.arm.linux.org.uk>
References: <20090417231009.GB6900@flint.arm.linux.org.uk> <200904181523.36010.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904181523.36010.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 18, 2009 at 03:23:35PM +0200, Rafael J. Wysocki wrote:
> The patchset in question had been discussed quite extensively before it was
> merged and it's a pity none of the people caring for the affected platforms
> took part in those discussions.  That would allow us to avoid the breakage.

Maybe on some list, but not everyone is subscribed to a million and one
mailing lists.  I don't have enough time to read those which I'm currently
subscribed to, so I definitely don't want any more.

> > or provide alternative equivalent functionality where the platform code is
> > notified of the PM event prior to the late suspend callback being issued.
> 
> There is the .begin() callback that could be used, but if you need the
> platform to be notified _just_ prior to the late suspend callback, then the
> only thing I can think of at the moment is the appended patch.
> 
> It shouldn't break anything in theory, because the majority of drivers put
> their devices into low power states in the "regular" suspend callbacks anyway.

Okay, my requirement is:

What I need to be able to do is to suspend most devices on the host side
which may involve talking to a separate microcontroller via I2C to shut
down power to peripherals.

Once that's complete, I then need to inform this microcontroller via I2C
that we're going to be entering suspend mode, and wait for it to acknowledge
that (after it's done its own suspend preparations).  At that point I can
shutdown the I2C controller, and enter suspend mode.

Upon resume (which is activated by this microcontroller, including jtagging
the boot code across to the host CPU), we need to tell this microcontroller
that we're going back to 'run' mode again via I2C, and then resume the
devices.

This is why we hooked the PXA I2C driver into the late suspend and
early resume methods, so the I2C driver would be the last to suspend and
the first to resume, thus allowing it to be used to talk to this micro-
controller when required.  This worked out nicely because the late suspend
used to before the platform prepare and platform finish used to happen
after the early resume methods were called.

So, it looks like your patch to kernel/power/main.c will allow me to
continue to achieve this.  (Don't know about the disk.c bits, I've
never used suspend-to-disk.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
