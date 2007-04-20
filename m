Return-Path: <linux-kernel-owner+w=401wt.eu-S2992500AbXDTIjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992500AbXDTIjz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992551AbXDTIjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:39:55 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:49796 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992500AbXDTIjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:39:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qFvsCHlUz2kIwQGN5mVR727X6+oQ9Niu3K2l+eQI1mj9MzNWkvm0flhn0SVX/5UoQYSYB2Eoe1vtMi3lxiXX5JoiLDo/Y3du/NiQuC3Fy2pibSKCHU/M3lF2p9YCkveQHVO8o4X6CILA1xMDCqEnXJIAEMp0w03xe5Hhds/a4l4=
Message-ID: <6d6a94c50704200139vb9b24f6y77a6d23544c8f7b9@mail.gmail.com>
Date: Fri, 20 Apr 2007 16:39:52 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: "David Howells" <dhowells@redhat.com>
Subject: Re: [PATCH] CONFIG_PACKET_MMAP should depend on MMU
Cc: "Robin Getz" <rgetz@blackfin.uclinux.org>, uaca@alumni.uv.es,
       bryan.wu@analog.com, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       waltje@uwalt.nl.mugnet.org, netdev@vger.kernel.org,
       "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1016.1177055893@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704091146.32346.rgetz@blackfin.uclinux.org>
	 <1176112223.17975.8.camel@roc-desktop> <9561.1176209728@redhat.com>
	 <200704101952.05380.rgetz@blackfin.uclinux.org>
	 <6d6a94c50704170336l62fc9ael1e58197e6c3853ba@mail.gmail.com>
	 <2817.1176910411@redhat.com>
	 <6d6a94c50704192146k5bbe2aefr31fa5726bf1c1e54@mail.gmail.com>
	 <1016.1177055893@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/07, David Howells <dhowells@redhat.com> wrote:
> Aubrey Li <aubreylee@gmail.com> wrote:
>
> > The patch works properly on my side. But
> > 1) I'm not sure why you re-wrote alloc/free_pg_vec function, doesn't
> > the current implement work for NOMMU? I know you want to allocate the
> > entire data buffer as one contiguous lump, but is it really necessary?
>
> Yes.  It's not possible to map the whole buffer otherwise.  Think about it!
> mmap() returns _one_ reference address.  In MMU-mode, the non-contiguous
> physical buffers can be made to appear virtually contiguous by fudging the
> page tables and using the MMU.  This is not possible in NOMMU-mode.  The app
> will expect the buffer to be one contiguous lump in its address space, and
> will not be able to locate the other segments of the buffer.

Great explanation, thanks, :-)

>
> Actually, what I said is not quite true.  It is possible to map the whole
> buffer otherwise: I could lift the restriction that requires that you map the
> whole buffer or not at all, and then userspace could stitch the whole lot
> together itself.  This would then require userspace to be bimodal.
>
> > 2) So the mapped pages doesn't count into NR_FILE_MAPPED, is it a problem?
>
> Not really, no - there are no pagetables.
>
> Furthermore, issuing the PACKET_RX_RING sockopt does the entire allocation.
> Any subsequent mmaps on it have little effect.
>
> We could do that accounting though if you think it'd be better.  I don't
> suppose it hurts.
>
as checked in packet_set_ring, buffer size must be a multiple of PAGE_SIZE,
--------------------packet_set_ring------------------------
if (unlikely(req->tp_block_size & (PAGE_SIZE - 1)))

So why not use __get_free_pages rather than kmalloc, so that we have
pagetables to count?

-Aubrey
