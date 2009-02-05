Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbZBERNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbZBERNT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:13:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbZBERNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:13:07 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:57821 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103AbZBERNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:13:05 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEAIariknCTsYx/2dsb2JhbACBbs86hBYG
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH] Video/UVC: Port mainlined uvc video driver to NOMMU
Date: Thu, 5 Feb 2009 18:12:54 +0100
User-Agent: KMail/1.9.9
Cc: Paul Mundt <lethal@linux-sh.org>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       linux-uvc-devel@lists.berlios.de, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
References: <1225963130-6784-1-git-send-email-cooloney@kernel.org> <20081118133908.GA26119@linux-sh.org> <386072610902050110r192c53f5xf06a91ac3a115c8f@mail.gmail.com>
In-Reply-To: <386072610902050110r192c53f5xf06a91ac3a115c8f@mail.gmail.com>
X-Face: 4Mf^tnii7k\_EnR5aobBm6Di[DZ9@AX1wJ"okBdX-UoJ>:SRn]c6DDU"qUIwfs98vF>=?utf-8?q?Tnf=0A=09SacR=7B?=(0Du"N%_.#X]"TXx)A'gKB1i7SK$CTLuy{h})c=g:'w3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902051812.54504.laurent.pinchart@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On Thursday 05 February 2009, Bryan Wu wrote:
> On Tue, Nov 18, 2008 at 9:39 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> > On Fri, Nov 14, 2008 at 12:52:10AM +0100, Laurent Pinchart wrote:
> >> On Monday 10 November 2008, Hennerich, Michael wrote:
> >> > >On Thursday 06 November 2008, Bryan Wu wrote:
> >> > > > @@ -1071,7 +1072,20 @@ static int uvc_v4l2_mmap(struct file *file,
> >> > > > struct vm_area_struct *vma) addr += PAGE_SIZE;
> >> > > >                 size -= PAGE_SIZE;
> >> > > >         }
> >> > > > +#else
> >> > > > +       if (i == video->queue.count ||
> >> > > > +               PAGE_ALIGN(size) != video->queue.buf_size) {
> >> > >
> >> > > Just out of curiosity, why do you need to PAGE_ALIGN size for
> >> > > non-MMU platforms ?
> >> >
> >> > Size and video->queue.buf_size is not the 100% same size (off by a few
> >> > bytes < pagesize), I think it's because on NOMMU the kernel calls
> >> > kmalloc() to allocate the buffer, not get_free_page().
> >>
> >> That's right, but only for private mappings. It makes little sense to
> >> create a private mapping on a V4L2 device as the kernel will read()
> >> device data into the buffer when mapping the device (at least on NOMMU
> >> platforms). Only shared mappings make sense in this case.
> >
> > The change itself is crap anyways, since it is just working around the
> > fact that vm_insert_page() presently -EINVAL's out on nommu. The
> > vmalloc_to_page()/vm_insert_page() pair is used extensively across the
> > v4l drivers, and it's unrealistic to expect to patch every call site with
> > this sort of a workaround.
> >
> > While we can't support vm_insert_page() in most cases, these sorts of
> > use cases where it is just iterating over a contiguous block of pages on
> > a VMA that has already been established is something that can at least be
> > handled fairly easily (in this case, even just doing nothing in
> > vm_insert_page() would likely give the desired result, although we ought
> > to fix up vm_insert_page() to do something more useful instead). Working
> > out the bounds of the VMA isn't exactly difficult either, since we have
> > all of that already filled in the VMA by the time vma_insert_page() is
> > called.
> >
> > Regarding the VMA flag, this can be rectified by providing a dummy
> > get_unmapped_area() for the v4l devices which will set some default
> > capabilities. After that, determine_vm_flags() should take care of
> > setting up the proper VMA flags without hacking every driver's mmap()
> > routine. This sort of thing has absolutely no place in the driver,
> > though.
>
> Hi Laurent,
>
> Does this patch make sense? I hope you understand the tricky things in
> nommu mapping world.

I agree with Paul, the problem lies in vm_insert_page() and a fix is needed 
there.

Best regards,

Laurent Pinchart
