Return-Path: <linux-kernel-owner+w=401wt.eu-S1764835AbZLQQr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764835AbZLQQr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 11:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764843AbZLQQrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 11:47:24 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764802AbZLQQrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 11:47:23 -0500
Date: Thu, 17 Dec 2009 08:46:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: tytso@mit.edu
cc: Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James.Bottomley@suse.de, hch@infradead.org, linux-arch@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [git patches] xfs and block fixes for virtually indexed arches
In-Reply-To: <20091217163036.GE2123@thunk.org>
Message-ID: <alpine.LFD.2.00.0912170839550.15740@localhost.localdomain>
References: <20091216043618.GB9104@hera.kernel.org> <20091217132256.GO28962@bombadil.infradead.org> <alpine.LFD.2.00.0912170811130.15740@localhost.localdomain> <20091217163036.GE2123@thunk.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Dec 2009, tytso@mit.edu wrote:
> 
> That's because apparently the iSCSI and DMA blocks assume that they
> have Real Pages (tm) passed to block I/O requests, and apparently XFS
> ran into problems when sending vmalloc'ed pages.  I don't know if this
> is a problem if we pass the bio layer addresses coming from the SLAB
> allocator, but oral tradition seems to indicate this is problematic,
> although no one has given me the full chapter and verse explanation
> about why this is so.

kmalloc() memory should be ok. It's backed by "real pages". Doing the DMA 
translations for such pages is trivial and fundamental.

In contrast, vmalloc is pure and utter unadulterated CRAP. The pages 
may be contiguous virtually, but it makes no difference for the block 
layer, that has to be able to do IO by DMA anyway, so it has to look up 
the page translations in the page tables etc crazy sh*t.

So passing vmalloc'ed page addresses around to something that will 
eventually do a non-CPU-virtual thing on them is fundamentally insane. The 
vmalloc space is about CPU virtual addresses. Such concepts simpyl do not 
-exist- for some random block device.

> Now that I see Linus's complaint, I'm wondering if the issue is really
> about kernel virtual addresses (i.e., coming from vmalloc), and not a
> requirement for Real Pages (i.e., coming from the SLAB allocator as
> opposed to get_free_page).  And can this be documented someplace?  I
> tried looking at the bio documentation, and couldn't find anything
> definitive on the subject.

The whole "vmalloc is special" has always been true. If you want to 
treat vmalloc as normal memory, you need to look up the pages yourself. We 
have helpers for that (including helpers that populate vmalloc space from 
a page array to begin with - so you can _start_ from some array of pages 
and then lay them out virtually if you want to have a convenient CPU 
access to the array).

And this whole "vmalloc is about CPU virtual addresses" is so obviously 
and fundamentally true that I don't understand how anybody can ever be 
confused about it. The "v" in vmalloc is for "virtual" as in virtual 
memory.

Think of it like virtual user addresses. Does anybody really expect to be 
able to pass a random user address to the BIO layer?

And if you do, I would suggest that you get out of kernel programming 
pronto. You're a danger to society, and have a lukewarm IQ. I don't want 
you touching kernel code.

And no, I do _not_ want the BIO layer having to walk page tables. Not for 
vmalloc space, not for user virtual addresses.

(And don't tell me it already does. Maybe somebody sneaked it in past me, 
without me ever noticing. That wouldn't be an excuse, that would be just 
sad. Jesus wept)

			Linus
