Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbYLMNFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbYLMNFm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 08:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbYLMNFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 08:05:33 -0500
Received: from mail-bw0-f13.google.com ([209.85.218.13]:47862 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbYLMNFd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 08:05:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:content-type
         :content-transfer-encoding:message-id;
        b=W4dVo3Ap9xVJJ9t7Yi07ye0F0eCUalnKTonyPT09UAAK0rAQEkpeePMkIJ/fImzZxP
         jR0YE8qvk6a/tZ5OWXTX36Hr64y69HdEca4JqWZ6SJ8z4OuL1LfdCCxMEn2o7h6Mbwp0
         Vj0cgjhD35p22QHMZKunIoTq7nqFpYkPip6gk=
From: Florian Fainelli <florian@openwrt.org>
To: Hugo Villeneuve <hugo@hugovil.com>
Subject: Re: FPGA programming driver architecture
Date: Sat, 13 Dec 2008 13:58:01 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org
References: <20081212150314.6ea24996.hugo@hugovil.com>
In-Reply-To: <20081212150314.6ea24996.hugo@hugovil.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200812131358.03010.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC'ing linux-embedded)

Salut Hugo,

Le Friday 12 December 2008 21:03:14 Hugo Villeneuve, vous avez écrit :
> Hi,
> I have written some code to program a FPGA in Linux, for two different
> types of boards: one uses a serial interface (SPI) and the second a
> parallel interface. I have been able to sucessfully program both boards.
> I'm now trying to clean my code and make it more generic, as well as better
> in line with the Linux driver model. I would also like to include it in the
> mainline kernel if there is interest.

Is it a platform-driver ? What do you provide in platform_data ?

>
> Here is a description of the current architecture (refer to diagrams
> below): The fpgaload module controls one output GPIOs (PROG), and two input
> GPIOs (INIT and DONE). These GPIOs are specified in board setup code. Both
> fpgaload_ser and fpgaload_par modules export a single function to write a
> byte. The fpgaload driver is a char device to which we can write
> (/dev/fpgaload) to program a bitstream (FPGA firmware) inside the FPGA. 

You should probably consider using request_firmware to load the bitstream from 
the userspace and possibly add a /sys interface to export some attributes 
like :

- GPIOs being used between the host and the FPGA
- status (i.e : programmed, not programmed ...)
- FPGA vendor, type ...

> The 
> fpgaload driver will toggle the GPIOs to initiate programming and the then
> call the corresponding write_byte function based on the interface type
> specified in board setup code (serial or parallel, or any future interface
> desired).

> The problem with that approach is that when loading the fpgaload module
> with modprobe, it will automatically try to load the fpgaload_ser and
> fpgaload_par modules, even if only serial interface was specified in board
> setup code for example. This is not good when building a kernel for similar
> but different boards.

What about something like that :

- fpgaload-core which contains all the code that can be shared between the 
drivers like requesting firmware, providing sysfs attributes, 
- fpgaload-spi would handle the low-level SPI connection
- fpgaload-par would handle the low-level parallel connection

fpgaload-ser and par would register with fpgaload-core and they could register 
a fpga loading callback which is low-level specific for instance. Platform 
code would instantiate the core driver. That way, adding support for other 
loading protocols like slave serial or master serial can be done easily.

>
> Probably a better approach would be for the fpgaload_Ser and fpgaload_par
> modules to register themselves with the fpgaload module. Then, should the
> fpgaload module be built using a BUS driver structure? Or anyone having any
> suggestions on how it should be implemented?
-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
