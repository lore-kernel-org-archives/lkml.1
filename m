Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbYIOSXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbYIOSXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 14:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbYIOSWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 14:22:54 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51271 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbYIOSWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 14:22:54 -0400
From: Jarod Wilson <jwilson@redhat.com>
Organization: Red Hat, Inc.
To: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Subject: Re: [PATCH 02/18] lirc serial port receiver/transmitter device driver
Date: Mon, 15 Sep 2008 14:20:31 -0400
User-Agent: KMail/1.10.1 (Linux/2.6.25.16-1.fc10.x86_64; KDE/4.1.1; x86_64; ; )
Cc: Janne Grunau <j@jannau.net>, linux-kernel@vger.kernel.org,
       Christoph Bartelmus <lirc@bartelmus.de>
References: <200809112149.25762.stefan.bauer@cs.tu-chemnitz.de> <200809131041.33717.stefan.bauer@cs.tu-chemnitz.de> <200809142355.38387.jwilson@redhat.com>
In-Reply-To: <200809142355.38387.jwilson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809151420.32130.jwilson@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 September 2008 23:55:38 Jarod Wilson wrote:
> On Saturday 13 September 2008 04:41:33 Stefan Bauer wrote:
> > On Saturday 13 September 2008 02:26, Janne Grunau wrote:
> > > On Friday 12 September 2008 18:24:33 Jarod Wilson wrote:
> > > > > I just want to thank you very much for your work and give you my
> > > > > Tested-By. Todays git (b2e9c18a32423310a309f94ea5a659c4bb264378)
> > > > > works well here with lirc-0.8.3 userspace on a Pentium
> > > > > 3/i815-system.
> > > >
> > > > Oh good! I haven't broken anything further w/my changes up to
> > > > b2e9c18... ;) I've got another slew of updates to lirc_serial still
> > > > pending though
> > >
> > > I hope I haven't broken anything with my lirc_dev changes. I doubt I'll
> > > have a change to test it before monday.
> >
> > Unfortunately, you did. Commit ea74897 (port lirc to dynamic device
> > numbers) broke things.
> > This is what ea74897 and further (latest tested was dd13cc7) are telling
> > me:
> >
> > $ insmod drivers/input/lirc/lirc_dev.ko
> > $ insmod drivers/input/lirc/lirc_serial.ko
> > insmod: error inserting 'drivers/input/lirc/lirc_serial.ko': -1
> > Input/output error
> > $ dmesg | tail
> > lirc_dev: IR Remote Control driver registered, major 253
> > lirc_serial: auto-detected active low receiver
> > lirc_dev: lirc_register_driver: sample_rate: 0
> > lirc_serial: register_chrdev failed!
> >
> >
> > There has also been a compile issue in the meanwhile, introduced with
> > 95efa30 (inb/outb and readb/writeb deal in u8 types), but this is gone
> > with todays git pull :)
> >
> >
> > I'll keep on testing (unfortunately only at weekends),
> > regards, Stefan
>
> I'd hope to get around to some testing myself much earlier in the weekend,
> but alas... Did just mix in a quick peed at lirc_i2c though:
>
> ...
> lirc_dev: IR Remote Control driver registered, major 247
> bttv: driver version 0.9.17 loaded
> bttv: using 8 buffers with 2080k (520 pages) each for capture
> cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
> lirc_i2c: chip 0x10020 found @ 0x18 (Hauppauge IR)
> lirc_dev: lirc_register_driver: sample_rate: 10
>
> No register_chrdev failure reported, everything looks the same as prior to
> the dynamic dev num change (save the dev num, of course), and I've got a
> /dev/lirc0, but I'm unable to see any IR signals (start up lircd, run irw,
> press buttons on remote).
>
> ...and I just took a quick look at lirc_i2c... The result from
> lirc_register_driver() is never checked, whereas it is in the lirc_serial
> case (which is where the register_chrdev error msg came from). Narf. So its
> likely the same failure, just not noticed (will fix lirc_i2c in a sec).

So I've done a bit of work to fix up a few drivers so they properly check to 
see that lirc_register_driver() actually succeeded, and then accidentally 
stumbled onto the fix for the failure when merging some coverity-inspired 
patches from Erik Hovland. lirc_dev.c's lirc_cdev_add() function had an 
inverted kmalloc failure check. With that fixed, lirc_i2c appears to be 
behaving for me now, although I can't actually check to be 100% certain until 
I get home tonight.

...
lirc_dev: IR Remote Control driver registered, major 240 
lirc_i2c: probe 0x1a @ ivtv i2c driver #0: no
lirc_i2c: probe 0x18 @ ivtv i2c driver #0: yes
lirc_i2c: chip 0x10020 found @ 0x18 (Hauppauge IR)
lirc_dev: lirc_register_driver: sample_rate: 10
lirc_dev: driver lirc_i2c registered at minor number = 0
lirc_dev (lirc_i2c[0]): poll thread started
lirc_i2c: ir_attach: success (minor 0)
...

Fixes are in the git tree now for anyone else who wants to or is willing to 
test. Will verify myself tonight w/lirc_i2c and lirc_mceusb2 at a minimum.

-- 
Jarod Wilson
jarod@redhat.com

