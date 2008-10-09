Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbYJIOMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbYJIOMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 10:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbYJIOM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 10:12:28 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:35320 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbYJIOM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 10:12:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=qeopuJsf27HAu2yHf3fHvva4nFIfxnYexII/A+3GYgPGATI4VKCoImoLsXbvKEZLAH
         Cu2jK2clyU+/U3FalflCz1seXiF1ivfE+eRGCjPJnLGeudUBJI6BPgTPGOH41hpZw9Zg
         t1XkPdFLih24eZfOxy0z2vVsP2bRcIazx2gZI=
Message-ID: <d970ff420810090712p7a70d22bw37aea8d62a1a436f@mail.gmail.com>
Date: Thu, 9 Oct 2008 11:12:25 -0300
From: Alemao <xcarandiru@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Physmap drivers (FSL UPM NAND)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Im trying to use a physmap driver for NOR and NAND flash devices.

With NOR, everything ok. It uses CFI driver.

The problem is with NAND, cause it is connected at Freescale
LocalBus UPM, and at a first look, the UPM driver is loading after the
physmap (lines 14-15 in kernel output)

Here some outputs from the board:

Bootloader (U-Boot 1.2.0):

CPU:   e300c1, MPC8360E, Rev: 21 at 499.999 MHz, CSB:  333 MHz
Board: MPC8360KTX
I2C:   ready
DDR RAM: 128 MB
FLASH: 16 MB
NAND:  64 MiB
In:    serial
Out:   serial
Err:   serial


Kernel (linux-2.6.17):

1               physmap nor flash device: 1000000 at ff000000
2               NOR flash: Found 1 x16 devices at 0x0 in 16-bit bank
3                Amd/Fujitsu Extended Query Table at 0x0040
4                number of CFI chips: 1
5               Using physmap partition definition
6               Creating 6 MTD partitions on "NOR flash":
7               0x00000000-0x00040000 : "u-boot"
8               0x00040000-0x00060000 : "env."
9               0x00060000-0x00080000 : "sys"
10              0x00080000-0x000c0000 : "logs"
11              0x000c0000-0x00860000 : "admin"
12              0x00860000-0x01000000 : "users"
13
14              physmap nand flash device: 4000000 at 60000000
15              UPM: User-Programmable Machine NAND driver


Device Tree Source:

localbus@e0005000 {
   compatible = "fsl,board-localbus";
   #address-cells = <2>;
   #size-cells = <1>;
   reg = <e0005000 d8>;    // BRx, ORx, etc

   ranges = <0 0 ff000000 1000000     // nor flash,  16 MB
                     1 0 60000000 4000000>;   // nand flash, 64 MB

   flash@0,0 {
       compatible = "atmel,29LV256", "cfi-flash";
       reg = <0 0 1000000>;
       bank-width = <2>;
       device-width = <1>;
   };

   nand@1,0 {
       compatible = "stmicro,NAND512W3A", "fsl,upm-nand";
       reg = <1 0 4000000>;   //reg = <1 0 1>;
       width = <1>;
       upm = "A";
       upm-addr-offset = <16>;
       upm-cmd-offset = <8>;
       gpios = <4 18>;
       gpio-parent = <&qe_pio>;
       wait-pattern;
       wait-write;
   };
};

The CFI driver is at linux/drivers/mtd/chips
The UPM driver is at linux/drivers/mtd/nand

So, how can I load the UPM driver before physmap?

Thanks in advance,

--
Alemao
