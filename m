Return-Path: <linux-kernel-owner+w=401wt.eu-S967440AbXEHMOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967440AbXEHMOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 08:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967387AbXEHMOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 08:14:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967363AbXEHMOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 08:14:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070508114003.GB19294@wotan.suse.de> 
References: <20070508114003.GB19294@wotan.suse.de>  <20070508113709.GA19294@wotan.suse.de> 
To: Nick Piggin <npiggin@suse.de>
Cc: linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [rfc] optimise unlock_page 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 08 May 2007 13:13:35 +0100
Message-ID: <9948.1178626415@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Nick Piggin <npiggin@suse.de> wrote:

> This patch trades a page flag for a significant improvement in the unlock_page
> fastpath. Various problems in the previous version were spotted by Hugh and
> Ben (and fixed in this one).

It looks reasonable at first glance, though it does consume yet another page
flag:-/  However, I think that's probably a worthy trade.

>  }
> -	
> +
> +static inline void unlock_page(struct page *page)
> +{
> +	VM_BUG_ON(!PageLocked(page));
> +	ClearPageLocked_Unlock(page);
> +	if (unlikely(PageWaiters(page)))
> +		__unlock_page(page);
> +}
> +

Please don't simply discard the documentation, we have little enough as it is:

> -/**
> - * unlock_page - unlock a locked page
> - * @page: the page
> - *
> - * Unlocks the page and wakes up sleepers in ___wait_on_page_locked().
> - * Also wakes sleepers in wait_on_page_writeback() because the wakeup
> - * mechananism between PageLocked pages and PageWriteback pages is shared.
> - * But that's OK - sleepers in wait_on_page_writeback() just go back to sleep.
> - *
> - * The mb is necessary to enforce ordering between the clear_bit and the read
> - * of the waitqueue (to avoid SMP races with a parallel wait_on_page_locked()).

David
