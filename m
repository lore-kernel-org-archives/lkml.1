Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbYG2HtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbYG2HtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 03:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbYG2Hsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 03:48:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753259AbYG2Hsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 03:48:54 -0400
Date: Tue, 29 Jul 2008 00:47:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org,
       Markus Lidel <Markus.Lidel@shadowconnect.com>,
       Vasily Averin <vvs@sw.ru>
Subject: Re: [PATCH]: Proposed fix to the I2O problems with > 4GB space
Message-Id: <20080729004756.113d85a0.akpm@linux-foundation.org>
In-Reply-To: <20080725131637.48072ef3@lxorguk.ukuu.org.uk>
References: <20080725131637.48072ef3@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008 13:16:37 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@redhat.com>
> 
> The I2O ioctls assume 32bits. In itself that is fine as they are old cards
> and nobody uses 64bit. However on LKML it was noted this assumption is also
> made for some ioctl allocated memory and is unsafe on 64bit systems.
> 
> Fixing this is a mess. It turns out there is tons of crap buried in a header
> file that does racy 32/64bit filtering on the masks.
> 
> So we:
> - Verify all callers of the racy code can sleep (i2o_dma_[re]alloc)
> - Move the code into a new i2o/memory.c file
> - Remove the gfp_mask argument so nobody can try and misuse the function
> - Wrap a mutex around the problem area (a single mutex is easy to do and
>   none of this is performance relevant)
> - Switch the remaining problem kmalloc holdout to use i2o_dma_alloc
> 
> There is a remaining race but that causes 32bit allocations to occur very
> rarely during block I/O when 64bit could be used. I don't think that is worth
> the cost of fixing as the impact is just a negligible performance loss.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 

I think you sent the wrong version of this patch - i2o_dma_alloc() is
all mucked up.  Sometimes takes three args, sometimes four.  When it's
four the fourth arg is sometimes a gfp_t, sometimes a PCI_DMA_foo.

It fell afoul of the dma_mapping_error() interface change too.

> (but could do with more testing, especially on 64bit > 4GB boxes with 64bit
> capable I2O cards)

A bit of git-trolling indicates that Vasily might be able to help out
with a bit of testing?

