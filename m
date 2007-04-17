Return-Path: <linux-kernel-owner+w=401wt.eu-S1031061AbXDQDFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031061AbXDQDFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 23:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031062AbXDQDFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 23:05:12 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:48452 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031061AbXDQDFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 23:05:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=TdG2eTcACLKk7SNgyv7qgtRqYCJ91InPgT/ji+4WuJ4RAi7penxjmwHz8cZdySU8Q5adWh/MsVa8x4BPtFkEQv2FhxwDvbo28SuvBS7Izfj6Rgt5oA7gaS5lKI4X2+aJfTL26Y1MZDOdcIVxpLxX7nidTFpRxyTaTCatf1IsX98=  ;
X-YMail-OSG: sIGKLlgVM1mbASnZaEJy5eZfAG4wtC0ji9A9zk.Vp5LLM25dMnRW1UoPSlyYu4Quf3vtNlZ9UA--
From: David Brownell <david-b@pacbell.net>
To: bryan.wu@analog.com
Subject: Re: [PATCH] Blackfin: blackfin on-chip SPI controller driver
Date: Mon, 16 Apr 2007 18:31:35 -0800
User-Agent: KMail/1.7.1
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
References: <1173091280.5264.201.camel@roc-desktop>
In-Reply-To: <1173091280.5264.201.camel@roc-desktop>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200704161931.36065.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaning out some of my pending-reviews queue ... after you address
these comments I think what I'd like to do is sign off on one clean
patch, rather than initial-plus-cleanups.


On Monday 05 March 2007 2:41 am, Wu, Bryan wrote:

> --- linux-2.6.orig/drivers/spi/Kconfig	2007-03-01 11:33:07.000000000 +0800
> +++ linux-2.6/drivers/spi/Kconfig	2007-03-01 11:40:22.000000000 +0800

I'm adjusting this to address the later patches you sent.

One global comment I'll make, just in case -- please make
sure all your line-start indents only include tabs, and
there's no space-at-end-of-line stuff going on, or lines
wrapping past column 80.

I did this review in KMail, which doesn't highlight such
minor errors; and I suspect you're mostly OK, but for a
new driver there's no reason not to be 100% OK in those
particular respects!  (And I *did* notice one of your
cleanup patches clearly adding tabs-then-spaces indents.)


> @@ -156,7 +156,11 @@
>  #
>  # Add new SPI protocol masters in alphabetical order above this line
>  #
> -
> +config SPI_BFIN
> +	tristate "SPI controller driver for ADI Blackfin5xx"
> +	depends on SPI_MASTER && BFIN
> +	help
> +	  This is the SPI controller master driver for Blackfin 5xx processor.

Please put this in Kconfig up with the other SPI controller drivers, in
alphabetical order.  Just like the comment says.

Likewise, please add it to the Makefile in alphabetical order.


> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/drivers/spi/spi_bfin5xx.c	2007-03-01 11:40:22.000000000 +0800

> +#ifdef DEBUG
> +#define ASSERT(expr) \
> +	if (!(expr)) { \
> +		printk(KERN_DEBUG "assertion failed! %s[%d]: %s\n", \
> +		       __FUNCTION__, __LINE__, #expr); \
> +		panic(KERN_DEBUG "%s", __FUNCTION__); \

Seems like either WARN_ON(expr) or BUG_ON(expr) will be better.
The general rule of BUG variants is: don't, unless the system
really can't continue operating.  (I see a later patch removed
this entirely, good.


> +	}
> +#else
> +#define ASSERT(expr)
> +#endif
> +
> +#define IS_DMA_ALIGNED(x) (((u32)(x)&0x07)==0)
> +
> +#define DEFINE_SPI_REG(reg, off) \
> +static inline u16 read_##reg(void) \
> +            { return *(volatile unsigned short*)(SPI0_REGBASE + off); } \
> +static inline void write_##reg(u16 v) \
> +            {*(volatile unsigned short*)(SPI0_REGBASE + off) = v;\
> +             SSYNC();}

These should be readw() and writew() or similar... also, I can't tell
what SSYNC() does, but it sure looks like something that shouldn't be
hidden like that.  I/O memory should be mapped such that writes don't
get re-ordered.  And flushing any write buffer should not be forced in
such low-level accessors ... if it's needed, it should be done at the
relevant points in the driver.  (Which you seem to do in a few places
below.  The duplication is undesirable.)


> +
> +DEFINE_SPI_REG(CTRL, 0x00)

... this particular style of register accessor is not generally used in Linux.
The typical style is

	u16 value = __raw_readw(SPI0_REGBASE + SPI_CTRL)
	__raw_writew(SPI0_REGBASE + SPI_CTRL, value);

or wrapped in macros so spi_readw(CTRL) and spi_writew(CTRL, value) work.

Of course, SPI1/SPI2/etc should be supported too ... so it's common to have
those take a pointer to some controller struct with a "void __iomem *regs"
pointer to the rgisters for that instance.  spi_readw(master, CTRL) etc.
 

> +#define START_STATE ((void*)0)
> +#define RUNNING_STATE ((void*)1)
> +#define DONE_STATE ((void*)2)
> +#define ERROR_STATE ((void*)-1)

Normally states would be represented by enum values, which among other
things supports "switch (state) { ... }" state machine code.  This driver
is full of uncommon idioms, which will make it harder for most kernel
developers to dive in and help.

Even if you have a style guide internal to Analog which says to do things
this way ... don't.


> +
> +#define QUEUE_RUNNING 0
> +#define QUEUE_STOPPED 1
> +
> +int dma_requested;
> +char chip_select_flag;

These should probably be members of the per-controller state struct,
and otherwise should certainly be static.  This driver exports a LOT
of stuff that should be static ...


> +
> +struct driver_data {

Not the most explanatory of names.  Could you do better?


> +	/* Driver model hookup */
> +	struct platform_device *pdev;
> +
> +	/* SPI framework hookup */
> +	struct spi_master *master;
> +
> +	/* BFIN hookup */
> +	struct bfin5xx_spi_master *master_info;

I would have assumed this struct would *BE* the Blackfin-specific
spi_master state ...

> +
> +	/* Driver message queue */
> +	struct workqueue_struct *workqueue;
> +	struct work_struct pump_messages;
> +	spinlock_t lock;
> +	struct list_head queue;
> +	int busy;
> +	int run;
> +
> +	/* Message Transfer pump */
> +	struct tasklet_struct pump_transfers;
> +
> +	/* Current message transfer state info */
> +	struct spi_message *cur_msg;
> +	struct spi_transfer *cur_transfer;
> +	struct chip_data *cur_chip;

This looks like a lot of data being duplicated.  It would
be clearer just to clone cur_transfer if your goal is to have
a mutable copy of this (to update on the fly during PIO).


> +	size_t len_in_bytes;
> +	size_t len;
> +	void *tx;
> +	void *tx_end;
> +	void *rx;
> +	void *rx_end;
> +	int dma_mapped;
> +	dma_addr_t rx_dma;
> +	dma_addr_t tx_dma;
> +	size_t rx_map_len;
> +	size_t tx_map_len;
> +	u8 n_bytes;
> +	void (*write) (struct driver_data *);
> +	void (*read) (struct driver_data *);
> +	void (*duplex) (struct driver_data *);
> +};
> +
> +struct chip_data {
> +	u16 ctl_reg;
> +	u16 baud;
> +	u16 flag;
> +
> +	u8 chip_select_num;
> +	u8 n_bytes;
> +	u32 width;		/* 0 or 1 */

Why is the "width" flag a u32, while the other flags
are just "u8"?

> +	u8 enable_dma;
> +	u8 bits_per_word;	/* 8 or 16 */

I don't know where this cs_change_per_word thing came from;
it's not part of the SPI driver interface.

> +	u8 cs_change_per_word;
> +	u8 cs_chg_udelay;
> +	void (*write) (struct driver_data *);
> +	void (*read) (struct driver_data *);
> +	void (*duplex) (struct driver_data *);
> +};
> +
> +void bfin_spi_enable(struct driver_data *drv_data)
> +{
> +	u16 cr;
> +
> +	cr = read_CTRL();
> +	write_CTRL(cr | BIT_CTL_ENABLE);
> +	SSYNC();
> +}
> +
> +void bfin_spi_disable(struct driver_data *drv_data)
> +{
> +	u16 cr;
> +
> +	cr = read_CTRL();
> +	write_CTRL(cr & (~BIT_CTL_ENABLE));
> +	SSYNC();
> +}

So are those routines enabling and disabling the controller?
I guess I'll assume something else is turning the clocks on
and off using clk_enable()/clk_disable() ...

Regardless, this is yet another case where you export methods
that should be private to this compile unit.  GCC can do better
optimization, and the linker has less work to do, when you do
things the right way.

> +
> +/* Caculate the SPI_BAUD register value based on input HZ */
> +static u16 hz_to_spi_baud(u32 speed_hz)
> +{
> +	u_long sclk = get_sclk();

Shouldn't that be a clk_get_rate() call?


> +	u16 spi_baud = (sclk / (2*speed_hz));
> +
> +	if ((sclk % (2*speed_hz)) > 0)
> +		spi_baud++;
> +
> +	pr_debug("sclk = %ld, speed_hz = %d, spi_baud = %d\n", sclk, speed_hz, spi_baud);
> +	
> +	return spi_baud;
> +}


> +
> +static int flush(struct driver_data *drv_data)
> +{
> +	unsigned long limit = loops_per_jiffy << 1;
> +
> +	/* wait for stop and clear stat */
> +	do {} while (!(read_STAT() & BIT_STAT_SPIF) && limit--);

Normally the "do {} " would be omitted; I like to put a "continue"
as the body of such empty loops.  Regardless, one-line loops aren't
good style.  A later patch of yours put the "do {" on a line by
itself; not better.  (Repeat this comment everywhere it applies...)


> +	write_STAT(BIT_STAT_CLR);
> +
> +	return limit;
> +}
> +
> +/* stop controller and re-config current chip*/
> +static void restore_state(struct driver_data *drv_data)
> +{
> +	struct chip_data *chip = drv_data->cur_chip;

These type names confuse me already.  "driver_data" would
seem to be all the state associated with a single SPI master
controller, except for those variables noted above and the
choice of SPI0 vs SPI1 etc.  I'm guessing "chip_data" is
then per-slave state ...


> +	/* Clear status and disable clock */
> +	write_STAT(BIT_STAT_CLR);
> +	bfin_spi_disable(drv_data);
> +	pr_debug("restoring spi ctl state\n");
> +
> +#if defined(CONFIG_BF534)||defined(CONFIG_BF536)||defined(CONFIG_BF537)
> +	if (chip->chip_select_num == 1) {
> +		pr_debug("set for chip select 1\n");
> +		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3c00);
> +		SSYNC();

This would be much more clear as a switch() statement.  And these SSYNC()
things seem like they should not be needed ... don't I/O writes behave
right without them?

> +
> +	} else if (chip->chip_select_num == 2 || chip->chip_select_num == 3) {
> +		pr_debug("set for chip select 2\n");
> +		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PJSE_SPI);
> +		SSYNC();
> +		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3800);
> +		SSYNC();
> +
> +	} else if (chip->chip_select_num == 4) {
> +		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PFS4E_SPI);
> +		SSYNC();
> +		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3840);
> +		SSYNC();
> +
> +	} else if (chip->chip_select_num == 5) {
> +		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PFS5E_SPI);
> +		SSYNC();
> +		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3820);
> +		SSYNC();
> +
> +	} else if (chip->chip_select_num == 6) {
> +		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PFS6E_SPI);
> +		SSYNC();
> +		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3810);
> +		SSYNC();
> +
> +	} else if (chip->chip_select_num == 7) {
> +		bfin_write_PORT_MUX(bfin_read_PORT_MUX() | PJCE_SPI);
> +		SSYNC();
> +		bfin_write_PORTF_FER(bfin_read_PORTF_FER() | 0x3800);
> +		SSYNC();
> +	}

#else
#error what kind of Blackfin is this?

> +#endif
> +
> +	/* Load the registers */
> +	write_CTRL(chip->ctl_reg);
> +	write_BAUD(chip->baud);
> +	write_FLAG(chip->flag);
> +}
> +
> +/* used to kick off transfer in rx mode */
> +static unsigned short dummy_read(void)
> +{
> +	unsigned short tmp;
> +	tmp = read_RDBR();
> +	return tmp;
> +}
> +
> +static void null_writer(struct driver_data *drv_data)
> +{
> +	u8 n_bytes = drv_data->n_bytes;
> +
> +	while (drv_data->tx < drv_data->tx_end) {
> +		write_TDBR(0);
> +		do {} while ((read_STAT() & BIT_STAT_TXS));
> +		drv_data->tx += n_bytes;
> +	}
> +}
> +
> +static void null_reader(struct driver_data *drv_data)
> +{
> +	u8 n_bytes = drv_data->n_bytes;
> +	dummy_read();
> +
> +	while (drv_data->rx < drv_data->rx_end) {
> +		do {} while (!(read_STAT() & BIT_STAT_RXS));
> +		dummy_read();
> +		drv_data->rx += n_bytes;
> +	}
> +}

On first principles these null reader/writer routines seem odd...

The transfer is full duplex, so unless you're doing this in
fifo-sized chunks (which would need a comment!) the writer is
wrong because it doesn't read the data, and the reader is wrong
because it doesn't write it ...

Plus the "null" writer doesn't act the same way as u8_writer
below, the transfer won't be complete right?

In any case, I think a short comment -- sentence or two -- about
how PIO works would clarify things.



> +
> +static void u8_writer(struct driver_data *drv_data)
> +{
> +	pr_debug("cr8-s is 0x%x\n", read_STAT());
> +	while (drv_data->tx < drv_data->tx_end) {
> +		write_TDBR(*(u8 *)(drv_data->tx));
> +		do {} while (read_STAT() & BIT_STAT_TXS);
> +		++drv_data->tx;
> +	}
> +
> +	// poll for SPI completion before returning
> +	do {} while (!(read_STAT() & BIT_STAT_SPIF));
> +}
> +
> +static void u8_cs_chg_writer(struct driver_data *drv_data)
> +{
> +	struct chip_data *chip = drv_data->cur_chip;
> +
> +	while (drv_data->tx < drv_data->tx_end) {
> +		write_FLAG(chip->flag);
> +		SSYNC();
> +
> +		write_TDBR(*(u8 *)(drv_data->tx));
> +		do {} while (read_STAT() & BIT_STAT_TXS);
> +		do {} while (!(read_STAT() & BIT_STAT_SPIF));
> +		write_FLAG(0xFF00|chip->flag);

This looks odd too.  Just guessing -- no comments!! -- but isn't
it trying to deselect the chip after each byte?  That's not a
model exposed in the API.  (Deselect after a given transfer segment,
yes.  Between n-segment messages, yes.  Otherwise, no.)


> +		SSYNC();
> +		if (chip->cs_chg_udelay)
> +			udelay(chip->cs_chg_udelay);
> +		++drv_data->tx;
> +	}
> +	write_FLAG(0xFF00);
> +	SSYNC();
> +}
> +
> +static void u8_reader(struct driver_data *drv_data)
> +{
> +	pr_debug("cr-8 is 0x%x\n", read_STAT());
> +
> +	// clear TDBR buffer before read(else it will be shifted out)
> +	write_TDBR(0xFFFF);
> +
> +	dummy_read();
> +
> +	while (drv_data->rx < drv_data->rx_end - 1) {
> +		do {} while (!(read_STAT() & BIT_STAT_RXS));
> +		*(u8 *)(drv_data->rx) = read_RDBR();
> +		++drv_data->rx;

Is this shifting out zeroes for each byte it reads?


> +	}
> +	do {} while (!(read_STAT() & BIT_STAT_RXS));
> +	*(u8 *)(drv_data->rx) = read_SHAW();
> +	++drv_data->rx;
> +}
> +
> +static void u8_cs_chg_reader(struct driver_data *drv_data)
> +{
> +	struct chip_data *chip = drv_data->cur_chip;
> +
> +	while (drv_data->rx < drv_data->rx_end) {
> +		write_FLAG(chip->flag);
> +		SSYNC();
> +
> +		read_RDBR(); /* kick off */
> +		do {} while (!(read_STAT() & BIT_STAT_RXS));
> +		do {} while (!(read_STAT() & BIT_STAT_SPIF));
> +		*(u8 *)(drv_data->rx) = read_SHAW();
> +		write_FLAG(0xFF00|chip->flag);

Same comments as above re chipselect.  This also differs
from the previous reader in terms of TDBR ... so evently
at least one of the routines is incorrect.

> +		SSYNC();
> +		if (chip->cs_chg_udelay)
> +			udelay(chip->cs_chg_udelay);
> +		++drv_data->rx;
> +	}
> +	write_FLAG(0xFF00);
> +	SSYNC();
> +}
> +
> +static void u8_duplex(struct driver_data *drv_data)
> +{
> +	/* in duplex mode, clk is triggered by writing of TDBR */
> +	while (drv_data->rx < drv_data->rx_end) {
> +		write_TDBR(*(u8 *)(drv_data->tx));
> +		do {} while (!(read_STAT() & BIT_STAT_SPIF));
> +		do {} while (!(read_STAT() & BIT_STAT_RXS));
> +		*(u8 *)(drv_data->rx) = read_RDBR();
> +		//if (*(u8 *)(drv_data->rx)) pr_debug(KERN_NOTICE "u8_duplex: %c\n", *(u8 *)(drv_data->rx));

Don't includes such debug code ... (a) C++ style comments, (b) all on
one line, (c) using pr_debug not dev_dbg(&spi->dev)...

And again, I'm puzzled.  All the methods seem to act differently
in terms of I/O ... are writes of zero-bytes triggered by reads?
It's common for writes to clobber RX data that hasn't yet been
pulled from the fifo, but this driver seems to have a strange pattern.


> +		++drv_data->rx;
> +		++drv_data->tx;
> +	}
> +}
> +
> +static void u8_cs_chg_duplex(struct driver_data *drv_data)
> +{
> +	struct chip_data *chip = drv_data->cur_chip;
> +
> +	while (drv_data->rx < drv_data->rx_end) {
> +		write_FLAG(chip->flag);
> +		SSYNC();
> +
> +		write_TDBR(*(u8 *)(drv_data->tx));
> +		do {} while (!(read_STAT() & BIT_STAT_SPIF));
> +		do {} while (!(read_STAT() & BIT_STAT_RXS));
> +		*(u8 *)(drv_data->rx) = read_RDBR();
> +		write_FLAG(0xFF00|chip->flag);
> +		SSYNC();
> +		if (chip->cs_chg_udelay)
> +			udelay(chip->cs_chg_udelay);

Again, this isn't the semantics for cs_chg; it's not triggered
after each byte, only after the a segment completes.

> +		++drv_data->rx;
> +		++drv_data->tx;
> +	}
> +	write_FLAG(0xFF00);
> +	SSYNC();
> +}


I'm assuming all your "u16" operations are just wider clones
of your "u8" operations, so the comments above apply equally.
And for brevity I deleted those methods here.


> +/* test if ther is more transfer to be done */
> +static void *next_transfer(struct driver_data *drv_data)
> +{
> +	struct spi_message *msg = drv_data->cur_msg;
> +	struct spi_transfer *trans = drv_data->cur_transfer;
> +
> +	/* Move to next transfer */
> +	if (trans->transfer_list.next != &msg->transfers) {
> +		drv_data->cur_transfer =
> +			list_entry(trans->transfer_list.next,
> +					struct spi_transfer,
> +					transfer_list);
> +		return RUNNING_STATE;

Again:  strange.  One normally wants states to support
state machine idioms like "switch(state){...}"; that can't
work if with a "void *", and it looks quite puzzling too.


> +	} else
> +		return DONE_STATE;
> +}
> +
> +/* caller already set message->status; dma and pio irqs are blocked
> + * give finished message back
> + */
> +static void giveback(struct driver_data *drv_data)
> +{
> +	struct spi_transfer *last_transfer;
> +	unsigned long flags;
> +	struct spi_message *msg;
> +
> +	spin_lock_irqsave(&drv_data->lock, flags);
> +	msg = drv_data->cur_msg;
> +	drv_data->cur_msg = NULL;
> +	drv_data->cur_transfer = NULL;
> +	drv_data->cur_chip = NULL;
> +	queue_work(drv_data->workqueue, &drv_data->pump_messages);
> +	spin_unlock_irqrestore(&drv_data->lock, flags);
> +
> +	last_transfer = list_entry(msg->transfers.prev,
> +					struct spi_transfer,
> +					transfer_list);
> +
> +	msg->state = NULL;
> +	/* disable chip select signal. And not stop spi in autobuffer mode */
> +	if (drv_data->tx_dma != 0xFFFF) {

This is a curious magic number.  You should probably have a #defined
constant for "invalid DMA address".  Plus, this would be the natural
place to reverse any DMA mappings ...


> +		write_FLAG(0xFF00);
> +		bfin_spi_disable(drv_data);
> +	}
> +
> +	if (msg->complete)

It'd be an error if msg->complete were null, and that error
should have prevented the message from being submitted.

> +		msg->complete(msg->context);
> +}
> +
> +static irqreturn_t dma_irq_handler(int irq, void *dev_id, struct pt_regs *regs)
> +{
> +	struct driver_data *drv_data = (struct driver_data *)dev_id;
> +	struct spi_message *msg = drv_data->cur_msg;
> +
> +	pr_debug("in dma_irq_handler\n");
> +	clear_dma_irqstat(CH_SPI);
> +
> +	/* wait for the last transaction shifted out.  yes, these two
> +	 * while loops are supposed to be the same (see the HRM).
> +	 */
> +	if (drv_data->tx != NULL) {
> +		while (bfin_read_SPI_STAT() & TXS)
> +			;
> +		while (bfin_read_SPI_STAT() & TXS)
> +			;
> +	}
> +
> +	while (!(bfin_read_SPI_STAT() & SPIF))
> +		;

When the body of a loop is empty, I prefer to see it be
a "continue;" statement not something completely empty.
That way at least it's not easily mistaken for an error...


> +
> +	bfin_spi_disable(drv_data);
> +
> +	msg->actual_length += drv_data->len_in_bytes;
> +
> +	/* Move to next transfer */
> +	msg->state = next_transfer(drv_data);
> +
> +	/* Schedule transfer tasklet */
> +	tasklet_schedule(&drv_data->pump_transfers);
> +
> +	/* free the irq handler before next transfer */
> +	pr_debug("disable dma channel irq%d\n", CH_SPI);
> +	dma_disable_irq(CH_SPI);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void pump_transfers(unsigned long data)
> +{
> +	struct driver_data *drv_data = (struct driver_data *)data;
> +	struct spi_message *message = NULL;
> +	struct spi_transfer *transfer = NULL;
> +	struct spi_transfer *previous = NULL;
> +	struct chip_data *chip = NULL;
> +	u16 cr, width, dma_width, dma_config;
> +	u32 tranf_success = 1;
> +
> +	/* Get current state information */
> +	message = drv_data->cur_msg;
> +	transfer = drv_data->cur_transfer;
> +	chip = drv_data->cur_chip;
> +
> +	/* if msg is error or done, report it back using complete() callback */
> +	/* Handle for abort */
> +	if (message->state == ERROR_STATE) {
> +		message->status = -EIO;
> +		giveback(drv_data);
> +		return;
> +	}
> +
> +	/* Handle end of message */
> +	if (message->state == DONE_STATE) {
> +		message->status = 0;
> +		giveback(drv_data);
> +		return;
> +	}
> +
> +	/* Delay if requested at end of transfer */
> +	if (message->state == RUNNING_STATE) {
> +		previous = list_entry(transfer->transfer_list.prev,
> +					struct spi_transfer,
> +					transfer_list);
> +		if (previous->delay_usecs)
> +			udelay(previous->delay_usecs);

This could be done more efficiently by recording delay_usecs
in the state used by this routine, as part of retiring the
previous transfer.  No need to figure out "previous" ... which
I'm sure hoping you have somehow guaranteed will always be valid.

Same thing with dropping the chipselect briefly ... which happens
after that delay if the preveious transfer asked for it.  Neither
happen at the beginning of a message.


> +	}
> +
> +	/* Setup the transfer state based on the type of transfer */
> +	if (flush(drv_data) == 0) {

These comments seem misleading to me.  A flush() is more like waiting
for a previous transfer to complete than setting up something new...


> +		dev_err(&drv_data->pdev->dev, "pump_transfers: flush failed\n");
> +		message->status = -EIO;
> +		giveback(drv_data);
> +		return;
> +	}
> +
> +	if (transfer->tx_buf != NULL) {
> +		drv_data->tx = (void *)transfer->tx_buf;
> +		drv_data->tx_end = drv_data->tx + transfer->len;
> +		pr_debug("tx_buf is %p, tx_end is %p\n", transfer->tx_buf, drv_data->tx_end);
> +	} else {
> +		drv_data->tx = NULL;
> +	}
> +
> +	if (transfer->rx_buf != NULL) {
> +		drv_data->rx = transfer->rx_buf;
> +		drv_data->rx_end = drv_data->rx + transfer->len;
> +		pr_debug("rx_buf is %p, rx_end is %p\n", transfer->rx_buf, drv_data->rx_end);
> +	} else {
> +		drv_data->rx = NULL;
> +	}
> +
> +	drv_data->rx_dma = transfer->rx_dma;
> +	drv_data->tx_dma = transfer->tx_dma;
> +	drv_data->len_in_bytes = transfer->len;
> +
> +	width = chip->width;
> +	if (width == CFG_SPI_WORDSIZE16) {
> +		drv_data->len = (transfer->len) >> 1;
> +	} else {
> +		drv_data->len = transfer->len;
> +	}
> +	drv_data->write = drv_data->tx ? chip->write : null_writer;
> +	drv_data->read = drv_data->rx ? chip->read : null_reader;
> +	drv_data->duplex = chip->duplex ? chip->duplex : null_writer;

I don't see why you have three separate method pointers.  You
can just set the correct PIO routine here, rather than setting
up three possibilities and then testing later ... and in fact,
you can set up the chip->X methods earlier too, in setup(),
so you can eliminate these drv_data->X pointers.


> +	pr_debug("transfer: drv_data->write is %p, chip->write is %p, null_wr is %p\n",
> +	       drv_data->write, chip->write, null_writer);
> +
> +	/* speed and width has been set on per message */

Odd comment; there are no per-message settings.  There's a device
default, and there are per-transfer overrides ...

(Hmm, below I see the per-transfer speed update being handled.
But not the per-transfer width updates, allowing e.g. 9-bit
commands to be followed by 8-bit data streams.  Not handling
that is OK, if such requests are rejected before they enter
the queue.)

> +
> +	message->state = RUNNING_STATE;
> +	dma_config = 0;
> +
> +	/* restore spi status for each spi transfer */
> +	if (transfer->speed_hz) {
> +		write_BAUD(hz_to_spi_baud(transfer->speed_hz));
> +	} else {
> +		write_BAUD(chip->baud);
> +	}
> +	write_FLAG(chip->flag);
> +
> +	pr_debug("now pumping a transfer: width is %d, len is %d\n",width,transfer->len);
> +	/* Try to map dma buffer and do a dma transfer if successful */

I don't see dma_map_single() calls here.  Again, those would better be
done as the transfer is submitted.  So the comment seems incorrect.

> +	/* use different way to r/w according to drv_data->cur_chip->enable_dma */
> +	if (drv_data->cur_chip->enable_dma && drv_data->len > 6) {
> +
> +		write_STAT(BIT_STAT_CLR);
> +		disable_dma(CH_SPI);
> +		clear_dma_irqstat(CH_SPI);
> +		bfin_spi_disable(drv_data);
> +
> +		pr_debug("doing dma transfer\n");
> +		/* config dma channel */

Please put comments BEFORE the block of code, preceded by a
blank line ... not in the middle of a block.  And again,
dev_dbg() by preference (there can be many devices involved).

> +		if (width == CFG_SPI_WORDSIZE16) {
> +			set_dma_x_count(CH_SPI, drv_data->len);
> +			set_dma_x_modify(CH_SPI, 2);
> +			dma_width = WDSIZE_16;
> +		} else {
> +			set_dma_x_count(CH_SPI, drv_data->len);
> +			set_dma_x_modify(CH_SPI, 1);
> +			dma_width = WDSIZE_8;
> +		}
> +
> +		/* Go baby, go */
> +		/* set transfer width,direction. And enable spi */
> +		cr = (read_CTRL() & (~BIT_CTL_TIMOD));	/* clear the TIMOD bits */

The "clear the ..." comment is obvious; delete it.  And the "Go" comment
should either be part of the "set..." comment or else split apart from
it as a separate "paragraph".


> +
> +		/* dirty hack for autobuffer DMA mode */
> +		if (drv_data->tx_dma == 0xFFFF) {
> +			pr_debug("doing autobuffer DMA out.\n");

What's an "autobuffer" ?


> +
> +			/* no irq in autobuffer mode */
> +			dma_config = (DMAFLOW_AUTO | RESTART | dma_width | DI_EN);
> +			set_dma_config(CH_SPI, dma_config);
> +			set_dma_start_addr(CH_SPI, (unsigned long)drv_data->tx);
> +			enable_dma(CH_SPI);
> +			write_CTRL(cr | CFG_SPI_DMAWRITE | (width << 8) | (CFG_SPI_ENABLE << 14));
> +			/* just return here, there can only be one transfer in this mode*/

Let's see.  It's incorrect to return before the transfer completes.
And I don't see how you can know there's only one transfer in this message,
since tx_dma was provided by the driver.  And sticking a comment in the
middle of code like that -- no blank-line preceding it -- looks to me
like someone's trying to hide it...


> +			message->status = 0;
> +			giveback(drv_data);
> +			return;
> +		}
> +
> +		/* In dma mode, rx or tx must be NULL in one transfer*/
> +		if (drv_data->rx != NULL) {
> +			/* set transfer mode, and enable SPI */
> +			pr_debug("doing DMA in.\n");
> +
> +			/* disable SPI before write to TDBR*/
> +			write_CTRL(cr & ~BIT_CTL_ENABLE);
> +
> +			/* clear tx reg soformer data is not shifted out */
> +			write_TDBR(0xFF);

But how then do you ensure zeroes are shifted out?


> +
> +			set_dma_x_count(CH_SPI, drv_data->len);
> +
> +			/* start dma*/
> +			dma_enable_irq(CH_SPI);
> +			dma_config = (WNR | RESTART | dma_width | DI_EN);
> +			set_dma_config(CH_SPI, dma_config);
> +			set_dma_start_addr(CH_SPI, (unsigned long)drv_data->rx);
> +			enable_dma(CH_SPI);
> +
> +			cr |= CFG_SPI_DMAREAD | (width << 8) | (CFG_SPI_ENABLE << 14);
> +			/* set transfer mode, and enable SPI */
> +			write_CTRL(cr);
> +		} else if (drv_data->tx != NULL) {
> +			pr_debug("doing DMA out.\n");
> +			/* start dma */
> +			dma_enable_irq(CH_SPI);
> +			dma_config = (RESTART | dma_width | DI_EN);
> +			set_dma_config(CH_SPI, dma_config);
> +			set_dma_start_addr(CH_SPI, (unsigned long)drv_data->tx);
> +			enable_dma(CH_SPI);
> +
> +			write_CTRL(cr | CFG_SPI_DMAWRITE | (width << 8) | (CFG_SPI_ENABLE << 14));
> +
> +		}
> +	} else {		/* IO mode write then read */
> +		/* Go baby, go */
> +		pr_debug("doing IO transfer\n");

Maybe dev_dbg(..., "doing PIO transfer\n") ?  DMA is IO too ...

> +
> +		write_STAT(BIT_STAT_CLR);
> +
> +		if (drv_data->tx != NULL && drv_data->rx != NULL) { /* full duplex mode */
> +			ASSERT((drv_data->tx_end - drv_data->tx) == (drv_data->rx_end - drv_data->rx));
> +			cr = (read_CTRL() & (~BIT_CTL_TIMOD));	/* clear the TIMOD bits */
> +			cr |= CFG_SPI_WRITE | (width << 8) | (CFG_SPI_ENABLE << 14);
> +			pr_debug("IO duplex: cr is 0x%x\n", cr);
> +
> +			write_CTRL(cr);
> +			SSYNC();
> +
> +			drv_data->duplex(drv_data);
> +
> +			if (drv_data->tx != drv_data->tx_end)
> +				tranf_success = 0;
> +		} else if (drv_data->tx != NULL) {        /* write only half duplex */
> +			cr = (read_CTRL() & (~BIT_CTL_TIMOD));	/* clear the TIMOD bits */
> +			cr |= CFG_SPI_WRITE | (width << 8) | (CFG_SPI_ENABLE << 14);
> +			pr_debug("IO write: cr is 0x%x\n", cr);
> +
> +			write_CTRL(cr);
> +			SSYNC();
> +
> +			drv_data->write(drv_data);
> +
> +			if (drv_data->tx != drv_data->tx_end)
> +				tranf_success = 0;
> +		} else if (drv_data->rx != NULL) {        /* read only half duplex */
> +
> +			cr = (read_CTRL() & (~BIT_CTL_TIMOD));	/* cleare the TIMOD bits */
> +			cr |= CFG_SPI_READ | (width << 8) | (CFG_SPI_ENABLE << 14);
> +			pr_debug("IO read: cr is 0x%x\n", cr);
> +
> +			write_CTRL(cr);
> +			SSYNC();
> +
> +			drv_data->read(drv_data);
> +			if (drv_data->rx != drv_data->rx_end)
> +				tranf_success = 0;
> +		}
> +
> +		if (!tranf_success) {
> +			pr_debug("IO write error!\n");
> +			message->state = ERROR_STATE;
> +		} else {
> +			/* Update total byte transfered */
> +			message->actual_length += drv_data->len;
> +
> +			/* Move to next transfer of this msg*/
> +			message->state = next_transfer(drv_data);
> +		}
> +
> +		/* Schedule next transfer tasklet */
> +		tasklet_schedule(&drv_data->pump_transfers);
> +
> +	}
> +}
> +
> +/* pop a msg from queue and kick off real transfer */
> +static void pump_messages(struct work_struct *work)
> +{
> +	struct driver_data *drv_data = container_of(work, struct driver_data, pump_messages);
> +	unsigned long flags;
> +
> +	/* Lock queue and check for queue work */
> +	spin_lock_irqsave(&drv_data->lock, flags);
> +	if (list_empty(&drv_data->queue) || drv_data->run == QUEUE_STOPPED) {
> +		/* pumper kicked off but no work to do */
> +		drv_data->busy = 0;
> +		spin_unlock_irqrestore(&drv_data->lock, flags);
> +		return;
> +	}
> +
> +	/* Make sure we are not already running a message */
> +	if (drv_data->cur_msg) {
> +		spin_unlock_irqrestore(&drv_data->lock, flags);
> +		return;
> +	}

Looks like "drv->busy" and "drv_data->cur_msg" must be coupled, yes?
If so, get rid of the "busy" flag...

> +
> +	/* Extract head of queue */
> +	drv_data->cur_msg = list_entry(drv_data->queue.next,
> +					struct spi_message, queue);
> +	list_del_init(&drv_data->cur_msg->queue);
> +
> +	/* Initial message state*/
> +	drv_data->cur_msg->state = START_STATE;
> +	drv_data->cur_transfer = list_entry(drv_data->cur_msg->transfers.next,
> +						struct spi_transfer,
> +						transfer_list);
> +
> +	/* Setup the SSP using the per chip configuration */
> +	drv_data->cur_chip = spi_get_ctldata(drv_data->cur_msg->spi);
> +	restore_state(drv_data);
> +	pr_debug("got a message to pump, state is set to: baud %d, flag 0x%x, ctl 0x%x\n",
> +	       drv_data->cur_chip->baud, drv_data->cur_chip->flag, drv_data->cur_chip->ctl_reg);
> +	pr_debug("the first transfer len is %d\n", drv_data->cur_transfer->len);
> +
> +	/* Mark as busy and launch transfers */
> +	tasklet_schedule(&drv_data->pump_transfers);
> +
> +	drv_data->busy = 1;
> +	spin_unlock_irqrestore(&drv_data->lock, flags);
> +}
> +
> +/* got a msg to transfer, queue it in drv_data->queue. And kick off message pumper */
> +static int transfer(struct spi_device *spi, struct spi_message *msg)
> +{
> +	struct driver_data *drv_data = spi_master_get_devdata(spi->master);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&drv_data->lock, flags);
> +
> +	if (drv_data->run == QUEUE_STOPPED) {
> +		spin_unlock_irqrestore(&drv_data->lock, flags);
> +		return -ESHUTDOWN;
> +	}
> +
> +	msg->actual_length = 0;
> +	msg->status = -EINPROGRESS;
> +	msg->state = START_STATE;

I think you won't really needs msg->state; in any case, the
controller state machine is not per-message state.

Plus, here's the right place to handle things like DMA mapping
(call dma_map_single if !msg->is_dma_mapped and the device is
configured to use DMA), sanity checking the per-transfer protocol
tweaks (notably unsupported wordlengths) missing dma addresses
in each transfer when msg->is_dma_mapped, transfers with both
rx and tx missing, and so on.

> +
> +	pr_debug("adding an msg in transfer() \n");
> +	list_add_tail(&msg->queue, &drv_data->queue);
> +
> +	if (drv_data->run == QUEUE_RUNNING && !drv_data->busy)

Presumably I missed some reason why drv_data->run needs more
states than stopped and not-stopped ... if not, this should
simplify to check against drv_data->cur_msg ...

> +		queue_work(drv_data->workqueue, &drv_data->pump_messages);
> +
> +	spin_unlock_irqrestore(&drv_data->lock, flags);
> +
> +	return 0;
> +}
> +
> +/* first setup for new devices */
> +static int setup(struct spi_device *spi)
> +{
> +	struct bfin5xx_spi_chip *chip_info = NULL;
> +	struct chip_data *chip;
> +	struct driver_data *drv_data = spi_master_get_devdata(spi->master);
> +	u8 spi_flg;
> +
> +	if (chip_select_flag & (1 << (spi->chip_select))) {
> +		printk(KERN_ERR "spi_bfin: error: %s is using the same chip selection as another device.\n", spi->modalias);
> +		return -ENODEV;
> +	}

The SPI core should have prevented collisions on chipselect,
so this test ought not to be needed ...

> +	chip_select_flag |= (1 << (spi->chip_select));
> +
> +	if (!spi->bits_per_word)
> +		spi->bits_per_word = 16;

No; zero (the default) there means *EIGHT* bits.


> +
> +	if (spi->bits_per_word != 8 && spi->bits_per_word != 16)
> +		return -EINVAL;
> +
> +	/* Only alloc (or use chip_info) on first setup */
> +	chip = spi_get_ctldata(spi);
> +	if (chip == NULL) {
> +		chip = kzalloc(sizeof(struct chip_data), GFP_KERNEL);
> +		if (!chip)
> +			return -ENOMEM;
> +
> +		chip->enable_dma = 0;
> +		chip_info = spi->controller_data;
> +	}
> +
> +	/* chip_info isn't always needed */
> +	if (chip_info) {
> +		chip->enable_dma = chip_info->enable_dma != 0
> +					&& drv_data->master_info->enable_dma;
> +		chip->ctl_reg = chip_info->ctl_reg;
> +		chip->bits_per_word = chip_info->bits_per_word;
> +		chip->cs_change_per_word = chip_info->cs_change_per_word;
> +		chip->cs_chg_udelay = chip_info->cs_chg_udelay;
> +	}
> +
> +	if (spi->mode & SPI_CPOL)
> +		chip->ctl_reg &= CPOL;
> +	if (spi->mode & SPI_CPHA)
> +		chip->ctl_reg &= CPHA;

You need to also verify SPI_CS_HIGH and SPI_LSB_FIRST ... if they're
set and you don't handle those options, fail politely.  You're not
testing for either of those cases.

(In fact, the clean way to test this is to see if any bits you
don't handle are set in spi->mode, and fail if there are any.
That way if new options come in the future, you'll handle them
politely.)

> +
> +	/* if any one SPI chip is registered and wants DMA, request the
> +	   DMA channel for it */
> +	if (chip->enable_dma && !dma_requested) {
> +		/* register dma irq handler */
> +		if (request_dma(CH_SPI, "BF53x_SPI_DMA") < 0) {
> +			pr_debug("Unable to request BlackFin SPI DMA channel\n");

Why is this a fatal error?  Surely you can just continue in pure PIO mode.

> +			return -ENODEV;
> +		}
> +		if (set_dma_callback(CH_SPI, (void *)dma_irq_handler, drv_data) < 0) {
> +			pr_debug("Unable to set dma callback\n");

Ah yes, the old "every platform needs its own DMA interface" problem.

> +			return -EPERM;
> +		}
> +		dma_disable_irq(CH_SPI);
> +		dma_requested = 1;
> +	}
> +
> +	/* Notice: for blackfin, the speed_hz is the value of register
> +	   SPI_BAUD, not the real baudrate */
> +	chip->baud = hz_to_spi_baud(spi->max_speed_hz);
> +	spi_flg = ~(1 << (spi->chip_select));
> +	chip->flag = ((u16)spi_flg << 8 ) | (1 << (spi->chip_select));
> +	chip->chip_select_num = spi->chip_select;
> +
> +	if (chip->bits_per_word <= 8) {
> +		chip->n_bytes = 1;
> +		chip->width = CFG_SPI_WORDSIZE8;

Does this mean you're treating all wordsizes from 1..8 as if 8 bits
were specified?  And (below) all wordsizes from 9..16 as if 16 bits
were specified?  If so, that's wrong ...

... and I still don't see what this cs_change_per_word thing is.
Looks like a Blackfin-only feature.  If such a thing is needed,
propose it as a general feature for the SPI interface, something
to go into spi->mode.  Else remove it.

> +		chip->read = chip->cs_change_per_word? u8_cs_chg_reader: u8_reader;
> +		chip->write = chip->cs_change_per_word? u8_cs_chg_writer: u8_writer;
> +		chip->duplex = chip->cs_change_per_word? u8_cs_chg_duplex: u8_duplex;
> +		pr_debug("8bit: chip->write is %p, u8_writer is %p\n", chip->write, u8_writer);
> +	} else if (spi->bits_per_word <= 16) {
> +		chip->n_bytes = 2;
> +		chip->width = CFG_SPI_WORDSIZE16;
> +		chip->read = chip->cs_change_per_word? u16_cs_chg_reader: u16_reader;
> +		chip->write = chip->cs_change_per_word? u16_cs_chg_writer: u16_writer;
> +		chip->duplex = chip->cs_change_per_word? u16_cs_chg_duplex: u16_duplex;
> +		pr_debug("16bit: chip->write is %p, u16_writer is %p\n", chip->write, u16_writer);
> +	} else {
> +		dev_err(&spi->dev, "invalid wordsize\n");

It'd be useful to include the wordsize that's not supported, too.  :)

> +		kfree(chip);
> +		return -ENODEV;
> +	}
> +	pr_debug("setup spi chip %s, width is %d, dma is %d, ctl_reg is 0x%x, flag_reg is 0x%x\n",
> +	       spi->modalias, chip->width, chip->enable_dma, chip->ctl_reg, chip->flag);
> +	spi_set_ctldata(spi, chip);
> +
> +	return 0;
> +}
> +
> +/* callback for spi framework. clean driver specific data */
> +static void cleanup(const struct spi_device *spi)
> +{
> +	struct chip_data *chip = spi_get_ctldata((struct spi_device *)spi);
> +
> +	kfree(chip);
> +}
> +

I think GCC will nicely in-line these three queue methods.  :)

> +static int init_queue(struct driver_data *drv_data)
> +{
> +	INIT_LIST_HEAD(&drv_data->queue);
> +	spin_lock_init(&drv_data->lock);
> +
> +	drv_data->run = QUEUE_STOPPED;
> +	drv_data->busy = 0;
> +
> +	/* init transfer tasklet */
> +	tasklet_init(&drv_data->pump_transfers,
> +			pump_transfers,	(unsigned long)drv_data);
> +
> +	/* init messages workqueue */
> +	INIT_WORK(&drv_data->pump_messages, pump_messages);
> +	drv_data->workqueue = create_singlethread_workqueue(
> +					drv_data->master->cdev.dev->bus_id);
> +	if (drv_data->workqueue == NULL)
> +		return -EBUSY;
> +
> +	return 0;
> +}
> +
> +static int start_queue(struct driver_data *drv_data)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&drv_data->lock, flags);
> +
> +	if (drv_data->run == QUEUE_RUNNING || drv_data->busy) {
> +		spin_unlock_irqrestore(&drv_data->lock, flags);
> +		return -EBUSY;
> +	}
> +
> +	drv_data->run = QUEUE_RUNNING;
> +	drv_data->cur_msg = NULL;
> +	drv_data->cur_transfer = NULL;
> +	drv_data->cur_chip = NULL;
> +	spin_unlock_irqrestore(&drv_data->lock, flags);
> +
> +	queue_work(drv_data->workqueue, &drv_data->pump_messages);
> +
> +	return 0;
> +}
> +
> +static int stop_queue(struct driver_data *drv_data)
> +{
> +	unsigned long flags;
> +	unsigned limit = 500;
> +	int status = 0;
> +
> +	spin_lock_irqsave(&drv_data->lock, flags);
> +
> +	/* This is a bit lame, but is optimized for the common execution path.
> +	 * A wait_queue on the drv_data->busy could be used, but then the common
> +	 * execution path (pump_messages) would be required to call wake_up or
> +	 * friends on every SPI message. Do this instead */
> +	drv_data->run = QUEUE_STOPPED;
> +	while (!list_empty(&drv_data->queue) && drv_data->busy && limit--) {
> +		spin_unlock_irqrestore(&drv_data->lock, flags);
> +		msleep(10);
> +		spin_lock_irqsave(&drv_data->lock, flags);
> +	}
> +
> +	if (!list_empty(&drv_data->queue) || drv_data->busy)
> +		status = -EBUSY;
> +
> +	spin_unlock_irqrestore(&drv_data->lock, flags);
> +
> +	return status;
> +}
> +
> +static int destroy_queue(struct driver_data *drv_data)
> +{
> +	int status;
> +
> +	status = stop_queue(drv_data);
> +	if (status != 0)
> +		return status;
> +
> +	destroy_workqueue(drv_data->workqueue);
> +
> +	return 0;
> +}
> +
> +static int bfin5xx_spi_probe(struct platform_device *pdev)

I think this should be an __init function.

> +{
> +	struct device *dev = &pdev->dev;
> +	struct bfin5xx_spi_master *platform_info;
> +	struct spi_master *master;
> +	struct driver_data *drv_data = 0;
> +	int status = 0;
> +
> +	platform_info = dev->platform_data;
> +
> +	/* Allocate master with space for drv_data and null dma buffer */
> +	master = spi_alloc_master(dev, sizeof(struct driver_data) + 16);

What's this "null DMA buffer" thing?  It's not set up below ...

> +	if (!master) {
> +		dev_err(&pdev->dev, "can not alloc spi_master\n");
> +		return -ENOMEM;
> +	}
> +	drv_data = spi_master_get_devdata(master);
> +	drv_data->master = master;
> +	drv_data->master_info = platform_info;
> +	drv_data->pdev = pdev;
> +
> +	master->bus_num = pdev->id;
> +	master->num_chipselect = platform_info->num_chipselect;
> +	master->cleanup = cleanup;
> +	master->setup = setup;
> +	master->transfer = transfer;
> +
> +	/* Initial and start queue */
> +	status = init_queue(drv_data);
> +	if (status != 0) {
> +		dev_err(&pdev->dev, "problem initializing queue\n");
> +		goto out_error_queue_alloc;
> +	}
> +	status = start_queue(drv_data);
> +	if (status != 0) {
> +		dev_err(&pdev->dev, "problem starting queue\n");
> +		goto out_error_queue_alloc;
> +	}
> +
> +	/* Register with the SPI framework */
> +	platform_set_drvdata(pdev, drv_data);
> +	status = spi_register_master(master);
> +	if (status != 0) {
> +		dev_err(&pdev->dev, "problem registering spi master\n");
> +		goto out_error_queue_alloc;
> +	}
> +	pr_debug("controller probe successfully\n");
> +	return status;
> +
> +out_error_queue_alloc:
> +	destroy_queue(drv_data);
> +	spi_master_put(master);
> +	return status;
> +}
> +
> +/* stop hardware and remove the driver */
> +static int bfin5xx_spi_remove(struct platform_device *pdev)

This should be an __exit function ...


> +{
> +	struct driver_data *drv_data = platform_get_drvdata(pdev);
> +	int status = 0;
> +
> +	if (!drv_data)
> +		return 0;
> +
> +	/* Remove the queue */
> +	status = destroy_queue(drv_data);
> +	if (status != 0)
> +		return status;
> +
> +	/* Disable the SSP at the peripheral and SOC level */
> +	bfin_spi_disable(drv_data);
> +
> +	/* Release DMA */
> +	if (drv_data->master_info->enable_dma) {
> +		if (dma_channel_active(CH_SPI))
> +			free_dma(CH_SPI);
> +	}
> +
> +	/* Disconnect from the SPI framework */
> +	spi_unregister_master(drv_data->master);
> +
> +	/* Prevent double remove */
> +	platform_set_drvdata(pdev, NULL);
> +
> +	return 0;
> +}
> +
> +static void bfin5xx_spi_shutdown(struct platform_device *pdev)
> +{
> +	int status = 0;
> +
> +	if ((status = bfin5xx_spi_remove(pdev)) != 0)
> +		dev_err(&pdev->dev, "shutdown failed with %d\n", status);

I see you sent a patch to remove this bug, good.


> +}
> +
> +/* PM, do nothing now */

"Nothing" is incorrect; you're stopping the queue.


> +#ifdef CONFIG_PM
> +static int suspend_devices(struct device *dev, void *pm_message)
> +{
> +	pm_message_t *state = pm_message;
> +
> +	if (dev->power.power_state.event != state->event &&
> +	    dev->driver != NULL) {
> +		dev_warn(dev, "pm state does not match request\n");
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int bfin5xx_spi_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +	struct driver_data *drv_data = platform_get_drvdata(pdev);
> +	int status = 0;
> +
> +	/* Check all childern for current power state */
> +	if (device_for_each_child(&pdev->dev, &state, suspend_devices) != 0) {

Just delete this check.  The power->power.state field is nonsense
and will be going away.


> +	...
> +#else
> +#define bfin5xx_spi_suspend NULL
> +#define bfin5xx_spi_resume NULL
> +#endif /* CONFIG_PM */
> +
> +
> +static struct platform_driver driver = {
> +	.driver = {
> +		.name = "bfin-spi-master",
> +		.bus = &platform_bus_type,
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = bfin5xx_spi_probe,
> +	.remove = __devexit_p(bfin5xx_spi_remove),

Better yet, make that __exit and strike the probe() method there
(see below) ...


> +	.shutdown = bfin5xx_spi_shutdown,
> +	.suspend = bfin5xx_spi_suspend,
> +	.resume = bfin5xx_spi_resume,
> +};
> +
> +static int __init bfin5xx_spi_init(void)
> +{
> +	platform_driver_register(&driver);

... and make this return platorm_driver_probe(...);

I'm assuming your platform devices work like on other platforms:
they're set up in board init, never hotplugged (why would they be).

If that's so, you can save space by putting the probe() logic in
the init section, and remove() logic in the exit section ... so
that at least the setup code doesn't need to stick around even in
modular versions of this driver.  Save space, and all that.

> +	return 0;
> +}
> +module_init(bfin5xx_spi_init);
> +
> +static void __exit bfin5xx_spi_exit(void)
> +{
> +	platform_driver_unregister(&driver);
> +}
> +module_exit(bfin5xx_spi_exit);
> _
> 
