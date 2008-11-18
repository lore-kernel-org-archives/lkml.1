Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbYKRNkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbYKRNkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 08:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbYKRNk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 08:40:26 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:21619 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750857AbYKRNkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 08:40:25 -0500
Date: Tue, 18 Nov 2008 22:39:09 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Laurent Pinchart <laurent.pinchart@skynet.be>
Cc: "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>, linux-uvc-devel@lists.berlios.de,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Video/UVC: Port mainlined uvc video driver to NOMMU
Message-ID: <20081118133908.GA26119@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Laurent Pinchart <laurent.pinchart@skynet.be>,
	"Hennerich, Michael" <Michael.Hennerich@analog.com>,
	Bryan Wu <cooloney@kernel.org>, linux-uvc-devel@lists.berlios.de,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
References: <1225963130-6784-1-git-send-email-cooloney@kernel.org> <200811092222.18047.laurent.pinchart@skynet.be> <8A42379416420646B9BFAC9682273B6D065BA718@limkexm3.ad.analog.com> <200811140052.10520.laurent.pinchart@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811140052.10520.laurent.pinchart@skynet.be>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 12:52:10AM +0100, Laurent Pinchart wrote:
> On Monday 10 November 2008, Hennerich, Michael wrote:
> > >On Thursday 06 November 2008, Bryan Wu wrote:
> > > > @@ -1071,7 +1072,20 @@ static int uvc_v4l2_mmap(struct file *file,
> > > > struct vm_area_struct *vma) addr += PAGE_SIZE;
> > > >  		size -= PAGE_SIZE;
> > > >  	}
> > > > +#else
> > > > +	if (i == video->queue.count ||
> > > > +		PAGE_ALIGN(size) != video->queue.buf_size) {
> > >
> > > Just out of curiosity, why do you need to PAGE_ALIGN size for non-MMU
> > > platforms ?
> >
> > Size and video->queue.buf_size is not the 100% same size (off by a few
> > bytes < pagesize), I think it's because on NOMMU the kernel calls
> > kmalloc() to allocate the buffer, not get_free_page().
> 
> That's right, but only for private mappings. It makes little sense to create a 
> private mapping on a V4L2 device as the kernel will read() device data into 
> the buffer when mapping the device (at least on NOMMU platforms). Only shared 
> mappings make sense in this case.
> 
The change itself is crap anyways, since it is just working around the
fact that vm_insert_page() presently -EINVAL's out on nommu. The
vmalloc_to_page()/vm_insert_page() pair is used extensively across the
v4l drivers, and it's unrealistic to expect to patch every call site with
this sort of a workaround.

While we can't support vm_insert_page() in most cases, these sorts of
use cases where it is just iterating over a contiguous block of pages on
a VMA that has already been established is something that can at least be
handled fairly easily (in this case, even just doing nothing in
vm_insert_page() would likely give the desired result, although we ought
to fix up vm_insert_page() to do something more useful instead). Working
out the bounds of the VMA isn't exactly difficult either, since we have
all of that already filled in the VMA by the time vma_insert_page() is
called.

Regarding the VMA flag, this can be rectified by providing a dummy
get_unmapped_area() for the v4l devices which will set some default
capabilities. After that, determine_vm_flags() should take care of
setting up the proper VMA flags without hacking every driver's mmap()
routine. This sort of thing has absolutely no place in the driver,
though.
