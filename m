Return-Path: <linux-kernel-owner+w=401wt.eu-S1760528AbYENMc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760528AbYENMc4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 08:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755949AbYENMct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 08:32:49 -0400
Received: from n1.cetrtapot.si ([89.212.80.162]:60578 "EHLO n1.cetrtapot.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753746AbYENMcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 08:32:48 -0400
Message-ID: <482ADBB5.8050608@cetrtapot.si>
Date: Wed, 14 May 2008 14:31:49 +0200
From: =?UTF-8?B?SGlua28gS2/EjWV2YXI=?= <hinko.kocevar@cetrtapot.si>
User-Agent: Thunderbird 2.0.0.14 (X11/20080508)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: register_chrdev vs. cdev_add
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Testing 2.6.26 (GIT) on cris architecture shown that old style of registering 
char devices with register_chrdev() vs. new style with cdev_init() and 
cdev_add() does not produce the same results.

static unsigned int htrc110_major = 123;
static unsigned int htrc110_minor = 2;

CODE:
dev = MKDEV(htrc110_major, htrc110_minor);
ret = register_chrdev_region(dev, 1, mod_name);
ret = register_chrdev(dev, mod_name, &htrc110_fops);

Using char driver with 123 major and 2 minor and registering it with 
register_chrdev() shows this in /proc/devices:
# cat /proc/devices
Character devices:
   1 mem
   2 pty
   3 ttyp
   4 ttyS
   4 ttyS
   5 /dev/tty
   5 /dev/console
   5 /dev/ptmx
  10 misc
  29 fb
  90 mtd
123 carneol-htrc110
128 ptm
136 pts
180 usb
128974850 carneol-htrc110
189 usb_device
253 usb_endpoint
254 usbmon

CODE:
dev = MKDEV(htrc110_major, htrc110_minor);
ret = register_chrdev_region(dev, 1, mod_name);
cdev_init(&htrc110_dev->cdev, &htrc110_fops);
htrc110_dev->cdev.owner = THIS_MODULE;
htrc110_dev->cdev.ops = &htrc110_fops;
ret = cdev_add(&htrc110_dev->cdev, dev, 1);

While using cdev_init() and cdev_add():
# cat /proc/devices
Character devices:
   1 mem
   2 pty
   3 ttyp
   4 ttyS
   4 ttyS
   5 /dev/tty
   5 /dev/console
   5 /dev/ptmx
  10 misc
  29 fb
  90 mtd
123 carneol-htrc110
128 ptm
136 pts
180 usb
189 usb_device
253 usb_endpoint
254 usbmon

This is just heads up, I know that the old interface to registering char devices 
will be dropped, but when...

regards,
Hinko

-- 
ČETRTA POT, d.o.o., Kranj
Planina 3
4000 Kranj
Slovenia, Europe
Tel. +386 (0) 4 280 66 03
E-mail: hinko.kocevar@cetrtapot.si
Http: www.cetrtapot.si

