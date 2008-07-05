Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbYGESzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbYGESzU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 14:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYGESzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 14:55:09 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:28378 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbYGESzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 14:55:07 -0400
Date: Sat, 5 Jul 2008 20:54:55 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, LKML <linux-kernel@vger.kernel.org>
Subject: device/driver binding notification
Message-ID: <20080705205455.7e6579ea@hyperion.delvare>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, hi Kay,

In the course of finally making the i2c subsystem comply with the Linux
2.6 device driver model, I am facing an issue which affects many v4l
drivers. I'm curious if the core device driver code has something to
offer to solve it.

Basically, a v4l driver creates an i2c bus, instantiates i2c devices on
that bus, and needs i2c chip drivers for these devices. In the past, i2c
devices were always bound to a driver by the time the v4l driver knew
they existed, so they were directly usable. But now that we follow the
device driver model, this is no longer the case. The sequence of events
is as follows:

1* v4l driver creates i2c bus.

2* v4l driver declares i2c devices in that bus.
   At this point, the v4l driver can't be used yet.

3* Later on, the drivers for these devices in question are loaded
   (typically thanks to udev), and they bind to the i2c devices.

4* Now the v4l driver can complete its initialization and users can make
   use of the device.

For now, between steps 2 and 3, I made the v4l driver sleep and
repeatedly check whether i2c_client.driver is set or not. It works but
it's pretty ugly. I am curious if there's a way to be notified when a
driver is finally bound to a given device? That's what I would need.

This also raises another question on reference counting. Ideally, the
i2c chip drivers shouldn't be allowed to be removed before the v4l
driver itself is (without the i2c chip drivers, the v4l drivers cannot
work properly.) So I would like to increase the reference count to the
i2c chip drivers when they bind to my chips, and decrease it when I
quit. Should I just do a try_module_get(i2c_driver.driver.owner) at a
random time and just hope for the best? Or is there a cleaner way to
express that kind of dependency between drivers?

Thanks,
-- 
Jean Delvare
