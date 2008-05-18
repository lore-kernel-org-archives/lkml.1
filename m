Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbYERMFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbYERMFh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 08:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYERMFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 08:05:20 -0400
Received: from mout1.freenet.de ([195.4.92.91]:55292 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758094AbYERMFQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 08:05:16 -0400
From: Sascha Sommer <saschasommer@freenet.de>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: [PATCH] MMC/SD host driver for Ricoh Bay1Controllers
Date: Sun, 18 May 2008 14:05:01 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       sdricohcs-devel@lists.sourceforge.net
References: <200804271617.53438.saschasommer@freenet.de> <200805111050.55662.saschasommer@freenet.de> <20080512195435.4d2d3b58@mjolnir.drzeus.cx>
In-Reply-To: <20080512195435.4d2d3b58@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <200805181405.05774.saschasommer@freenet.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

thanks for the review. See my comments below.

On Montag, 12. Mai 2008, Pierre Ossman wrote:
> Big thanks to Andrew for helping out with the basic review here. :)
>
> On Sun, 11 May 2008 10:50:55 +0200
>
> Sascha Sommer <saschasommer@freenet.de> wrote:
> > On Freitag, 2. Mai 2008, Andrew Morton wrote:
> > > Will this code work correctly on big-endian machines?
> >
> > Most likely not and there might be other big-endian related problems in
> > the driver. I don't know of a case where this hardware can be found on
> > big endian.
>
> That's not a really good reason to just ignore the problem though.
> Endian safe code is generally more bug free and more easily understood
> because it doesn't use arch specific shortcuts. I won't NAK the patch
> because of this, but I do prefer endian safe code even if there is no
> hardware built that needs it right now. It's always good to practice
> writing such code anyway. :)
>

I will fix that then.

> > > hm.  I don't really know how the kernel gets down into here, but I
> > > wonder if this driver (and, I bet, lots of similar ones) should be
> > > doing flush_dcache_page() after modifying the page.  If this page can
> > > be file pagecache or user memory then "yes".  Unless it's done
> > > elsewhere for us.
>
> Andrew, could you elaborate a bit on this (couldn't find anything in
> the docs)? AFAIK dcache is a VFS thing, so I don't see how low level
> devices should have to deal with it. The VFS should be well aware of
> what pages have been submitted for data transfers.
>
> > > Is the dependency on YENTA correct?
> >
> > Yes. At least noone who wants to enable this driver will forget the yenta
> > driver then.
>
> But is there a technical dependency? We shouldn't be introducing
> artificial dependencies just because of how Ricoh is currently bundling
> things.
>

The driver should compile without it and it should not crash without it. 
However it will never get activated without a driver for the yenta bridge.


> The actual review:
> > +#include <linux/mmc/mmc.h>
> > +#include <linux/mmc/sd.h>
> > +#include <linux/mmc/sdio.h>
>
> Including these three in a host driver is always an error. The driver
> should be operating at a lower level than the stuff these describe.
>

That is the point where I'm not sure about. While I agree that the driver 
theoretically shouldn't care about the commands it currently cannot handle 
all commands that read or write a data block. In this context the commands 
itself are the problem and not some integer values.

> > +	/* wait for command completion */
> > +	if (opcode) {
> > +		for (loop = 0; loop < CMD_TIMEOUT; loop++) {
> > +			status = sdricoh_readl(host, R21C_STATUS);
> > +			sdricoh_writel(host, R2E4_STATUS_RESP, status);
> > +			if (status  & STATUS_CMD_FINISHED)
> > +				break;
> > +		}
>
> You might want to have a look at making this a bit more compliant with
> the spec. A MMC command can take 64 clock cycles plus the transfer time
> for the command and response. So you need to figure out how long a
> readl takes (as that is your source of delays) and adjust CMD_TIMEOUT
> depending on current clock frequency. You can submit a patch for this
> later though.
>

I will try to fix that with a later patch.

> > +	dev_dbg(dev, "mmc_cmd opcode=%i arg=0x%x => %i (queries=%i)\n",
> > +	    opcode, arg, result, loop);
>
> The core should be giving you the same output.
>
> > +	if (result == 0) {
> > +		/* EXT_CSD are filtered so this should be save */
> > +		if (opcode == SD_SEND_IF_COND) {
> > +			if (host->mode != MODE_SDHC) {
> > +				dev_info(dev, "switching to SDHC mode\n");
> > +				host->mode = MODE_SDHC;
> > +			}
> > +		}
> > +
> > +		/* switch to SD mode if APP_CMDs are supported */
> > +		if (opcode == MMC_APP_CMD) {
> > +			if (host->mode == MODE_MMC) {
> > +				dev_info(dev, "switching to SD mode\n");
> > +				host->mode = MODE_SD;
> > +			}
> > +		}
> > +	}
>
> What's the point of this? Looking at the rest of the code, it seems to
> be mostly that you haven't properly mapped up the 4-bit bus control
> (which is used on MMC cards as well these days).
>

Hm it seems like you are right here. I was confused by the opcode |= 64 and 
the fact that the scr command never really worked so linux would never 
activate the 4-bit bus mode. Windows does this unconditionally for SD cards.
It also looks like all ACMDS have this |= 64

> > +static int sdricoh_blockio(struct sdricoh_host *host, int read,
> > +				unsigned int *buf)
> > +{
> > +	int i;
> > +	/* wait until the data is available */
> > +	if (read) {
> > +		if (sdricoh_query_status(host, STATUS_READY_TO_READ,
> > +						TRANSFER_TIMEOUT))
> > +			return 0;
> > +		sdricoh_writel(host, R21C_STATUS, 0x18);
> > +		/* read data */
> > +		for (i = 0; i < 512 / 4; i++)
> > +			buf[i] = sdricoh_readl(host, R230_DATA);
>
> Is the controller only capable of 512 byte transfers? I seriously hope
> not, but if that's the case then you still need to make sure you fail
> transfers that aren't a multiple of 512.
>

I think I found the register now where one can adjust the transfer size but 
this requires a lot more testing.

> > +	/* wait until the tranfer is finished */
> > +	for (i = 0; i < BUSY_TIMEOUT; i++) {
> > +		status = sdricoh_readl(host, R21C_STATUS);
> > +		sdricoh_writel(host, R2E4_STATUS_RESP, status);
> > +		if (!(status & STATUS_BUSY))
> > +			break;
> > +	}
>
> The card can be busy for minutes with some operations, so this is
> probably wrong.
>

What do you propose instead? Moving this code into a seperate thread?


> > +	dev_dbg(dev, "=============================\n");
> > +	dev_dbg(dev, "sdricoh_request opcode=%i\n", cmd->opcode);
>
> More redundant debug output.
>
> > +	/* we cannot handle all commands that require a block transfer
> > +	   therefore do some ugly special handling here
> > +	*/
>
> What kind of analysis have you done here? It's likely that the
> controller just needs some special handling, as there is so far only a
> single known controller (wbsd) that looks at opcodes.
>

See below.

> > +	if (cmd->data) {
> > +		switch (cmd->opcode) {
> > +		/* working commands */
> > +		case MMC_READ_SINGLE_BLOCK:
> > +		case MMC_READ_MULTIPLE_BLOCK:
> > +		case MMC_WRITE_BLOCK:
> > +		case MMC_WRITE_MULTIPLE_BLOCK:
> > +			break;
>
> In any case, you should do what the hardware does and put a list of the
> actual integers the hardware looks at. Using the defines implies that
> it is those specific opcodes that are a problem (which likely isn't the
> case as opcodes are context dependent).

>From my point of view this is such an unlikely case. From what I currently 
know all opcodes that are required to read a data block and that are not 
listed above very likely do not work. When I for example let the EXT_CSD 
command through this filter the command itself will succeed but the bit that 
notifies us if the data is available for read does not get set. The status 
doesn't change. If I leave out the checks and just read from the data 
register only zeros are returned. 
Note that the windows driver does not use any of these commands.
Do you know of a case where a broken card caused such a behaviour?
Unfortunatelly I do not have another card reader or other MMC cards to test.

>
> > +		case SD_APP_SEND_SCR: /* required for SDHC */
> > +			cmd->error = sdricoh_mmc_cmd(host, cmd->opcode,
> > +							cmd->arg);
> > +			mmc_request_done(mmc, mrq);
> > +			return;
>
> What are you doing here?
>

Well that is one of these extra special handling hacks. While leaving out the 
SEND_SCR command for my SD card makes no difference a user reported that his 
SDHC card won't work without it. In any case the MMC layer requires that this 
command succeeds but reading the data block doesn't work. When I do a |= 64
like for the BUS_WIDTH command I can read something but I'm not sure yet if 
this is the SCR or some random values. When I need to do the |= 64 I also 
would need to know for every command if this they are an ACMD or not. I think 
it would be nice if the mmc layer could give a hint here.


> > +
> > +	/* read/write commands seem to require this */
> > +	if (data) {
> > +		cmd->error = sdricoh_busy(host);
> > +		if (cmd->error)
>
> mmc_block should make sure this isn't a problem, so if you need this
> then we have a bug somewhere. Still, you should be waiting for the busy
> signal to go away at the end of commands, not compensating for it in
> the subsequent one.
>

This is some cruft from the early days.

> > +			}
> > +			dev_dbg(dev, "resp[0]=0x%x\n", cmd->resp[0]);
> > +			dev_dbg(dev, "resp[1]=0x%x\n", cmd->resp[1]);
> > +			dev_dbg(dev, "resp[2]=0x%x\n", cmd->resp[2]);
> > +			dev_dbg(dev, "resp[2]=0x%x\n", cmd->resp[3]);
> > +		} else {
> > +			cmd->resp[0] = sdricoh_readl(host, R20C_RESP);
> > +			dev_dbg(dev, "resp[0]=0x%x\n", cmd->resp[0]);
> > +		}
>
> More redundant output. There's a few others, but you get the picture...
>

What would you say if I want to keep them ;)? For testing and debugging I find 
it a lot easier to just play with some local debug statements instead of 
checking back with the mmc framework when what values gets printed etc.

> > +	/* yet another workaround */
> > +	/* without the extra command SD cards do not work at all */
> > +	if (cmd->opcode == MMC_SELECT_CARD) {
> > +		if (host->mode != MODE_MMC) {
> > +			sdricoh_mmc_cmd(host, MMC_APP_CMD, cmd->arg);
> > +			sdricoh_mmc_cmd(host, 0x46, 0x02);
> > +		} else {
> > +			sdricoh_writel(host, R228_POWER, 0xc0e0);
> > +			sdricoh_writel(host, R224_MODE, 0x2000301);
> > +		}
> > +	}
> > +
>
> This is probably caused by the fact that you're messing with the SCR
> earlier. You're sending a faked ACMD6 (SET_BUS_WIDTH) to the card.
>

I think this can be avoided now.

> > +			buf = kmap(page) + data->sg->offset + (512 * i);
>
> You cannot just assume that the block size is 512 bytes.
>
> > +MODULE_PARM_DESC(switchlocked, "Switch the cards locked status."
> > +		"Use this when unlocked cards are shown readonly (default 0)");
>
> This doesn't seem to be used anywhere in the code.
>

It is. See sdricoh_get_ro(). There also seem to be different versions of the 
window driver for different notebooks that compensate for this behaviour...

Regards

Sascha

