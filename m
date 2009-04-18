Return-Path: <linux-kernel-owner+w=401wt.eu-S1758812AbZDROn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812AbZDROn0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 10:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756355AbZDROnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 10:43:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44973 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591AbZDROnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 10:43:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Russell King <rmk+lkml@arm.linux.org.uk>, Len Brown <lenb@kernel.org>
Subject: Re: 900af0d breaks some embedded suspend/resume
Date: Sat, 18 Apr 2009 16:42:31 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
References: <20090417231009.GB6900@flint.arm.linux.org.uk> <20090418135323.GA7148@flint.arm.linux.org.uk> <200904181626.10388.rjw@sisk.pl>
In-Reply-To: <200904181626.10388.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904181642.32343.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 April 2009, Rafael J. Wysocki wrote:
> On Saturday 18 April 2009, Russell King wrote:
> > On Sat, Apr 18, 2009 at 03:23:35PM +0200, Rafael J. Wysocki wrote:
> > > The patchset in question had been discussed quite extensively before it was
> > > merged and it's a pity none of the people caring for the affected platforms
> > > took part in those discussions.  That would allow us to avoid the breakage.
> > 
> > Maybe on some list, but not everyone is subscribed to a million and one
> > mailing lists.  I don't have enough time to read those which I'm currently
> > subscribed to, so I definitely don't want any more.
> > 
> > > > or provide alternative equivalent functionality where the platform code is
> > > > notified of the PM event prior to the late suspend callback being issued.
> > > 
> > > There is the .begin() callback that could be used, but if you need the
> > > platform to be notified _just_ prior to the late suspend callback, then the
> > > only thing I can think of at the moment is the appended patch.
> > > 
> > > It shouldn't break anything in theory, because the majority of drivers put
> > > their devices into low power states in the "regular" suspend callbacks anyway.
> > 
> > Okay, my requirement is:
> > 
> > What I need to be able to do is to suspend most devices on the host side
> > which may involve talking to a separate microcontroller via I2C to shut
> > down power to peripherals.
> > 
> > Once that's complete, I then need to inform this microcontroller via I2C
> > that we're going to be entering suspend mode, and wait for it to acknowledge
> > that (after it's done its own suspend preparations).  At that point I can
> > shutdown the I2C controller, and enter suspend mode.
> 
> Would it be an option to use a sysdev for that?
> 
> > Upon resume (which is activated by this microcontroller, including jtagging
> > the boot code across to the host CPU), we need to tell this microcontroller
> > that we're going back to 'run' mode again via I2C, and then resume the
> > devices.
> > 
> > This is why we hooked the PXA I2C driver into the late suspend and
> > early resume methods, so the I2C driver would be the last to suspend and
> > the first to resume, thus allowing it to be used to talk to this micro-
> > controller when required.  This worked out nicely because the late suspend
> > used to before the platform prepare and platform finish used to happen
> > after the early resume methods were called.
> 
> Unfortunately I'm not familiar with I2C, so I'm not sure whether or not this
> would work, but it looks like sysdev could be used instead of platform_driver
> for i2c_pxa_driver.
> 
> If using sysdev here (and analogously in i2c-s3c2410.c) is an option, I'd
> prefer to do that instead of reordering suspend and resume code once again.

Well, that wouldn't be straightforward, so I think I'll push my patch for
2.6.30 if Len doesn't object to it.

Thanks,
Rafael
