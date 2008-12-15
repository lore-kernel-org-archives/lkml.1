Return-Path: <linux-kernel-owner+w=401wt.eu-S1756099AbYLOSQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbYLOSQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 13:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbYLOSQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 13:16:50 -0500
Received: from 201-217-static-ppp.3menatwork.com ([64.235.217.201]:54685 "EHLO
	server.hugovil.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752110AbYLOSQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 13:16:49 -0500
Date: Mon, 15 Dec 2008 13:16:44 -0500
From: Hugo Villeneuve <hugo@hugovil.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
Subject: Re: FPGA programming driver architecture
Message-Id: <20081215131644.8671abeb.hugo@hugovil.com>
In-Reply-To: <200812131358.03010.florian@openwrt.org>
References: <20081212150314.6ea24996.hugo@hugovil.com>
	<200812131358.03010.florian@openwrt.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Default is to whitelist mail, not delayed by milter-greylist-3.0 (server.hugovil.com [64.235.217.201]); Mon, 15 Dec 2008 13:16:45 -0500 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2008 13:58:01 +0100
Florian Fainelli <florian@openwrt.org> wrote:

> (CC'ing linux-embedded)
> 
> Salut Hugo,
> 
> Le Friday 12 December 2008 21:03:14 Hugo Villeneuve, vous avez écrit :
> > Hi,
> > I have written some code to program a FPGA in Linux, for two
> > different types of boards: one uses a serial interface (SPI) and
> > the second a parallel interface. I have been able to sucessfully
> > program both boards. I'm now trying to clean my code and make it
> > more generic, as well as better in line with the Linux driver
> > model. I would also like to include it in the mainline kernel if
> > there is interest.
> 
> Is it a platform-driver ? What do you provide in platform_data ?

Hi Florian,
Yes, currently it is a platform driver. Here is my platform data:

static struct fpgaload_pdata_t fpgaload_pdata = {
        .fpga_family            = FPGA_FAMILY_XILINX_XC3S,
        .payload_full_size      = XC3S1400A_PAYLOAD_SIZE,
        .program_b              = GPIO(21),
        .done                   = GPIO(19),
        .init_b                 = GPIO(20),
        .swapbits               = 0,
        .interface              = FPGALOAD_INTERFACE_SERIAL,
        .bitstream_name         = "fpga.bit",
};

> > Here is a description of the current architecture (refer to diagrams
> > below): The fpgaload module controls one output GPIOs (PROG), and
> > two input GPIOs (INIT and DONE). These GPIOs are specified in board
> > setup code. Both fpgaload_ser and fpgaload_par modules export a
> > single function to write a byte. The fpgaload driver is a char
> > device to which we can write (/dev/fpgaload) to program a bitstream
> > (FPGA firmware) inside the FPGA. 
> 
> You should probably consider using request_firmware to load the
> bitstream from the userspace and possibly add a /sys interface to
> export some attributes like :

This is already the case with request_firmware :) The bitstream_name field in platform data is used to specify the name of the file.
 
> - GPIOs being used between the host and the FPGA
> - status (i.e : programmed, not programmed ...)
> - FPGA vendor, type ...
> 
> > The 
> > fpgaload driver will toggle the GPIOs to initiate programming and
> > the then call the corresponding write_byte function based on the
> > interface type specified in board setup code (serial or parallel,
> > or any future interface desired).
> 
> > The problem with that approach is that when loading the fpgaload
> > module with modprobe, it will automatically try to load the
> > fpgaload_ser and fpgaload_par modules, even if only serial
> > interface was specified in board setup code for example. This is
> > not good when building a kernel for similar but different boards.
> 
> What about something like that :
> 
> - fpgaload-core which contains all the code that can be shared
> between the drivers like requesting firmware, providing sysfs
> attributes, 
> - fpgaload-spi would handle the low-level SPI connection
> - fpgaload-par would handle the low-level parallel connection

This is pretty much like that right now, exceptfor sysfs attributes.

> fpgaload-ser and par would register with fpgaload-core and they could
> register a fpga loading callback which is low-level specific for
> instance. Platform code would instantiate the core driver. That way,
> adding support for other loading protocols like slave serial or
> master serial can be done easily.

Yes, I think this could work, but I would like to know what kind of driver fpgaload-core would be. Currently it is a platform driver and a chardev (to support open and write methods for programming). How shall I implement it? Bus driver, platform driver?

Ciao, Hugo V.
