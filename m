Return-Path: <linux-kernel-owner+w=401wt.eu-S1946525AbXD3RRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946525AbXD3RRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 13:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946532AbXD3RRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 13:17:51 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49769 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946525AbXD3RRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 13:17:50 -0400
Date: Mon, 30 Apr 2007 18:21:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: can a kmalloc be both GFP_ATOMIC and GFP_KERNEL at the same
 time?
Message-ID: <20070430182135.0fae7b89@the-village.bc.nu>
In-Reply-To: <20070430100225.353e3030.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0704280937060.24917@localhost.localdomain>
	<20070430001311.84d0291f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704300445460.17536@localhost.localdomain>
	<20070430100225.353e3030.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > drivers/scsi/aic7xxx_old.c:  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
> > > > drivers/message/i2o/device.c:   resblk = kmalloc(buflen + 8, GFP_KERNEL | GFP_ATOMIC);
> > > >
> > > >   clarification?
> > >
> > > GFP_ATOMIC implies that the memory comes from the zones which
> > > GFP_KERNEL also uses.  So the above usage of GFP_KERNEL is redundant
> > > and should be removed.
> > 
> > hang on ... based on an email i just got, is that reference to
> > GFP_KERNEL "redundant" or "conflicting"?  big difference there.  and
> > is the proper fix to remove "GFP_KERNEL" in both cases?
> > 
> 
> umm, yeah, oops.  GFP_KERNEL|GFP_ATOMIC is not a redundant combination. 
> It's GFP_KERNEL plus "is able to access emergency pools".  We'd normally
> represent that as GFP_KERNEL|__GFP_HIGH.

i2o/device.c should be GFP_KERNEL as far as I can tell. It was meant to
be that way and the callers appear to all be calling it in sleep capable
contexts.

aic7xxx_old.c should probably be GFP_KERNEL as ->slave_alloc methods
appear to be able to sleep (although some drivers use GFP_ATOMIC here and
some GFP_KERNEL).

Alan
