Return-Path: <linux-kernel-owner+w=401wt.eu-S1765778AbXEWTRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765778AbXEWTRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 15:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756164AbXEWTRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 15:17:23 -0400
Received: from mail-gw3.adaptec.com ([216.52.22.36]:55487 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173AbXEWTRW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 15:17:22 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
Subject: RE: [PATCH] [scsi] Remove __GFP_DMA
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Date: Wed, 23 May 2007 15:17:08 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1BDA@otce2k301.adaptec.com>
In-reply-to: <1179933494.3700.16.camel@mulgrave.il.steeleye.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] [scsi] Remove __GFP_DMA
Thread-Index: AcedTjUWC94ku7uJQvyyMCq8TAc5OwAIDuKA
References: <20070521151525.GA581@suse.de> <Pine.LNX.4.64.0705221443030.16285@schroedinger.engr.sgi.com> <6d6a94c50705221941y63f4db7bj174a2265d9eaa61a@mail.gmail.com> <1179933494.3700.16.camel@mulgrave.il.steeleye.com>
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
To: "James Bottomley" <James.Bottomley@SteelEye.com>,
       "Aubrey Li" <aubreylee@gmail.com>
Cc: "Christoph Lameter" <clameter@sgi.com>, "Bernhard Walle" <bwalle@suse.de>,
       <linux-scsi@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The 31 bit limit for some of these cards is a problem, we currently only
do __GFP_DMA for bounce buffer sg elements allocated for user supplied
references in ioctls.

I figure we should be using pci_alloc_consistent calls for these
allocations to more accurately acquire memory within the 31 bit limit if
necessary, we could switch to these to remove the need for the __GFP_DMA
flag in the aacraid driver?

-- Mark

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of James Bottomley
Sent: Wednesday, May 23, 2007 11:18 AM
To: Aubrey Li
Cc: Christoph Lameter; Bernhard Walle; linux-scsi@vger.kernel.org;
Andrew Morton; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [scsi] Remove __GFP_DMA

On Wed, 2007-05-23 at 10:41 +0800, Aubrey Li wrote:
> On 5/23/07, Christoph Lameter <clameter@sgi.com> wrote:
> > On Mon, 21 May 2007, Bernhard Walle wrote:
> >
> > > [PATCH] [scsi] Remove __GFP_DMA
> > >
> > > After 821de3a27bf33f11ec878562577c586cd5f83c64, it's not necessary
to alloate a
> > > DMA buffer any more in sd.c.
> > >
> > > Signed-off-by: Bernhard Walle <bwalle@suse.de>
> >
> > Great that avoids a DMA kmalloc slab. Any other GFP_DMAs left in the
scsi
> > layer?
> >
> > Acked-by: Christoph Lameter <clameter@sgi.com>
> 
> Yes, here is another patch

I'll defer to Mark on this one.  However, please remember that you can't
just blindly remove GFP_DMA ... there are some cards which require it.

Aacraid is one example ... it has a set of cards that can only DMA to 31
bits.  For them, the GFP_DMA is necessary:  The allocation in question
is a scatterlist, which must be within the device DMA mask.

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
