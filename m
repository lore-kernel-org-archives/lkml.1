Return-Path: <linux-kernel-owner+w=401wt.eu-S1762822AbXHVQDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762822AbXHVQDx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758180AbXHVQDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:03:44 -0400
Received: from outbound-mail-40.bluehost.com ([69.89.20.194]:33871 "HELO
	outbound-mail-40.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754567AbXHVQDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:03:43 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 2/3] dma: override "dma_flags_set_dmaflush" for sn-ia64
Date: Wed, 22 Aug 2007 09:03:23 -0700
User-Agent: KMail/1.9.7
Cc: Jes Sorensen <jes@sgi.com>, akepner@sgi.com,
       Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, rdreier@cisco.com,
       linux-ia64 <linux-ia64@vger.kernel.org>
References: <20070818002746.GU1813@sgi.com> <46CBE838.4000302@sgi.com> <1187791358.3410.1.camel@localhost.localdomain>
In-Reply-To: <1187791358.3410.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708220903.23702.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 22, 2007 7:02:38 am James Bottomley wrote:
> On Wed, 2007-08-22 at 09:39 +0200, Jes Sorensen wrote:
> > James Bottomley wrote:
> > > On Tue, 2007-08-21 at 17:34 -0700, akepner@sgi.com wrote:
> > >> The term "posted DMA" is used to describe this behavior in the Altix
> > >> Device Driver Writer's Guide, but it may be confusing things here.
> > >> Maybe a better term will suggest itself if I can clarify....
> > >
> > > OK, but posted DMA has a pretty specific meaning in terms of PCI, hence
> > > the confusion.
> >
> > Maybe it would be more better to refer to this as 'out of order DMA'?
>
> Or Relaxed ordering DMA ... that's why the readX_relaxed()?
>
> > >> On Altix, DMA from a device isn't guaranteed to arrive in host memory
> > >> in the order it was sent from the device. This reordering can happen
> > >> in the NUMA interconnect (it's specifically not a PCI reordering.)
> > >
> > > This is mmiowb and read_relaxed() again, isn't it?
> >
> > I believe it's the same problem, except this time it's when exposing
> > structures to userland.
>
> Hmm, so how does another kernel API exposing mmiowb in a different way
> help with this?  Surely, if the driver is exporting something to user
> space, it's simply up to the driver to call mmiowb when the user says
> it's done?

mmiowb() is for PIO->device.  This interface is for DMA->memory (see akepner's 
other mail).

The problem is a DMA write (say to a completion queue) from a device may imply 
something about another DMA write from the same device (say the actual data).  
If the completion queue write arrives first (which can happen on sn2), the 
driver must ensure that the rest of the outstanding DMA is complete prior to 
looking at the completion queue status.  It can either use a regular PIO read 
to do this (i.e. a non-relaxed one) or set a flag on the completion queue DMA 
address that makes it act as a barrier wrt other DMA, which is what akepner's 
patch does (which should be much more efficient that using a PIO read to 
guarantee DMA writes have completed).

Jesse
