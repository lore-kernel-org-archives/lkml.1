Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbYEYKrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbYEYKrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbYEYKq7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:46:59 -0400
Received: from server.drzeus.cx ([85.8.24.28]:55099 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752210AbYEYKq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:46:58 -0400
Date: Sun, 25 May 2008 12:46:01 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Sascha Sommer <saschasommer@freenet.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       sdricohcs-devel@lists.sourceforge.net
Subject: Re: [PATCH] MMC/SD host driver for Ricoh Bay1Controllers
Message-ID: <20080525124601.4d8d48cc@mjolnir.drzeus.cx>
In-Reply-To: <200805181405.05774.saschasommer@freenet.de>
References: <200804271617.53438.saschasommer@freenet.de>
	<200805111050.55662.saschasommer@freenet.de>
	<20080512195435.4d2d3b58@mjolnir.drzeus.cx>
	<200805181405.05774.saschasommer@freenet.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 May 2008 14:05:01 +0200
Sascha Sommer <saschasommer@freenet.de> wrote:

> 
> The driver should compile without it and it should not crash without it. 
> However it will never get activated without a driver for the yenta bridge.
> 

But does it have to be a yenta bridge? Would not the driver work fine
if Ricoh added it to something with another cardbus interface?

> 
> > The actual review:
> > > +#include <linux/mmc/mmc.h>
> > > +#include <linux/mmc/sd.h>
> > > +#include <linux/mmc/sdio.h>
> >
> > Including these three in a host driver is always an error. The driver
> > should be operating at a lower level than the stuff these describe.
> >
> 
> That is the point where I'm not sure about. While I agree that the driver 
> theoretically shouldn't care about the commands it currently cannot handle 
> all commands that read or write a data block. In this context the commands 
> itself are the problem and not some integer values.
> 

That isn't really possible as the hardware would have to be extremely
complex to figure out which command is being issued (it would have to
emulate the card state machine for every possible card type).

More realistically, the hardware looks at one of two things; the opcode
integer (rare), or some property of the command (e.g. "long reply" or
"busy signal"). Neither require the above headers.

> >
> > What's the point of this? Looking at the rest of the code, it seems to
> > be mostly that you haven't properly mapped up the 4-bit bus control
> > (which is used on MMC cards as well these days).
> >
> 
> Hm it seems like you are right here. I was confused by the opcode |= 64 and 
> the fact that the scr command never really worked so linux would never 
> activate the 4-bit bus mode. Windows does this unconditionally for SD cards.
> It also looks like all ACMDS have this |= 64
> 

Windows drivers tend to make lots and lots of assumptions, which makes
them a bit annoying to trace. :/

> >
> > Is the controller only capable of 512 byte transfers? I seriously hope
> > not, but if that's the case then you still need to make sure you fail
> > transfers that aren't a multiple of 512.
> >
> 
> I think I found the register now where one can adjust the transfer size but 
> this requires a lot more testing.
> 

This can also be added later if you like. Just as long as you add some
safe guards to make sure it doesn't foul up the system on other sizes.

> > > +	/* wait until the tranfer is finished */
> > > +	for (i = 0; i < BUSY_TIMEOUT; i++) {
> > > +		status = sdricoh_readl(host, R21C_STATUS);
> > > +		sdricoh_writel(host, R2E4_STATUS_RESP, status);
> > > +		if (!(status & STATUS_BUSY))
> > > +			break;
> > > +	}
> >
> > The card can be busy for minutes with some operations, so this is
> > probably wrong.
> >
> 
> What do you propose instead? Moving this code into a seperate thread?
> 

I didn't really check where this was called, but if you have process
context then you could just sleep. Or have a workqueue that you keep
rescheduling.

For now, you can just return success instead of timeout (many other
drivers forget to wait for busy) and make a note to fix this later. The
upper layers are forgiving about leaving the card in a busy state.

(It is a bug to do so though, so it should be fixed eventually)

> > > +	if (cmd->data) {
> > > +		switch (cmd->opcode) {
> > > +		/* working commands */
> > > +		case MMC_READ_SINGLE_BLOCK:
> > > +		case MMC_READ_MULTIPLE_BLOCK:
> > > +		case MMC_WRITE_BLOCK:
> > > +		case MMC_WRITE_MULTIPLE_BLOCK:
> > > +			break;
> >
> > In any case, you should do what the hardware does and put a list of the
> > actual integers the hardware looks at. Using the defines implies that
> > it is those specific opcodes that are a problem (which likely isn't the
> > case as opcodes are context dependent).
> 
> From my point of view this is such an unlikely case. From what I currently 
> know all opcodes that are required to read a data block and that are not 
> listed above very likely do not work. When I for example let the EXT_CSD 
> command through this filter the command itself will succeed but the bit that 
> notifies us if the data is available for read does not get set. The status 
> doesn't change. If I leave out the checks and just read from the data 
> register only zeros are returned. 

My [somewhat unclear] point is that the problem is not with the
commands themselves, but with some property specific to the failing
commands. So you need to compare the details of successful commands
with failing ones and figure out which of the differences is causing
the problem. Then you start coding logic around that property, not the
command.

> Note that the windows driver does not use any of these commands.

I guess it doesn't properly support MMC in that case. Not that unusual.

> Do you know of a case where a broken card caused such a behaviour?

Not that I can remember, no.

> > > +		case SD_APP_SEND_SCR: /* required for SDHC */
> > > +			cmd->error = sdricoh_mmc_cmd(host, cmd->opcode,
> > > +							cmd->arg);
> > > +			mmc_request_done(mmc, mrq);
> > > +			return;
> >
> > What are you doing here?
> >
> 
> Well that is one of these extra special handling hacks. While leaving out the 
> SEND_SCR command for my SD card makes no difference a user reported that his 
> SDHC card won't work without it. In any case the MMC layer requires that this 
> command succeeds but reading the data block doesn't work. When I do a |= 64
> like for the BUS_WIDTH command I can read something but I'm not sure yet if 
> this is the SCR or some random values. When I need to do the |= 64 I also 
> would need to know for every command if this they are an ACMD or not. I think 
> it would be nice if the mmc layer could give a hint here.
> 

There is no difference between a ACMD and a CMD from a hardware point
of view, so the core isn't exporting that information. In other words,
that can't be the problem.

The SCR is read while the card is still in 1-bit mode, which is the
most likely source of problems. I suggest looking at what the Windows
driver does for MMC cards (who were 1-bit only until 4.0).

> >
> > More redundant output. There's a few others, but you get the picture...
> >
> 
> What would you say if I want to keep them ;)? For testing and debugging I find 
> it a lot easier to just play with some local debug statements instead of 
> checking back with the mmc framework when what values gets printed etc.
> 

I won't NAK it, if that's what you're asking. But you should really
consider making the most of the core stuff. Your debug statements will
be unfamiliar to other mmc developers, so people will not be able to
help you out as easily when you (or your users) post dumps.

> > > +MODULE_PARM_DESC(switchlocked, "Switch the cards locked status."
> > > +		"Use this when unlocked cards are shown readonly (default 0)");
> >
> > This doesn't seem to be used anywhere in the code.
> >
> 
> It is. See sdricoh_get_ro(). There also seem to be different versions of the 
> window driver for different notebooks that compensate for this behaviour...
> 

Ah. I somehow missed that. Never mind then.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
