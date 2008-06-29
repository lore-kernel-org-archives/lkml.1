Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbYF2X3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbYF2X3B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 19:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYF2X2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 19:28:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:52096 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbYF2X2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 19:28:46 -0400
Subject: Re: [PATCH v2 -rt] ide: workaround buggy hardware issues with
	preemptable hardirqs
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: avorontsov@ru.mvista.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Daniel Walker <dwalker@mvista.com>
In-Reply-To: <20080628005436.GA1956@polina.dev.rtsoft.ru>
References: <20080623234037.GA6793@polina.dev.rtsoft.ru>
	 <20080623235141.GB17297@elte.hu>
	 <20080624000016.GA12547@polina.dev.rtsoft.ru>
	 <20080625123431.GA25452@polina.dev.rtsoft.ru>
	 <20080628005436.GA1956@polina.dev.rtsoft.ru>
Content-Type: text/plain
Date: Mon, 30 Jun 2008 09:26:14 +1000
Message-Id: <1214781974.20711.7.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-06-28 at 04:54 +0400, Anton Vorontsov wrote:
> IDE interrupt handler relies on the fact that, if necessary, hardirqs
> will re-trigger on ISR exit. The assumption is valid for level sensitive
> interrupts.
> 
> But some hardware (namely ULi M5228 in the ULi M1575 "Super South Brige")
> behaves in a strange way: it asserts interrupts as edge sensitive. And
> because preemptable IRQ handler disables PIC's interrupt, PIC will likely
> miss it.

Don't we replay edge IRQs that happen while soft-disabled ? Could be a
bug in your PIC code not to do so...

Ben.

> This patch fixes following issue:
> 
> ALI15X3: IDE controller (0x10b9:0x5229 rev 0xc8) at  PCI slot 0001:03:1f.0
> ALI15X3: 100% native mode on irq 18
> ide0: BM-DMA at 0x1120-0x1127, BIOS settings: hda:PIO, hdb:PIO
> ide1: BM-DMA at 0x1128-0x112f, BIOS settings: hdc:PIO, hdd:PIO
> hda: Optiarc DVD RW AD-7190A, ATAPI CD/DVD-ROM drive
> hda: UDMA/66 mode selected
> ide0 at 0x1100-0x1107,0x110a on irq 18
> ide-cd: cmd 0x5a timed out
> hda: lost interrupt
> hda: ATAPI 12X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
> Uniform CD-ROM driver Revision: 3.20
> ide-cd: cmd 0x3 timed out
> hda: lost interrupt
> ide-cd: cmd 0x3 timed out
> hda: lost interrupt
> ...
> 
> It would be great to re-configure the ULi bridge or ULi IDE controller
> to behave sanely, but no one knows how or if this is possible at all
> (no available specifications).
> 
> So.. to workaround the issue IDE interrupt handler should re-check for
> any pending IRQs. This isn't bulletproof solution, but it works and this
> is the best one we can do.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
> 
> On Wed, Jun 25, 2008 at 04:34:31PM +0400, Anton Vorontsov wrote:
> [...]
> > The bug, as I see it, in the alim15x3 (ULi M5228) hardware: for some
> > reason it does not hold IRQ line, but rises it for some short period
> > of time (while the drive itself rises and holds it correctly -- I'm
> > seeing it via oscilloscope).
> > 
> > So this scheme does not work:
> > mask_irq()
> > ...do something that will trigger IDE interrupt...
> > unmask_irq()
> > 
> > Because at the unmask_irq() time IDE IRQ is gone already, and interrupt
> > controller could not notice it (interrupts are level sensitive).
> > 
> > I did following test: disable RT + insert mask/unmask sequence in the
> > IDE IRQ handler, and I got the same behaviour as with RT enabled.
> > 
> > Also, further testing showed that this issue isn't drive-specific, i.e.
> > with a delay inserted before the unmask_irq(), the bug shows with any
> > drive I have.
> > 
> > So, in summary: I think that the patch is still correct as a hw bug
> > workaround (I'll need to correct its comments and description though).
> 
> Here is updated patch.
> 
>  drivers/ide/ide-io.c |   20 ++++++++++++++++----
>  1 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
> index 6c1b288..19d36f0 100644
> --- a/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
> @@ -1460,6 +1460,7 @@ static void unexpected_intr (int irq, ide_hwgroup_t *hwgroup)
>   
>  irqreturn_t ide_intr (int irq, void *dev_id)
>  {
> +	irqreturn_t ret = IRQ_NONE;
>  	unsigned long flags;
>  	ide_hwgroup_t *hwgroup = (ide_hwgroup_t *)dev_id;
>  	ide_hwif_t *hwif;
> @@ -1467,12 +1468,13 @@ irqreturn_t ide_intr (int irq, void *dev_id)
>  	ide_handler_t *handler;
>  	ide_startstop_t startstop;
>  
> +again:
>  	spin_lock_irqsave(&ide_lock, flags);
>  	hwif = hwgroup->hwif;
>  
>  	if (!ide_ack_intr(hwif)) {
>  		spin_unlock_irqrestore(&ide_lock, flags);
> -		return IRQ_NONE;
> +		return ret;
>  	}
>  
>  	if ((handler = hwgroup->handler) == NULL || hwgroup->polling) {
> @@ -1510,7 +1512,7 @@ irqreturn_t ide_intr (int irq, void *dev_id)
>  #endif /* CONFIG_BLK_DEV_IDEPCI */
>  		}
>  		spin_unlock_irqrestore(&ide_lock, flags);
> -		return IRQ_NONE;
> +		return ret;
>  	}
>  	drive = hwgroup->drive;
>  	if (!drive) {
> @@ -1532,7 +1534,7 @@ irqreturn_t ide_intr (int irq, void *dev_id)
>  		 * enough advance overhead that the latter isn't a problem.
>  		 */
>  		spin_unlock_irqrestore(&ide_lock, flags);
> -		return IRQ_NONE;
> +		return ret;
>  	}
>  	if (!hwgroup->busy) {
>  		hwgroup->busy = 1;	/* paranoia */
> @@ -1578,7 +1580,17 @@ irqreturn_t ide_intr (int irq, void *dev_id)
>  		}
>  	}
>  	spin_unlock_irqrestore(&ide_lock, flags);
> -	return IRQ_HANDLED;
> +	ret = IRQ_HANDLED;
> +
> +	/*
> +	 * Previous handler() may have set things up for another interrupt to
> +	 * occur soon... with hardirqs preemption we may lose it because of
> +	 * buggy hardware that asserts edge-sensitive IRQs, so try again and
> +	 * then return gracefully if no IRQs were actually pending.
> +	 */
> +	if (hardirq_preemption && startstop != ide_stopped)
> +		goto again;
> +	return ret;
>  }
>  
>  /**

