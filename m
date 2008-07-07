Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbYGGMlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbYGGMlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 08:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYGGMl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 08:41:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:62514 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbYGGMl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:41:28 -0400
Subject: Re: device/driver binding notification
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Hans Verkuil <hverkuil@xs4all.nl>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080705205455.7e6579ea@hyperion.delvare>
References: <20080705205455.7e6579ea@hyperion.delvare>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 14:41:31 +0200
Message-Id: <1215434491.23585.19.camel@linux.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18PCoVQ6nL8QD8XJrSFVdC+ASMnRee4g90PD2Q
 ATDd6nurtLEZcMKC+wkheLAxobOkMdUbebB1b40wwIFx05j4BP
 xPd7dWEyapM1vHbFFShNh7E/Qa9OYYD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-07-05 at 20:54 +0200, Jean Delvare wrote:
> Hi Greg, hi Kay,
> 
> In the course of finally making the i2c subsystem comply with the Linux
> 2.6 device driver model, I am facing an issue which affects many v4l
> drivers. I'm curious if the core device driver code has something to
> offer to solve it.
> 
> Basically, a v4l driver creates an i2c bus, instantiates i2c devices on
> that bus, and needs i2c chip drivers for these devices. In the past, i2c
> devices were always bound to a driver by the time the v4l driver knew
> they existed, so they were directly usable. But now that we follow the
> device driver model, this is no longer the case. The sequence of events
> is as follows:
> 
> 1* v4l driver creates i2c bus.
> 
> 2* v4l driver declares i2c devices in that bus.
>    At this point, the v4l driver can't be used yet.
> 
> 3* Later on, the drivers for these devices in question are loaded
>    (typically thanks to udev), and they bind to the i2c devices.
> 
> 4* Now the v4l driver can complete its initialization and users can make
>    use of the device.
> 
> For now, between steps 2 and 3, I made the v4l driver sleep and
> repeatedly check whether i2c_client.driver is set or not. It works but
> it's pretty ugly. I am curious if there's a way to be notified when a
> driver is finally bound to a given device? That's what I would need.

Is this what you are looking for? BUS_NOTIFY_BOUND_DRIVER:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=116af378201ef793424cd10508ccf18b06d8a021

> This also raises another question on reference counting. Ideally, the
> i2c chip drivers shouldn't be allowed to be removed before the v4l
> driver itself is (without the i2c chip drivers, the v4l drivers cannot
> work properly.) So I would like to increase the reference count to the
> i2c chip drivers when they bind to my chips, and decrease it when I
> quit. Should I just do a try_module_get(i2c_driver.driver.owner) at a
> random time and just hope for the best? Or is there a cleaner way to
> express that kind of dependency between drivers?

Shouldn't the v4l device take a reference on the i2c device which will
prevent the i2c device to go away?

Kay

