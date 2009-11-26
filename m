Return-Path: <linux-kernel-owner+w=401wt.eu-S932909AbZKZGoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909AbZKZGoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 01:44:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758548AbZKZGoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 01:44:08 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33413 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758544AbZKZGoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 01:44:07 -0500
Date: Thu, 26 Nov 2009 15:43:16 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Magnus Damm <magnus.damm@gmail.com>,
       spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: SuperH MSIOF SPI Master driver
Message-ID: <20091126064315.GA6580@linux-sh.org>
References: <20091124125531.14957.41264.sendpatchset@rxone.opensource.se> <20091125121152.4ccf03dc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091125121152.4ccf03dc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 25, 2009 at 12:11:52PM -0800, Andrew Morton wrote:
> On Tue, 24 Nov 2009 21:55:31 +0900
> Magnus Damm <magnus.damm@gmail.com> wrote:
> > +struct sh_msiof_spi_priv {
> > +	struct spi_bitbang bitbang; /* must be first for spi_bitbang.c */
> 
> Well if that's the case then spi_bitbang.c needs smacking.  What causes
> this requirement?
> 
spi_bitbang causes this requirement by being lazy with regards to
private data stashing. Both the drivers and the bitbang code use
spi_master_get_devdata() for getting their private data, which wraps
in to a dev_get_drvdata().

This needs to be reworked so that struct spi_master has its own private
data pointer which helper code like spi_bitbang can use, while freeing up
the struct device private data pointer so it can be freely used by
drivers as normal.

This is the same sort of private data through casting whimsy that the
framebuffer drivers used to employ, only fortunately that behaviour never
made it out of 2.3.x kernels -- until now!

> > +	void __iomem *mapbase;
> > +	struct clk *clk;
> > +	struct platform_device *pdev;
> > +	struct sh_msiof_spi_info *info;
> > +	struct completion done;
> > +	unsigned long flags;
> > +	int tx_fifo_size;
> > +	int rx_fifo_size;
> > +};
> > +
> >
> > ...
> >
> > +static void sh_msiof_modify_ctr_wait(struct sh_msiof_spi_priv *p,
> > +				     unsigned long clr, unsigned long set)
> > +{
> > +	unsigned long mask = clr | set;
> > +	unsigned long data;
> > +
> > +	data = sh_msiof_read(p, CTR);
> > +	data &= ~clr;
> > +	data |= set;
> > +	sh_msiof_write(p, CTR, data);
> > +
> > +	while ((sh_msiof_read(p, CTR) & mask) != set)
> > +		;
> 
> hm, confidence.  No timeout needed here?
> 
This definitely needs a timeout, nothing involving SPI inspires
confidence. A cpu_relax() to prevent the compiler from optimizing the
loop out would help, too.
