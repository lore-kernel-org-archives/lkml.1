Return-Path: <linux-kernel-owner+w=401wt.eu-S1760888AbXFTI4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760888AbXFTI4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 04:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbXFTIz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 04:55:56 -0400
Received: from smtp-103-wednesday.noc.nerim.net ([62.4.17.103]:1293 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751463AbXFTIzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 04:55:55 -0400
Date: Wed, 20 Jun 2007 10:56:48 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Vojtech Pavlik" <vojtech@ucw.cz>
Subject: Re: Writing a driver for a legacy serial device
Message-ID: <20070620105648.6d18ad66@hyperion.delvare>
In-Reply-To: <d120d5000706191159w29ebd0dajbd6cb9ac78d4faa2@mail.gmail.com>
References: <20070619190502.05d4e0c8@hyperion.delvare>
	<d120d5000706191159w29ebd0dajbd6cb9ac78d4faa2@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Thanks for your answer, very much appreciated.

On Tue, 19 Jun 2007 14:59:34 -0400, Dmitry Torokhov wrote:
> Hi Jean,
> 
> On 6/19/07, Jean Delvare <khali@linux-fr.org> wrote:
> > Hi all,
> >
> > I want to write a Linux kernel driver for a device which connects to
> > the legacy serial port. I started writing a driver, however I am
> > already stuck at the very beginning. The .connect function of my serial
> > driver is never called, and I just don't get why. I couldn't find any
> > documentation about writing such a legacy driver in Documentation nor
> > in LDD3. Is there anyone out there which could lend a helping hand?
> >
> > I know that the device and my serial port both work. I can talk to the
> > device using minicom just fine. I have the following drivers loaded:
> >
> > $ lsmod | grep 8250
> > 8250_pnp               11648  0
> > 8250                   23464  1 8250_pnp
> > serial_core            19392  1 8250
> >
> > Serial: 8250/16550 driver $Revision: 1.90 $ 2 ports, IRQ sharing disabled
> > 00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> >
> > But I need to implement my driver in kernel space. My code looks like
> > this:
> >
> > static struct serio_device_id taos_serio_ids[] = {
> >        {
> >                .type   = SERIO_RS232,
> >                .proto  = SERIO_ANY,
> >                .id     = SERIO_ANY,
> >                .extra  = SERIO_ANY,
> >        },
> >        { 0 }
> > };
> > MODULE_DEVICE_TABLE(serio, taos_serio_ids);
> >
> > static struct serio_driver taos_drv = {
> >        .driver         = {
> >                .name   = "taos-evm",
> >        },
> >        .description    = "TAOS evaluation module driver",
> >        .id_table       = taos_serio_ids,
> >        .connect        = taos_connect,
> >        .disconnect     = taos_disconnect,
> >        .interrupt      = taos_interrupt,
> > };
> >
> > static int __init taos_init(void)
> > {
> >        return serio_register_driver(&taos_drv);
> > }
> >
> > static void __exit taos_exit(void)
> > {
> >        serio_unregister_driver(&taos_drv);
> > }
> >
> > The problem is that taos_connect is never called. I suppose that I need
> > different values for .type, .proto or .id, except that I just don't
> > know what to put there. I tried a few random values without success.
> > What's the trick?
> 
> You need to load serport modue and play with inputattach utility.

Ah, I see. There's no way to detect what device is connected to the
serial port, so we need a user-space tool to bind the port to the right
driver? Makes some sense, even though it's a but strange that I need
something called inputattach for a device which isn't an input device.

So I've set CONFIG_SERIO_SERPORT=m, compiled and loaded serport. Then I
added a new protocol number in <linux/serio.h>:

#define SERIO_TAOSEVM	0x40

Then I added the following entry to inputattach and recompiled it:

{ "--taos-evm",		"-taos",	B1200, CS8,			SERIO_TAOSEVM,	0,	0,	0,	NULL },

Then I changed my driver code to:

static struct serio_device_id taos_serio_ids[] = {
	{
		.type	= SERIO_RS232,
		.proto	= SERIO_TAOSEVM,
		.id	= SERIO_ANY,
		.extra	= SERIO_ANY,
	},
	{ 0 }
};

And lastly I ran, as root:

./inputattach -taos /dev/ttyS0

I see the following line in the logs as a result:

serio: Serial port ttyS0

But unfortunately, my driver's .connect function is still not called.
I guess that I missed one step? Any idea what it would be?

Thanks,
-- 
Jean Delvare
