Return-Path: <linux-kernel-owner+w=401wt.eu-S1760351AbXFSREZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351AbXFSREZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 13:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756790AbXFSRES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 13:04:18 -0400
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:3277 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754543AbXFSRER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 13:04:17 -0400
Date: Tue, 19 Jun 2007 19:05:02 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Vojtech Pavlik <vojtech@ucw.cz>
Subject: Writing a driver for a legacy serial device
Message-ID: <20070619190502.05d4e0c8@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I want to write a Linux kernel driver for a device which connects to
the legacy serial port. I started writing a driver, however I am
already stuck at the very beginning. The .connect function of my serial
driver is never called, and I just don't get why. I couldn't find any
documentation about writing such a legacy driver in Documentation nor
in LDD3. Is there anyone out there which could lend a helping hand?

I know that the device and my serial port both work. I can talk to the
device using minicom just fine. I have the following drivers loaded: 

$ lsmod | grep 8250
8250_pnp               11648  0
8250                   23464  1 8250_pnp
serial_core            19392  1 8250

Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A

But I need to implement my driver in kernel space. My code looks like
this:

static struct serio_device_id taos_serio_ids[] = {
	{
		.type	= SERIO_RS232,
		.proto	= SERIO_ANY,
		.id	= SERIO_ANY,
		.extra	= SERIO_ANY,
	},
	{ 0 }
};
MODULE_DEVICE_TABLE(serio, taos_serio_ids);

static struct serio_driver taos_drv = {
	.driver		= {
		.name	= "taos-evm",
	},
	.description	= "TAOS evaluation module driver",
	.id_table	= taos_serio_ids,
	.connect	= taos_connect,
	.disconnect	= taos_disconnect,
	.interrupt	= taos_interrupt,
};

static int __init taos_init(void)
{
	return serio_register_driver(&taos_drv);
}

static void __exit taos_exit(void)
{
	serio_unregister_driver(&taos_drv);
}

The problem is that taos_connect is never called. I suppose that I need
different values for .type, .proto or .id, except that I just don't
know what to put there. I tried a few random values without success.
What's the trick?

Thanks,
-- 
Jean Delvare
