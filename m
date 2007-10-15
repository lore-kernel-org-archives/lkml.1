Return-Path: <linux-kernel-owner+w=401wt.eu-S1764525AbXJOLZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764525AbXJOLZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 07:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758910AbXJOLZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 07:25:16 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:56674 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555AbXJOLZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 07:25:12 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Ferenc Wagner <wferi@niif.hu>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: RocketPort Linux driver errors on module reload
In-reply-to: <87abqk1z3t.fsf@tac.ki.iif.hu>
Message-id: <bububu786234897832@pripojeni.net>
Date: Mon, 15 Oct 2007 07:25:12 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> -------------------- Start of forwarded message --------------------
> From: Ferenc Wagner <wferi@niif.hu>
> To: support@comtrol.co.uk
> Subject: RocketPort Linux driver errors on module reload
> Date: Fri, 12 Oct 2007 00:22:17 +0200
> Message-ID: <87fy0hwaue.fsf@tac.ki.iif.hu>
> 
> Hi,
> 
> I hope I send this message to the right address...
> 
> I experience the following with the 2.09 version of the driver, as
> included in vanilla Linux 2.6.23.  If I insert the module, I got some
> pretty normal messages, like:
> 
> RocketPort device driver module, version 2.09, 12-June-2003
> ACPI: PCI Interrupt 0000:01:08.0[A] -> GSI 20 (level, low) -> IRQ 21
> Comtrol PCI controller #0 ID 0x802 found in bus:slot:fn 0000:01:08.0 at address d800, 1 AIOP(s) (RocketPort UPCI 8 port w/external I/F)
> Installing RocketPort UPCI 8 port w/external I/F, creating /dev/ttyR0 - 7
> ACPI: PCI Interrupt 0000:02:06.0[A] -> GSI 24 (level, low) -> IRQ 22
> Comtrol PCI controller #1 ID 0x802 found in bus:slot:fn 0000:02:06.0 at address c800, 1 AIOP(s) (RocketPort UPCI 8 port w/external I/F)
> Installing RocketPort UPCI 8 port w/external I/F, creating /dev/ttyR8 - 15
> 
> However, if I remove the module from the kernel, and then insert it
> again, lots of error messages result:
> 
> RocketPort device driver module, version 2.09, 12-June-2003
> Comtrol PCI controller #0 ID 0x802 found in bus:slot:fn 0000:01:08.0 at address d800, 1 AIOP(s) (RocketPort UPCI 8 port w/external I/F)
> Installing RocketPort UPCI 8 port w/external I/F, creating /dev/ttyR0 - 7
> kobject_add failed for ttyR0 with -EEXIST, don't try to register things with the same name in the same directory.
>  [<c01ccdb4>] kobject_shadow_add+0x156/0x188
>  [<c01cd095>] kobject_set_name+0x2b/0x92
>  [<c022d022>] device_add+0x87/0x50f
>  [<c01cce24>] kobject_init+0x2f/0x3f
>  [<c022da2c>] device_create+0x77/0x97
>  [<c02154cb>] tty_register_device+0xb5/0xbd
>  [<f8a130d3>] init_r_port+0x5f1/0x623 [rocket]
>  [<c02409a9>] pci_read+0x29/0x2e
>  [<f8b74ff7>] rp_init+0xff7/0x111a [rocket]
>  [<c013fd38>] __link_module+0x0/0x1f
>  [<c01421de>] sys_init_module+0x1470/0x15a9
>  [<c01296a7>] __request_region+0x0/0x80
>  [<c0103e12>] sysenter_past_esp+0x6b/0xa1
>  =======================
> And so on for each device.
> 
> However, the card seems to operate all right.  Still, the messages
> suggest something isn't quite right and could use some fixing.  Hope
> you can find the problem.

Could you try the attached patch below?

--

diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 56cbba7..94bb3d0 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -699,8 +699,8 @@ static void init_r_port(int board, int aiop, int chan, struct pci_dev *pci_dev)
 	spin_lock_init(&info->slock);
 	mutex_init(&info->write_mtx);
 	rp_table[line] = info;
-	if (pci_dev)
-		tty_register_device(rocket_driver, line, &pci_dev->dev);
+	tty_register_device(rocket_driver, line, pci_dev ? &pci_dev->dev :
+			NULL);
 }
 
 /*
@@ -2434,7 +2434,7 @@ static int __init rp_init(void)
 	rocket_driver->init_termios.c_ispeed = 9600;
 	rocket_driver->init_termios.c_ospeed = 9600;
 #ifdef ROCKET_SOFT_FLOW
-	rocket_driver->flags |= TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
+	rocket_driver->flags |= TTY_DRIVER_REAL_RAW;
 #endif
 	tty_set_operations(rocket_driver, &rocket_ops);
 
@@ -2491,10 +2491,14 @@ static void rp_cleanup_module(void)
 	if (retval)
 		printk(KERN_INFO "Error %d while trying to unregister "
 		       "rocketport driver\n", -retval);
-	put_tty_driver(rocket_driver);
 
 	for (i = 0; i < MAX_RP_PORTS; i++)
-		kfree(rp_table[i]);
+		if (rp_table[i]) {
+			tty_unregister_device(rocket_driver, i);
+			kfree(rp_table[i]);
+		}
+
+	put_tty_driver(rocket_driver);
 
 	for (i = 0; i < NUM_BOARDS; i++) {
 		if (rcktpt_io_addr[i] <= 0 || is_PCI[i])
