Return-Path: <linux-kernel-owner+w=401wt.eu-S1752246AbZLKInX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbZLKInX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 03:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbZLKInT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 03:43:19 -0500
Received: from smtp.nokia.com ([192.100.122.230]:17099 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbZLKInT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 03:43:19 -0500
Subject: Re: [PATCH 2/3] gpiolib: add support for having symlinks under
	gpio class directory
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: ext Greg KH <gregkh@suse.de>
Cc: bn@niasdigital.com,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dsilvers@simtec.co.uk" <dsilvers@simtec.co.uk>,
       "ben@simtec.co.uk" <ben@simtec.co.uk>,
       "Bityutskiy Artem (Nokia-D/Helsinki)" <Artem.Bityutskiy@nokia.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
In-Reply-To: <20091210144920.GA27237@suse.de>
References: <cover.1260364108.git.ext-jani.1.nikula@nokia.com>
	 <71eff9c88d3fec3daa218341c83c19a106ee1f62.1260364108.git.ext-jani.1.nikula@nokia.com>
	 <20091210024834.GB20410@suse.de> <1260455537.25352.1762.camel@jani-desktop>
	 <20091210144920.GA27237@suse.de>
Content-Type: text/plain
Date: Fri, 11 Dec 2009 10:41:40 +0200
Message-Id: <1260520900.25352.2823.camel@jani-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Dec 2009 08:41:47.0101 (UTC) FILETIME=[C63DC0D0:01CA7A3D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-10 at 15:49 +0100, ext Greg KH wrote:
> On Thu, Dec 10, 2009 at 04:32:17PM +0200, Jani Nikula wrote:
> > We want to assign symbolic names to GPIO lines and hide the numbering
> > changes from userspace, because it is very painful to amend userspace
> > for every board revision.
> 
> True, just like it is hard to change the kernel for every type of
> configuration as well :)

As explained by Artem, the kernel might get that information from the
bootloader, for example, so once things are in place, there'd be no need
to modify either the kernel or the userspace.

> This is the problem that udev solves, from usersapce, but you don't have
> device nodes for it to manage, right?

When exporting a GPIO to sysfs, a struct device is created with 0,0 for
dev_t, so I suppose that's correct. 

Not having a device node limits the options with udev, right?

> This type of "policy" should be better off done in userspace whereever
> possible.  Can't you just have a udev rule to create symlinks from
> somewhere else, into /sys/class/gpio/ that show this type of information
> that you are wanting to have?

Let's see. 'udevadm monitor --env' gives me this when I 'echo add >
uevent' for an exported gpio #5:

UDEV  [1230784956.241303] add      /class/gpio/gpio5 (gpio)                     
UDEV_LOG=3                                                                      
ACTION=add                                                                      
DEVPATH=/class/gpio/gpio5                                                       
SUBSYSTEM=gpio                                                                  
SEQNUM=930                                                                      
UDEVD_EVENT=1

Now *assuming* we had /sys/class/gpio/gpioN/name, I could create very
crude udev rules along the lines of this:

SUBSYSTEM=="gpio", ACTION=="add", ATTR{name}!="", RUN="/bin/ln -s /sys$devpath /tmp/gpio-$attr{name}"
SUBSYSTEM=="gpio", ACTION=="remove", ATTR{name}!="", RUN="/bin/rm /tmp/gpio-$attr{name}"

Not exactly pretty, but seems to work (using another attr for testing).
Is there a more elegant way of doing this with udev when there are no
device nodes? Or is it even sensible to use udev without the device
nodes? And what would be the right place for the symlinks?

*If* we got that working in a sensible fashion, it'd be a matter of
adding the "name" attribute to each gpio.


BR,
Jani.


