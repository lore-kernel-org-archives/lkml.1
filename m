Return-Path: <linux-kernel-owner+w=401wt.eu-S1754786AbZFYCao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbZFYCao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 22:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZFYCaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 22:30:35 -0400
Received: from exprod6ob111.obsmtp.com ([64.18.1.26]:46850 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751772AbZFYCae convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 22:30:34 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [spi-devel-general] [PATCH] SST25L (non JEDEC) SPI Flash driver
Date: Wed, 24 Jun 2009 22:30:34 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909019BE1D5@mi8nycmail19.Mi8.com>
In-Reply-To: <4A42DB93.8020503@bluewatersys.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [spi-devel-general] [PATCH] SST25L (non JEDEC) SPI Flash driver
Thread-Index: Acn1OTEjAYwdl3pzQNe98dkv4+bhNQAAh3TQ
References: <4A3F017B.2010409@bluewatersys.com> <BD79186B4FD85F4B8E60E381CAEE1909019BE1CE@mi8nycmail19.Mi8.com> <4A42DB93.8020503@bluewatersys.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Ryan Mallon" <ryan@bluewatersys.com>
Cc: "David Woodhouse" <dwmw2@infradead.org>, <linux-mtd@lists.infradead.org>,
       <spi-devel-general@lists.sourceforge.net>, <mike@steroidmicros.com>,
       "linux kernel" <linux-kernel@vger.kernel.org>,
       "Linus Walleij" <linus.ml.walleij@gmail.com>,
       <akpm@linux-foundation.org>
X-OriginalArrivalTime: 25 Jun 2009 02:30:35.0569 (UTC) FILETIME=[EB8FEA10:01C9F53C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 24, 2009 7:06 PM, Ryan Mallon wrote:
> H Hartley Sweeten wrote:
>> On Sunday, June 21, 2009 8:59 PM, Ryan Mallon wrote:
>>   
>>> Add support for the non JEDEC SST25L SPI Flash devices.
>>>
>>> Signed-off-by: Andre Renaud <andre@bluewatersys.com>
>>> Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
>>>     
>>
>>   
>>> +struct flash_info {
>>> +	const char		*name;
>>> +	u16			device_id;
>>> +	unsigned		page_size;
>>> +	unsigned		nr_pages;
>>> +	unsigned		erase_size;
>>> +};
>>> +
>>> +#define to_sst25l_flash(x) container_of(x, struct sst25l_flash, mtd)
>>> +
>>> +static struct flash_info __devinitdata sst25l_flash_info[] = {
>>> +	{"sst25lf020a", 0xbf43, 256, 1024, 32 * 1024},
>>> +	{"sst25lf040a",	0xbf44,	256, 2048, 32 * 1024},
>>> +};
>>> +
>>>     
>>
>> Ryan,
>>
>> I finally got a chance to test this on my hardware.  Previously
>> I was using a hacked version on the m25p80 driver to access the
>> SST23LF020A on my board.
>>
>> The driver works fine but you are only supporting the block erase,
>> SST25L_CMD_BLOCK_ERASE (opcode 0x52).  The SST25L chips also can do a
>> sector erase (opcode 0x20) and a full chip erase (opcode 0x60).
>>   
> The MTD sub-system doesn't support different types of erases (as far as
> I am aware). We chose to use block erases since they are faster than
> sector erases and the trade-off of having 32k aligned partitions didn't
> seem to bad.

True.  The mtd.erasesize is supposed to be the smallest erasable region
on the chip.  Thus, the sector size should be used.

>> The full chip erase is not that important but might give a slight
>> performance increase on larger devices.  Max block erase time is
>> listed as 25ms at 25MHz in the datasheet.  The SST25LF020A contains
>> 8 blocks so it's "typical" full chip erase time should be around
>> 200ms.  For comparison, the chip erase time is listed as 100ms.
>>
>> The sector erase is a bigger deal.  On the EDB93xx boards one of the
>> SPI flash uses is used to store the MAC address at offset 0x2000 (4K
>> offset).  The board can also be configured to boot from offset 0x0000
>> in the SPI flash.  
>>   
>> Without the sector erase this partition setup results in all of the
>> partitions being forced read-only.
>>   
> The updated patch below uses sector erases instead to allow for smaller
> partition sizes.
>
> Linus, is this still okay by you?

I think you could still support the block erase and chip erase internal
to the driver for performance.  Maybe something like the following?


static int __sst25l_erase(struct sst25l_flash *flash, u32 offset, u8 cmd)
{
	u8 command[4];
	int err;

	err = sst25l_write_enable(flash, 1);
	if (err)
		return err;

	command[0] = cmd;
	if (cmd != SST25L_CMD_CHIP_ERASE) {
		command[1] = offset >> 16;
		command[2] = offset >> 8;
		command[3] = offset;
	}
	err = spi_write(flash->spi, command,
			cmd == SST25L_CMD_CHIP_ERASE ? 1 : 4);
	if (err)
		return err;

	err = sst25l_wait_till_ready(flash);
	if (err)
		return err;

	return sst25l_write_enable(flash, 0);
}

static int sst25l_erase(struct mtd_info *mtd, struct erase_info *instr)
{
	struct sst25l_flash *flash = to_sst25l_flash(mtd);
	u32 block = flash->block_size;
	u32 sector = flash->sector_size;
	u32 addr, end;
	int err;

	/* Sanity checks */
	if (instr->addr + instr->len > flash->mtd.size)
		return -EINVAL;

	if ((u32)instr->len % mtd->erasesize)
		return -EINVAL;

	if ((u32)instr->addr % mtd->erasesize)
		return -EINVAL;

	addr = instr->addr;
	end = addr + instr->len;

	mutex_lock(&flash->lock);

	err = sst25l_wait_till_ready(flash);
	if (err)
		return err;

	if (instr->len == mtd->size) {
		err = __sst25l_erase(flash, addr, SST25L_CMD_CHIP_ERASE);
		if (err) {
			mutex_unlock(&flash->lock);
			instr->state = MTD_ERASE_FAILED;
			dev_err(&flash->spi->dev, "Erase failed\n");
			return err;
		}
	} else {
		while (addr < end) {
			u32 erasesize;

			if (addr % block || addr + block > end) {
				erasesize = sector;
				err = __sst25l_erase(flash, addr,
						SST25L_CMD_SECTOR_ERASE);
			} else {
				erasesize = block;
				err = __sst25l_erase(flash, addr,
						SST25L_CMD_BLOCK_ERASE);
			}
			if (err) {
				mutex_unlock(&flash->lock);
				instr->state = MTD_ERASE_FAILED;
				dev_err(&flash->spi->dev, "Erase failed\n");
				return err;
			}

			addr += erasesize;
		}
	}

	mutex_unlock(&flash->lock);

	instr->state = MTD_ERASE_DONE;
	mtd_erase_callback(instr);
	return 0;
}


You would need to add sector_size and block_size to the ss25l_flash
and flash_info structs and modify flash_info as appropriate.  Then copy
those over during the probe and use sector_size for mtd.erasesize.

That way we get the 4K erase size but still get the performance increase
for block and chip erase.

What do you think?

Regards,
Hartley
