Return-Path: <linux-kernel-owner+w=401wt.eu-S1752411AbZIUG27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbZIUG27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 02:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbZIUG25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 02:28:57 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:33486 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbZIUG24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 02:28:56 -0400
X-IronPort-AV: E=Sophos;i="4.44,423,1249272000"; 
   d="scan'208";a="6610464"
Subject: Re: [PATCH 1/2] spi: new SPI bus lock/unlock functions
From: Li Yi <yi.li@analog.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mike Frysinger <vapier@gentoo.org>,
       spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       cooloney@kernel.org
In-Reply-To: <20090918142911.2d0c4408.akpm@linux-foundation.org>
References: <1253224997-7422-1-git-send-email-vapier@gentoo.org>
	 <20090918142911.2d0c4408.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 14:33:00 +0800
Message-ID: <1253514780.3925.36.camel@adam-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Sep 2009 06:28:55.0700 (UTC) FILETIME=[CB74BD40:01CA3A84]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 14:29 -0700, Andrew Morton wrote:
> On Thu, 17 Sep 2009 18:03:16 -0400
> Mike Frysinger <vapier@gentoo.org> wrote:
> 
> > From: Yi Li <yi.li@analog.com>
> > 
> > For some MMC cards over SPI bus, it needs to lock the SPI bus for its own
> > use.  The SPI transfer must not be interrupted by other SPI devices that
> > share the SPI bus with SPI MMC card.
> > 
> > This patch introduces 2 APIs for SPI bus locking operation.
> > 
> > Signed-off-by: Yi Li <yi.li@analog.com>
> > Signed-off-by: Bryan Wu <cooloney@kernel.org>
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> > ---
> > Andrew: we've posted these in the past with no response.  could you pick
> >         them up please ?
> > 
> >  drivers/spi/spi.c       |   48 +++++++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/spi/spi.h |    7 ++++++
> >  2 files changed, 55 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> > index 70845cc..b82b8ad 100644
> > --- a/drivers/spi/spi.c
> > +++ b/drivers/spi/spi.c
> > @@ -653,6 +653,54 @@ static void spi_complete(void *arg)
> >  }
> >  
> >  /**
> > + * spi_lock_bus - lock SPI bus for exclusive access
> > + * @spi: device which want to lock the bus
> > + * Context: any
> > + *
> > + * Once the caller owns exclusive access to the SPI bus,
> > + * only messages for this device will be transferred.
> > + * Messages for other devices are queued but not transferred until
> > + * the bus owner unlock the bus.
> > + *
> > + * The caller may call spi_lock_bus() before spi_sync() or spi_async().
> > + * So this call may be used in irq and other contexts which can't sleep,
> > + * as well as from task contexts which can sleep.
> 
> Hence spi_lock_bus() basically has to use a spinning lock?
> 
> So code which has called spi_lock_bus() cannot sleep until it calls
> spi_unlock_bus()?
> 
> That's worth mentioning in the description.
> 
Code called spi_lock_bus() _can_ sleep. This is mentioned in the
comments.

> > + * It returns zero on success, else a negative error code.
> > + */
> > +int spi_lock_bus(struct spi_device *spi)
> > +{
> > +	if (spi->master->lock_bus)
> > +		return spi->master->lock_bus(spi);
> > +	else
> > +		return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(spi_lock_bus);
> > +
> > +/**
> > + * spi_unlock_bus - unlock SPI bus
> > + * @spi: device which want to unlock the bus
> > + * Context: any
> > + *
> > + * The caller has called spi_lock_bus() to lock the bus. It calls
> > + * spi_unlock_bus() to release the bus so messages for other devices
> > + * can be transferred.
> > + *
> > + * If the caller did not call spi_lock_bus() before, spi_unlock_bus()
> > + * should have no effect.
> 
> That's crazy.
> 
> Calling spi_unlock_bus() without having earlier called spi_lock_bus()
> is a bug, and the kernel's response should be to go BUG(), not to
> silently ignore the bug.  Especially as the implementation will need to
> add extra code to silently ignore the bug!
> 
I will change the patch to fix this. Thanks.

> Perhaps the comment wasn't well thought-out.  I cannot tell because I
> cannot see any implementations of ->lock_bus() anywhere.
> 
The implementation for blackfin spi master is in
drivers/spi/spi_bfin5xx.c:
http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=commitdiff;h=cc54fa8ed63e11a000031bc650d41d57b441803d

As you mentioned, if a spi device calls spi_unlock_bus() without calling
spi_lock_bus() before, it should be returned an error. This will be
fixed in next version of the patch.

-Yi









