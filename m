Return-Path: <linux-kernel-owner+w=401wt.eu-S1762674AbXHPHEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762674AbXHPHEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 03:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbXHPHEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 03:04:35 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37051 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819AbXHPHEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 03:04:32 -0400
Message-ID: <46C3F6FB.2070909@garzik.org>
Date: Thu, 16 Aug 2007 03:04:27 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Sonic Zhang <sonic.adi@gmail.com>
CC: Linux IDE <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Bryan Wu <bryan.wu@analog.com>
Subject: Re: [PATCH take #5] [libata] libata driver for bf548 on chip ATAPI
 controller.
References: <1187169256.31383.3.camel@sevens.analog.com>
In-Reply-To: <1187169256.31383.3.camel@sevens.analog.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sonic Zhang wrote:
> Update:
> 1. Condition branch code instead of while loop from Alan Cox.
> 2. Condtinue in PIO mode after failing to request DMA.
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
>  drivers/ata/Kconfig      |   28 +
>  drivers/ata/Makefile     |    1
>  drivers/ata/pata_bf54x.c | 1581 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 1610 insertions(+)
> 
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index b4a8d60..e679f04 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -583,4 +583,32 @@ config PATA_SCC
>  
>  	  If unsure, say N.
>  
> +config PATA_BF54X
> +	tristate "Blackfin 54x ATAPI support"
> +	depends on BF542 || BF548 || BF549
> +	help
> +	  This option enables support for the built-in ATAPI controller on
> +	  Blackfin 54x family chips.
> +
> +	  If unsure, say N.
> +
> +choice
> +	prompt "Blackfin 54x ATAPI mode"
> +	depends on PATA_BF54X
> +	default PATA_BF54X_DMA
> +	help
> +	  This option selects bf54x ATAPI controller working mode.
> +
> +config PATA_BF54X_PIO
> +	bool "PIO mode"
> +	help
> +	  Blackfin ATAPI controller works under PIO mode.
> +
> +config PATA_BF54X_DMA
> +	bool "DMA mode"
> +	help
> +	  Blackfin ATAPI controller works under DMA mode.


Given update #2 at the top of your message, I would think a more natural 
Kconfig setup would now be a simple "DMA support?" yes/no setting.  PIO 
would theoretically always be present as a fallback, I would think.


> diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
> index 8149c68..c2ecba5 100644
> --- a/drivers/ata/Makefile
> +++ b/drivers/ata/Makefile
> @@ -61,6 +61,7 @@ obj-$(CONFIG_PATA_SIS)		+= pata_sis.o
>  obj-$(CONFIG_PATA_TRIFLEX)	+= pata_triflex.o
>  obj-$(CONFIG_PATA_IXP4XX_CF)	+= pata_ixp4xx_cf.o
>  obj-$(CONFIG_PATA_SCC)		+= pata_scc.o
> +obj-$(CONFIG_PATA_BF54X)	+= pata_bf54x.o
>  obj-$(CONFIG_PATA_PLATFORM)	+= pata_platform.o
>  obj-$(CONFIG_PATA_ICSIDE)	+= pata_icside.o
>  # Should be last but one libata driver
> diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
> new file mode 100644
> index 0000000..d0f52b0
> --- /dev/null
> +++ b/drivers/ata/pata_bf54x.c
> @@ -0,0 +1,1581 @@
> +/*
> + * File:         drivers/ata/pata_bf54x.c
> + * Author:       Sonic Zhang <sonic.zhang@analog.com>
> + *
> + * Created:
> + * Description:  ATAPI Driver for blackfin 54x

Terminology:  When used alone, "ATAPI" normally refers to CD/DVD-ROM 
style devices.  A better description would be "PATA driver for ..."


> +#define DRV_NAME		"bf54x-atapi"
> +#define DRV_VERSION		"0.6"

DRV_NAME should be "pata_bf54x"


> +#define ATA_REG_CTRL		0x0E
> +#define ATA_REG_ALTSTATUS	ATA_REG_CTRL

a simple comment at the beginning of this list, noting that these are 
the controller's registers, would be nice


> +#define ATAPI_OFFSET_CONTROL		0x00
> +#define ATAPI_OFFSET_STATUS		0x04
> +#define ATAPI_OFFSET_DEV_ADDR		0x08
> +#define ATAPI_OFFSET_DEV_TXBUF		0x0c
> +#define ATAPI_OFFSET_DEV_RXBUF		0x10
> +#define ATAPI_OFFSET_INT_MASK		0x14
> +#define ATAPI_OFFSET_INT_STATUS		0x18
> +#define ATAPI_OFFSET_XFER_LEN		0x1c
> +#define ATAPI_OFFSET_LINE_STATUS	0x20
> +#define ATAPI_OFFSET_SM_STATE		0x24
> +#define ATAPI_OFFSET_TERMINATE		0x28
> +#define ATAPI_OFFSET_PIO_TFRCNT		0x2c
> +#define ATAPI_OFFSET_DMA_TFRCNT		0x30
> +#define ATAPI_OFFSET_UMAIN_TFRCNT	0x34
> +#define ATAPI_OFFSET_UDMAOUT_TFRCNT	0x38
> +#define ATAPI_OFFSET_REG_TIM_0		0x40
> +#define ATAPI_OFFSET_PIO_TIM_0		0x44
> +#define ATAPI_OFFSET_PIO_TIM_1		0x48
> +#define ATAPI_OFFSET_MULTI_TIM_0	0x50
> +#define ATAPI_OFFSET_MULTI_TIM_1	0x54
> +#define ATAPI_OFFSET_MULTI_TIM_2	0x58
> +#define ATAPI_OFFSET_ULTRA_TIM_0	0x60
> +#define ATAPI_OFFSET_ULTRA_TIM_1	0x64
> +#define ATAPI_OFFSET_ULTRA_TIM_2	0x68
> +#define ATAPI_OFFSET_ULTRA_TIM_3	0x6c
> +
> +
> +/**
> + * PIO Mode - Frequency compatibility
> + */
> +/* mode: 0         1         2         3         4 */
> +static u32 pio_fsclk[] =
> +{ 33333333, 33333333, 33333333, 33333333, 33333333 };
> +
> +/**
> + * MDMA Mode - Frequency compatibility
> + */
> +/*               mode:      0         1         2        */
> +static u32 mdma_fsclk[] = { 33333333, 33333333, 33333333 };
> +
> +/**
> + * UDMA Mode - Frequency compatibility
> + *
> + * UDMA5 - 100 MB/s   - SCLK  = 133 MHz
> + * UDMA4 - 66 MB/s    - SCLK >=  80 MHz
> + * UDMA3 - 44.4 MB/s  - SCLK >=  50 MHz
> + * UDMA2 - 33 MB/s    - SCLK >=  40 MHz
> + */
> +/* mode: 0         1         2         3         4          5 */
> +static u32 udma_fsclk[] =
> +{ 33333333, 33333333, 40000000, 50000000, 80000000, 133333333 };
> +
> +/**
> + * Register transfer timing table
> + */
> +/*               mode:       0    1    2    3    4    */
> +/* Cycle Time                     */
> +static u32 reg_t0min[]   = { 600, 383, 330, 180, 120 };
> +/* DIOR/DIOW to end cycle         */
> +static u32 reg_t2min[]   = { 290, 290, 290, 70,  25  };
> +/* DIOR/DIOW asserted pulse width */
> +static u32 reg_teocmin[] = { 290, 290, 290, 80,  70  };
> +
> +/**
> + * PIO timing table
> + */
> +/*               mode:       0    1    2    3    4    */
> +/* Cycle Time                     */
> +static u32 pio_t0min[]   = { 600, 383, 240, 180, 120 };
> +/* Address valid to DIOR/DIORW    */
> +static u32 pio_t1min[]   = { 70,  50,  30,  30,  25  };
> +/* DIOR/DIOW to end cycle         */
> +static u32 pio_t2min[]   = { 165, 125, 100, 80,  70  };
> +/* DIOR/DIOW asserted pulse width */
> +static u32 pio_teocmin[] = { 165, 125, 100, 70,  25  };
> +/* DIOW data hold                 */
> +static u32 pio_t4min[]   = { 30,  20,  15,  10,  10  };
> +
> +/* ******************************************************************
> + * Multiword DMA timing table
> + * ******************************************************************
> + */
> +/*               mode:       0   1    2        */
> +/* Cycle Time                     */
> +static u32 mdma_t0min[]  = { 480, 150, 120 };
> +/* DIOR/DIOW asserted pulse width */
> +static u32 mdma_tdmin[]  = { 215, 80,  70  };
> +/* DMACK to read data released    */
> +static u32 mdma_thmin[]  = { 20,  15,  10  };
> +/* DIOR/DIOW to DMACK hold        */
> +static u32 mdma_tjmin[]  = { 20,  5,   5   };
> +/* DIOR negated pulse width       */
> +static u32 mdma_tkrmin[] = { 50,  50,  25  };
> +/* DIOR negated pulse width       */
> +static u32 mdma_tkwmin[] = { 215, 50,  25  };
> +/* CS[1:0] valid to DIOR/DIOW     */
> +static u32 mdma_tmmin[]  = { 50,  30,  25  };
> +/* DMACK to read data released    */
> +static u32 mdma_tzmax[]  = { 20,  25,  25  };
> +
> +/**
> + * Ultra DMA timing table
> + */
> +/*               mode:         0    1    2    3    4    5       */
> +static u32 udma_tcycmin[]  = { 112, 73,  54,  39,  25,  17 };
> +static u32 udma_tdvsmin[]  = { 70,  48,  31,  20,  7,   5  };
> +static u32 udma_tenvmax[]  = { 70,  70,  70,  55,  55,  50 };
> +static u32 udma_trpmin[]   = { 160, 125, 100, 100, 100, 85 };
> +static u32 udma_tmin[]     = { 5,   5,   5,   5,   3,   3  };
> +
> +
> +static u32 udma_tmlimin = 20;
> +static u32 udma_tzahmin = 20;
> +static u32 udma_tenvmin = 20;
> +static u32 udma_tackmin = 20;
> +static u32 udma_tssmin = 50;

how many of these can be marked 'static const'?


> +static unsigned short num_clocks_min(unsigned long tmin,
> +				unsigned long fsclk)
> +{
> +	unsigned long tmp ;
> +	unsigned short result;
> +
> +	tmp = tmin * (fsclk/1000/1000) / 1000;
> +	result = (unsigned short)tmp;
> +	if ((tmp*1000*1000) < (tmin*(fsclk/1000))) {
> +		result++;
> +	}
> +
> +	return result;
> +}
> +
> +/**
> + *	bfin_set_piomode - Initialize host controller PATA PIO timings
> + *	@ap: Port whose timings we are configuring
> + *	@adev: um
> + *
> + *	Set PIO mode for device.
> + *
> + *	LOCKING:
> + *	None (inherited from caller).
> + */
> +
> +static void bfin_set_piomode(struct ata_port *ap, struct ata_device *adev)
> +{
> +	int mode = adev->pio_mode - XFER_PIO_0;
> +	unsigned long base = (unsigned long)ap->ioaddr.ctl_addr;


(added Bryan Wu to CC)

Someone needs to need fix the bfin architecture:  the addresses on the 
bfin_read/bfin_write functions should be 'void __iomem *' not unsigned long.

Also, it would make this driver quite a bit smaller if you can use the 
ioread/iowrite (iomap) functions provided by the architecture.  Then you 
can use a lot of the standard libata helper functions.



> +	unsigned int fsclk = get_sclk();
> +	unsigned short teoc_reg, t2_reg, teoc_pio;
> +	unsigned short t4_reg, t2_pio, t1_reg;
> +	unsigned short n0, n6, t6min = 5;
> +
> +	/* the most restrictive timing value is t6 and tc, the DIOW - data hold
> +	* If one SCLK pulse is longer than this minimum value then register
> +	* transfers cannot be supported at this frequency.
> +	*/
> +	n6 = num_clocks_min(t6min, fsclk);
> +	if (mode >= 0 && mode <= 4 && n6 >= 1) {
> +		pr_debug("set piomode: mode=%d, fsclk=%ud\n", mode, fsclk);
> +		/* calculate the timing values for register transfers. */
> +		while (mode > 0 && pio_fsclk[mode] > fsclk) {
> +			mode--;
> +		}

In Linux kernel code, we prefer that single C statements not be 
surrounded by [optional] braces.


> +		/* DIOR/DIOW to end cycle time */
> +		t2_reg = num_clocks_min(reg_t2min[mode], fsclk);
> +		/* DIOR/DIOW asserted pulse width */
> +		teoc_reg = num_clocks_min(reg_teocmin[mode], fsclk);
> +		/* Cycle Time */
> +		n0  = num_clocks_min(reg_t0min[mode], fsclk);
> +
> +		/* increase t2 until we meed the minimum cycle length */
> +		if (t2_reg + teoc_reg < n0)
> +			t2_reg = n0 - teoc_reg;
> +
> +		/* calculate the timing values for pio transfers. */
> +
> +		/* DIOR/DIOW to end cycle time */
> +		t2_pio = num_clocks_min(pio_t2min[mode], fsclk);
> +		/* DIOR/DIOW asserted pulse width */
> +		teoc_pio = num_clocks_min(pio_teocmin[mode], fsclk);
> +		/* Cycle Time */
> +		n0  = num_clocks_min(pio_t0min[mode], fsclk);
> +
> +		/* increase t2 until we meed the minimum cycle length */
> +		if (t2_pio + teoc_pio < n0)
> +			t2_pio = n0 - teoc_pio;
> +
> +		/* Address valid to DIOR/DIORW */
> +		t1_reg = num_clocks_min(pio_t1min[mode], fsclk);
> +
> +		/* DIOW data hold */
> +		t4_reg = num_clocks_min(pio_t4min[mode], fsclk);
> +
> +		ATAPI_SET_REG_TIM_0(base, (teoc_reg<<8 | t2_reg));
> +		ATAPI_SET_PIO_TIM_0(base, (t4_reg<<12 | t2_pio<<4 | t1_reg));
> +		ATAPI_SET_PIO_TIM_1(base, teoc_pio);
> +		if (mode > 2) {
> +			ATAPI_SET_CONTROL(base,
> +				ATAPI_GET_CONTROL(base) | IORDY_EN);
> +		} else {
> +			ATAPI_SET_CONTROL(base,
> +				ATAPI_GET_CONTROL(base) & ~IORDY_EN);
> +		}
> +
> +		/* Disable host ATAPI PIO interrupts */
> +		ATAPI_SET_INT_MASK(base, ATAPI_GET_INT_MASK(base)
> +			& ~(PIO_DONE_MASK | HOST_TERM_XFER_MASK));
> +		SSYNC();
> +	}
> +}
> +
> +/**
> + *	bfin_set_dmamode - Initialize host controller PATA DMA timings
> + *	@ap: Port whose timings we are configuring
> + *	@adev: um
> + *	@udma: udma mode, 0 - 6
> + *
> + *	Set UDMA mode for device.
> + *
> + *	LOCKING:
> + *	None (inherited from caller).
> + */
> +
> +static void bfin_set_dmamode (struct ata_port *ap, struct ata_device *adev)
> +{
> +	int mode;
> +	unsigned long base = (unsigned long)ap->ioaddr.ctl_addr;
> +	unsigned long fsclk = get_sclk();
> +	unsigned short tenv, tack, tcyc_tdvs, tdvs, tmli, tss, trp, tzah;
> +	unsigned short tm, td, tkr, tkw, teoc, th;
> +	unsigned short n0, nf, tfmin = 5;
> +	unsigned short nmin, tcyc;

> +/**
> + *
> + *    Function:       wait_complete
> + *
> + *    Description:    Waits the interrupt from device
> + *
> + */
> +static void inline wait_complete(unsigned long base, unsigned short mask)
> +{
> +	unsigned short status;
> +
> +	do {
> +		status = ATAPI_GET_INT_STATUS(base) & mask;
> +	} while (!status);
> +
> +	ATAPI_SET_INT_STATUS(base, mask);
> +}

no infinite loops, please.  always make sure the function errors out 
after (100? 1000? 100000?) iterations.





> + */
> +
> +static void bfin_bmdma_setup (struct ata_queued_cmd *qc)
> +{
> +	unsigned short config = WDSIZE_16;
> +	struct scatterlist *sg;
> +
> +	pr_debug("in atapi dma setup\n");
> +	/* Program the ATA_CTRL register with dir */
> +	if (qc->tf.flags & ATA_TFLAG_WRITE) {
> +		/* fill the ATAPI DMA controller */
> +		set_dma_config(CH_ATAPI_TX, config);
> +		set_dma_x_modify(CH_ATAPI_TX, 2);
> +		ata_for_each_sg(sg, qc) {
> +			set_dma_start_addr(CH_ATAPI_TX, sg_dma_address(sg));
> +			set_dma_x_count(CH_ATAPI_TX, sg_dma_len(sg) >> 1);
> +		}
> +	} else {
> +		config |= WNR;
> +		/* fill the ATAPI DMA controller */
> +		set_dma_config(CH_ATAPI_RX, config);
> +		set_dma_x_modify(CH_ATAPI_RX, 2);
> +		ata_for_each_sg(sg, qc) {
> +			set_dma_start_addr(CH_ATAPI_RX, sg_dma_address(sg));
> +			set_dma_x_count(CH_ATAPI_RX, sg_dma_len(sg) >> 1);
> +		}
> +	}
> +}
> +
> +/**
> + *	bfin_bmdma_start - Start an IDE DMA transaction
> + *	@qc: Info associated with this ATA transaction.
> + *
> + *	Note: Original code is ata_bmdma_start().
> + */
> +
> +static void bfin_bmdma_start (struct ata_queued_cmd *qc)
> +{
> +	struct ata_port *ap = qc->ap;
> +	unsigned long base = (unsigned long)ap->ioaddr.ctl_addr;
> +	struct scatterlist *sg;
> +
> +	pr_debug("in atapi dma start\n");
> +	if (ap->udma_mask || ap->mwdma_mask) {

invert this test, and have it return from the function early if so.

this allows you to un-indent the following section of code, making it 
easier to read.


> +		/* start ATAPI DMA controller*/
> +		if (qc->tf.flags & ATA_TFLAG_WRITE) {

a comment explaining what the flush_dcache_range() loop is accomplishing 
would be nice


> +			ata_for_each_sg(sg, qc) {
> +				flush_dcache_range(sg_dma_address(sg),
> +					sg_dma_address(sg) + sg_dma_len(sg));
> +			}
> +			enable_dma(CH_ATAPI_TX);
> +			pr_debug("enable udma write\n");
> +
> +			/* Send ATA DMA write command */
> +			bfin_exec_command(ap, &qc->tf);
> +
> +			/* set ATA DMA write direction */
> +			ATAPI_SET_CONTROL(base, (ATAPI_GET_CONTROL(base)
> +				| XFER_DIR));
> +		} else {
> +			enable_dma(CH_ATAPI_RX);
> +			pr_debug("enable udma read\n");
> +
> +			/* Send ATA DMA read command */
> +			bfin_exec_command(ap, &qc->tf);
> +
> +			/* set ATA DMA read direction */
> +			ATAPI_SET_CONTROL(base, (ATAPI_GET_CONTROL(base)
> +				& ~XFER_DIR));
> +		}
> +
> +		/* Reset all transfer count */
> +		ATAPI_SET_CONTROL(base,
> +			ATAPI_GET_CONTROL(base) | TFRCNT_RST);
> +
> +		/* Set transfer length to buffer len */
> +		ata_for_each_sg(sg, qc) {
> +			ATAPI_SET_XFER_LEN(base, (sg_dma_len(sg) >> 1));
> +		}
> +
> +		/* Enable ATA DMA operation*/
> +		if (ap->udma_mask) {
> +			ATAPI_SET_CONTROL(base, ATAPI_GET_CONTROL(base)
> +				| ULTRA_START);
> +		} else {
> +			ATAPI_SET_CONTROL(base, ATAPI_GET_CONTROL(base)
> +				| MULTI_START);
> +		}
> +	}
> +}
> +
> +/**
> + *	bfin_bmdma_stop - Stop IDE DMA transfer
> + *	@qc: Command we are ending DMA for
> + */
> +
> +static void bfin_bmdma_stop (struct ata_queued_cmd *qc)
> +{
> +	struct ata_port *ap = qc->ap;
> +	struct scatterlist *sg;
> +
> +	pr_debug("in atapi dma stop\n");
> +	if (ap->udma_mask || ap->mwdma_mask) {

ditto -- invert test and return early.

then, un-indent all code following.


> +		/* stop ATAPI DMA controller*/
> +		if (qc->tf.flags & ATA_TFLAG_WRITE) {
> +			disable_dma(CH_ATAPI_TX);
> +		} else {
> +			disable_dma(CH_ATAPI_RX);
> +			if (ap->hsm_task_state & HSM_ST_LAST) {

ditto -- a comment explaining the invalidate_dcache_range() loop would 
be nice.

it really looks like this should be hidden inside the architecture's dma 
functions, I would think?


> +				ata_for_each_sg(sg, qc) {
> +					invalidate_dcache_range(
> +						sg_dma_address(sg),
> +						sg_dma_address(sg)
> +						+ sg_dma_len(sg));
> +				}
> +			}
> +		}
> +	}

you appear to be missing an important error handling operation: thaw


> +static void bfin_bmdma_freeze (struct ata_port *ap)
> +{
> +	unsigned long base = (unsigned long)ap->ioaddr.ctl_addr;
> +
> +	pr_debug("in atapi dma freeze\n");
> +	ap->ctl |= ATA_NIEN;
> +	ap->last_ctl = ap->ctl;
> +
> +	write_atapi_register(base, ATA_REG_CTRL, ap->ctl);
> +
> +	/* Under certain circumstances, some controllers raise IRQ on
> +	 * ATA_NIEN manipulation.  Also, many controllers fail to mask
> +	 * previously pending IRQ on ATA_NIEN assertion.  Clear it.
> +	 */
> +	ata_chk_status(ap);
> +
> +	ap->ops->irq_clear(ap);

All occurences of "ap->ops->..." in this driver may be replaced with 
direct calls to functions.



> + *	bfin_std_postreset - standard postreset callback
> + *	@ap: the target ata_port
> + *	@classes: classes of attached devices
> + *
> + *	Note: Original code is ata_std_postreset().
> + */
> +
> +static void bfin_std_postreset (struct ata_port *ap, unsigned int *classes)
> +{
> +	unsigned long base = (unsigned long)ap->ioaddr.ctl_addr;
> +
> +	/* re-enable interrupts */
> +	if (!ap->ops->error_handler)
> +		ap->ops->irq_on(ap);

->error_handler is always non-NULL for this driver


> +	/* is double-select really necessary? */
> +	if (classes[0] != ATA_DEV_NONE)
> +		ap->ops->dev_select(ap, 1);
> +	if (classes[1] != ATA_DEV_NONE)
> +		ap->ops->dev_select(ap, 0);
> +
> +	/* bail out if no device is present */
> +	if (classes[0] == ATA_DEV_NONE && classes[1] == ATA_DEV_NONE) {
> +		return;
> +	}
> +
> +	/* set up device control */
> +	write_atapi_register(base, ATA_REG_CTRL, ap->ctl);
> +}
> +
> +/**
> + *	bfin_error_handler - Stock error handler for DMA controller
> + *	@ap: port to handle error for
> + */
> +
> +static void bfin_error_handler (struct ata_port *ap)
> +{
> +	ata_bmdma_drive_eh(ap, ata_std_prereset, bfin_std_softreset, NULL,
> +			   bfin_std_postreset);
> +}
> +
> +/**
> + *	bfin_bmdma_irq_clear - Clear ATAPI interrupt.
> + *	@ap: Port associated with this ATA transaction.
> + *
> + *	Note: Original code is ata_bmdma_irq_clear().
> + */
> +
> +static void bfin_bmdma_irq_clear (struct ata_port *ap)
> +{
> +	unsigned long base = (unsigned long)ap->ioaddr.ctl_addr;
> +
> +	pr_debug("in atapi irq clear\n");
> +	ATAPI_SET_INT_STATUS(base, 0x1FF);
> +}
> +
> +static void bfin_port_stop(struct ata_port *ap)
> +{
> +	pr_debug("in atapi port stop\n");
> +	if (ap->udma_mask != 0 || ap->mwdma_mask != 0) {
> +		free_dma(CH_ATAPI_RX);
> +		free_dma(CH_ATAPI_TX);
> +	}
> +}
> +
> +static int bfin_port_start(struct ata_port *ap)
> +{
> +	pr_debug("in atapi port start\n");
> +	if (ap->udma_mask != 0 || ap->mwdma_mask != 0) {

ditto above comments -- invert test, return early, un-indent code that 
follows


> +		if (request_dma(CH_ATAPI_RX, "BFIN ATAPI RX DMA") >= 0) {
> +			if (request_dma(CH_ATAPI_TX,
> +				"BFIN ATAPI TX DMA") >= 0) {
> +				return 0;
> +			}
> +			free_dma(CH_ATAPI_RX);
> +		}
> +		ap->udma_mask = 0;
> +		ap->mwdma_mask = 0;
> +		dev_err(ap->dev, "Unable to request ATAPI DMA!"
> +			" Continue in PIO mode.\n");
> +	}
> +	return 0;
> +}
> +
> +void bfin_qc_prep(struct ata_queued_cmd *qc)
> +{
> +}

use ata_noop_qc_prep() and delete the above


> +static struct scsi_host_template bfin_sht = {
> +	.module			= THIS_MODULE,
> +	.name			= DRV_NAME,
> +	.ioctl			= ata_scsi_ioctl,
> +	.queuecommand		= ata_scsi_queuecmd,
> +	.can_queue		= ATA_DEF_QUEUE,
> +	.this_id		= ATA_SHT_THIS_ID,
> +/*	.sg_tablesize		= LIBATA_MAX_PRD,*/
> +	.sg_tablesize		= SG_NONE,
> +	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,
> +	.emulated		= ATA_SHT_EMULATED,
> +	.use_clustering		= ATA_SHT_USE_CLUSTERING,
> +	.proc_name		= DRV_NAME,
> +	.dma_boundary		= ATA_DMA_BOUNDARY,
> +	.slave_configure	= ata_scsi_slave_config,
> +	.slave_destroy		= ata_scsi_slave_destroy,
> +	.bios_param		= ata_std_bios_param,
> +#ifdef CONFIG_PM
> +	.resume			= ata_scsi_device_resume,
> +	.suspend		= ata_scsi_device_suspend,
> +#endif
> +};
> +
> +static const struct ata_port_operations bfin_pata_ops = {
> +	.port_disable		= ata_port_disable,
> +	.set_piomode		= bfin_set_piomode,
> +	.set_dmamode		= bfin_set_dmamode,
> +
> +	.tf_load		= bfin_tf_load,
> +	.tf_read		= bfin_tf_read,
> +	.exec_command		= bfin_exec_command,
> +	.check_status		= bfin_check_status,
> +	.check_altstatus	= bfin_check_altstatus,
> +	.dev_select		= bfin_std_dev_select,
> +
> +	.bmdma_setup		= bfin_bmdma_setup,
> +	.bmdma_start		= bfin_bmdma_start,
> +	.bmdma_stop		= bfin_bmdma_stop,
> +	.bmdma_status		= bfin_bmdma_status,
> +	.data_xfer		= bfin_data_xfer,
> +
> +	.qc_prep		= bfin_qc_prep,
> +	.qc_issue		= ata_qc_issue_prot,
> +
> +	.freeze			= bfin_bmdma_freeze,
> +	.error_handler		= bfin_error_handler,
> +	.post_internal_cmd	= bfin_bmdma_stop,
> +
> +	.irq_handler		= ata_interrupt,
> +	.irq_clear		= bfin_bmdma_irq_clear,
> +	.irq_on			= bfin_irq_on,
> +	.irq_ack		= bfin_irq_ack,
> +
> +	.port_start		= bfin_port_start,
> +	.port_stop		= bfin_port_stop,
> +};
> +
> +static struct ata_port_info bfin_port_info[] = {
> +	{
> +		.sht		= &bfin_sht,
> +		.flags		= ATA_FLAG_SLAVE_POSS
> +				| ATA_FLAG_MMIO
> +				| ATA_FLAG_NO_LEGACY,
> +		.pio_mask	= 0x1f,	/* pio0-4 */
> +		.mwdma_mask	= 0,
> +#ifdef CONFIG_PATA_BF54X_DMA
> +		.udma_mask	= ATA_UDMA5,
> +#else
> +		.udma_mask	= 0,
> +#endif
> +		.port_ops	= &bfin_pata_ops,
> +	},
> +};
> +
> +/**
> + *	bfin_reset_controller - initialize BF54x ATAPI controller.
> + */
> +
> +static int bfin_reset_controller(struct ata_host *host)
> +{
> +	unsigned long base = (unsigned long)host->ports[0]->ioaddr.ctl_addr;
> +	int count;
> +	unsigned short status;
> +
> +	/* Disable all ATAPI interrupts */
> +	ATAPI_SET_INT_MASK(base, 0);
> +	SSYNC();
> +
> +	/* Assert the RESET signal 25us*/
> +	ATAPI_SET_CONTROL(base, ATAPI_GET_CONTROL(base) | DEV_RST);
> +	udelay(30);
> +
> +	/* Negate the RESET signal for 2ms*/
> +	ATAPI_SET_CONTROL(base, ATAPI_GET_CONTROL(base) & ~DEV_RST);
> +	udelay(2100);

1) udelay() greater than 1000 should be mdelay()

2) you can sleep here, so msleep() is preferred


> +	/* Wait on Busy flag to clear */
> +	count = 10000000;
> +	do {
> +		status = read_atapi_register(base, ATA_REG_STATUS);
> +	} while (count-- && (status & ATA_BUSY));
> +
> +	/* Enable only ATAPI Device interrupt */
> +	ATAPI_SET_INT_MASK(base, 1);
> +	SSYNC();
> +
> +	return (!count);
> +}
> +
> +/**
> + *	atapi_io_port - define atapi peripheral port pins.
> + */
> +static unsigned short atapi_io_port[] = {
> +	P_ATAPI_RESET,
> +	P_ATAPI_DIOR,
> +	P_ATAPI_DIOW,
> +	P_ATAPI_CS0,
> +	P_ATAPI_CS1,
> +	P_ATAPI_DMACK,
> +	P_ATAPI_DMARQ,
> +	P_ATAPI_INTRQ,
> +	P_ATAPI_IORDY,
> +	0
> +};
> +
> +/**
> + *	bfin_atapi_probe	-	attach a bfin atapi interface
> + *	@pdev: platform device
> + *
> + *	Register a bfin atapi interface.
> + *
> + *
> + *	Platform devices are expected to contain 2 resources per port:
> + *
> + *		- I/O Base (IORESOURCE_IO)
> + *		- IRQ	   (IORESOURCE_IRQ)
> + *
> + */
> +static int __devinit bfin_atapi_probe(struct platform_device *pdev)
> +{
> +	int board_idx = 0;
> +	struct resource *res;
> +	struct ata_host *host;
> +	const struct ata_port_info *ppi[] =
> +		{ &bfin_port_info[board_idx], NULL };
> +
> +	/*
> +	 * Simple resource validation ..
> +	 */
> +	if (unlikely(pdev->num_resources != 2)) {
> +		dev_err(&pdev->dev, "invalid number of resources\n");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Get the register base first
> +	 */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (res == NULL)
> +		return -EINVAL;
> +
> +	/*
> +	 * Now that that's out of the way, wire up the port..
> +	 */
> +	host = ata_host_alloc_pinfo(&pdev->dev, ppi, 1);
> +	if (!host)
> +		return -ENOMEM;
> +
> +	host->ports[0]->ioaddr.ctl_addr = (void *)res->start;
> +
> +	if (peripheral_request_list(atapi_io_port, "atapi-io-port")) {
> +		dev_err(&pdev->dev, "Requesting Peripherals faild\n");
> +		return -EFAULT;
> +	}
> +
> +	if (bfin_reset_controller(host)) {
> +		peripheral_free_list(atapi_io_port);
> +		dev_err(&pdev->dev, "Fail to reset ATAPI device\n");
> +		return -EFAULT;
> +	}
> +
> +	if (ata_host_activate(host, platform_get_irq(pdev, 0),
> +		ata_interrupt, IRQF_SHARED, &bfin_sht) != 0) {
> +		peripheral_free_list(atapi_io_port);
> +		dev_err(&pdev->dev, "Fail to attach ATAPI device\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + *	bfin_atapi_remove	-	unplug a bfin atapi interface
> + *	@pdev: platform device
> + *
> + *	A bfin atapi device has been unplugged. Perform the needed
> + *	cleanup. Also called on module unload for any active devices.
> + */
> +static int __devexit bfin_atapi_remove(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct ata_host *host = dev_get_drvdata(dev);
> +
> +	ata_host_detach(host);
> +
> +	peripheral_free_list(atapi_io_port);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver bfin_atapi_driver = {
> +	.probe			= bfin_atapi_probe,
> +	.remove			= __devexit_p(bfin_atapi_remove),
> +	.driver = {
> +		.name		= DRV_NAME,
> +		.owner		= THIS_MODULE,
> +	},

if you are going to implement suspend/resume in scsi-host-template, you 
probably should do so here too


> +static int __init bfin_atapi_init (void)
> +{
> +	pr_info("register bfin atapi driver\n");
> +	return platform_driver_register(&bfin_atapi_driver);
> +}
> +
> +static void __exit bfin_atapi_exit (void)
> +{
> +	platform_driver_unregister(&bfin_atapi_driver);
> +}
> +
> +module_init(bfin_atapi_init);
> +module_exit(bfin_atapi_exit);
> +
> +MODULE_AUTHOR("Sonic Zhang <sonic.zhang@analog.com>");
> +MODULE_DESCRIPTION("ATAPI libata driver for blackfin 54x ATAPI controller");

recommend s/ATAPI/PATA/


> +MODULE_LICENSE("GPL");
> +MODULE_VERSION(DRV_VERSION);
> 
> 

