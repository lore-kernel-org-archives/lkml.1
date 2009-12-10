Return-Path: <linux-kernel-owner+w=401wt.eu-S1760887AbZLJO60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887AbZLJO60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 09:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760870AbZLJO6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 09:58:25 -0500
Received: from cantor.suse.de ([195.135.220.2]:45441 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760845AbZLJO6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 09:58:24 -0500
Date: Thu, 10 Dec 2009 06:49:20 -0800
From: Greg KH <gregkh@suse.de>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
Cc: "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dsilvers@simtec.co.uk" <dsilvers@simtec.co.uk>,
       "ben@simtec.co.uk" <ben@simtec.co.uk>,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] gpiolib: add support for having symlinks under
	gpio class directory
Message-ID: <20091210144920.GA27237@suse.de>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com> <71eff9c88d3fec3daa218341c83c19a106ee1f62.1260364108.git.ext-jani.1.nikula@nokia.com> <20091210024834.GB20410@suse.de> <1260455537.25352.1762.camel@jani-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260455537.25352.1762.camel@jani-desktop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 04:32:17PM +0200, Jani Nikula wrote:
> On Thu, 2009-12-10 at 03:48 +0100, ext Greg KH wrote:
> > On Wed, Dec 09, 2009 at 03:49:03PM +0200, Jani Nikula wrote:
> > > Extend the functionality of gpio_export_link() to allow exported GPIOs
> > > to have names using sysfs links under /sys/class/gpio.
> > 
> > No, please don't create symlinks under a class, that is not something
> > that any userspace tool is expecting.
> > 
> > I don't understand what you are trying to do here, why do you need a
> > symlink?  What is wrong with the original device names?
> 
> The problem
> ~~~~~~~~~~~
> 
> GPIOs can be exported to gpiolib sysfs at /sys/class/gpio/ like this:
> 
> # ls -l /sys/class/gpio/
> --w-------    1 root     0            4096 Jan  1 00:00 export
> lrwxrwxrwx    1 root     0               0 Jan  1 00:00 gpio25 -> ../../devices/virtual/gpio/gpio25
> lrwxrwxrwx    1 root     0               0 Jan  1 00:00 gpio38 -> ../../devices/virtual/gpio/gpio38
> ...
> 
> The GPIO lines may and do change from board revision to another. For
> example a power button's GPIO number might be 25 in board rev 1.0 but 66
> in board rev 1.1.
> 
> We want to assign symbolic names to GPIO lines and hide the numbering
> changes from userspace, because it is very painful to amend userspace
> for every board revision.

True, just like it is hard to change the kernel for every type of
configuration as well :)

This is the problem that udev solves, from usersapce, but you don't have
device nodes for it to manage, right?

> Existing solution
> ~~~~~~~~~~~~~~~~~
> 
> gpio_export_link() can be used to create symlinks from drivers' sysfs
> to gpiolib, but this obviously requires a driver. For example:
> 
> # ls -l /sys/devices/platform/foo/
> lrwxrwxrwx    1 root     0               0 Jan  2 00:31 power_button -> ../../virtual/gpio/gpio25
> ...
> 
> This doesn't really work for GPIO lines not associated with any driver.

Understood

> How we addressed the problem
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> We simply decided to extend gpio_export_link(). When it is called
> with 'dev == NULL' (no driver), it creates an additional symlink
> in /sys/class/gpio/
> 
> # ls -l /sys/class/gpio/
> --w-------    1 root     0            4096 Jan  1 00:00 export
> lrwxrwxrwx    1 root     0               0 Jan  1 00:00 power_button -> ../../devices/virtual/gpio/gpio25
> lrwxrwxrwx    1 root     0               0 Jan  1 00:00 gpio25 -> ../../devices/virtual/gpio/gpio25
> lrwxrwxrwx    1 root     0               0 Jan  1 00:00 gpio38 -> ../../devices/virtual/gpio/gpio38
> ...
> 
> This is exactly what our patchset allows to do.
> 
> An alternative would be a dummy driver just to create a home in sysfs
> for the standalone GPIOs and use the gpio_export_link() to make the
> links there.
> 
> Any other suggestions?

This type of "policy" should be better off done in userspace whereever
possible.  Can't you just have a udev rule to create symlinks from
somewhere else, into /sys/class/gpio/ that show this type of information
that you are wanting to have?

thanks,

greg k-h
