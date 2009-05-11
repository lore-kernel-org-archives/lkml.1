Return-Path: <linux-kernel-owner+w=401wt.eu-S1755783AbZEKTXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbZEKTXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbZEKTWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:22:53 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45604 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204AbZEKTWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:22:53 -0400
Date: Mon, 11 May 2009 21:22:53 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Steve Rottinger <steve@pentek.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: splice methods in character device driver
Message-ID: <20090511192253.GH4694@kernel.dk>
References: <4A0838D1.5090102@pentek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0838D1.5090102@pentek.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11 2009, Steve Rottinger wrote:
> Hi,
> 
> Has anyone successfully implemented the splice() method's in a character
> device driver?
> I'm having a tough time finding any existing drivers that implement
> these method's, which
> I can use as an example. Specifically, it is unclear to me, as to how I
> need to set up .ops
> in the splice_pipe_desc, when using splice_to_pipe(). 
> My ultimate goal is to use splice to move data from a high speed data
> acquisition device,
> which has a buffer in PCI space to disk without the need for going
> through block memory.

I implemented ->splice_write() for /dev/null for testing purposes, but I
doubt that you'll find much inspiration there.

To use splice_to_pipe(), basically all you need to do is provide some
way of stuffing the data pages in question into a struct page *pages[].
See fs/splice.c:vmsplice_to_pipe(), for instance. Then you need to
provide a way to ensure that these pages can be settled if they need to
be accessed. Splice doesn't require that the IO is completed on the
pages before they are put in the pipe, that's part of the power of the
design. So if your design is allocating the pages in the ->splice_read()
handler and initiating IO to these pages, then you need to provide a
suitable ->confirm() hook that can wait on this IO to complete if
needed. ->map() and ->unmap() can typically use the generic functions,
ditto ->release(). You can implement ->steal() easily if you use the
method of dynamically allocating pages for each IO instead of reusing
them.

So it should not be very hard, your best inspiration is likely to be
found in fs/splice.c itself.

-- 
Jens Axboe

