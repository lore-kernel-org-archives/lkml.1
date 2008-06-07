Return-Path: <linux-kernel-owner+w=401wt.eu-S1759917AbYFGMWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759917AbYFGMWt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 08:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYFGMWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 08:22:39 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:56476 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751993AbYFGMWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 08:22:37 -0400
Date: Sat, 7 Jun 2008 13:22:27 +0100
From: Ben Dooks <ben@fluff.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 01/15] MMC: S3C24XX MMC/SD driver. From: Thomas Kleffel
	<tk@maintech.de>
Message-ID: <20080607122227.GA1500@fluff.org.uk>
References: <20080606155117.074799346@fluff.org.uk> <20080606155524.699256747@fluff.org.uk> <20080606224928.a3ac2655.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606224928.a3ac2655.akpm@linux-foundation.org>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 10:49:28PM -0700, Andrew Morton wrote:
> On Fri, 06 Jun 2008 16:51:18 +0100 Ben Dooks <ben-linux@fluff.org> wrote:
> 
> > This is the latest S3C MMC/SD driver by Thomas Kleffel
> 
> If Thomas was the author then this patch should have had
>
> From: Thomas Kleffel <tk@maintech.de>

I thought I'd done this for all the relevant patches, will fix thus.
 
> right at the top of the changelog so that the commit is correctly
> attributed.
> 
> > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> 
> Please pass these patches through chechpatch?  This one alone generates
> 
> total: 40 errors, 29 warnings, 1488 lines checked
> 
> many of which you would have fixed had you been aware of them.  That's
> what checkpatch is for.

Is it ok to fit another patch after this one to fixup these problems?

> >
> > ...
> >
> > +#define dbg(host, channels, args...)		 \
> > +	if (dbgmap_err & channels) 		 \
> > +		dev_err(&host->pdev->dev, args); \
> > +	else if (dbgmap_info & channels)	 \
> > +		dev_info(&host->pdev->dev, args);\
> > +	else if (dbgmap_debug & channels)	 \
> > +		dev_dbg(&host->pdev->dev, args);
> > +
> > +#define RESSIZE(ressource) (((ressource)->end - (ressource)->start)+1)
> 
> Could be written in C.  That would fix the bug wherein this macro
> evaluates its argument twice.  "resource" is misspelled.
> 
> > +static struct s3c2410_dma_client s3cmci_dma_client = {
> > +	.name		= "s3c-mci",
> > +};
> > +
> > +static void finalize_request(struct s3cmci_host *host);
> > +static void s3cmci_send_request(struct mmc_host *mmc);
> > +static void s3cmci_reset(struct s3cmci_host *host);
> > +
> > +#ifdef CONFIG_MMC_DEBUG
> > +
> > +static inline void dbg_dumpregs(struct s3cmci_host *host, char *prefix)
> 
> too large to inline.

yeah, fix that.

> > +{
> > +	u32 con, pre, cmdarg, cmdcon, cmdsta, r0, r1, r2, r3, timer, bsize;
> > +	u32 datcon, datcnt, datsta, fsta, imask;
> > +
> > +	con 	= readl(host->base + S3C2410_SDICON);
> > +	pre 	= readl(host->base + S3C2410_SDIPRE);
> > +	cmdarg 	= readl(host->base + S3C2410_SDICMDARG);
> > +	cmdcon 	= readl(host->base + S3C2410_SDICMDCON);
> > +	cmdsta 	= readl(host->base + S3C2410_SDICMDSTAT);
> > +	r0 	= readl(host->base + S3C2410_SDIRSP0);
> > +	r1 	= readl(host->base + S3C2410_SDIRSP1);
> > +	r2 	= readl(host->base + S3C2410_SDIRSP2);
> > +	r3 	= readl(host->base + S3C2410_SDIRSP3);
> > +	timer 	= readl(host->base + S3C2410_SDITIMER);
> > +	bsize 	= readl(host->base + S3C2410_SDIBSIZE);
> > +	datcon 	= readl(host->base + S3C2410_SDIDCON);
> > +	datcnt 	= readl(host->base + S3C2410_SDIDCNT);
> > +	datsta 	= readl(host->base + S3C2410_SDIDSTA);
> > +	fsta 	= readl(host->base + S3C2410_SDIFSTA);
> > +	imask   = readl(host->base + host->sdiimsk);
> > +
> > +	dbg(host, dbg_debug, "%s  CON:[%08x]  PRE:[%08x]  TMR:[%08x]\n",
> > +				prefix, con, pre, timer);
> > +
> > +	dbg(host, dbg_debug, "%s CCON:[%08x] CARG:[%08x] CSTA:[%08x]\n",
> > +				prefix, cmdcon, cmdarg, cmdsta);
> > +
> > +	dbg(host, dbg_debug, "%s DCON:[%08x] FSTA:[%08x]"
> > +			       " DSTA:[%08x] DCNT:[%08x]\n",
> > +				prefix, datcon, fsta, datsta, datcnt);
> > +
> > +	dbg(host, dbg_debug, "%s   R0:[%08x]   R1:[%08x]"
> > +			       "   R2:[%08x]   R3:[%08x]\n",
> > +				prefix, r0, r1, r2, r3);
> > +}
> > +
> >
> > ...
> >
> > +static void dbg_dumpcmd(struct s3cmci_host *host, struct mmc_command *cmd,
> > +								int fail)
> > +{
> > +	unsigned int dbglvl = fail?dbg_fail:dbg_debug;
> >
> 
> Spaces around the ? and :, please.

fixed.
 
> checkpatch misses this.
> 
> > +	if (!cmd)
> > +		return;
> > +
> > +	if (cmd->error == MMC_ERR_NONE) {
> > +		dbg(host, dbglvl, "CMD[OK] %s R0:0x%08x\n",
> > +			host->dbgmsg_cmd, cmd->resp[0]);
> > +	} else {
> > +		dbg(host, dbglvl, "CMD[ERR %i] %s Status:%s\n",
> > +			cmd->error, host->dbgmsg_cmd, host->status);
> > +	}
> > +
> > +	if (!cmd->data)
> > +		return;
> > +
> > +	if (cmd->data->error == MMC_ERR_NONE) {
> > +		dbg(host, dbglvl, "DAT[OK] %s\n", host->dbgmsg_dat);
> > +	} else {
> > +		dbg(host, dbglvl, "DAT[ERR %i] %s DCNT:0x%08x\n",
> > +			cmd->data->error, host->dbgmsg_dat,
> > +			readl(host->base + S3C2410_SDIDCNT));
> > +	}
> > +}
> > +#endif
> > +
> > +static inline u32 enable_imask(struct s3cmci_host *host, u32 imask)
> > +{
> > +	u32 newmask;
> > +
> > +	newmask = readl(host->base + host->sdiimsk);
> > +	newmask|= imask;
> > +
> > +	writel(newmask, host->base + host->sdiimsk);
> > +
> > +	return newmask;
> > +}
> > +
> > +static inline u32 disable_imask(struct s3cmci_host *host, u32 imask)
> > +{
> > +	u32 newmask;
> > +
> > +	newmask = readl(host->base + host->sdiimsk);
> > +	newmask&= ~imask;
> > +
> > +	writel(newmask, host->base + host->sdiimsk);
> > +
> > +	return newmask;
> > +}
> 
> Probably too large to inline.  A useful metric is to build the .o file
> with and without the `inline' statements and see which results in the
> smaller /bin/size output.  Smaller is usuall faster.  And it's smaller.

I'll have a look, but with the function pre-ambles and call overheads
I expect these'll stay inlines.

> > +static inline void clear_imask(struct s3cmci_host *host)
> > +{
> > +	writel(0, host->base + host->sdiimsk);
> > +}
> > +
> > +static inline int get_data_buffer(struct s3cmci_host *host,
> > +			volatile u32 *words, volatile u32 **pointer)
> > +{
> > +	struct scatterlist *sg;
> > +
> > +	if (host->pio_active == XFER_NONE)
> > +		return -EINVAL;
> > +
> > +	if ((!host->mrq) || (!host->mrq->data))
> > +		return -EINVAL;
> > +
> > +	if (host->pio_sgptr >= host->mrq->data->sg_len) {
> > +		dbg(host, dbg_debug, "no more buffers (%i/%i)\n",
> > +		      host->pio_sgptr, host->mrq->data->sg_len);
> > +		return -EBUSY;
> > +	}
> > +	sg = &host->mrq->data->sg[host->pio_sgptr];
> > +
> > +	*words	= sg->length >> 2;
> > +	*pointer= page_address(sg->page) + sg->offset;
> > +
> > +	host->pio_sgptr++;
> > +
> > +	dbg(host, dbg_sg, "new buffer (%i/%i)\n",
> > +	      host->pio_sgptr, host->mrq->data->sg_len);
> > +
> > +	return 0;
> > +}
> 
> This one has three callsites!

Hmm, I'll leave it up to the compiler whether it wants to
try and inline this.

> > +#define FIFO_FILL(host) ((readl(host->base + S3C2410_SDIFSTA) & S3C2410_SDIFSTA_COUNTMASK) >> 2)
> > +#define FIFO_FREE(host) ((63 - (readl(host->base + S3C2410_SDIFSTA) & S3C2410_SDIFSTA_COUNTMASK)) >> 2)
> 
> These didn't need to be implemented as macros.

these are now inlined.

> > +
> > +static inline void do_pio_read(struct s3cmci_host *host)
> > +{
> > +	int res;
> > +	u32 fifo;
> > +	void __iomem *from_ptr;
> > +
> > +	//write real prescaler to host, it might be set slow to fix
> > +	writel(host->prescaler, host->base + S3C2410_SDIPRE);
> > +
> > +	from_ptr = host->base + host->sdidata;
> > +
> > +	while ((fifo = FIFO_FILL(host))) {
> > +		if (!host->pio_words) {
> > +			res = get_data_buffer(host, &host->pio_words,
> > +							&host->pio_ptr);
> > +			if (res) {
> > +				host->pio_active = XFER_NONE;
> > +				host->complete_what = COMPLETION_FINALIZE;
> > +
> > +				dbg(host, dbg_pio, "pio_read(): "
> > +					"complete (no more data).\n");
> > +				return;
> > +			}
> > +
> > +			dbg(host, dbg_pio, "pio_read(): new target: [%i]@[%p]\n",
> > +			       host->pio_words, host->pio_ptr);
> > +		}
> > +
> > +		dbg(host, dbg_pio, "pio_read(): fifo:[%02i] "
> > +				   "buffer:[%03i] dcnt:[%08X]\n",
> > +				   fifo, host->pio_words,
> > +				   readl(host->base + S3C2410_SDIDCNT));
> > +
> > +		if (fifo > host->pio_words)
> > +			fifo = host->pio_words;
> > +
> > +		host->pio_words-= fifo;
> > +		host->pio_count+= fifo;
> > +
> > +		while(fifo--) {
> > +			*(host->pio_ptr++) = readl(from_ptr);
> > +		}
> > +	}
> > +
> > +	if (!host->pio_words) {
> > +		res = get_data_buffer(host, &host->pio_words, &host->pio_ptr);
> > +		if (res) {
> > +			dbg(host, dbg_pio, "pio_read(): "
> > +				"complete (no more buffers).\n");
> > +			host->pio_active = XFER_NONE;
> > +			host->complete_what = COMPLETION_FINALIZE;
> > +
> > +			return;
> > +		}
> > +	}
> > +
> > +	enable_imask(host, S3C2410_SDIIMSK_RXFIFOHALF | S3C2410_SDIIMSK_RXFIFOLAST);
> > +}
> > +
> > +static inline void do_pio_write(struct s3cmci_host *host)
> > +{
> > +	int res;
> > +	u32 fifo;
> > +
> > +	void __iomem *to_ptr;
> > +
> > +	to_ptr = host->base + host->sdidata;
> > +
> > +	while ((fifo = FIFO_FREE(host))) {
> > +		if (!host->pio_words) {
> > +			res = get_data_buffer(host, &host->pio_words,
> > +							&host->pio_ptr);
> > +			if (res) {
> > +				dbg(host, dbg_pio, "pio_write(): "
> > +					"complete (no more data).\n");
> > +				host->pio_active = XFER_NONE;
> > +
> > +				return;
> > +			}
> > +
> > +			dbg(host, dbg_pio, "pio_write(): "
> > +				"new source: [%i]@[%p]\n",
> > +				host->pio_words, host->pio_ptr);
> > +
> > +		}
> > +
> > +		if (fifo > host->pio_words)
> > +			fifo = host->pio_words;
> > +
> > +		host->pio_words-= fifo;
> > +		host->pio_count+= fifo;
> > +
> > +		while(fifo--) {
> > +			writel(*(host->pio_ptr++), to_ptr);
> > +		}
> > +	}
> > +
> > +	enable_imask(host, S3C2410_SDIIMSK_TXFIFOHALF);
> > +}
> 
> Two callsites :(  This is one bloaty driver.

un-inlined.
 
> > +static void pio_tasklet(unsigned long data)
> > +{
> > +	struct s3cmci_host *host = (struct s3cmci_host *) data;
> > +
> > +
> > +	if (host->pio_active == XFER_WRITE)
> > +		do_pio_write(host);
> > +
> > +	if (host->pio_active == XFER_READ)
> > +		do_pio_read(host);
> > +
> > +	if (host->complete_what == COMPLETION_FINALIZE) {
> > +		clear_imask(host);
> > +		if (host->pio_active != XFER_NONE) {
> > +			dbg(host, dbg_err, "unfinished %s "
> > +				"- pio_count:[%u] pio_words:[%u]\n",
> > +				(host->pio_active == XFER_READ)?"read":"write",
> > +				host->pio_count, host->pio_words);
> > +
> > +			host->mrq->data->error = MMC_ERR_DMA;
> > +		}
> > +
> > +		disable_irq(host->irq);
> > +		finalize_request(host);
> > +	}
> > +}
> 
> I see no tasklet_disable() in the driver.  Is there anything to prevent
> the tasklet from running after device close, rmmod, etc?

fixed.
 
> The disable_irq()/enable_irq() on every interrupt will be quite
> inefficient and hostile to any device which shares the interrupt.  WHy
> is it necessary?

do you mean "on every request", no the driver won't be sharing
interrupts with another block, and I would expect that it is to
stop any interrupts when there is no request present, although
I have not checked for this.

> > +/*
> > + * ISR for SDI Interface IRQ
> > + * Communication between driver and ISR works as follows:
> > + *   host->mrq 			points to current request
> > + *   host->complete_what	tells the ISR when the request is considered done
> > + *     COMPLETION_CMDSENT	  when the command was sent
> > + *     COMPLETION_RSPFIN          when a response was received
> > + *     COMPLETION_XFERFINISH	  when the data transfer is finished
> > + *     COMPLETION_XFERFINISH_RSPFIN both of the above.
> > + *   host->complete_request	is the completion-object the driver waits for
> > + *
> > + * 1) Driver sets up host->mrq and host->complete_what
> > + * 2) Driver prepares the transfer
> > + * 3) Driver enables interrupts
> > + * 4) Driver starts transfer
> > + * 5) Driver waits for host->complete_rquest
> > + * 6) ISR checks for request status (errors and success)
> > + * 6) ISR sets host->mrq->cmd->error and host->mrq->data->error
> > + * 7) ISR completes host->complete_request
> > + * 8) ISR disables interrupts
> > + * 9) Driver wakes up and takes care of the request
> > + *
> > + * Note: "->error"-fields are expected to be set to 0 before the request
> > + *       was issued by mmc.c - therefore they are only set, when an error
> > + *       contition comes up
> > + */
> > +
> > +static irqreturn_t s3cmci_irq(int irq, void *dev_id)
> > +{
> > +	struct s3cmci_host *host;
> > +	struct mmc_command *cmd;
> > +	u32 mci_csta, mci_dsta, mci_fsta, mci_dcnt, mci_imsk;
> > +	u32 mci_cclear, mci_dclear;
> > +	unsigned long iflags;
> > +
> > +	host = (struct s3cmci_host *)dev_id;
> 
> Unneeded and undesirable cast of void*.

fuxed

> > +	spin_lock_irqsave(&host->complete_lock, iflags);
> > +
> > +	mci_csta 	= readl(host->base + S3C2410_SDICMDSTAT);
> > +	mci_dsta 	= readl(host->base + S3C2410_SDIDSTA);
> > +	mci_dcnt 	= readl(host->base + S3C2410_SDIDCNT);
> > +	mci_fsta 	= readl(host->base + S3C2410_SDIFSTA);
> > +	mci_imsk	= readl(host->base + host->sdiimsk);
> >
> > ...
> >
> > +void s3cmci_dma_done_callback(struct s3c2410_dma_chan *dma_ch, void *buf_id,
> > +	int size, enum s3c2410_dma_buffresult result)
> > +{
> > +	unsigned long iflags;
> > +	u32 mci_csta, mci_dsta, mci_fsta, mci_dcnt;
> > +	struct s3cmci_host *host = (struct s3cmci_host *)buf_id;
> > +
> > +	mci_csta 	= readl(host->base + S3C2410_SDICMDSTAT);
> > +	mci_dsta 	= readl(host->base + S3C2410_SDIDSTA);
> > +	mci_fsta 	= readl(host->base + S3C2410_SDIFSTA);
> > +	mci_dcnt 	= readl(host->base + S3C2410_SDIDCNT);
> > +
> > +	if ((!host->mrq) || (!host->mrq) || (!host->mrq->data))
> > +		return;
> > +
> > +	if (!host->dmatogo)
> > +		return;
> 
> Can these things all really happen?

I've not tried finding out.

> > +	spin_lock_irqsave(&host->complete_lock, iflags);
> > +
> > +	if (result != S3C2410_RES_OK) {
> > +		dbg(host, dbg_fail, "DMA FAILED: csta=0x%08x dsta=0x%08x "
> > +			"fsta=0x%08x dcnt:0x%08x result:0x%08x toGo:%u\n",
> > +			mci_csta, mci_dsta, mci_fsta,
> > +			mci_dcnt, result, host->dmatogo);
> > +
> > +		goto fail_request;
> > +	}
> > +
> > +	host->dmatogo--;
> > +	if (host->dmatogo) {
> > +		dbg(host, dbg_dma, "DMA DONE  Size:%i DSTA:[%08x] "
> > +			"DCNT:[%08x] toGo:%u\n",
> > +			size, mci_dsta, mci_dcnt, host->dmatogo);
> > +
> > +		goto out;
> > +	}
> > +
> > +	dbg(host, dbg_dma, "DMA FINISHED Size:%i DSTA:%08x DCNT:%08x\n",
> > +		size, mci_dsta, mci_dcnt);
> > +
> > +	host->complete_what = COMPLETION_FINALIZE;
> > +
> > +out:
> > +	tasklet_schedule(&host->pio_tasklet);
> > +	spin_unlock_irqrestore(&host->complete_lock, iflags);
> > +	return;
> > +
> > +
> > +fail_request:
> > +	host->mrq->data->error = MMC_ERR_DMA;
> > +	host->complete_what = COMPLETION_FINALIZE;
> > +	writel(0, host->base + host->sdiimsk);
> > +	goto out;
> > +
> > +}
> > +
> >
> > ...
> >
> > +static int s3cmci_setup_data(struct s3cmci_host *host, struct mmc_data *data)
> > +{
> > +	u32 dcon, imsk, stoptries=3;
> > +
> > +	/* write DCON register */
> > +
> > +	if (!data) {
> > +		writel(0, host->base + S3C2410_SDIDCON);
> > +		return 0;
> > +	}
> > +
> > +	while(readl(host->base + S3C2410_SDIDSTA) &
> > +		(S3C2410_SDIDSTA_TXDATAON | S3C2410_SDIDSTA_RXDATAON)) {
> > +
> > +		dbg(host, dbg_err,
> > +			"mci_setup_data() transfer stillin progress.\n");
> > +
> > +		writel(0, host->base + S3C2410_SDIDCON);
> > +		s3cmci_reset(host);
> > +
> > +		if (0 == (stoptries--)) {
> 
> Swap 'em, please.  It's not necessary.

fixed

> > +#ifdef CONFIG_MMC_DEBUG
> > +			dbg_dumpregs(host, "DRF");
> > +#endif
> > +
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> > +	dcon  = data->blocks & S3C2410_SDIDCON_BLKNUM_MASK;
> > +
> > +	if (host->dodma) {
> > +		dcon |= S3C2410_SDIDCON_DMAEN;
> > +	}
> > +
> > +	if (host->bus_width == MMC_BUS_WIDTH_4) {
> > +		dcon |= S3C2410_SDIDCON_WIDEBUS;
> > +	}
> > +
> > +	if (!(data->flags & MMC_DATA_STREAM)) {
> > +		dcon |= S3C2410_SDIDCON_BLOCKMODE;
> > +	}
> > +
> > +	if (data->flags & MMC_DATA_WRITE) {
> > +		dcon |= S3C2410_SDIDCON_TXAFTERRESP;
> > +		dcon |= S3C2410_SDIDCON_XFER_TXSTART;
> > +	}
> > +
> > +	if (data->flags & MMC_DATA_READ) {
> > +		dcon |= S3C2410_SDIDCON_RXAFTERCMD;
> > +		dcon |= S3C2410_SDIDCON_XFER_RXSTART;
> > +	}
> > +
> >
> > ...
> >
> > +static int s3cmci_prepare_dma(struct s3cmci_host *host, struct mmc_data *data)
> > +{
> > +	int dma_len, i;
> > +
> > +	int rw = (data->flags & MMC_DATA_WRITE)?1:0;
> > +
> > +	if (rw != ((data->flags & MMC_DATA_READ)?0:1))
> > +		return -EINVAL;
> 
> That's pretty clumsy looking.
> 
> Setting both MMC_DATA_WRITE and MMC_DATA_READ would be a programming
> bug, wouldn't it?  If so, BUG would be a more appropriate response.

ok, changed.
 
> > +	s3cmci_dma_setup(host, rw?S3C2410_DMASRC_MEM:S3C2410_DMASRC_HW);
> > +	s3c2410_dma_ctrl(host->dma, S3C2410_DMAOP_FLUSH);
> > +
> > +	dma_len = dma_map_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
> > +				(rw)?DMA_TO_DEVICE:DMA_FROM_DEVICE);
> > +
> > +
> > +	if (dma_len == 0)
> > +		return -ENOMEM;
> > +
> > +	host->dma_complete = 0;
> > +	host->dmatogo = dma_len;
> > +
> > +	for (i = 0; i < dma_len; i++) {
> > +		int res;
> > +
> > +		dbg(host, dbg_dma, "enqueue %i:%u@%u\n", i,
> > +			sg_dma_address(&data->sg[i]),
> > +			sg_dma_len(&data->sg[i]));
> > +
> > +		res = s3c2410_dma_enqueue(host->dma, (void *) host,
> > +				sg_dma_address(&data->sg[i]),
> > +				sg_dma_len(&data->sg[i]));
> > +
> > +		if (res) {
> > +			s3c2410_dma_ctrl(host->dma, S3C2410_DMAOP_FLUSH);
> > +			return -EBUSY;
> > +		}
> > + 	}
> > +
> > +	s3c2410_dma_ctrl(host->dma, S3C2410_DMAOP_START);
> > +
> > +	return 0;
> > +}
> > +
> >
> > ...
> >
> > +
> > +	host->irq = platform_get_irq(pdev, 0);
> > +	if (host->irq == 0) {
> > +		dev_err(&pdev->dev, "failed to get interrupt resouce.\n");
> > +		ret = -EINVAL;
> > +		goto probe_iounmap;
> > +	}
> > +
> > +	if (request_irq(host->irq, s3cmci_irq, 0, DRIVER_NAME, host)) {
> 
> So these interrupts cannot be shared?  The driver will never be used in
> an environment where interrupt sharing is possible?

All current SoCs in the family have one interrupt for each controller,
so this is unlikely.
 
> > +		dev_err(&pdev->dev, "failed to request mci interrupt.\n");
> > +		ret = -ENOENT;
> > +		goto probe_iounmap;
> > +	}
> > +
> > +	disable_irq(host->irq);
> > +
> > +	s3c2410_gpio_cfgpin(S3C2410_GPF2, S3C2410_GPF2_EINT2);
> > +	set_irq_type(host->irq_cd, IRQT_BOTHEDGE);
> > +
> > +	if (request_irq(host->irq_cd, s3cmci_irq_cd, 0, DRIVER_NAME, host)) {
> > +		dev_err(&pdev->dev,
> > +			"failed to request card detect interrupt.\n");
> > +
> > +		ret = -ENOENT;
> > +		goto probe_free_irq;
> > +	}
> > +
> > +	if (s3c2410_dma_request(S3CMCI_DMA, &s3cmci_dma_client, NULL)) {
> > +		dev_err(&pdev->dev, "unable to get DMA channel.\n");
> > +		ret = -EBUSY;
> > +		goto probe_free_irq_cd;
> > +	}
> > +
> > +	host->clk = clk_get(&pdev->dev, "sdi");
> > +	if (IS_ERR(host->clk)) {
> > +		dev_err(&pdev->dev, "failed to find clock source.\n");
> > +		ret = PTR_ERR(host->clk);
> > +		host->clk = NULL;
> > +		goto probe_free_host;
> > +	}
> > +
> > +	if ((ret = clk_enable(host->clk))) {
> > +		dev_err(&pdev->dev, "failed to enable clock source.\n");
> > +		goto clk_free;
> > +	}
> > +
> > +	host->clk_rate = clk_get_rate(host->clk);
> > +
> > +	mmc->ops 	= &s3cmci_ops;
> > +	mmc->ocr_avail	= MMC_VDD_32_33;
> > +	mmc->caps	= MMC_CAP_4_BIT_DATA;
> > +	mmc->f_min 	= host->clk_rate / (host->clk_div * 256);
> > +	mmc->f_max 	= host->clk_rate / host->clk_div;
> > +
> > +	mmc->max_blk_count	= 4095;
> > +	mmc->max_blk_size	= 4095;
> > +	mmc->max_req_size	= 4095 * 512;
> > +	mmc->max_seg_size	= mmc->max_req_size;
> > +
> > +	mmc->max_phys_segs	= 128;
> > +	mmc->max_hw_segs	= 128;
> > +
> > +	dbg(host, dbg_debug, "probe: mode:%s mapped mci_base:%p irq:%u irq_cd:%u dma:%u.\n",
> > +		(host->is2440?"2440":""),
> > +		host->base, host->irq, host->irq_cd, host->dma);
> > +
> > +	if ((ret = mmc_add_host(mmc))) {
> > +		dev_err(&pdev->dev, "failed to add mmc host.\n");
> > +		goto free_dmabuf;
> > +	}
> > +
> > +	platform_set_drvdata(pdev, mmc);
> > +
> > +	dev_info(&pdev->dev,"initialisation done.\n");
> > +	return 0;
> > +
> > + free_dmabuf:
> > +	clk_disable(host->clk);
> > +
> > + clk_free:
> > +	clk_put(host->clk);
> > +
> > + probe_free_irq_cd:
> > + 	free_irq(host->irq_cd, host);
> > +
> > + probe_free_irq:
> > + 	free_irq(host->irq, host);
> > +
> > + probe_iounmap:
> > +	iounmap(host->base);
> > +
> > + probe_free_mem_region:
> > +	release_mem_region(host->mem->start, RESSIZE(host->mem));
> > +
> > + probe_free_host:
> > +	mmc_free_host(mmc);
> > + probe_out:
> > +	return ret;
> > +}
> > +
> >
> > ...
> >
> > +//FIXME: DMA Resource management ?!
> 
> ?
> 
> > +#define S3CMCI_DMA 0
> > +
> > +enum s3cmci_waitfor {
> > +	COMPLETION_NONE,
> > +	COMPLETION_FINALIZE,
> > +	COMPLETION_CMDSENT,
> > +	COMPLETION_RSPFIN,
> > +	COMPLETION_XFERFINISH,
> > +	COMPLETION_XFERFINISH_RSPFIN,
> > +};
> > +
> > +struct s3cmci_host {
> > +	struct platform_device	*pdev;
> > +	struct mmc_host		*mmc;
> > +	struct resource		*mem;
> > +	struct clk		*clk;
> > +	void __iomem		*base;
> > +	int			irq;
> > +	int			irq_cd;
> > +	int			dma;
> > +
> > +	unsigned long		clk_rate;
> > +	unsigned long		clk_div;
> > +	unsigned long		real_rate;
> > +	u8			prescaler;
> > +
> > +	int			is2440;
> > +	unsigned		sdiimsk;
> > +	unsigned		sdidata;
> > +	int			dodma;
> > +
> > +	volatile int		dmatogo;
> > +
> > +	struct mmc_request	*mrq;
> > +	int			cmd_is_stop;
> > +
> > +	spinlock_t		complete_lock;
> > +	volatile enum s3cmci_waitfor
> > +				complete_what;
> > +
> > +	volatile int		dma_complete;
> > +
> > +	volatile u32		pio_sgptr;
> > +	volatile u32		pio_words;
> > +	volatile u32		pio_count;
> > +	volatile u32		*pio_ptr;
> 
> volatiles.  checkpatch..
> 
> > +#define XFER_NONE 0
> > +#define XFER_READ 1
> > +#define XFER_WRITE 2
> > +	volatile u32		pio_active;
> > +
> > +	int			bus_width;
> > +
> > +	char 			dbgmsg_cmd[301];
> > +	char 			dbgmsg_dat[301];
> > +	volatile char		*status;
> > +
> > +	unsigned int		ccnt, dcnt;
> > +	struct tasklet_struct	pio_tasklet;
> > +};
> 
> Those problems were really really basic stuff.  kernel drivers 101.

Yeah, however I don't want to go about writing a new driver
for this from scratch, and having this interface supported
would add more support for an SoC series used in an number
of PDAs and other devices.

Unfortunatley the original authour isn't interested in getting
it submitted (IE, it works for the kernel he needs to use), and
other people haven't stepped up to try and get this integrated.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
