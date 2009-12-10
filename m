Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbZLJOcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbZLJOcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 09:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752927AbZLJOcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 09:32:45 -0500
Received: from smtp.nokia.com ([192.100.105.134]:41375 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbZLJOco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 09:32:44 -0500
Subject: Re: [PATCH 2/3] gpiolib: add support for having symlinks under
	gpio class directory
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: ext Greg KH <gregkh@suse.de>
Cc: "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dsilvers@simtec.co.uk" <dsilvers@simtec.co.uk>,
       "ben@simtec.co.uk" <ben@simtec.co.uk>,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <20091210024834.GB20410@suse.de>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com>
	 <71eff9c88d3fec3daa218341c83c19a106ee1f62.1260364108.git.ext-jani.1.nikula@nokia.com>
	 <20091210024834.GB20410@suse.de>
Content-Type: text/plain
Date: Thu, 10 Dec 2009 16:32:17 +0200
Message-Id: <1260455537.25352.1762.camel@jani-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2009 14:32:19.0847 (UTC) FILETIME=[94525970:01CA79A5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-10 at 03:48 +0100, ext Greg KH wrote:
> On Wed, Dec 09, 2009 at 03:49:03PM +0200, Jani Nikula wrote:
> > Extend the functionality of gpio_export_link() to allow exported GPIOs
> > to have names using sysfs links under /sys/class/gpio.
> 
> No, please don't create symlinks under a class, that is not something
> that any userspace tool is expecting.
> 
> I don't understand what you are trying to do here, why do you need a
> symlink?  What is wrong with the original device names?

The problem
~~~~~~~~~~~

GPIOs can be exported to gpiolib sysfs at /sys/class/gpio/ like this:

# ls -l /sys/class/gpio/
--w-------    1 root     0            4096 Jan  1 00:00 export
lrwxrwxrwx    1 root     0               0 Jan  1 00:00 gpio25 -> ../../devices/virtual/gpio/gpio25
lrwxrwxrwx    1 root     0               0 Jan  1 00:00 gpio38 -> ../../devices/virtual/gpio/gpio38
...

The GPIO lines may and do change from board revision to another. For
example a power button's GPIO number might be 25 in board rev 1.0 but 66
in board rev 1.1.

We want to assign symbolic names to GPIO lines and hide the numbering
changes from userspace, because it is very painful to amend userspace
for every board revision.

Existing solution
~~~~~~~~~~~~~~~~~

gpio_export_link() can be used to create symlinks from drivers' sysfs
to gpiolib, but this obviously requires a driver. For example:

# ls -l /sys/devices/platform/foo/
lrwxrwxrwx    1 root     0               0 Jan  2 00:31 power_button -> ../../virtual/gpio/gpio25
...

This doesn't really work for GPIO lines not associated with any driver.

How we addressed the problem
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We simply decided to extend gpio_export_link(). When it is called
with 'dev == NULL' (no driver), it creates an additional symlink
in /sys/class/gpio/

# ls -l /sys/class/gpio/
--w-------    1 root     0            4096 Jan  1 00:00 export
lrwxrwxrwx    1 root     0               0 Jan  1 00:00 power_button -> ../../devices/virtual/gpio/gpio25
lrwxrwxrwx    1 root     0               0 Jan  1 00:00 gpio25 -> ../../devices/virtual/gpio/gpio25
lrwxrwxrwx    1 root     0               0 Jan  1 00:00 gpio38 -> ../../devices/virtual/gpio/gpio38
...

This is exactly what our patchset allows to do.

An alternative would be a dummy driver just to create a home in sysfs
for the standalone GPIOs and use the gpio_export_link() to make the
links there.

Any other suggestions?


Thanks,
Jani,
Artem.


