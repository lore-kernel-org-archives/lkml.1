Return-Path: <linux-kernel-owner+w=401wt.eu-S1757830AbZBDQzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830AbZBDQzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 11:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZBDQzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 11:55:22 -0500
Received: from mail.suse.de ([195.135.220.2]:34683 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752326AbZBDQzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 11:55:22 -0500
Date: Wed, 4 Feb 2009 08:48:02 -0800
From: Greg KH <gregkh@suse.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, jgarzik@redhat.com,
       stable@kernel.org
Subject: Re: patch sata_nv-fix-mcp5x-reset.patch added to 2.6.28-stable tree
Message-ID: <20090204164802.GA12671@suse.de>
References: <20090203224712.E16AA4901A@coco.kroah.org> <200902041518.52708.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902041518.52708.s.L-H@gmx.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 04, 2009 at 03:18:50PM +0100, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Dienstag, 3. Februar 2009, gregkh@suse.de wrote:
> > This is a note to let you know that we have just queued up the patch titled
> > 
> >     Subject: sata_nv: fix MCP5x reset
> > 
> > to the 2.6.28-stable tree.  Its filename is
> > 
> >     sata_nv-fix-mcp5x-reset.patch
> > 
> > A git repo of this tree can be found at 
> >     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > 
> > From 2d775708bc6613f1be47f1e720781343341ecc94 Mon Sep 17 00:00:00 2001
> > From: Tejun Heo <tj@kernel.org>
> > Date: Sun, 25 Jan 2009 11:29:38 +0900
> > Subject: sata_nv: fix MCP5x reset
> > 
> > From: Tejun Heo <tj@kernel.org>
> > 
> > commit 2d775708bc6613f1be47f1e720781343341ecc94 upstream.
> > 
> > MCP5x family of controllers seem to share much more with nf2's as far
> > as reset protocol is concerned.  It requires heardreset to get the PHY
> > going and classfication code report after hardreset is unreliable.
> > Create a new board type MCP5x and use noclassify hardreset.  SWNCQ is
> > modified to inherit from this new type.
> > 
> > This fixes hotplug regression reported in kernel bz#12351.
> [...]
> > --- a/drivers/ata/sata_nv.c
> > +++ b/drivers/ata/sata_nv.c
> [...]
> > +/* Kernel bz#12351 reports that when SWNCQ is enabled, for hotplug to
> > + * work, hardreset should be used and hardreset can't report proper
> > + * signature, which suggests that mcp5x is closer to nf2 as long as
> > + * reset quirkiness is concerned.  Define separate ops for mcp5x with
> > + * nv_noclassify_hardreset().
> > + */
> > +static struct ata_port_operations nv_mcp5x_ops = {
> > +	.inherits		= &nv_common_ops,
> > +	.hardreset		= nv_noclassify_hardreset,
> > +};
> [...]
> 
> This fails to compile on 2.6.28.3+stable-queue (and most likely 2.6.27 as 
> well), because it depends on the rename from nv_nf2_hardreset() to 
> nv_noclassify_hardreset() in:
> 
> commit e8caa3c70e94d867ca2efe9e53fd388b52d6d0c8
> Author: Tejun Heo <tj@kernel.org>
> Date:   Sun Jan 25 11:25:22 2009 +0900
> 
>     sata_nv: rename nv_nf2_hardreset()
> 
>     nv_nf2_hardreset() will be used by other flavors too.  Rename it to
>     nv_noclassify_hardreset().
> 
>     Signed-off-by: Tejun Heo <tj@kernel.org>
>     Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> 
> As this function has only been renamed without functional changes, either 
> applying "sata_nv: rename nv_nf2_hardreset()" as well or using
> s/nv_nf2_hardreset/nv_noclassify_hardreset/g on this patch
> (and potentially following changes, "sata_nv: ck804 has borked hardreset 
> too" 8d993eaa9c3c61b8a5929a7f695078a1fcfb4869 comes to mind) fixes the 
> build.

Thanks a lot for letting me know this.  I've added the additional
build-fix patch and also 8d993eaa9c3c61b8a5929a7f695078a1fcfb4869 as it
looks relevant.

greg k-h
