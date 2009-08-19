Return-Path: <linux-kernel-owner+w=401wt.eu-S1751736AbZHSUQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbZHSUQD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 16:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbZHSUQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 16:16:02 -0400
Received: from ppp-145-186.adsl.restena.lu ([158.64.145.186]:46508 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbZHSUP7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 16:15:59 -0400
Date: Wed, 19 Aug 2009 22:15:32 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
Message-ID: <20090819221532.6b4e8a4a@neptune.home>
In-Reply-To: <Pine.LNX.4.44L0.0908191413460.3229-100000@iolanthe.rowland.org>
References: <20090819192256.0e907b54@neptune.home>
 <Pine.LNX.4.44L0.0908191413460.3229-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 August 2009 Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 19 Aug 2009, Bruno Prémont wrote:
> > I did try to understand what happens exactly, using backtrace from
> > kernel compiled with debug info and running objdump on usbserial.ko.
> 
> > Verifying by adding a few printk()'s inside serial_do_free()
> > confirms my understanding of the objdump and also tells me that
> > after unplug serial_do_free() is called twice (with different
> > addresses for port->serial->type)!
> 
> In fact, with different values for port->serial.  Probably because
> port was deallocated before the second call occurred.
> 
> > The first one (right after unplug) survives, the second one (when
> > exiting minicom) crashes.
> > 
> > Extract from the logs with my printk()'s
> > [  266.290632] ftdi_sio ttyUSB0: FTDI USB Serial Device converter
> > now disconnected from ttyUSB0 [  266.290938] ftdi_sio 2-2:1.1:
> > device disconnected [  266.292378] tty_port_close_start: count = -1
> > [  266.292535] serial_do_free(port @da0d9000)
> > [  266.292692]   serial @da3e9840
> > [  266.292791]   type   @deb45660
> > /* exit minicom */
> > [  290.728196] serial_do_free(port @da0d9000)
> > [  290.728341]   serial @da0d9200
> > [  290.728461]   type   @3a6e6967
> > [  290.728591] BUG: unable to handle kernel paging request at
> > 3a6e6983 [  290.728823] IP: [<deb02d5d>] serial_do_free+0x6d/0xd0
> > [usbserial]
> 
> > Printk's were added:
> > 
> > 	if (port->console)
> > 		return;
> > 	/* here */
> > 	serial = serial->port;
> > 	owner = serial->type->driver.owner /* crash here */
> > 
> > Is it useful to check calls to serial_do_free() for my pl2303
> > usb2serial converter? (e.g. to compare behavior from both of them)
> 
> You could try; it wouldn't hurt.
Huh that caused me a NULL port->serial on second call to serial_do_free()
with the pl2302... weird!

Just run minicom -o -c on server (with no getty listening on the other
side, a good old legacy uart of x86 box).

After more tries with pl2302 it seems possible to reproduce, but it is
harder. For now it's rather the second attempt that is eventually
successful as getting an Oops, though each time with NULL pointer
dereference instead of bad pointer for serial->type.

> More useful would be to add some debugging messages to
> destroy_serial(). There should not be any calls to serial_do_free()
> after destroy_serial() runs.
> 
> Also add some messages to the places that call usb_serial_put() and
> usb_serial_get_by_index().

I've added WARN_ON()s in usb_serial_put() and usb_serial_get_by_index()
in order to have information on who called us (easier than searching
around and adding lots of printk()s and output is also more verbose :)

Below, my changes to usb-serial.c and dmesg extracts for crash cases with
pl2302 and ftdi_sio.

You have guessed right, there are calls to serial_do_free() after
destroy_serial() in the crash cases. destroy_serial when disconnecting
device and final serial_do_free() when exiting minicom.



These are the changes I made to 2.6.31-rc6 to get debugging output:
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 99188c9..7859e44 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -74,6 +74,8 @@ struct usb_serial *usb_serial_get_by_index(unsigned index)
 
 	mutex_lock(&table_lock);
 	serial = serial_table[index];
+	printk("usb_serial_get_by_index(index %d): @%p\n", index, serial);
+	WARN_ON(true);
 
 	if (serial)
 		kref_get(&serial->kref);
@@ -135,7 +137,9 @@ static void destroy_serial(struct kref *kref)
 	struct usb_serial_port *port;
 	int i;
 
+	printk("destroy_serial(kref @%p)\n", kref);
 	serial = to_usb_serial(kref);
+	printk("  serial @%p\n", serial);
 
 	dbg("%s - %s", __func__, serial->type->description);
 
@@ -171,6 +175,8 @@ static void destroy_serial(struct kref *kref)
 
 void usb_serial_put(struct usb_serial *serial)
 {
+	printk("usb_serial_put(serial @%p)\n", serial);
+	WARN_ON(true);
 	mutex_lock(&table_lock);
 	kref_put(&serial->kref, destroy_serial);
 	mutex_unlock(&table_lock);
@@ -328,6 +334,10 @@ static void serial_do_free(struct usb_serial_port *port)
 	if (port->console)
 		return;
 
+	printk(KERN_DEBUG "serial_do_free(port @%p)\n", port);
+	printk(KERN_DEBUG "  serial @%p\n", port ? port->serial : NULL);
+	printk(KERN_DEBUG "  type   @%p\n", port && port->serial ? port->serial->type : NULL);
+
 	serial = port->serial;
 	owner = serial->type->driver.owner;
 	put_device(&port->dev);



dmesg extract for pl2302 attempt
[   79.230040] usb 2-1: new full speed USB device using uhci_hcd and address 2
[   79.396191] usb 2-1: New USB device found, idVendor=067b, idProduct=2303
[   79.396201] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   79.396209] usb 2-1: Product: USB-Serial Controller
[   79.396216] usb 2-1: Manufacturer: Prolific Technology Inc.
[   79.396444] usb 2-1: configuration #1 chosen from 1 choice
[   79.532613] usbcore: registered new interface driver usbserial
[   79.532617] usbserial: USB Serial Driver core
[   79.559641] USB Serial support registered for pl2303
[   79.559694] pl2303 2-1:1.0: pl2303 converter detected
[   79.571376] usb 2-1: pl2303 converter now attached to ttyUSB0
[   79.571419] usbcore: registered new interface driver pl2303
[   79.571425] pl2303: Prolific PL2303 USB to serial adaptor driver
[  100.366955] usb_serial_get_by_index(index 0): @d9cc29c0
[  100.367151] ------------[ cut here ]------------
[  100.367345] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:78 usb_serial_get_by_index+0x42/0x70 [usbserial]()
[  100.367696] Hardware name: TravelMate 660
[  100.367843] Modules linked in: pl2303 usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus uhci_hcd snd_pcm ehci_hcd nsc_ircc usbcore snd_timer irda snd pcspkr i2c_i801 snd_page_alloc crc_ccitt
[  100.369196] Pid: 2160, comm: minicom Tainted: G   M       2.6.31-rc6 #1
[  100.369434] Call Trace:
[  100.369529]  [<c12b7052>] ? printk+0x18/0x1e
[  100.369694]  [<dea49182>] ? usb_serial_get_by_index+0x42/0x70 [usbserial]
[  100.369917]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  100.370143]  [<dea49182>] ? usb_serial_get_by_index+0x42/0x70 [usbserial]
[  100.370363]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  100.370554]  [<dea49182>] usb_serial_get_by_index+0x42/0x70 [usbserial]
[  100.370774]  [<dea4936d>] serial_open+0x2d/0x250 [usbserial]
[  100.370975]  [<c115f7b9>] ? tty_init_dev+0x89/0x160
[  100.371135]  [<c115fa4d>] tty_open+0x1bd/0x4b0
[  100.371299]  [<c1077566>] chrdev_open+0x96/0x140
[  100.371454]  [<c10732ff>] __dentry_open+0x9f/0x250
[  100.371628]  [<c1073599>] nameidata_to_filp+0x59/0x70
[  100.371793]  [<c10774d0>] ? chrdev_open+0x0/0x140
[  100.371964]  [<c107f889>] do_filp_open+0x269/0x890
[  100.372121]  [<c1038c5c>] ? ktime_get_ts+0x4c/0x50
[  100.372298]  [<c10730c7>] do_sys_open+0x57/0x140
[  100.372451]  [<c1026d55>] ? alarm_setitimer+0x35/0x70
[  100.372632]  [<c1073219>] sys_open+0x29/0x40
[  100.372774]  [<c1002e08>] sysenter_do_call+0x12/0x26
[  100.372951] ---[ end trace d126221248e369ae ]---
[  149.040186] usb 2-1: USB disconnect, address 2
[  149.040856] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
[  149.041116] usb_serial_put(serial @d9cc29c0)
[  149.041254] ------------[ cut here ]------------
[  149.041438] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:179 usb_serial_put+0x2b/0x60 [usbserial]()
[  149.041778] Hardware name: TravelMate 660
[  149.041922] Modules linked in: pl2303 usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus uhci_hcd snd_pcm ehci_hcd nsc_ircc usbcore snd_timer irda snd pcspkr i2c_i801 snd_page_alloc crc_ccitt
[  149.043273] Pid: 978, comm: khubd Tainted: G   M    W  2.6.31-rc6 #1
[  149.043489] Call Trace:
[  149.043583]  [<c12b7052>] ? printk+0x18/0x1e
[  149.043746]  [<dea48ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  149.043946]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  149.044141]  [<dea48ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  149.044335]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  149.044525]  [<dea48ceb>] usb_serial_put+0x2b/0x60 [usbserial]
[  149.044720]  [<dea48f81>] usb_serial_disconnect+0xf1/0x160 [usbserial]
[  149.044981]  [<deb54447>] ? usb_disable_interface+0x37/0x50 [usbcore]
[  149.045214]  [<deb57221>] usb_unbind_interface+0xf1/0x130 [usbcore]
[  149.045437]  [<c11b5441>] __device_release_driver+0x51/0xa0
[  149.045618]  [<c11b5540>] device_release_driver+0x20/0x40
[  149.045809]  [<c11b4aad>] bus_remove_device+0x7d/0xb0
[  149.045974]  [<c11b2ef2>] device_del+0x102/0x190
[  149.046167]  [<deb543a7>] usb_disable_device+0x87/0xf0 [usbcore]
[  149.046384]  [<deb4f8a6>] usb_disconnect+0x96/0xf0 [usbcore]
[  149.046608]  [<deb50989>] hub_thread+0x829/0x1210 [usbcore]
[  149.046796]  [<c10357a0>] ? autoremove_wake_function+0x0/0x50
[  149.047022]  [<deb50160>] ? hub_thread+0x0/0x1210 [usbcore]
[  149.047203]  [<c10353cc>] kthread+0x7c/0x90
[  149.047358]  [<c1035350>] ? kthread+0x0/0x90
[  149.047500]  [<c1003673>] kernel_thread_helper+0x7/0x14
[  149.047684] ---[ end trace d126221248e369af ]---
[  149.047833] pl2303 2-1:1.0: device disconnected
[  184.321029] serial_do_free(port @d9c61a00)
[  184.321175]   serial @d9cc29c0
[  184.321297]   type   @de77dc20
[  184.321398] usb_serial_put(serial @d9cc29c0)
[  184.321550] ------------[ cut here ]------------
[  184.321715] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:179 usb_serial_put+0x2b/0x60 [usbserial]()
[  184.322074] Hardware name: TravelMate 660
[  184.322202] Modules linked in: pl2303 usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus uhci_hcd snd_pcm ehci_hcd nsc_ircc usbcore snd_timer irda snd pcspkr i2c_i801 snd_page_alloc crc_ccitt
[  184.323568] Pid: 2160, comm: minicom Tainted: G   M    W  2.6.31-rc6 #1
[  184.323775] Call Trace:
[  184.323883]  [<c12b7052>] ? printk+0x18/0x1e
[  184.324032]  [<dea48ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  184.324246]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  184.324426]  [<dea48ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  184.324636]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  184.324810]  [<dea48ceb>] usb_serial_put+0x2b/0x60 [usbserial]
[  184.325022]  [<dea48db9>] serial_do_free+0x99/0xd0 [usbserial]
[  184.325217]  [<dea48e57>] serial_close+0x67/0xa0 [usbserial]
[  184.325417]  [<c115d1a5>] ? tty_fasync+0x55/0xe0
[  184.325569]  [<c115f2e0>] tty_release_dev+0x130/0x490
[  184.325756]  [<c1056d72>] ? put_page+0x42/0x120
[  184.325908]  [<c10897b6>] ? mntput_no_expire+0x16/0x60
[  184.326091]  [<c115f64a>] tty_release+0xa/0x10
[  184.326237]  [<c1075f1c>] __fput+0xdc/0x1d0
[  184.326391]  [<c107602f>] fput+0x1f/0x30
[  184.326523]  [<c1072f8e>] filp_close+0x3e/0x70
[  184.326687]  [<c1024fa2>] put_files_struct+0xa2/0xc0
[  184.326849]  [<c1024fdc>] exit_files+0x1c/0x20
[  184.327011]  [<c1026339>] do_exit+0xb9/0x630
[  184.327154]  [<c103acd8>] ? __put_cred+0x18/0x20
[  184.327322]  [<c10268dd>] do_group_exit+0x2d/0x80
[  184.327476]  [<c1026943>] sys_exit_group+0x13/0x20
[  184.327650]  [<c1002e08>] sysenter_do_call+0x12/0x26
[  184.327810] ---[ end trace d126221248e369b0 ]---
[  184.327974] destroy_serial(kref @d9cc29f4)
[  184.328105]   serial @d9cc29c0
[  300.000233] Machine check events logged
[  417.320036] usb 2-1: new full speed USB device using uhci_hcd and address 3
[  417.486198] usb 2-1: New USB device found, idVendor=067b, idProduct=2303
[  417.486418] usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[  417.486663] usb 2-1: Product: USB-Serial Controller
[  417.486820] usb 2-1: Manufacturer: Prolific Technology Inc.
[  417.487238] usb 2-1: configuration #1 chosen from 1 choice
[  417.490544] pl2303 2-1:1.0: pl2303 converter detected
[  417.502366] usb 2-1: pl2303 converter now attached to ttyUSB0
[  419.476126] usb_serial_get_by_index(index 0): @d9cc2720
[  419.476320] ------------[ cut here ]------------
[  419.476518] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:78 usb_serial_get_by_index+0x42/0x70 [usbserial]()
[  419.476870] Hardware name: TravelMate 660
[  419.477016] Modules linked in: pl2303 usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus uhci_hcd snd_pcm ehci_hcd nsc_ircc usbcore snd_timer irda snd pcspkr i2c_i801 snd_page_alloc crc_ccitt
[  419.478371] Pid: 2186, comm: minicom Tainted: G   M    W  2.6.31-rc6 #1
[  419.478609] Call Trace:
[  419.478704]  [<c12b7052>] ? printk+0x18/0x1e
[  419.478869]  [<dea49182>] ? usb_serial_get_by_index+0x42/0x70 [usbserial]
[  419.479092]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  419.487714]  [<dea49182>] ? usb_serial_get_by_index+0x42/0x70 [usbserial]
[  419.496407]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  419.505172]  [<dea49182>] usb_serial_get_by_index+0x42/0x70 [usbserial]
[  419.514032]  [<dea4936d>] serial_open+0x2d/0x250 [usbserial]
[  419.522887]  [<c115f7b9>] ? tty_init_dev+0x89/0x160
[  419.531577]  [<c115fa4d>] tty_open+0x1bd/0x4b0
[  419.540063]  [<c1077566>] chrdev_open+0x96/0x140
[  419.548236]  [<c10732ff>] __dentry_open+0x9f/0x250
[  419.556144]  [<c1073599>] nameidata_to_filp+0x59/0x70
[  419.563852]  [<c10774d0>] ? chrdev_open+0x0/0x140
[  419.571517]  [<c107f889>] do_filp_open+0x269/0x890
[  419.579145]  [<c1038c5c>] ? ktime_get_ts+0x4c/0x50
[  419.586769]  [<c10730c7>] do_sys_open+0x57/0x140
[  419.594351]  [<c1026d55>] ? alarm_setitimer+0x35/0x70
[  419.601918]  [<c1073219>] sys_open+0x29/0x40
[  419.609406]  [<c1002e08>] sysenter_do_call+0x12/0x26
[  419.616902] ---[ end trace d126221248e369b1 ]---
[  434.000189] usb 2-1: USB disconnect, address 3
[  434.001726] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
[  434.001986] usb_serial_put(serial @d9cc2720)
[  434.002126] ------------[ cut here ]------------
[  434.002310] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:179 usb_serial_put+0x2b/0x60 [usbserial]()
[  434.002650] Hardware name: TravelMate 660
[  434.002795] Modules linked in: pl2303 usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus uhci_hcd snd_pcm ehci_hcd nsc_ircc usbcore snd_timer irda snd pcspkr i2c_i801 snd_page_alloc crc_ccitt
[  434.004145] Pid: 978, comm: khubd Tainted: G   M    W  2.6.31-rc6 #1
[  434.004361] Call Trace:
[  434.004455]  [<c12b7052>] ? printk+0x18/0x1e
[  434.004620]  [<dea48ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  434.004818]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  434.005014]  [<dea48ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  434.005208]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  434.005398]  [<dea48ceb>] usb_serial_put+0x2b/0x60 [usbserial]
[  434.005594]  [<dea48f81>] usb_serial_disconnect+0xf1/0x160 [usbserial]
[  434.005857]  [<deb54447>] ? usb_disable_interface+0x37/0x50 [usbcore]
[  434.006091]  [<deb57221>] usb_unbind_interface+0xf1/0x130 [usbcore]
[  434.006314]  [<c11b5441>] __device_release_driver+0x51/0xa0
[  434.006495]  [<c11b5540>] device_release_driver+0x20/0x40
[  434.006686]  [<c11b4aad>] bus_remove_device+0x7d/0xb0
[  434.006850]  [<c11b2ef2>] device_del+0x102/0x190
[  434.007043]  [<deb543a7>] usb_disable_device+0x87/0xf0 [usbcore]
[  434.007261]  [<deb4f8a6>] usb_disconnect+0x96/0xf0 [usbcore]
[  434.007486]  [<deb50989>] hub_thread+0x829/0x1210 [usbcore]
[  434.007673]  [<c10357a0>] ? autoremove_wake_function+0x0/0x50
[  434.007901]  [<deb50160>] ? hub_thread+0x0/0x1210 [usbcore]
[  434.008082]  [<c10353cc>] kthread+0x7c/0x90
[  434.008236]  [<c1035350>] ? kthread+0x0/0x90
[  434.008379]  [<c1003673>] kernel_thread_helper+0x7/0x14
[  434.008562] ---[ end trace d126221248e369b2 ]---
[  434.008710] pl2303 2-1:1.0: device disconnected
[  434.009183] usb_serial_get_by_index(index 0): @d9cc2720
[  434.009354] ------------[ cut here ]------------
[  434.009532] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:78 usb_serial_get_by_index+0x42/0x70 [usbserial]()
[  434.009885] Hardware name: TravelMate 660
[  434.010054] Modules linked in: pl2303 usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus uhci_hcd snd_pcm ehci_hcd nsc_ircc usbcore snd_timer irda snd pcspkr i2c_i801 snd_page_alloc crc_ccitt
[  434.011402] Pid: 2186, comm: minicom Tainted: G   M    W  2.6.31-rc6 #1
[  434.011626] Call Trace:
[  434.011714]  [<c12b7052>] ? printk+0x18/0x1e
[  434.011877]  [<dea49182>] ? usb_serial_get_by_index+0x42/0x70 [usbserial]
[  434.012097]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  434.012293]  [<dea49182>] ? usb_serial_get_by_index+0x42/0x70 [usbserial]
[  434.012511]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  434.012701]  [<dea49182>] usb_serial_get_by_index+0x42/0x70 [usbserial]
[  434.012920]  [<dea4936d>] serial_open+0x2d/0x250 [usbserial]
[  434.013123]  [<c10897b6>] ? mntput_no_expire+0x16/0x60
[  434.013292]  [<c115fa4d>] tty_open+0x1bd/0x4b0
[  434.013456]  [<c1077566>] chrdev_open+0x96/0x140
[  434.013611]  [<c10732ff>] __dentry_open+0x9f/0x250
[  434.013786]  [<c1073599>] nameidata_to_filp+0x59/0x70
[  434.013950]  [<c10774d0>] ? chrdev_open+0x0/0x140
[  434.014120]  [<c107f889>] do_filp_open+0x269/0x890
[  434.014278]  [<c1038c5c>] ? ktime_get_ts+0x4c/0x50
[  434.023849]  [<c10730c7>] do_sys_open+0x57/0x140
[  434.033742]  [<c1026d55>] ? alarm_setitimer+0x35/0x70
[  434.043683]  [<c1073219>] sys_open+0x29/0x40
[  434.053671]  [<c1002e08>] sysenter_do_call+0x12/0x26
[  434.063679] ---[ end trace d126221248e369b3 ]---
[  434.079109] usb_serial_put(serial @d9cc2720)
[  434.083537] ------------[ cut here ]------------
[  434.087641] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:179 usb_serial_put+0x2b/0x60 [usbserial]()
[  434.091916] Hardware name: TravelMate 660
[  434.096132] Modules linked in: pl2303 usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus uhci_hcd snd_pcm ehci_hcd nsc_ircc usbcore snd_timer irda snd pcspkr i2c_i801 snd_page_alloc crc_ccitt
[  434.105454] Pid: 2186, comm: minicom Tainted: G   M    W  2.6.31-rc6 #1
[  434.109980] Call Trace:
[  434.114426]  [<c12b7052>] ? printk+0x18/0x1e
[  434.118801]  [<dea48ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  434.123133]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  434.127306]  [<dea48ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  434.131466]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  434.135581]  [<dea48ceb>] usb_serial_put+0x2b/0x60 [usbserial]
[  434.139755]  [<dea493b0>] serial_open+0x70/0x250 [usbserial]
[  434.143923]  [<c115fa4d>] tty_open+0x1bd/0x4b0
[  434.148035]  [<c1077566>] chrdev_open+0x96/0x140
[  434.152172]  [<c10732ff>] __dentry_open+0x9f/0x250
[  434.156257]  [<c1073599>] nameidata_to_filp+0x59/0x70
[  434.160367]  [<c10774d0>] ? chrdev_open+0x0/0x140
[  434.164429]  [<c107f889>] do_filp_open+0x269/0x890
[  434.168489]  [<c1038c5c>] ? ktime_get_ts+0x4c/0x50
[  434.172551]  [<c10730c7>] do_sys_open+0x57/0x140
[  434.176561]  [<c1026d55>] ? alarm_setitimer+0x35/0x70
[  434.180600]  [<c1073219>] sys_open+0x29/0x40
[  434.184596]  [<c1002e08>] sysenter_do_call+0x12/0x26
[  434.188611] ---[ end trace d126221248e369b4 ]---
[  434.193345] tty_port_close_start: count = -1
[  434.290041] serial_do_free(port @d8df5c00)
[  434.299763]   serial @d9cc2720
[  434.309450]   type   @de77dc20
[  434.319321] usb_serial_put(serial @d9cc2720)
[  434.323540] ------------[ cut here ]------------
[  434.327490] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:179 usb_serial_put+0x2b/0x60 [usbserial]()
[  434.331601] Hardware name: TravelMate 660
[  434.335662] Modules linked in: pl2303 usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus uhci_hcd snd_pcm ehci_hcd nsc_ircc usbcore snd_timer irda snd pcspkr i2c_i801 snd_page_alloc crc_ccitt
[  434.344746] Pid: 2186, comm: minicom Tainted: G   M    W  2.6.31-rc6 #1
[  434.349160] Call Trace:
[  434.353463]  [<c12b7052>] ? printk+0x18/0x1e
[  434.357707]  [<dea48ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  434.361868]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  434.365907]  [<dea48ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  434.369882]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  434.373881]  [<dea48ceb>] usb_serial_put+0x2b/0x60 [usbserial]
[  434.377868]  [<dea48db9>] serial_do_free+0x99/0xd0 [usbserial]
[  434.381857]  [<dea48e57>] serial_close+0x67/0xa0 [usbserial]
[  434.385792]  [<c115d1a5>] ? tty_fasync+0x55/0xe0
[  434.389716]  [<c115f2e0>] tty_release_dev+0x130/0x490
[  434.393638]  [<dea48ceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  434.397546]  [<c10207e3>] ? __cond_resched+0x23/0x40
[  434.401443]  [<c12b7d7e>] ? mutex_lock+0xe/0x20
[  434.405321]  [<dea48d0b>] ? usb_serial_put+0x4b/0x60 [usbserial]
[  434.409216]  [<dea493b0>] ? serial_open+0x70/0x250 [usbserial]
[  434.413153]  [<c115fced>] tty_open+0x45d/0x4b0
[  434.417051]  [<c1077566>] chrdev_open+0x96/0x140
[  434.420985]  [<c10732ff>] __dentry_open+0x9f/0x250
[  434.424892]  [<c1073599>] nameidata_to_filp+0x59/0x70
[  434.428818]  [<c10774d0>] ? chrdev_open+0x0/0x140
[  434.432630]  [<c107f889>] do_filp_open+0x269/0x890
[  434.436315]  [<c1038c5c>] ? ktime_get_ts+0x4c/0x50
[  434.439985]  [<c10730c7>] do_sys_open+0x57/0x140
[  434.443676]  [<c1026d55>] ? alarm_setitimer+0x35/0x70
[  434.447346]  [<c1073219>] sys_open+0x29/0x40
[  434.451022]  [<c1002e08>] sysenter_do_call+0x12/0x26
[  434.454672] ---[ end trace d126221248e369b5 ]---
[  434.459076] destroy_serial(kref @d9cc2754)
[  434.462686]   serial @d9cc2720
[  454.363600] serial_do_free(port @d8df5c00)
[  454.363745]   serial @d8df5a00
[  454.363868]   type   @(null)
[  454.363992] BUG: unable to handle kernel NULL pointer dereference at 0000001c
[  454.364252] IP: [<dea48d8d>] serial_do_free+0x6d/0xd0 [usbserial]
[  454.364487] *pde = 00000000 
[  454.364609] Oops: 0000 [#1] 
[  454.364731] last sysfs file: /sys/devices/virtual/hwmon/hwmon0/temp1_input
[  454.364974] Modules linked in: pl2303 usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus uhci_hcd snd_pcm ehci_hcd nsc_ircc usbcore snd_timer irda snd pcspkr i2c_i801 snd_page_alloc crc_ccitt
[  454.366315] 
[  454.366391] Pid: 2186, comm: minicom Tainted: G   M    W  (2.6.31-rc6 #1) TravelMate 660
[  454.366644] EIP: 0060:[<dea48d8d>] EFLAGS: 00010282 CPU: 0
[  454.366844] EIP is at serial_do_free+0x6d/0xd0 [usbserial]
[  454.367018] EAX: 00000000 EBX: d8df5c00 ECX: ffffffff EDX: c13c6584
[  454.367245] ESI: d8df5a00 EDI: 00000000 EBP: d8cc3e24 ESP: d8cc3e10
[  454.367444]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  454.367633] Process minicom (pid: 2186, ti=d8cc3000 task=dd8e1dd0 task.ti=d8cc3000)
[  454.367870] Stack:
[  454.367954]  dea4cc4e 00000000 d8df5c00 dd0d8c00 00000000 d8cc3e4c dea48e57 00000000
[  454.368329] <0> d8cc3e4c c115d1a5 dd0d8ca0 dd8d1180 dd0d8c00 00000000 00000000 d8cc3edc
[  454.368749] <0> c115f2e0 40000000 d8cc3e94 00000082 dd8d1180 00000000 00000000 00000000
[  454.369178] Call Trace:
[  454.369290]  [<dea48e57>] ? serial_close+0x67/0xa0 [usbserial]
[  454.369483]  [<c115d1a5>] ? tty_fasync+0x55/0xe0
[  454.369652]  [<c115f2e0>] ? tty_release_dev+0x130/0x490
[  454.369828]  [<c1056d72>] ? put_page+0x42/0x120
[  454.369993]  [<c105435a>] ? free_hot_page+0xa/0x10
[  454.370195]  [<c105438f>] ? __free_pages+0x2f/0x40
[  454.370356]  [<c107042e>] ? __free_slab+0xae/0x160
[  454.370530]  [<c115f64a>] ? tty_release+0xa/0x10
[  454.370681]  [<c1075f1c>] ? __fput+0xdc/0x1d0
[  454.370840]  [<c107602f>] ? fput+0x1f/0x30
[  454.370976]  [<c1072f8e>] ? filp_close+0x3e/0x70
[  454.371148]  [<c1024fa2>] ? put_files_struct+0xa2/0xc0
[  454.371315]  [<c1024fdc>] ? exit_files+0x1c/0x20
[  454.371483]  [<c1026339>] ? do_exit+0xb9/0x630
[  454.371631]  [<c103acd8>] ? __put_cred+0x18/0x20
[  454.371799]  [<c10268dd>] ? do_group_exit+0x2d/0x80
[  454.371959]  [<c1026943>] ? sys_exit_group+0x13/0x20
[  454.372137]  [<c1002e08>] ? sysenter_do_call+0x12/0x26
[  454.372300] Code: a4 de 89 44 24 04 e8 cd e2 86 e2 8b 13 31 c0 85 d2 74 03 8b 42 04 89 44 24 04 c7 04 24 4e cc a4 de e8 b2 e2 86 e2 8b 33 8b 46 04 <8b> 78 1c 8d 83 bc 00 00 00 e8 95 93 76 e2 8d 5e 38 89 d8 e8 cb 
[  454.374157] EIP: [<dea48d8d>] serial_do_free+0x6d/0xd0 [usbserial] SS:ESP 0068:d8cc3e10
[  454.374470] CR2: 000000000000001c
[  454.374580] ---[ end trace d126221248e369b6 ]---
[  454.374742] Fixing recursive fault but reboot is needed!

First unplug attempt with running minicom survived, the second attempt
crashed.



dmesg extract for ftdi_sio attempt:
[   97.650041] usb 1-2: new full speed USB device using uhci_hcd and address 2
[   97.868191] usb 1-2: New USB device found, idVendor=9e88, idProduct=9e8f
[   97.868410] usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   97.868655] usb 1-2: Product: SheevaPlug JTAGKey FT2232D B
[   97.868831] usb 1-2: Manufacturer: FTDI
[   97.868972] usb 1-2: SerialNumber: FTS55QK6
[   97.869346] usb 1-2: configuration #1 chosen from 1 choice
[   98.005741] usbcore: registered new interface driver usbserial
[   98.005961] usbserial: USB Serial Driver core
[   98.105309] USB Serial support registered for FTDI USB Serial Device
[   98.105782] usb 1-2: Ignoring serial port reserved for JTAG
[   98.106078] ftdi_sio 1-2:1.1: FTDI USB Serial Device converter detected
[   98.106359] usb 1-2: Detected FT2232C
[   98.106482] usb 1-2: Number of endpoints 2
[   98.106634] usb 1-2: Endpoint 1 MaxPacketSize 64
[   98.106783] usb 1-2: Endpoint 2 MaxPacketSize 64
[   98.106947] usb 1-2: Setting MaxPacketSize 64
[   98.108347] usb 1-2: FTDI USB Serial Device converter now attached to ttyUSB0
[   98.108641] usbcore: registered new interface driver ftdi_sio
[   98.108824] ftdi_sio: v1.5.0:USB FTDI Serial Converters Driver
[  109.201971] usb_serial_get_by_index(index 0): @d8c60c00
[  109.211271] ------------[ cut here ]------------
[  109.220604] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:78 usb_serial_get_by_index+0x42/0x70 [usbserial]()
[  109.230195] Hardware name: TravelMate 660
[  109.239718] Modules linked in: ftdi_sio usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus ehci_hcd uhci_hcd nsc_ircc snd_pcm usbcore irda snd_timer pcspkr snd i2c_i801 snd_page_alloc crc_ccitt
[  109.260505] Pid: 2163, comm: minicom Tainted: G   M       2.6.31-rc6 #1
[  109.270831] Call Trace:
[  109.281027]  [<c12b7052>] ? printk+0x18/0x1e
[  109.291242]  [<dea5d182>] ? usb_serial_get_by_index+0x42/0x70 [usbserial]
[  109.301505]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  109.311732]  [<dea5d182>] ? usb_serial_get_by_index+0x42/0x70 [usbserial]
[  109.322008]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  109.332244]  [<dea5d182>] usb_serial_get_by_index+0x42/0x70 [usbserial]
[  109.342515]  [<dea5d36d>] serial_open+0x2d/0x250 [usbserial]
[  109.352742]  [<c115f7b9>] ? tty_init_dev+0x89/0x160
[  109.362895]  [<c115fa4d>] tty_open+0x1bd/0x4b0
[  109.372987]  [<c1077566>] chrdev_open+0x96/0x140
[  109.383039]  [<c10732ff>] __dentry_open+0x9f/0x250
[  109.393033]  [<c1073599>] nameidata_to_filp+0x59/0x70
[  109.402978]  [<c10774d0>] ? chrdev_open+0x0/0x140
[  109.412910]  [<c107f889>] do_filp_open+0x269/0x890
[  109.422804]  [<c1038c5c>] ? ktime_get_ts+0x4c/0x50
[  109.432598]  [<c10730c7>] do_sys_open+0x57/0x140
[  109.442338]  [<c1026d55>] ? alarm_setitimer+0x35/0x70
[  109.451867]  [<c1073219>] sys_open+0x29/0x40
[  109.461165]  [<c1002e08>] sysenter_do_call+0x12/0x26
[  109.470466] ---[ end trace 3473a8310f07944c ]---
[  119.290059] usb 1-2: USB disconnect, address 2
[  119.290625] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disconnected from ttyUSB0
[  119.290932] usb_serial_put(serial @d8c60c00)
[  119.291070] ------------[ cut here ]------------
[  119.291255] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:179 usb_serial_put+0x2b/0x60 [usbserial]()
[  119.291584] Hardware name: TravelMate 660
[  119.291728] Modules linked in: ftdi_sio usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus ehci_hcd uhci_hcd nsc_ircc snd_pcm usbcore irda snd_timer pcspkr snd i2c_i801 snd_page_alloc crc_ccitt
[  119.293082] Pid: 989, comm: khubd Tainted: G   M    W  2.6.31-rc6 #1
[  119.293313] Call Trace:
[  119.293406]  [<c12b7052>] ? printk+0x18/0x1e
[  119.293570]  [<dea5cceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  119.293769]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  119.293964]  [<dea5cceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  119.294158]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  119.294348]  [<dea5cceb>] usb_serial_put+0x2b/0x60 [usbserial]
[  119.294543]  [<dea5cf81>] usb_serial_disconnect+0xf1/0x160 [usbserial]
[  119.294819]  [<deb54447>] ? usb_disable_interface+0x37/0x50 [usbcore]
[  119.295053]  [<deb57221>] usb_unbind_interface+0xf1/0x130 [usbcore]
[  119.295276]  [<c11b5441>] __device_release_driver+0x51/0xa0
[  119.295457]  [<c11b5540>] device_release_driver+0x20/0x40
[  119.295649]  [<c11b4aad>] bus_remove_device+0x7d/0xb0
[  119.295813]  [<c11b2ef2>] device_del+0x102/0x190
[  119.296006]  [<deb543a7>] usb_disable_device+0x87/0xf0 [usbcore]
[  119.296223]  [<deb4f8a6>] usb_disconnect+0x96/0xf0 [usbcore]
[  119.296448]  [<deb50989>] hub_thread+0x829/0x1210 [usbcore]
[  119.296636]  [<c10357a0>] ? autoremove_wake_function+0x0/0x50
[  119.296863]  [<deb50160>] ? hub_thread+0x0/0x1210 [usbcore]
[  119.297044]  [<c10353cc>] kthread+0x7c/0x90
[  119.297198]  [<c1035350>] ? kthread+0x0/0x90
[  119.297341]  [<c1003673>] kernel_thread_helper+0x7/0x14
[  119.297524] ---[ end trace 3473a8310f07944d ]---
[  119.297673] ftdi_sio 1-2:1.1: device disconnected
[  119.299108] usb_serial_get_by_index(index 0): @d8c60c00
[  119.299287] ------------[ cut here ]------------
[  119.299473] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:78 usb_serial_get_by_index+0x42/0x70 [usbserial]()
[  119.299823] Hardware name: TravelMate 660
[  119.299968] Modules linked in: ftdi_sio usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus ehci_hcd uhci_hcd nsc_ircc snd_pcm usbcore irda snd_timer pcspkr snd i2c_i801 snd_page_alloc crc_ccitt
[  119.301355] Pid: 2163, comm: minicom Tainted: G   M    W  2.6.31-rc6 #1
[  119.301562] Call Trace:
[  119.301667]  [<c12b7052>] ? printk+0x18/0x1e
[  119.301815]  [<dea5d182>] ? usb_serial_get_by_index+0x42/0x70 [usbserial]
[  119.302051]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  119.302230]  [<dea5d182>] ? usb_serial_get_by_index+0x42/0x70 [usbserial]
[  119.302464]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  119.302638]  [<dea5d182>] usb_serial_get_by_index+0x42/0x70 [usbserial]
[  119.302873]  [<dea5d36d>] serial_open+0x2d/0x250 [usbserial]
[  119.303061]  [<c10897b6>] ? mntput_no_expire+0x16/0x60
[  119.303247]  [<c115fa4d>] tty_open+0x1bd/0x4b0
[  119.303395]  [<c1077566>] chrdev_open+0x96/0x140
[  119.303566]  [<c10732ff>] __dentry_open+0x9f/0x250
[  119.313182]  [<c1073599>] nameidata_to_filp+0x59/0x70
[  119.323123]  [<c10774d0>] ? chrdev_open+0x0/0x140
[  119.333092]  [<c107f889>] do_filp_open+0x269/0x890
[  119.343121]  [<c1038c5c>] ? ktime_get_ts+0x4c/0x50
[  119.353157]  [<c10730c7>] do_sys_open+0x57/0x140
[  119.363185]  [<c1026d55>] ? alarm_setitimer+0x35/0x70
[  119.373242]  [<c1073219>] sys_open+0x29/0x40
[  119.383280]  [<c1002e08>] sysenter_do_call+0x12/0x26
[  119.393324] ---[ end trace 3473a8310f07944e ]---
[  119.408837] usb_serial_put(serial @d8c60c00)
[  119.413343] ------------[ cut here ]------------
[  119.417526] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:179 usb_serial_put+0x2b/0x60 [usbserial]()
[  119.421858] Hardware name: TravelMate 660
[  119.426125] Modules linked in: ftdi_sio usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus ehci_hcd uhci_hcd nsc_ircc snd_pcm usbcore irda snd_timer pcspkr snd i2c_i801 snd_page_alloc crc_ccitt
[  119.435491] Pid: 2163, comm: minicom Tainted: G   M    W  2.6.31-rc6 #1
[  119.440021] Call Trace:
[  119.444452]  [<c12b7052>] ? printk+0x18/0x1e
[  119.448835]  [<dea5cceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  119.453171]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  119.457354]  [<dea5cceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  119.461511]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  119.465632]  [<dea5cceb>] usb_serial_put+0x2b/0x60 [usbserial]
[  119.469788]  [<dea5d3b0>] serial_open+0x70/0x250 [usbserial]
[  119.473949]  [<c115fa4d>] tty_open+0x1bd/0x4b0
[  119.478075]  [<c1077566>] chrdev_open+0x96/0x140
[  119.482212]  [<c10732ff>] __dentry_open+0x9f/0x250
[  119.486300]  [<c1073599>] nameidata_to_filp+0x59/0x70
[  119.490406]  [<c10774d0>] ? chrdev_open+0x0/0x140
[  119.494476]  [<c107f889>] do_filp_open+0x269/0x890
[  119.498540]  [<c1038c5c>] ? ktime_get_ts+0x4c/0x50
[  119.502596]  [<c10730c7>] do_sys_open+0x57/0x140
[  119.506622]  [<c1026d55>] ? alarm_setitimer+0x35/0x70
[  119.510654]  [<c1073219>] sys_open+0x29/0x40
[  119.514676]  [<c1002e08>] sysenter_do_call+0x12/0x26
[  119.518689] ---[ end trace 3473a8310f07944f ]---
[  119.523383] tty_port_close_start: count = -1
[  119.527396] serial_do_free(port @da025e00)
[  119.531404]   serial @d8c60c00
[  119.535353]   type   @deb0e660
[  119.539434] usb_serial_put(serial @d8c60c00)
[  119.543430] ------------[ cut here ]------------
[  119.547389] WARNING: at /usr/src/linux-2.6/drivers/usb/serial/usb-serial.c:179 usb_serial_put+0x2b/0x60 [usbserial]()
[  119.551513] Hardware name: TravelMate 660
[  119.555583] Modules linked in: ftdi_sio usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus ehci_hcd uhci_hcd nsc_ircc snd_pcm usbcore irda snd_timer pcspkr snd i2c_i801 snd_page_alloc crc_ccitt
[  119.564707] Pid: 2163, comm: minicom Tainted: G   M    W  2.6.31-rc6 #1
[  119.569109] Call Trace:
[  119.573439]  [<c12b7052>] ? printk+0x18/0x1e
[  119.577675]  [<dea5cceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  119.581857]  [<c10236fc>] warn_slowpath_common+0x6c/0xc0
[  119.585894]  [<dea5cceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  119.589896]  [<c1023765>] warn_slowpath_null+0x15/0x20
[  119.593885]  [<dea5cceb>] usb_serial_put+0x2b/0x60 [usbserial]
[  119.597906]  [<dea5cdb9>] serial_do_free+0x99/0xd0 [usbserial]
[  119.601891]  [<dea5ce57>] serial_close+0x67/0xa0 [usbserial]
[  119.605852]  [<c115d1a5>] ? tty_fasync+0x55/0xe0
[  119.609774]  [<c115f2e0>] tty_release_dev+0x130/0x490
[  119.613714]  [<dea5cceb>] ? usb_serial_put+0x2b/0x60 [usbserial]
[  119.617621]  [<c10207e3>] ? __cond_resched+0x23/0x40
[  119.621535]  [<c12b7d7e>] ? mutex_lock+0xe/0x20
[  119.625407]  [<dea5cd0b>] ? usb_serial_put+0x4b/0x60 [usbserial]
[  119.629318]  [<dea5d3b0>] ? serial_open+0x70/0x250 [usbserial]
[  119.633249]  [<c115fced>] tty_open+0x45d/0x4b0
[  119.637046]  [<c1077566>] chrdev_open+0x96/0x140
[  119.640727]  [<c10732ff>] __dentry_open+0x9f/0x250
[  119.644412]  [<c1073599>] nameidata_to_filp+0x59/0x70
[  119.648080]  [<c10774d0>] ? chrdev_open+0x0/0x140
[  119.651781]  [<c107f889>] do_filp_open+0x269/0x890
[  119.655451]  [<c1038c5c>] ? ktime_get_ts+0x4c/0x50
[  119.659128]  [<c10730c7>] do_sys_open+0x57/0x140
[  119.662807]  [<c1026d55>] ? alarm_setitimer+0x35/0x70
[  119.666484]  [<c1073219>] sys_open+0x29/0x40
[  119.670149]  [<c1002e08>] sysenter_do_call+0x12/0x26
[  119.673808] ---[ end trace 3473a8310f079450 ]---
[  119.678200] destroy_serial(kref @d8c60c34)
[  119.681814]   serial @d8c60c00
[  128.465874] serial_do_free(port @da025e00)
[  128.466022]   serial @da025400
[  128.466147]   type   @203a6e69
[  128.466277] BUG: unable to handle kernel paging request at 203a6e85
[  128.466510] IP: [<dea5cd8d>] serial_do_free+0x6d/0xd0 [usbserial]
[  128.466747] *pde = 00000000 
[  128.466870] Oops: 0000 [#1] 
[  128.466991] last sysfs file: /sys/devices/virtual/hwmon/hwmon0/temp1_input
[  128.467236] Modules linked in: ftdi_sio usbserial squashfs zlib_inflate nfs lockd nfs_acl sunrpc 8021q snd_pcm_oss snd_mixer_oss xfs exportfs loop snd_intel8x0 snd_ac97_codec ac97_bus ehci_hcd uhci_hcd nsc_ircc snd_pcm usbcore irda snd_timer pcspkr snd i2c_i801 snd_page_alloc crc_ccitt
[  128.468576] 
[  128.468651] Pid: 2163, comm: minicom Tainted: G   M    W  (2.6.31-rc6 #1) TravelMate 660
[  128.468905] EIP: 0060:[<dea5cd8d>] EFLAGS: 00010282 CPU: 0
[  128.469105] EIP is at serial_do_free+0x6d/0xd0 [usbserial]
[  128.469279] EAX: 203a6e69 EBX: da025e00 ECX: ffffffff EDX: c13c6584
[  128.469507] ESI: da025400 EDI: 00000000 EBP: db56de24 ESP: db56de10
[  128.469706]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  128.469895] Process minicom (pid: 2163, ti=db56d000 task=dd9ac9f0 task.ti=db56d000)
[  128.470166] Stack:
[  128.470236]  dea60c4e 203a6e69 da025e00 db442c00 00000000 db56de4c dea5ce57 00000000
[  128.470612] <0> db56de4c c115d1a5 db442ca0 d9c84280 db442c00 00000000 00000000 db56dedc
[  128.471032] <0> c115f2e0 00000001 00000002 c17b1c00 d9c84280 00000000 00000000 c1817d80
[  128.471479] Call Trace:
[  128.471576]  [<dea5ce57>] ? serial_close+0x67/0xa0 [usbserial]
[  128.471784]  [<c115d1a5>] ? tty_fasync+0x55/0xe0
[  128.471938]  [<c115f2e0>] ? tty_release_dev+0x130/0x490
[  128.472130]  [<c1056d72>] ? put_page+0x42/0x120
[  128.472282]  [<c10897b6>] ? mntput_no_expire+0x16/0x60
[  128.472466]  [<c115f64a>] ? tty_release+0xa/0x10
[  128.472618]  [<c1075f1c>] ? __fput+0xdc/0x1d0
[  128.472777]  [<c107602f>] ? fput+0x1f/0x30
[  128.472914]  [<c1072f8e>] ? filp_close+0x3e/0x70
[  128.473086]  [<c1024fa2>] ? put_files_struct+0xa2/0xc0
[  128.473253]  [<c1024fdc>] ? exit_files+0x1c/0x20
[  128.473421]  [<c1026339>] ? do_exit+0xb9/0x630
[  128.473570]  [<c103acd8>] ? __put_cred+0x18/0x20
[  128.473738]  [<c10268dd>] ? do_group_exit+0x2d/0x80
[  128.473898]  [<c1026943>] ? sys_exit_group+0x13/0x20
[  128.474076]  [<c1002e08>] ? sysenter_do_call+0x12/0x26
[  128.474240] Code: a6 de 89 44 24 04 e8 cd a2 85 e2 8b 13 31 c0 85 d2 74 03 8b 42 04 89 44 24 04 c7 04 24 4e 0c a6 de e8 b2 a2 85 e2 8b 33 8b 46 04 <8b> 78 1c 8d 83 bc 00 00 00 e8 95 53 75 e2 8d 5e 38 89 d8 e8 cb 
[  128.476094] EIP: [<dea5cd8d>] serial_do_free+0x6d/0xd0 [usbserial] SS:ESP 0068:db56de10
[  128.476408] CR2: 00000000203a6e85
[  128.476518] ---[ end trace 3473a8310f079451 ]---
[  128.476680] Fixing recursive fault but reboot is needed!

With ftdi it crashes on first attempt each time I try.
