Return-Path: <linux-kernel-owner+w=401wt.eu-S934053AbZLOW2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934053AbZLOW2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:28:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761387AbZLOW2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:28:35 -0500
Received: from www.tglx.de ([62.245.132.106]:51648 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934064AbZLOW2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:28:33 -0500
Date: Tue, 15 Dec 2009 23:28:11 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Earl Chew <earl_chew@agilent.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, gregkh@suse.de,
       linux-mm <linux-mm@kvack.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/1] Userspace I/O (UIO): Add support for userspace DMA
Message-ID: <20091215222811.GC2432@local>
References: <1228379942.5092.14.camel@twins>
 <4B22DD89.2020901@agilent.com>
 <20091214192322.GA3245@bluebox.local>
 <4B27905B.4080006@agilent.com>
 <20091215210002.GA2432@local>
 <4B2803D8.10704@agilent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2803D8.10704@agilent.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 01:47:04PM -0800, Earl Chew wrote:
> Hans J. Koch wrote:
> > Sorry, I think I wasn't clear enough: The current interface for static
> > mappings shouldn't be changed. Dynamically added mappings need a new
> > interface.
> 
> Thanks for the quick reply.
> 
> Are you ok with changes to the (internal) struct uio_device ?

Hey, we live in a free world :)
Anything can be changed as long as it's a technically sensible solution and
doesn't break existing interfaces to userspace.

The DMA-for-UIO thing is something that shouldn't be taken lightly. If we
define an interface for that, it should cover all possible applications.
There are not only devices that need to allocate new DMA buffers at runtime,
but also devices which could very well live with one or two statically
allocated DMA buffers. We need to cover all these cases.

One example: An A/D converter has an on-chip 32k buffer. It causes an
interrupt as soon as the buffer is filled up to a certain high-water mark.
Such cases would easily fit into the current UIO system. The UIO core could
simply DMA the data to one of the mappings. A new flag for that mapping and
a few other changes are all it takes. After the DMA transfer is complete, the
interrupt is passed on to userspace, which would find the buffer already
filled with the desired data. Just a thought, unfortunately I haven't got
such hardware to try it.

When it comes to dynamically allocated DMA buffers, it might well be possible
to add a new directory in sysfs besides the "mem" directory, e.g. something
like /sys/class/uio/uioN/dma-mem/. This would save us the trouble of creating
a new device. Maybe the example above would better fit in here, too. Who knows.

These are only some thoughts, I haven't got any DMA capable hardware to deal
with ATM.

You certainly notice that there are important design decisions to make.
Remember that once a kernel interface to userspace exists, it is etched in
stone forever.

Thanks,
Hans

