Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbZFYCur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbZFYCur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 22:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbZFYCug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 22:50:36 -0400
Received: from 130.120.124.202.static.snap.net.nz ([202.124.120.130]:45606
	"EHLO hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751772AbZFYCug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 22:50:36 -0400
Message-ID: <4A42E68A.3020702@bluewatersys.com>
Date: Thu, 25 Jun 2009 14:52:58 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       spi-devel-general@lists.sourceforge.net, mike@steroidmicros.com,
       linux kernel <linux-kernel@vger.kernel.org>,
       Linus Walleij <linus.ml.walleij@gmail.com>, akpm@linux-foundation.org
Subject: Re: [spi-devel-general] [PATCH] SST25L (non JEDEC) SPI Flash driver
References: <4A3F017B.2010409@bluewatersys.com> <BD79186B4FD85F4B8E60E381CAEE1909019BE1CE@mi8nycmail19.Mi8.com> <4A42DB93.8020503@bluewatersys.com> <BD79186B4FD85F4B8E60E381CAEE1909019BE1D5@mi8nycmail19.Mi8.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE1909019BE1D5@mi8nycmail19.Mi8.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H Hartley Sweeten wrote:
> On Wednesday, June 24, 2009 7:06 PM, Ryan Mallon wrote:
>> H Hartley Sweeten wrote:
>>> On Sunday, June 21, 2009 8:59 PM, Ryan Mallon wrote:

> I think you could still support the block erase and chip erase internal
> to the driver for performance.  Maybe something like the following?
> 
> static int sst25l_erase(struct mtd_info *mtd, struct erase_info *instr)
> {
...
> 	if (instr->len == mtd->size) {
> 		err = __sst25l_erase(flash, addr, SST25L_CMD_CHIP_ERASE);
> 		if (err) {
> 			mutex_unlock(&flash->lock);
> 			instr->state = MTD_ERASE_FAILED;
> 			dev_err(&flash->spi->dev, "Erase failed\n");
> 			return err;
> 		}
> 	} else {
> 		while (addr < end) {
> 			u32 erasesize;
> 
> 			if (addr % block || addr + block > end) {
> 				erasesize = sector;
> 				err = __sst25l_erase(flash, addr,
> 						SST25L_CMD_SECTOR_ERASE);
> 			} else {
> 				erasesize = block;
> 				err = __sst25l_erase(flash, addr,
> 						SST25L_CMD_BLOCK_ERASE);
> 			}
> 			if (err) {
> 				mutex_unlock(&flash->lock);
> 				instr->state = MTD_ERASE_FAILED;
> 				dev_err(&flash->spi->dev, "Erase failed\n");
> 				return err;
> 			}
> 
> 			addr += erasesize;
> 		}
> 	}

> 
> You would need to add sector_size and block_size to the ss25l_flash
> and flash_info structs and modify flash_info as appropriate.  Then copy
> those over during the probe and use sector_size for mtd.erasesize.
> 
> That way we get the 4K erase size but still get the performance increase
> for block and chip erase.

We discussed this, but it adds additional complexity to what is
otherwise quite a simple driver. The 4K sector erase will work in all
cases, and the speed difference shouldn't be a massive problem. I would
venture a guess that most people using the chips have reasonably
non-volatile storage on them, and don't get erased very often. We use
ours for the Bootloader and boot environment.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

       Ryan Mallon                              Unit 5, Amuri Park
       Phone: +64 3 3779127                     404 Barbadoes St
       Fax:   +64 3 3779135                     PO Box 13 889
       Email: ryan@bluewatersys.com             Christchurch, 8013
       Web:   http://www.bluewatersys.com       New Zealand
       Freecall Australia  1800 148 751         USA 1800 261 2934
