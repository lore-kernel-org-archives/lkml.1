Return-Path: <linux-kernel-owner+w=401wt.eu-S1762811AbZLQQRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762811AbZLQQRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 11:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761729AbZLQQRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 11:17:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59180 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761484AbZLQQRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 11:17:01 -0500
Date: Thu, 17 Dec 2009 08:16:12 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Kyle McMartin <kyle@mcmartin.ca>
cc: linux-parisc@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James.Bottomley@suse.de, hch@infradead.org, linux-arch@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [git patches] xfs and block fixes for virtually indexed arches
In-Reply-To: <20091217132256.GO28962@bombadil.infradead.org>
Message-ID: <alpine.LFD.2.00.0912170811130.15740@localhost.localdomain>
References: <20091216043618.GB9104@hera.kernel.org> <20091217132256.GO28962@bombadil.infradead.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 17 Dec 2009, Kyle McMartin wrote:
>
> Linus, any word on these? I'd really love to get jejb and hch off
> my back. :)

I hate them.

I don't see what the point of allowing kernel virtual addresses in bio's 
is. It's wrong. The fact that XFS does that sh*t is an XFS issue. Handle 
it there.

Fix XFS. Or convince me with some really good arguments, and make sure 
that Jens signs off on the cr*p too.

In other words, the thing I object to isn't even the new flushing thing, 
it's this idiocy:

 - save off virtual address:
	..
	bio->bi_private = data;
	..

 - do vmalloc_to_page:

	+		if (is_vmalloc_addr(data)) {
	+			flush_kernel_dcache_addr(data);
	+			page = vmalloc_to_page(data);
	+		} else
	+			page = virt_to_page(data);

WTF? Why the hell should the block layer support this kind of absolute 
crap? When has "use random kernel virtual address" ever been a valid thing 
to do for IO?

Why aren't you doing this before you submit the vmalloc range for IO?

So no. Not a way in hell do I pull this for 33. And preferably never.

		Linus
