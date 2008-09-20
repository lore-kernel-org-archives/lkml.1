Return-Path: <linux-kernel-owner+w=401wt.eu-S1752100AbYITQLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbYITQLl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 12:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750780AbYITQLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 12:11:31 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36035 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbYITQLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 12:11:31 -0400
Date: Sat, 20 Sep 2008 17:11:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Felipe Balbi <felipe.balbi@nokia.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
       Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>
Subject: Re: [PATCH 3/5] watchdog: cleanup a bit omap_wdt.c
Message-ID: <20080920161111.GA9873@flint.arm.linux.org.uk>
References: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com> <200809191741.44986.david-b@pacbell.net> <20080920081326.GB11114@flint.arm.linux.org.uk> <200809200832.15440.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200809200832.15440.david-b@pacbell.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 08:32:14AM -0700, David Brownell wrote:
> On Saturday 20 September 2008, Russell King - ARM Linux wrote:
> > On Fri, Sep 19, 2008 at 05:41:44PM -0700, David Brownell wrote:
> > > On Friday 19 September 2008, Felipe Balbi wrote:
> > > >  static int omap_wdt_open(struct inode *inode, struct file *file)
> > > >  {
> > > > -       struct omap_wdt_dev *wdev;
> > > > -       void __iomem *base;
> > > > -       wdev = platform_get_drvdata(omap_wdt_dev);
> > > > -       base = wdev->base;
> > > > +       struct omap_wdt_dev *wdev = platform_get_drvdata(omap_wdt_dev);
> > > > +       void __iomem *base = wdev->base;
> > > > +
> > > 
> > > Oh, I see where "omap_wdt_dev" (global) gets used.  The normal
> > > way to do stuff like that is using void* pointers placed in the
> > > inode and file structures for exactly that purpose.
> > 
> > You don't have an inode or a file structure until open() is called -
> > at which point it _is_ placed in file->private_data.  So this driver
> > is doing the right thing.
> 
> Well, the conventional thing for misc drivers, at any rate.  In
> various other drivers, inode->i_private is set up earlier, just
> to avoid such a need for globals (or equivalent).

None that I know about - generally other drivers look up their private
data in some kind of array and assign to file->private_data in their
open() method - in much the same way that watchdog and misc drivers do.

See __ptmx_open, __tty_open, pp_open, apm_open, hpet_open, mbcs_open,
raw_open, etc.

If you look at data structure lifetimes, the lifetime of 'file' is for
the duration that any one particular instance of the file is open, and
when closed, it's destroyed.  It is not shared between separate opens
of the same node.

The 'inode' is shared between separate opens, and can be discarded when
the node is not open by anyone - in other words, it's not persistent.
So the only time that an inode structure is guaranteed to be present
is just before the node is opened - useless for passing private
pointers from the registration function through to the open() function.

So, you need to store the private data pointer somewhere no matter what.

The simplest solution is as the watchdog drivers are doing.  You can
only have one watchdog driver anyway, so there's no problem having a
single static global device pointer to allow you to carry your private
data across to the open() function.

And anyway, the point of these patches is not to fix issues like this.
It's to get what's in mainline updated to what's in the OMAP tree so
stuff can move forwards.  So, let's not go down rabbit warrens trying
to find obscure new issues which lots of other code already "suffers"
from.

We're into the third day on this one driver.  If every OMAP driver takes
this long, we're still going to be struggling with this beyond Christmas,
probably no further forward since other stuff will have regressed, and
we'll have to start over again.

Yes, make sure what we're submitting is correct.  But don't introduce any
_new_ unnecessary changes while we're trying to merge stuff upstream.  Do
that only once it's upstream and send those changes upstream.
