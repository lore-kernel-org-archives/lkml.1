Return-Path: <linux-kernel-owner+w=401wt.eu-S932398AbZJLOtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbZJLOtA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932378AbZJLOs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:48:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:47497 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932376AbZJLOs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:48:58 -0400
Date: Mon, 12 Oct 2009 07:44:58 -0700
From: Greg KH <gregkh@suse.de>
To: =?iso-8859-1?Q?=C9ric?= Piel <eric.piel@tremplin-utc.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Torokhov <dtor@insightbb.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not work
 anymore
Message-ID: <20091012144458.GA1326@suse.de>
References: <4AD120F2.3020606@tremplin-utc.net>
 <20091011030029.GA6526@suse.de>
 <200910112135.29384.dmitry.torokhov@gmail.com>
 <4AD31709.4000103@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AD31709.4000103@tremplin-utc.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 01:46:17PM +0200, Éric Piel wrote:
> Op 12-10-09 06:35, Dmitry Torokhov schreef:
> > On Saturday 10 October 2009 08:00:29 pm Greg KH wrote:
> >> On Sun, Oct 11, 2009 at 02:04:02AM +0200, ?ric Piel wrote:
> >>> Hello,
> >>>
> >>> After a suspend, I used to do this (to get the PS2 keyboard working
> >>> again), and it used to work fine:
> >>> echo -n "i8042" > /sys/bus/platform/drivers/i8042/unbind ; sleep 1 ; echo
> >>> -n "i8042" > /sys/bus/platform/drivers/i8042/bind
> >>>
> >>> Unfortunately since 2.6.32-rc1, the unbind works fine, but the bind
> >>> returns a "no such device" error now (and the binding is not done). After
> >>> that, additional unbinds also report the error. I think 2.6.31 worked
> >>> fine. Any idea what's going wrong?
> >> Odd.  Any chance you can run 'git bisect' to figure out which patch
> >> might have caused it?
> > 
> > I8042 has been converted to use platform_driver_probe() - we are creating 
> > platform device and platform driver together, there is no chance that some 
> > other device might be driven by i8042 driver.
> I haven't finished bisecting, but indeed, the problem seemed to converge
> toward this patch.
> 
> 
> > Eric, do you still need to fiddle with i8042 to get your keyboard working with 
> > 2.6.32-rc3? We need to make sure that resube works without users needing to 
> > mess with bind/unbind.
> Yes, the keyboard doesn't work after the first resume from ram (the
> later resumes do work). I haven't tried any special option to the i8042
> driver. This is on a HP 2510, in 64 bits.
> 
> Indeed, it would be great to fix this root problem! Is there any bug
> report opened to work on this?
> 
> However, currently the first problem is that unbind works, while bind
> doesn't. Which means anyone doing an unbind will have keyboard and mouse
> lost until the next reboot. That's rather bad because it has been
> recommended for a long time to have this kind of script at resume:
> http://intertrusion.com/files/hp-s2ram.patch
> http://en.opensuse.org/Pm-utils
> 
> So at least, unbind should fail as well as bind.

Ah, I bet I know why bind fails...  Yeah, the i8042_platform_device is
never freed up in the i8042_remove() function in
drivers/input/serio/i8042.c, so when you try to register it again, it
fails.

Dmitry, care to fix this up?  Should be pretty simple.

thanks,

greg k-h
