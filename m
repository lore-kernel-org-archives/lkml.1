Return-Path: <linux-kernel-owner+w=401wt.eu-S1761302AbYEPWta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761302AbYEPWta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 18:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594AbYEPWtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 18:49:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:53727 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516AbYEPWtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 18:49:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=YBhxx/FnmX9KYcvyltyQgakTGjrWnFXQRav2hSWz8tM6Q3rMovtumsgDVZrpy6E3Khg8NNEIj2awn72MmnRZZ2+8ltIDnxnWmFfIEqpoc44qog7tWaP5iw1usLZuAyRQi4bJYMCJR+P1tA3eMEJkjRctINsTXfi0jlddbSc3kmY=
Date: Sat, 17 May 2008 02:49:16 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linuxppc-dev@ozlabs.org, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       fabrizio.garetto@gmail.com
Subject: Re: [PATCH 3/4] spi: Add OF binding support for SPI busses
Message-ID: <20080516224916.GA16702@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20080516193054.28030.35126.stgit@trillian.secretlab.ca> <20080516193613.28030.13950.stgit@trillian.secretlab.ca> <20080516220338.GA3255@zarina> <fa686aa40805161514r513d0eebt380a76f64abe8434@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <fa686aa40805161514r513d0eebt380a76f64abe8434@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2008 at 04:14:23PM -0600, Grant Likely wrote:
> On Fri, May 16, 2008 at 4:03 PM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> > On Fri, May 16, 2008 at 01:36:13PM -0600, Grant Likely wrote:
> >> +             /* Store a pointer to the node in the device structure */
> >> +             of_node_get(nc);
> >> +             spi->dev.archdata.of_node = nc;
> >> +
> >> +             /* Register the new device */
> >> +             rc = spi_register_device(spi);
> >> +             if (rc) {
> >> +                     dev_err(&master->dev, "spi_device register error %s\n",
> >> +                             np->full_name);
> >> +                     spi_device_release(spi);
> >> +             }
> >
> > No way to pass platform data... can you suggest any idea to use
> > this for things like
> > "[POWERPC] 86xx: mpc8610_hpcd: add support for SPI and MMC-over-SPI"
> > I've sent just recently...?
> 
> That's right.  platform_data being a very driver specific thing there
> is no way to generically extract a pdata structure from the device
> tree.  Instead, I'm storing the device node in archdata.of_node (line
> immediately above spi_register_device) so that drivers can read the
> device node themselves to populate a platform_device structure.
> (Protected by CONFIG_OF of course).
> 
> > Maybe this code could do something like
> > spi->dev.platform_data = nc->data;
> > and board code would fill nc->data at early stages? This needs to be a
> > convention, not just random use though.. Maybe we can expand the struct
> > device_node to explicitly include .platform_data for such cases?
> 
> Hmmm, as you say, this could end up being rather messy.  However, by
> passing the device node pointer, the driver could extract that data on
> a per case basis.  (ie. it would be decided on a per driver basis
> where to get the platform data).  I'm not sure; this bears more
> thought...

Sometimes it's not worth powder and shot adding OF functionality to
the drivers, I2C and SPI are major examples. Another [not mmc_spi]
example is drivers/input/touchscreen/ads7846.c, which is SPI driver
and needs platform data. There is a board that needs this (touchscreen
controller on a MPC8360E-RDK).

Also there is no way to pass functions via device tree, we're
always end up doing board-specific hooks in the generic drivers...

Finally, let's call this platform_data and be done with it. Then we
can use this for things like drivers/video/fsl-diu-fb.c (see diu_ops,
which is global struct, filled by
arch/powerpc/platforms/86xx/mpc8610_hpcd.c).

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
