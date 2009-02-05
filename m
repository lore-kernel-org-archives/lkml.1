Return-Path: <linux-kernel-owner+w=401wt.eu-S1759288AbZBEJKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759288AbZBEJKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 04:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756537AbZBEJK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 04:10:26 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:24489 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbZBEJKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 04:10:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=L2IOYwNDse330kNN0w8z5Mh+2m3Qd6KLPMyuWyDoD4VChf8wDuclyXp8RMr/5OLO1y
         3+qKiFlP/PtXUe2ojuCagSGz733OGyBVaifYvFr244RYpjVBPmz/Y4KTZo7JikQ4FN1g
         39R8qYz2XahhJBl1eOL6QP0hbGw8CqhVHPQfY=
MIME-Version: 1.0
In-Reply-To: <20081118133908.GA26119@linux-sh.org>
References: <1225963130-6784-1-git-send-email-cooloney@kernel.org>
	 <200811092222.18047.laurent.pinchart@skynet.be>
	 <8A42379416420646B9BFAC9682273B6D065BA718@limkexm3.ad.analog.com>
	 <200811140052.10520.laurent.pinchart@skynet.be>
	 <20081118133908.GA26119@linux-sh.org>
Date: Thu, 5 Feb 2009 17:10:22 +0800
X-Google-Sender-Auth: fb693c9720cc17cc
Message-ID: <386072610902050110r192c53f5xf06a91ac3a115c8f@mail.gmail.com>
Subject: Re: [PATCH] Video/UVC: Port mainlined uvc video driver to NOMMU
From: Bryan Wu <cooloney@kernel.org>
To: Paul Mundt <lethal@linux-sh.org>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>, linux-uvc-devel@lists.berlios.de,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 9:39 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Fri, Nov 14, 2008 at 12:52:10AM +0100, Laurent Pinchart wrote:
>> On Monday 10 November 2008, Hennerich, Michael wrote:
>> > >On Thursday 06 November 2008, Bryan Wu wrote:
>> > > > @@ -1071,7 +1072,20 @@ static int uvc_v4l2_mmap(struct file *file,
>> > > > struct vm_area_struct *vma) addr += PAGE_SIZE;
>> > > >                 size -= PAGE_SIZE;
>> > > >         }
>> > > > +#else
>> > > > +       if (i == video->queue.count ||
>> > > > +               PAGE_ALIGN(size) != video->queue.buf_size) {
>> > >
>> > > Just out of curiosity, why do you need to PAGE_ALIGN size for non-MMU
>> > > platforms ?
>> >
>> > Size and video->queue.buf_size is not the 100% same size (off by a few
>> > bytes < pagesize), I think it's because on NOMMU the kernel calls
>> > kmalloc() to allocate the buffer, not get_free_page().
>>
>> That's right, but only for private mappings. It makes little sense to create a
>> private mapping on a V4L2 device as the kernel will read() device data into
>> the buffer when mapping the device (at least on NOMMU platforms). Only shared
>> mappings make sense in this case.
>>
> The change itself is crap anyways, since it is just working around the
> fact that vm_insert_page() presently -EINVAL's out on nommu. The
> vmalloc_to_page()/vm_insert_page() pair is used extensively across the
> v4l drivers, and it's unrealistic to expect to patch every call site with
> this sort of a workaround.
>
> While we can't support vm_insert_page() in most cases, these sorts of
> use cases where it is just iterating over a contiguous block of pages on
> a VMA that has already been established is something that can at least be
> handled fairly easily (in this case, even just doing nothing in
> vm_insert_page() would likely give the desired result, although we ought
> to fix up vm_insert_page() to do something more useful instead). Working
> out the bounds of the VMA isn't exactly difficult either, since we have
> all of that already filled in the VMA by the time vma_insert_page() is
> called.
>
> Regarding the VMA flag, this can be rectified by providing a dummy
> get_unmapped_area() for the v4l devices which will set some default
> capabilities. After that, determine_vm_flags() should take care of
> setting up the proper VMA flags without hacking every driver's mmap()
> routine. This sort of thing has absolutely no place in the driver,
> though.
>

Hi Laurent,

Does this patch make sense? I hope you understand the tricky things in
nommu mapping world.

Thanks
-Bryan
