Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab0CJPVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 10:21:44 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55226 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432Ab0CJPVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 10:21:43 -0500
Date: Wed, 10 Mar 2010 15:21:25 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Markus Rechberger <mrechberger@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Subject: Re: USBFS Memory allocation Bug
Message-ID: <20100310152125.GN4883@csn.ul.ie>
References: <20100310135722.GL4883@csn.ul.ie> <Pine.LNX.4.44L0.1003101007410.1516-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1003101007410.1516-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 10:16:09AM -0500, Alan Stern wrote:
> On Wed, 10 Mar 2010, Mel Gorman wrote:
> 
> > On Tue, Mar 09, 2010 at 10:09:57PM +0100, Markus Rechberger wrote:
> > > Hi,
> > > 
> > > I just stumbled around following issue:
> > > 
> > > <SNIP to have one full message>
> > >
> > > [275835.491094] mediasrv: page allocation failure. order:6, mode:0x40d0
> > 
> > This is massive. Why is usbdev_ioctl requiring an order-6 allocation?
> > Does it have the option to fall back to vmalloc() for example?
> 
> We needed to implement an upper limit on the buffer size, and the value
> chosen was sufficient for 8 ms of data.  There is no fallback to
> vmalloc().
> 
> Of course, the mediasrv program could always make multiple smaller
> data submissions instead of a single big one.
> 

Is there any means for the driver to take the large request, break it up
into multiple smaller requests and submit them one at a time?

> > So, it's a high-order allocation but no swap is configured. As the
> > system has a big mix of both anonymous and file memory, it is likely it
> > was unable to find a large enough contiguous range of file-backed memory
> > it could discard. There is pretty much nothing the memory manager could
> > do here. 
> > 
> > FWIW, if swap was configured I'd think there was more the memory manager
> > could have done.
> > 
> > Is usb falling back to vmalloc() or order-0 pages possible?
> 
> No.  It's not possible since the buffer has to be contiguous for DMA
> purposes (this is a requirement of the driver interface).
> 

Regrettably, there is not much the VM can do in this situation. Without
swap, it cannot magic up contiguous memory. If memory compaction gets
merged then it could do more but the risk of failure is still non-zero.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
