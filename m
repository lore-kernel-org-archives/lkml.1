Return-Path: <linux-kernel-owner+w=401wt.eu-S932546AbZLNTX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546AbZLNTX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:23:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932504AbZLNTXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:23:53 -0500
Received: from www.tglx.de ([62.245.132.106]:55783 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506AbZLNTXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:23:51 -0500
Date: Mon, 14 Dec 2009 20:23:23 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Earl Chew <earl_chew@agilent.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       hjk@linutronix.de, gregkh@suse.de, hugh <hugh@veritas.com>,
       linux-mm <linux-mm@kvack.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA
Message-ID: <20091214192322.GA3245@bluebox.local>
References: <1228379942.5092.14.camel@twins> <4B22DD89.2020901@agilent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B22DD89.2020901@agilent.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 04:02:17PM -0800, Earl Chew wrote:
> I'm taking another look at the changes that were submitted in
> 
> http://lkml.org/lkml/2008/12/3/453
> 
> to see if they can be made more palatable.
> 
> 
> In http://lkml.org/lkml/2008/12/4/64 you wrote:
> 
> > Why not create another special device that will give you DMA memory when
> > you mmap it? That would also allow you to obtain the physical address
> > without this utter horrid hack of writing it in the mmap'ed memory.
> > 
> > /dev/uioN-dma would seem like a fine name for that.
> 
> 
> I understand the main objection was the hack to return the physical
> address of the allocated DMA buffer within the buffer itself amongst
> some other things.

The general thing is this: The UIO core supports only static mappings.
The possible number of mappings is usually set at compile time or module
load time and is currently limited to MAX_UIO_MAPS (== 5). This number
is usually sufficient for devices like PCI cards, which have a limited
number of mappings, too. All drivers currently in the kernel only need
one or two.

The current implementation of the UIO core is simply not made for
dynamic allocation of an unlimited amount of new mappings at runtime. As
we have seen in this patch, it needs raping of a documented kernel
interface to userspace. This is not acceptable.

So the easiest correct solution is to create a new device (e.g.
/dev/uioN-dma, as Peter suggested). It should only be created for a UIO
driver if it has a certain flag set, something like UIO_NEEDS_DYN_DMA_ALLOC.

> 
> Your suggestion was to create /dev/uioN-dma for the purpose of
> allocating DMA memory.
> 
> I'm having trouble figuring out how this would help to return the
> physical (bus) address of the DMA memory in a more elegant manner.

If you create this new device, you can invent any (reasonable) interface you
like. It should probably be something in sysfs, where you can write to a
file to allocate a new buffer, and read the address from some other.
It should also be possible to free a buffer again.

Thanks,
Hans

