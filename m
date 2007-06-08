Return-Path: <linux-kernel-owner+w=401wt.eu-S939637AbXFHTl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939637AbXFHTl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbXFHTlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:41:50 -0400
Received: from lazybastard.de ([212.112.238.170]:45122 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbXFHTlt (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:41:49 -0400
Date: Fri, 8 Jun 2007 21:36:07 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: carsteno@de.ibm.com
Cc: Christoph Hellwig <hch@infradead.org>, Jared Hulbert <jaredeh@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Message-ID: <20070608193606.GH20718@lazybastard.org>
References: <46690A39.3010402@de.ibm.com> <20070608075717.GA16927@infradead.org> <46690C58.7090304@de.ibm.com> <20070608080401.GA17684@infradead.org> <6934efce0706080905h253d9e3apd4168c5d14d305e5@mail.gmail.com> <20070608160929.GA3366@infradead.org> <6934efce0706080911y601a8377oad7b1251a95acd64@mail.gmail.com> <20070608161526.GA3729@infradead.org> <20070608175152.GG20718@lazybastard.org> <4669A831.3040105@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4669A831.3040105@de.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Whenever writes/erases to the device happen, the device driver would
need to call a function like

/**
 * unmap_page_range - remove all mapping to the given range of an address space
 * @mapping - the address space in question
 * @start_index - index of the first page in the range
 * @no_pages - number of pages to get unmapped
 *
 * Returns 0 on success or a negative errno value.
 */
int unmap_page_range(struct address_space *mapping, loff_t start_index,
		loff_t no_pages);

or implement something equivalent itself.  Your filesystem callback
looks like it would be just that, although I may be misreading you.

On Fri, 8 June 2007 21:04:17 +0200, Carsten Otte wrote:
> I think it needs to work like this:
> - temporary references (for read/write syscalls and friends) get 
> retrieved via get_xip_page and returned again via to-be-invented 
> put_page/page_cache_release

Either that or using standard mtd->read() and mtd->write() calls.  I see
some advantages to mtd->write() in particular, as the device driver
needs some notification to trigger unmap_page_range() before the actual
write and chip state transitions happen.  mtd->write() seems much easier
than something like

mtd->pre_write()
get_xip_page()
...
put_page()
mtd->post_write()

If get_xip_page() only has userland consumers all the locking can be
kept inside device drivers.

> - permanent references (for mapping to userland) get retrieved via 
> get_xip_page and don't get returned until unmap

Yep.

> - the device driver can access page->count via a helper function 
> provided by mm. This way, it can identify which pages are in use.

One of us is confused here.  The driver would have to check page->count
for a large range of pages, usually the whole chip.  And it would have
to tear down every single mapping before starting to write.  Is that
possible and desirable to do with page->count?  Unsure.

> - In order to get references back, the device driver can call a 
> callback provided by the file system. A default implementation will go 
> to filemap_xip.c. This callback would use rmap to find all mappings, 
> and unmap the page via xip_file_unmap()[mm/filemap_xip.c].

Jörn

-- 
Time? What's that? Time is only worth what you do with it.
-- Theo de Raadt
