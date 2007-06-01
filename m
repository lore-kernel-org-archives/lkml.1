Return-Path: <linux-kernel-owner+w=401wt.eu-S1761947AbXFARYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761947AbXFARYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759188AbXFARYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:24:03 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:45050 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755828AbXFARYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:24:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uOyT9cOzG3eMJzQgILfeBEAYyFM7/VsFyEkonM4A56DZ47h1V8QX8HT0CCddoPcwRgRTGUOpLORg4owBOmEDQ7KXHMdMUfc6EzBIh3y7tFbJ6MKjEPe4USycBYlRqnX+lbYtKX42cjxV/slqsjmfSzG31F4bj2dOfRFzLcZtFLo=  ;
X-YMail-OSG: WSKQQOUVM1mgHligG_oYC2L7CGey.4ZvvPPEnnO.kz71Yd20tPbjpUFsOOv5MP86TyUWjNOhEpVo0AN0PKwSdvsjdqq5BilCk5jaCV.RM2rZdlYpZspRQcc3v17L4xA8xBLad4bApw--
From: David Brownell <david-b@pacbell.net>
To: akorolev <alexey.korolev@intel.com>
Subject: Re: [PATCH] SPI FLASH naming conflicts solving
Date: Fri, 1 Jun 2007 10:01:05 -0700
User-Agent: KMail/1.9.6
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org, gregkh@suse.de
References: <523F3D8D8C97554AA47E53DF1A05466A666249@nnsmsx411.ccr.corp.intel.com> <45FEC94F.8090006@intel.com> <46602B2D.7070902@intel.com>
In-Reply-To: <46602B2D.7070902@intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706011001.05471.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 June 2007, akorolev wrote:
> Hi Dawid
> 
> I tried to enable SPI flash device in our development platform (Mainstone).
> Since the platform driver uses NOR flash device - it includes 
> "include/asm-arm/mach/flash.h" file where the structure "flhash_platform 
> _data" is defined.
> The structure with the same name "flhash_platform _data" is also defined 
> in "include/linux/spi/flash.h".
> These structures are different - so they cause compile errors.

That name seems a bit generic for either driver to use!

Except I don't understand why <asm/mach/flash.h> is used there
instead of the more current <linux/mtd/physmap.h> ... certainly
mainstone's current code doesn't need more than physmap.  After
all, the reason for the physmap updates was to help move away
from the platform-specific drivers (like those ARM ones).

And for mainstone, switching looks trivial.  Not to mention
overdue, since the "pxa2xx-flash" driver which would use the
old ARM-specific "flash_platform_data" isn't available in the
kernel.org tree ... so arch/arm/mach-pxa/mainstone.c seems to
be buggy in even using that struct.


> I attached the fix for this issue. IMHO it's more preferable to resolve 
> issue by minor modification of SPI driver than touching all arm platform 
> drivers.

Not "all" of them ... and in any case, as I said, I thought
the idea was to start getting rid of all those platform specific
mapping drivers.

In your case, it seems like fixing mainstone.c should come
first; and that would eliminate the problem you're seeing.
As folk have noted, the PXA code hasn't been well maintained;
this would seem to be a symptom of that.

But otherwise, if that ARM-specific stuff should still be
used ... maybe.  You omitted the header file change, as well
as some of its other users.  (A surprising number of Blackfin
boards use m25p80 with platform data to specify partitions.)
A shorter name, maybe "spi_flash_data", would be better too.


> --- orig/drivers/mtd/devices/m25p80.c	2007-06-01 19:06:52.000000000 +0400
> +++ new/drivers/mtd/devices/m25p80.c	2007-05-10 16:56:15.000000000 +0400
> @@ -423,7 +449,7 @@
>   */
>  static int __devinit m25p_probe(struct spi_device *spi)
>  {
> -	struct flash_platform_data	*data;
> +	struct spi_flash_platform_data	*data;
>  	struct m25p			*flash;
>  	struct flash_info		*info;
>  	unsigned			i;
> diff -aur orig/drivers/mtd/devices/mtd_dataflash.c new/drivers/mtd/devices/mtd_dataflash.c
> --- orig/drivers/mtd/devices/mtd_dataflash.c	2007-06-01 19:06:48.000000000 +0400
> +++ new/drivers/mtd/devices/mtd_dataflash.c	2007-05-10 14:41:39.000000000 +0400
> @@ -457,7 +457,7 @@
>  {
>  	struct dataflash		*priv;
>  	struct mtd_info			*device;
> -	struct flash_platform_data	*pdata = spi->dev.platform_data;
> +	struct spi_flash_platform_data	*pdata = spi->dev.platform_data;
>  
>  	priv = kzalloc(sizeof *priv, GFP_KERNEL);
> =============================
> Could you please take a look at this. The fix is simple. If you don't complain
> could you please include it.  

I think that'd be for the MTD and platform maintainers to handle.


> Thanks,
> Alexey
> 
> P/S Also I have a question:
> I faced rather strange problem with sending read and write commands  to 
> SPI  flash. It works Ok if I reverse 32bit SPI FLASH command
> I mean - read/write/erase works if to substitute
>     flash->command[0] = OPCODE_SE;
>     flash->command[1] = offset >> 16;
>     flash->command[2] = offset >> 8;
>     flash->command[3] = offset;
> for
>     flash->command[3] = OPCODE_SE;
>     flash->command[2] = offset >> 16;
>     flash->command[1] = offset >> 8;
>     flash->command[0] = offset;
> in file drivers/mtd/devices/m25p80.c
> 
> It seems pretty strange and may require more investigation.
> I wonder If you have any ideas why it could happen? If anybody tested 
> m25p80.c driver on LittleEndian platforms?

I'd guess this is just a bug in your spi controller driver or in
its configuration.  It looks like you're using a 32 bits_per_word
setting -- with an effective cpu_to_be32() in the I/O path, wrong
since the data is *already* in the right byte order -- instead of
the 8 bits specified by the driver (no byte order changes).

- Dave

 
