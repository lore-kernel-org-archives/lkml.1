Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbYCLCLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbYCLCLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 22:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYCLCLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 22:11:04 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:48192 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbYCLCLD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 22:11:03 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Fix fsldma.c warning messages when it's compiled underPPC64.
Date: Wed, 12 Mar 2008 10:10:46 +0800
Message-ID: <ABF87B0B6A38C0458E319AC973ED68AECE526A@zch01exm26.fsl.freescale.net>
In-Reply-To: <20080311142247.GA18915@lixom.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Fix fsldma.c warning messages when it's compiled underPPC64.
Thread-Index: AciDgot8YIY2OzKJQm+wl0D4j01ChwAYtdIw
References: <1205146045-17342-1-git-send-email-wei.zhang@freescale.com> <20080311142247.GA18915@lixom.net>
From: "Zhang Wei" <Wei.Zhang@freescale.com>
To: "Olof Johansson" <olof@lixom.net>
Cc: <dan.j.williams@intel.com>, <sfr@canb.auug.org.au>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

> -----Original Message-----
> From: Olof Johansson [mailto:olof@lixom.net] 
> 
> On Mon, Mar 10, 2008 at 06:47:25PM +0800, Zhang Wei wrote:
> > There are warning messages reported by Stephen Rothwell with
> > ARCH=powerpc allmodconfig build:
> > 
> > drivers/dma/fsldma.c: In function 'fsl_dma_prep_memcpy':
> > drivers/dma/fsldma.c:439: warning: comparison of distinct 
> pointer types
> > lacks a cast
> > drivers/dma/fsldma.c: In function 'fsl_chan_xfer_ld_queue':
> > drivers/dma/fsldma.c:584: warning: format '%016llx' expects 
> type 'long long
> > unsigned int', but argument 4 has type 'dma_addr_t'
> > drivers/dma/fsldma.c: In function 'fsl_dma_chan_do_interrupt':
> > drivers/dma/fsldma.c:668: warning: format '%x' expects type 
> 'unsigned int',
> > but argument 5 has type 'dma_addr_t'
> > drivers/dma/fsldma.c:684: warning: format '%016llx' expects 
> type 'long long
> > unsigned int', but argument 4 has type 'dma_addr_t'
> > drivers/dma/fsldma.c:684: warning: format '%016llx' expects 
> type 'long long
> > unsigned int', but argument 5 has type 'dma_addr_t'
> > drivers/dma/fsldma.c:701: warning: format '%02x' expects 
> type 'unsigned
> > int', but argument 4 has type 'dma_addr_t'
> > drivers/dma/fsldma.c: In function 'fsl_dma_self_test':
> > drivers/dma/fsldma.c:840: warning: format '%d' expects type 
> 'int', but
> > argument 5 has type 'size_t'
> > drivers/dma/fsldma.c: In function 'of_fsl_dma_probe':
> > drivers/dma/fsldma.c:1010: warning: format '%08x' expects 
> type 'unsigned
> > int', but argument 5 has type 'resource_size_t'
> > 
> > This patch fixed the above warning messages.
> > 
> > Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
> > ---
> >  drivers/dma/fsldma.c |   29 ++++++++++++++++-------------
> >  1 files changed, 16 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
> > index cc9a681..5dfedf3 100644
> > --- a/drivers/dma/fsldma.c
> > +++ b/drivers/dma/fsldma.c
> > @@ -57,12 +57,12 @@ static void dma_init(struct 
> fsl_dma_chan *fsl_chan)
> >  
> >  }
> >  
> > -static void set_sr(struct fsl_dma_chan *fsl_chan, dma_addr_t val)
> > +static void set_sr(struct fsl_dma_chan *fsl_chan, u32 val)
> 
> Why? dma_addr_t is the right type to use here.

The reason is the val will be assigned to SR register, and SR register
 is a 32-bit only register.

> > @@ -581,8 +581,8 @@ static void 
> fsl_chan_xfer_ld_queue(struct fsl_dma_chan *fsl_chan)
> >  	if (ld_node != &fsl_chan->ld_queue) {
> >  		/* Get the ld start address from ld_queue */
> >  		next_dest_addr = to_fsl_desc(ld_node)->async_tx.phys;
> > -		dev_dbg(fsl_chan->dev, "xfer LDs staring from 
> 0x%016llx\n",
> > -				(u64)next_dest_addr);
> > +		dev_dbg(fsl_chan->dev, "xfer LDs staring from %p\n",
> > +				(void *)next_dest_addr);
> 
> If anything you should cast to unsigned long and print as %lx.
> next_dest_addr is not a pointer, it's a bus/dma address.
> 
> Same for all the other changes in this file (dma_addr_t -> u32 doesn't
> seem right, same for the %llx -> %p changes).
> 

Here's cast is only for print out message. The type point can
 adapt the address width automatically in 32-bit and 64-bit kernel.

Thanks!
Wei.
