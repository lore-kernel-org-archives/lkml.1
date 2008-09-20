Return-Path: <linux-kernel-owner+w=401wt.eu-S1752187AbYITPcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbYITPcn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 11:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbYITPce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 11:32:34 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:24453 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750796AbYITPcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 11:32:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gAiWUCqDN33NNmJx+6YbN0eubEEwD1OjnA9AXCfoh5iMPZ6q7fJEBcABzhIwNj5RZ1yOaOpemoM/aAPwPJtJaQUSyZ5kGDsM0IKn3qhuXl23/XuMQBmxN1bjRDtfY4ZwOkHdkuegzXLJ0KVtvfjUpq1zOZJjWvqF+9yDE7gvINE=  ;
X-YMail-OSG: bV0elywVM1louICBCQz26krvjxVPH_4dOTgkMgysWzD0_8eKxNUIpGYqR3z6JhwUj8mw7nfCXQV8UmEP27ERpx3pK6Zo8PxNj77vKWggooUX1tjhfgkOk6esKO1m7.Z3qfoNLA0a
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 3/5] watchdog: cleanup a bit omap_wdt.c
Date: Sat, 20 Sep 2008 08:32:14 -0700
User-Agent: KMail/1.9.9
Cc: Felipe Balbi <felipe.balbi@nokia.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
       Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>
References: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com> <200809191741.44986.david-b@pacbell.net> <20080920081326.GB11114@flint.arm.linux.org.uk>
In-Reply-To: <20080920081326.GB11114@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200809200832.15440.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 September 2008, Russell King - ARM Linux wrote:
> On Fri, Sep 19, 2008 at 05:41:44PM -0700, David Brownell wrote:
> > On Friday 19 September 2008, Felipe Balbi wrote:
> > >  static int omap_wdt_open(struct inode *inode, struct file *file)
> > >  {
> > > -       struct omap_wdt_dev *wdev;
> > > -       void __iomem *base;
> > > -       wdev = platform_get_drvdata(omap_wdt_dev);
> > > -       base = wdev->base;
> > > +       struct omap_wdt_dev *wdev = platform_get_drvdata(omap_wdt_dev);
> > > +       void __iomem *base = wdev->base;
> > > +
> > 
> > Oh, I see where "omap_wdt_dev" (global) gets used.  The normal
> > way to do stuff like that is using void* pointers placed in the
> > inode and file structures for exactly that purpose.
> 
> You don't have an inode or a file structure until open() is called -
> at which point it _is_ placed in file->private_data.  So this driver
> is doing the right thing.

Well, the conventional thing for misc drivers, at any rate.  In
various other drivers, inode->i_private is set up earlier, just
to avoid such a need for globals (or equivalent).

One could argue that this idiom is ugly ... and fix it by having
misc_open() in drivers/char/misc.c initialize i_private before
delegating to the miscdevice->fops->open().  Even just setting
it to the miscdevice pointer would suffice with this driver;
container_of(i_private, struct omap_wdt_dev, omap_wdt_miscdev)
would then return what get_drvdata() returns, sans global.

But that wouldn't be just cleaning up this watchdog.

= Dave


