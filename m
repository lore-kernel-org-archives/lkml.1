Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbZAVSb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbZAVSb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 13:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbZAVSbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 13:31:18 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:52244 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752602AbZAVSbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 13:31:17 -0500
Date: Thu, 22 Jan 2009 21:31:15 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Pierre Ossman <drzeus-sdhci@drzeus.cx>, Ben Dooks <ben-linux@fluff.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, Xie Xiaobo <X.Xie@freescale.com>,
       Konjin Lai <Konjin.Lai@freescale.com>,
       "Joe D'Abbraccio" <Joe.D'abbraccio@freescale.com>,
       sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 02/10] sdhci: Add support for bus-specific IO memory
	accessors
Message-ID: <20090122183115.GA27961@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090122015649.GA6835@oksana.dev.rtsoft.ru> <20090122020019.GB11492@oksana.dev.rtsoft.ru> <200901221255.49724.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200901221255.49724.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 12:55:48PM +0100, Arnd Bergmann wrote:
> On Thursday 22 January 2009, Anton Vorontsov wrote:
> > +       /*
> > +        * These accessors duplicate sdhci_ops, but there are two reasons for
> > +        * this:
> > +        * 1. sdhci_ops are const, so the sdhci driver won't able to assign
> > +        *    default ops;
> 
> You could assign the pointer to a const default_sdhci_ops structure,
> which IMHO would be cleaner than copying the function pointers
> separately.

This won't work because ops also specify non-memory accessors ops
(i.e. enable_dma, set_clock, ...), so we can't just assign
default_ops ptr.

> > +        * 2. Using host->X instead of host->ops->X saves us one dereference.
> > +        *    This can be useful in PIO mode. (Though the benefit of this
> > +        *    is negligibly small).
> > +        */
> 
> I doubt that this is even measurable.

Yeah, I didn't even bother w/ measuring. ;-)

> If it was, you could still use a copy of that structure, like
> 
> struct sdhci_host {
> 	...
> 	struct sdhci_ops ops; /* not struct sdhci_ops *ops */
> 	...
> };
> 
> and do an assignment of the structure, like
> 
> static void assign_ops(struct sdhci_host *host, struct sdhci_ops *ops)
> {
> 	host->ops = *ops;
> }

This will work. Pierre, what do you think? That way drivers
will call this routine instead of "host->ops = driver_ops_ptr".

The other option would be to remove const from the ops. Or implement
another non-const ops struct (struct sdhci_io_ops?).

In any way, the type-checked variant will be even longer to type:

host->mem_ops->writel(val, host->ioaddr + reg);
host->ops.writel(val, host->ioaddr + reg);
host->writel(val, host->ioaddr + reg);


Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
