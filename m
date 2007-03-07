Return-Path: <linux-kernel-owner+w=401wt.eu-S1422709AbXCGKPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422709AbXCGKPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 05:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422707AbXCGKPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 05:15:25 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59932 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422709AbXCGKPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 05:15:23 -0500
Date: Wed, 7 Mar 2007 02:15:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 1/8] fix race in clear_page_dirty_for_io()
Message-Id: <20070307021518.3b1ff4a2.akpm@linux-foundation.org>
In-Reply-To: <20070307082337.101759335@szeredi.hu>
References: <20070307080949.290171170@szeredi.hu>
	<20070307082337.101759335@szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(cc's reinstated)

On Wed, 07 Mar 2007 09:09:50 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:

> There's a race in clear_page_dirty_for_io() that allows a page to have
> cleared PG_dirty, while being mapped read-write into the page table(s).

I assume you refer to this:

		 * FIXME! We still have a race here: if somebody
		 * adds the page back to the page tables in
		 * between the "page_mkclean()" and the "TestClearPageDirty()",
		 * we might have it mapped without the dirty bit set.
		 */
		if (page_mkclean(page))
			set_page_dirty(page);
		if (TestClearPageDirty(page)) {
			dec_zone_page_state(page, NR_FILE_DIRTY);
			return 1;
		}

I guess the comment actually refers to a writefault after the
set_page_dirty() and before the TestClearPageDirty().  The fault handler
will run set_page_dirty() and will return to userspace to rerun the write. 
The page then gets set pte-dirty but this thread of control will now make
the page !PageDirty() and will write it out.

With Nick's proposed lock-the-page-in-pagefaults patches, we have
lock_page() synchronisation between pagefaults and
clear_page_dirty_for_io() which I think will fix this.

