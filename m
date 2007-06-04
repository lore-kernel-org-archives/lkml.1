Return-Path: <linux-kernel-owner+w=401wt.eu-S1761040AbXFDTJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761040AbXFDTJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 15:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759848AbXFDTJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 15:09:09 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:36325 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759670AbXFDTJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 15:09:07 -0400
X-Originating-Ip: 72.143.65.211
Date: Mon, 4 Jun 2007 15:07:27 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Christoph Lameter <clameter@sgi.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: __get_free_pages:  can GFP_DMA omit GFP_KERNEL and GFP_ATOMIC?
In-Reply-To: <Pine.LNX.4.64.0706041201210.24550@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0706041504150.3644@localhost.localdomain>
References: <Pine.LNX.4.64.0706030435130.14627@localhost.localdomain>
 <Pine.LNX.4.64.0706041143520.24412@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0706041449470.3148@localhost.localdomain>
 <Pine.LNX.4.64.0706041201210.24550@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Christoph Lameter wrote:

> On Mon, 4 Jun 2007, Robert P. J. Day wrote:
>
> > all right, then some of those __get_free_pages() calls would translate
> > to calls of the form __get_dma_pages(0, ...) -- is that what you're
> > saying?  or would it be equivalent and preferable to put GFP_ATOMIC in
> > there just so it looks not so weird?
>
> Put GFP_ATOMIC in there so that it does not look weird.
>
> GFP_ATOMIC & ~__GFP_HIGH == GFP_NOWAIT
>
> So these should have GFP_NOWAIT as far as I can tell?

beats me.  just FYI, it's not like this would be a massive change --
here's the entire collection of candidates for conversion over to
__get_dma_pages():

$ grep -r "get_free.*GFP_DMA" *
arch/s390/kernel/smp.c:                 __get_free_pages(GFP_KERNEL | GFP_DMA,
drivers/net/arm/ep93xx_eth.c:           page = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
drivers/net/arm/ep93xx_eth.c:           page = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
drivers/s390/net/qeth_main.c:                   ptr = (void *) __get_free_page(GFP_KERNEL|GFP_DMA);
drivers/s390/net/claw.c:                        (void *)__get_free_pages(__GFP_DMA,
drivers/s390/net/claw.c:                        (void *)__get_free_pages(__GFP_DMA,
drivers/s390/net/claw.c:                   p_buff=(void *)__get_free_pages(__GFP_DMA,
drivers/s390/net/claw.c:                        (void *)__get_free_pages(__GFP_DMA,
drivers/s390/net/claw.c:                        p_buff = (void *)__get_free_pages(__GFP_DMA,
drivers/s390/block/dasd.c:      device->ccw_mem = (void *) __get_free_pages(GFP_ATOMIC | GFP_DMA, 1);
drivers/s390/char/tty3270.c:                    __get_free_pages(GFP_KERNEL|GFP_DMA, 0);
drivers/s390/char/sclp_cpi.c:   sccb = (struct cpi_sccb *) __get_free_page(GFP_KERNEL | GFP_DMA);
drivers/s390/cio/cmf.c:         mem = (void*)__get_free_pages(GFP_KERNEL | GFP_DMA,
lib/swiotlb.c:          io_tlb_start = (char *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
lib/swiotlb.c:  io_tlb_overflow_buffer = (void *)__get_free_pages(GFP_DMA,
sound/oss/sscape.c:             start_addr = (char *) __get_free_pages(GFP_ATOMIC|GFP_DMA, sz);
sound/oss/hal2.c:       codec->buffer = (unsigned char *)__get_free_pages(GFP_KERNEL | GFP_DMA,
sound/oss/dmabuf.c:             start_addr = (char *) __get_free_pages(GFP_ATOMIC|GFP_DMA|__GFP_NOWARN, sz);

  and, obviously, it's not worth doing anything under sound/.  so
we're not talking enormous cleanup or anything.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
