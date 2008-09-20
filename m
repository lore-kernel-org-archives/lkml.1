Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbYITLAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbYITLAY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 07:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbYITLAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 07:00:11 -0400
Received: from server.drzeus.cx ([85.8.24.28]:33059 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751499AbYITLAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 07:00:08 -0400
Date: Sat, 20 Sep 2008 13:00:06 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc: linux-kernel@vger.kernel.org, Alex Dubov <oakad@yahoo.com>
Subject: Re: RFC: Driver for CB710/720 memory card reader (MMC part)
Message-ID: <20080920130006.69d50cbb@mjolnir.drzeus.cx>
In-Reply-To: <20080912234302.GA19230@rere.qmqm.pl>
References: <20080907215228.GA19193@rere.qmqm.pl>
	<20080909091800.37eccc0f@mjolnir.drzeus.cx>
	<20080909090613.GA22158@rere.qmqm.pl>
	<20080911201307.GA31730@rere.qmqm.pl>
	<20080912234302.GA19230@rere.qmqm.pl>
X-Mailer: Claws Mail 3.5.0cvs92 (GTK+ 2.14.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Sep 2008 01:43:02 +0200
Michał Mirosław <mirq-linux@rere.qmqm.pl> wrote:

> Hello again,
> 
> Here is next version of CB710 MMC-host driver. Since I don't like
> copying code I used platform device "bus" instead of duplicating
> tifm_core and modifying it to cb710 specifics. Debugging printk()s
> were retained for now.
> 
> Please comment,
> Michał Mirosław
> 
> diff -urN empty/cb710.h cb710-pre-20080913/cb710.h
> --- empty/cb710.h	1970-01-01 01:00:00.000000000 +0100
> +++ cb710-pre-20080913/cb710.h	2008-09-13 00:30:51.000000000 +0200
> @@ -0,0 +1,186 @@
> +/*
> + *  cb710/cb710.h
> + *
> + *  Copyleft by Michał Mirosław, 2008
> + *

You should probably stick with "Copyright" even though it is a free
software license.

> +
> +#define RDPORT(t, p) \
> +	ioread##t(chip->iobase + (p))
> +#define WRPORT(t, p, v) \
> +	do { iowrite##t((v), chip->iobase + (p)); \
> +		(void)ioread8(chip->iobase + 0x13); } while (0)
> +#define UPDPORT(t, p, v, m) \
> +	do { \
> +		iowrite##t( \
> +			(ioread##t(chip->iobase + (p)) & ~(m)) | (v), \
> +			chip->iobase + (p)); \
> +		(void)ioread8(chip->iobase + 0x13); \
> +	} while (0)
> +#define S_RDPORT(t, p, b, c) \
> +	ioread##t##_rep(chip->iobase + (p), (b), (c))
> +#define S_WRPORT(t, p, b, c) \
> +	do { \
> +		iowrite##t##_rep(chip->iobase + (p), (b), (c)); \
> +		(void)ioread8(chip->iobase + 0x13); \
> +	} while (0)
> +

This is a pretty bad case of obfuscation. Don't construct macros that
reference local variables (chip in this case). Also,
iowrite16_rep(chip->iobase + CB700_FOO, buffer, 12); is quite readable
as it is. Using standard kernel functions allows your code to be more
accessible to other kernel hackers.

> +
> +void __cb710_pci_update_config_reg(struct pci_dev *pdev,
> +	int reg, uint32_t mask, uint32_t xor);
> +#define cb710_pci_update_config_reg(d, r, m, x) \
> +	__cb710_pci_update_config_reg((d), (r), ~(m), (x))

Again, this just obfuscates. If you keep the ~ in calling code it
becomes more obvious that it is a mask.

> +/* sg-to-PIO buffer */
> +#define CB710_SG_BUFFER_BLOCK	16	/* power of two */
> +struct cb710_sg_chain {
> +	uint8_t bounce_buffer[CB710_SG_BUFFER_BLOCK];
> +	struct scatterlist *sg;
> +	unsigned int sg_num;
> +	struct page *page;
> +	void *mapped_page;
> +	size_t cur_offset;
> +	size_t need_advance;
> +	unsigned page_no;
> +	unsigned page_offset;
> +	unsigned page_left;
> +	unsigned need_bounce:1;
> +	unsigned use_bounce:1;
> +};
> +
> +void cb710_sg_init(struct cb710_sg_chain *buf,
> +	struct scatterlist *sg, size_t nelem);
> +int cb710_sg_next_buf(struct cb710_sg_chain *buf,
> +	void **dataptr, size_t *len, int to_sg);
> +void cb710_sg_abort(struct cb710_sg_chain *buf, int to_sg);
> +
> +#define cb710_sg_read_next(b, d, l) \
> +	cb710_sg_next_buf((b), (d), (l), 0)
> +#define cb710_sg_write_next(b, d, l) \
> +	cb710_sg_next_buf((b), (d), (l), 1)
> +#define cb710_sg_abort_read(b) \
> +	cb710_sg_abort((b), 0)
> +#define cb710_sg_abort_write(b) \
> +	cb710_sg_abort((b), 1)
> +

Why this complex system? Can't you use the handlers the kernel already
provides? You also get a lot of special handling with those, e.g.
highmem.

> +void cb710_dump_regs(struct cb710_chip *chip, unsigned select)
> +{
> +	const unsigned allow[8] = {
> +		0xFFF0, 0xFFFF, 0xFFFF, 0xFFFF,
> +		0xFFF0, 0xFFFF, 0xFFFF, 0xFFFF,
> +	};
> +	const char *const prefix[sizeof(allow)/sizeof(*allow)] = {
> +		"MMC", "MMC", "MMC", "MMC",
> +		"MS?", "MS?", "SM?", "SM?"
> +	};
> +	u32 regs[sizeof(allow)/sizeof(*allow) << 2];
> +
> +	int i, j;
> +	char msg[100], *p;
> +
> +	if (!select)
> +		select = 0xFF;
> +	if (!(select & 0x700))
> +		select |= 0x100;
> +
> +#define reg(b, i) \
> +	(((u##b*)regs)[(i) / (b/8)])
> +#define allowed(b, i, j) \
> +	(((allow[i >> 4] >> j) & ((1 << b/8)-1)) == ((1 << b/8)-1))
> +#define dumpregs(b, f, x) { \

This thing is a bit big. It'll be more readable if you turn it into a
function.

> +
> +static irqreturn_t cb710_irq_handler(int irq, void *data)
> +{
> +	struct cb710_chip *chip = data;
> +	irqreturn_t handled = IRQ_NONE;
> +	unsigned flags;
> +	int nr;
> +
> +	spin_lock_irqsave(&chip->irq_lock, flags);

You shouldn't be using the interrupt versions inside the interrupt
handler. Just do a normal spin_lock().


> +
> +	pci_read_config_dword(pdev, 0x48, &val);
> +	if (!(val & 0x80000000)) {
> +		pci_write_config_dword(pdev, 0x48, val|0x71000000);
> +		pci_read_config_dword(pdev, 0x48, &val);
> +	}
> +
> +	printk(KERN_INFO CB710_DRIVER_NAME
> +		": PCI config[0x48] = 0x%08X (%d %d %d %d %d %d)\n",
> +		val,
> +		!(val & 0x01000000),
> +		(val >> 8) & 7,
> +		!!(val & 0x10000000),
> +		!!(val & 0x20000000),
> +		!!(val & 0x40000000),
> +		!(val & 0x02000000)
> +	);
> +

If this still is unknown voodoo, then please add a comment explaining
that. Otherwise I expect to see more defines. :)

> +
> +static const struct pci_device_id cb710_pci_tbl[] = {
> +	{ PCI_VENDOR_ID_ENE, 0x510, PCI_ANY_ID, PCI_ANY_ID, },
> +	{ 0, }
> +};

Allocate a define for 0x510, either in this file or pci_ids.h.

> diff -urN empty/Makefile cb710-pre-20080913/Makefile
> --- empty/Makefile	1970-01-01 01:00:00.000000000 +0100
> +++ cb710-pre-20080913/Makefile	2008-09-12 20:56:39.000000000 +0200

It's easier if you develop against the real kernel tree and send diffs
for that.

> diff -urN empty/mmc.c cb710-pre-20080913/mmc.c
> --- empty/mmc.c	1970-01-01 01:00:00.000000000 +0100
> +++ cb710-pre-20080913/mmc.c	2008-09-13 01:28:10.000000000 +0200

> +#include <linux/mmc/mmc.h>

You should never have to include this in a host driver.

> +	printk(KERN_INFO CB710_DRIVER_NAME
> +		": %s: clock set to %d Hz, wanted %d Hz; flag = %d\n",
> +		mmc_hostname(mmc),
> +		src_hz >> cb710_clock_divider_log2[divider_idx & 7],
> +		hz, (divider_idx & 8) != 0);

Please use pr_debug() for things like this.

> +static void cb710_mmc_enable_irq(struct cb710_chip *chip, int enable)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&chip->irq_lock, flags);
> +	__cb710_mmc_enable_irq(chip, enable);
> +	spin_unlock_irqrestore(&chip->irq_lock, flags);
> +}

This is a fairly useless wrapper. Look over how it is called instead.

> +static int cb710_check(struct cb710_chip *chip, int what)
> +{
> +	uint8_t status1, status2;
> +
> +	/* all this is magic */
> +	BUG_ON(what < 2 || what > 4);
> +

You seem to know what some of the "what" values are. Put some defines
for those.

> +/*	if (flags & MMC_CMD_IS_APP) */
> +	if (reader->app_cmd) {
> +		/* original driver set this bit for MMC/SD application
> +		 * commands. It apparently works without it, but... oh well.
> +		 */
> +		cb_flags |= 0x4000;
> +		reader->app_cmd = 0;
> +	}

ACMD:s are no different from "normal" commands. As you've discovered,
you do not need this code.

> +	if (flags & MMC_RSP_PRESENT) {
> +		/* Windows driver set 01 at bits 4,3 except for
> +		 * MMC_SET_BLOCKLEN. I assume that 00 here means no
> +		 * response is expected.
> +		 */
> +		if (cmd->opcode != MMC_SET_BLOCKLEN)
> +			cb_flags |= CB710_MMC_RSP_PRESENT;
> +		else
> +			cb_flags |= CB710_MMC_RSP_PRESENT_X;

Looking at the opcode is not acceptable, so you need to figure out
what's really going on here. MMC_SET_BLOCKLEN has a common R1 response,
so I don't know why the Windows driver special treated it.

> +		if (flags & MMC_RSP_136)		/* R2 */
> +			cb_flags |= CB710_MMC_RSP_136;
> +		else if (!(flags & MMC_RSP_CRC))	/* R3 */
> +			cb_flags |= CB710_MMC_RSP_NO_CRC;

I don't see a need for the "else".

> +
> +	if (rsp_opcode != ((cmd->flags & MMC_RSP_OPCODE) ? cmd->opcode : 0x3F))
> +		cmd->error = -EILSEQ;

This isn't terribly readable. Something like this would be better:

	if (cmd->flags & MMC_RSP_OPCODE) {
		if (rsp_opcode != cmd->opcode)
			cmd->error = -EILSEQ;
	} else {
		if (rsp_opcode != 0x3F)
			cmd->error = -EILSEQ;
	}

The code generated by the compiler should be the same.

> +	if (!error)	/* TODO: proper counting */
> +		data->bytes_xfered = data->blksz * data->blocks;

You can probably never do proper counting when you don't know how the
hardware behaves.

> +static const struct mmc_host_ops cb710_mmc_host = {
> +	.request = cb710_mmc_request,
> +	.set_ios = cb710_mmc_set_ios,
> +	.get_ro = cb710_mmc_get_ro,
> +	.enable_sdio_irq = NULL,
> +};

NULL is the default so you don't need to specify that.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
