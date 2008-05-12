Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbYELRzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbYELRzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 13:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753956AbYELRy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 13:54:57 -0400
Received: from server.drzeus.cx ([85.8.24.28]:44093 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753646AbYELRyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 13:54:55 -0400
Date: Mon, 12 May 2008 19:54:35 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Sascha Sommer <saschasommer@freenet.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       sdricohcs-devel@lists.sourceforge.net
Subject: Re: [PATCH] MMC/SD host driver for Ricoh Bay1Controllers
Message-ID: <20080512195435.4d2d3b58@mjolnir.drzeus.cx>
In-Reply-To: <200805111050.55662.saschasommer@freenet.de>
References: <200804271617.53438.saschasommer@freenet.de>
	<20080501163940.b49f9c4f.akpm@linux-foundation.org>
	<200805111050.55662.saschasommer@freenet.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Big thanks to Andrew for helping out with the basic review here. :)

On Sun, 11 May 2008 10:50:55 +0200
Sascha Sommer <saschasommer@freenet.de> wrote:

> On Freitag, 2. Mai 2008, Andrew Morton wrote:
> >
> > Will this code work correctly on big-endian machines?
> >
> 
> Most likely not and there might be other big-endian related problems in the 
> driver. I don't know of a case where this hardware can be found on big 
> endian.
> 

That's not a really good reason to just ignore the problem though.
Endian safe code is generally more bug free and more easily understood
because it doesn't use arch specific shortcuts. I won't NAK the patch
because of this, but I do prefer endian safe code even if there is no
hardware built that needs it right now. It's always good to practice
writing such code anyway. :)

> >
> > hm.  I don't really know how the kernel gets down into here, but I wonder
> > if this driver (and, I bet, lots of similar ones) should be doing
> > flush_dcache_page() after modifying the page.  If this page can be file
> > pagecache or user memory then "yes".  Unless it's done elsewhere for us.
> >

Andrew, could you elaborate a bit on this (couldn't find anything in
the docs)? AFAIK dcache is a VFS thing, so I don't see how low level
devices should have to deal with it. The VFS should be well aware of
what pages have been submitted for data transfers.

> >
> > Is the dependency on YENTA correct?
> >
> 
> Yes. At least noone who wants to enable this driver will forget the yenta 
> driver then.
> 

But is there a technical dependency? We shouldn't be introducing
artificial dependencies just because of how Ricoh is currently bundling
things.


The actual review:

> +#include <linux/mmc/mmc.h>
> +#include <linux/mmc/sd.h>
> +#include <linux/mmc/sdio.h>

Including these three in a host driver is always an error. The driver
should be operating at a lower level than the stuff these describe.

> +	/* wait for command completion */
> +	if (opcode) {
> +		for (loop = 0; loop < CMD_TIMEOUT; loop++) {
> +			status = sdricoh_readl(host, R21C_STATUS);
> +			sdricoh_writel(host, R2E4_STATUS_RESP, status);
> +			if (status  & STATUS_CMD_FINISHED)
> +				break;
> +		}

You might want to have a look at making this a bit more compliant with
the spec. A MMC command can take 64 clock cycles plus the transfer time
for the command and response. So you need to figure out how long a
readl takes (as that is your source of delays) and adjust CMD_TIMEOUT
depending on current clock frequency. You can submit a patch for this
later though.

> +	dev_dbg(dev, "mmc_cmd opcode=%i arg=0x%x => %i (queries=%i)\n",
> +	    opcode, arg, result, loop);

The core should be giving you the same output.

> +	if (result == 0) {
> +		/* EXT_CSD are filtered so this should be save */
> +		if (opcode == SD_SEND_IF_COND) {
> +			if (host->mode != MODE_SDHC) {
> +				dev_info(dev, "switching to SDHC mode\n");
> +				host->mode = MODE_SDHC;
> +			}
> +		}
> +
> +		/* switch to SD mode if APP_CMDs are supported */
> +		if (opcode == MMC_APP_CMD) {
> +			if (host->mode == MODE_MMC) {
> +				dev_info(dev, "switching to SD mode\n");
> +				host->mode = MODE_SD;
> +			}
> +		}
> +	}

What's the point of this? Looking at the rest of the code, it seems to
be mostly that you haven't properly mapped up the 4-bit bus control
(which is used on MMC cards as well these days).

> +static int sdricoh_blockio(struct sdricoh_host *host, int read,
> +				unsigned int *buf)
> +{
> +	int i;
> +	/* wait until the data is available */
> +	if (read) {
> +		if (sdricoh_query_status(host, STATUS_READY_TO_READ,
> +						TRANSFER_TIMEOUT))
> +			return 0;
> +		sdricoh_writel(host, R21C_STATUS, 0x18);
> +		/* read data */
> +		for (i = 0; i < 512 / 4; i++)
> +			buf[i] = sdricoh_readl(host, R230_DATA);

Is the controller only capable of 512 byte transfers? I seriously hope
not, but if that's the case then you still need to make sure you fail
transfers that aren't a multiple of 512.

> +	/* wait until the tranfer is finished */
> +	for (i = 0; i < BUSY_TIMEOUT; i++) {
> +		status = sdricoh_readl(host, R21C_STATUS);
> +		sdricoh_writel(host, R2E4_STATUS_RESP, status);
> +		if (!(status & STATUS_BUSY))
> +			break;
> +	}

The card can be busy for minutes with some operations, so this is
probably wrong.

> +	dev_dbg(dev, "=============================\n");
> +	dev_dbg(dev, "sdricoh_request opcode=%i\n", cmd->opcode);

More redundant debug output.

> +	/* we cannot handle all commands that require a block transfer
> +	   therefore do some ugly special handling here
> +	*/

What kind of analysis have you done here? It's likely that the
controller just needs some special handling, as there is so far only a
single known controller (wbsd) that looks at opcodes.

> +	if (cmd->data) {
> +		switch (cmd->opcode) {
> +		/* working commands */
> +		case MMC_READ_SINGLE_BLOCK:
> +		case MMC_READ_MULTIPLE_BLOCK:
> +		case MMC_WRITE_BLOCK:
> +		case MMC_WRITE_MULTIPLE_BLOCK:
> +			break;

In any case, you should do what the hardware does and put a list of the
actual integers the hardware looks at. Using the defines implies that
it is those specific opcodes that are a problem (which likely isn't the
case as opcodes are context dependent).

> +		case SD_APP_SEND_SCR: /* required for SDHC */
> +			cmd->error = sdricoh_mmc_cmd(host, cmd->opcode,
> +							cmd->arg);
> +			mmc_request_done(mmc, mrq);
> +			return;

What are you doing here?

> +
> +	/* read/write commands seem to require this */
> +	if (data) {
> +		cmd->error = sdricoh_busy(host);
> +		if (cmd->error)

mmc_block should make sure this isn't a problem, so if you need this
then we have a bug somewhere. Still, you should be waiting for the busy
signal to go away at the end of commands, not compensating for it in
the subsequent one.

> +			}
> +			dev_dbg(dev, "resp[0]=0x%x\n", cmd->resp[0]);
> +			dev_dbg(dev, "resp[1]=0x%x\n", cmd->resp[1]);
> +			dev_dbg(dev, "resp[2]=0x%x\n", cmd->resp[2]);
> +			dev_dbg(dev, "resp[2]=0x%x\n", cmd->resp[3]);
> +		} else {
> +			cmd->resp[0] = sdricoh_readl(host, R20C_RESP);
> +			dev_dbg(dev, "resp[0]=0x%x\n", cmd->resp[0]);
> +		}

More redundant output. There's a few others, but you get the picture...

> +	/* yet another workaround */
> +	/* without the extra command SD cards do not work at all */
> +	if (cmd->opcode == MMC_SELECT_CARD) {
> +		if (host->mode != MODE_MMC) {
> +			sdricoh_mmc_cmd(host, MMC_APP_CMD, cmd->arg);
> +			sdricoh_mmc_cmd(host, 0x46, 0x02);
> +		} else {
> +			sdricoh_writel(host, R228_POWER, 0xc0e0);
> +			sdricoh_writel(host, R224_MODE, 0x2000301);
> +		}
> +	}
> +

This is probably caused by the fact that you're messing with the SCR
earlier. You're sending a faked ACMD6 (SET_BUS_WIDTH) to the card.

> +			buf = kmap(page) + data->sg->offset + (512 * i);

You cannot just assume that the block size is 512 bytes.

> +MODULE_PARM_DESC(switchlocked, "Switch the cards locked status."
> +		"Use this when unlocked cards are shown readonly (default 0)");

This doesn't seem to be used anywhere in the code.

You've done a great job figuring out how this controller works, but
there is still a few more steps that need to be taken. The opcode
specific workarounds need to go, so a bit more testing and probing is
necessary. For example bit 0x40 of the mode register looks like a prime
candidate for bus width control.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
