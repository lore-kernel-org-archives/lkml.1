Return-Path: <linux-kernel-owner+w=401wt.eu-S1756590AbZJBO1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756590AbZJBO1e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 10:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbZJBO1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 10:27:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60722 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904AbZJBO1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 10:27:33 -0400
Date: Fri, 2 Oct 2009 15:27:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Mike Frysinger <vapier@gentoo.org>,
       tglx@linutronix.de, uclinux-dist-devel@blackfin.uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Uclinux-dist-devel] [PATCH v2] mfd: ADP5520 Multifunction
	LCDBacklight and Keypad Input Device Driver
Message-ID: <20091002142725.GC11133@sirena.org.uk>
References: <8A42379416420646B9BFAC9682273B6D0E33AC35@limkexm3.ad.analog.com> <8A42379416420646B9BFAC9682273B6D0E33B1AA@limkexm3.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A42379416420646B9BFAC9682273B6D0E33B1AA@limkexm3.ad.analog.com>
X-Cookie: Zeus gave Leda the bird.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 02, 2009 at 02:48:27PM +0100, Hennerich, Michael wrote:

> Well the threaded irq handlers are no option here, since we use a Level
> Sensitive Interrupt. 
> The work queue here is to schedule the main irq handler outside hardirq
> context.
> I2C can't we invoked form none sleepy context, so we can't clear the
> interrupt. 
> This will cause that we execute the hardirq over and over again,
> preventing the irq thread to be run.

> The threaded irqs with its current implementation also doesn't allow me
> to disable the irq in the hardirq handler.

This should all work perfectly fine.  If you don't supply a hard IRQ
handler then the genirq infrastructure will disable the IRQ and schedule
the threaded handler, reenabling the IRQ when the threaded handler
finishes.  The threaded handler runs in a non-atomic context so it can
happily access I2C devices.

> There have been some discussions about this on lkml recently.
> Until there is a way to workaround this issue (handle_level_oneshot_irq,
> etc.),
> I like to stick with: 

> >>> +	disable_irq_nosync(irq);
> >>> +	schedule_work(&chip->irq_work);

This is essentially what a threaded IRQ handler does with current
mainline.  There were issues in 2.6.31 but I believe all Thomas' fixes
have been merged now.
