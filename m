Return-Path: <linux-kernel-owner+w=401wt.eu-S1757275AbYEMS6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275AbYEMS6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 14:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbYEMS6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 14:58:40 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56939 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656AbYEMS6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 14:58:39 -0400
Date: Tue, 13 May 2008 19:58:31 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, video4linux-list@redhat.com
Subject: Build error: ARM badge4_defconfig
Message-ID: <20080513185831.GA18959@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For full details, see:

http://armlinux.simtec.co.uk/kautobuild/2.6.26-rc2-git2/badge4_defconfig.html

which is a regression at 2.6.25-git15 time. (2.6.25-git14 built fine,
seemingly because there wasn't a tuner-core.c in that kernel.)

  LD      .tmp_vmlinux1
drivers/built-in.o: In function `tuner_i2c_xfer_send_recv':
drivers/media/common/tuners/tuner-i2c.h:61: undefined reference to `i2c_transfer'
drivers/built-in.o: In function `tuner_i2c_xfer_send':
drivers/media/common/tuners/tuner-i2c.h:39: undefined reference to `i2c_transfer'
...

Divining options from the configuration log:

  I2C support (I2C) [M/n/y/?] m

So, i2c is modular here.

  Video For Linux (VIDEO_DEV) [Y/n/m/?] y

Video is built in, and since tuner-core.c is being built in as well, we
can assume MEDIA_TUNER=y.

drivers/media/common/tuners/Kconfig contains:

config MEDIA_TUNER
        tristate
        default DVB_CORE || VIDEO_DEV
        depends on DVB_CORE || VIDEO_DEV

which means it ends up being 'y' if either DVB_CORE or VIDEO_DEV is y
(which one is as shown above.)  There's a missing dependency here -
it clearly depends on i2c, so that should also be in the "depends" line.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
