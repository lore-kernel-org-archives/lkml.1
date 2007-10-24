Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbXJXVOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbXJXVOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbXJXVO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:14:27 -0400
Received: from xenotime.net ([66.160.160.81]:41274 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754431AbXJXVO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:14:27 -0400
Date: Wed, 24 Oct 2007 14:14:18 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Doug Reiland" <dreiland@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.xxx race condition in x86_64's global_flush_tlb???
Message-Id: <20071024141418.907c7396.rdunlap@xenotime.net>
In-Reply-To: <6844644e0710241339i4d9ee450s98f9941f43a8cd6@mail.gmail.com>
References: <6844644e0710241339i4d9ee450s98f9941f43a8cd6@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 16:39:57 -0400 Doug Reiland wrote:

> I have seen some hangs in 2.6-x86_64 in flush_kernel_map(). The tests
> cause alot of ioremap/iounmap to occur concurrently across many
> processor threads.
> 
> Looking at the hung processor hangs, they are looping in
> flush_kernel_map() and the list they get from the smp_call_function()
> appears to be corrupt. In fact, I see deferred_pages as an entry and
> that isn't supposed to happen.
> 
> I am questioning the locking in global_flush_tlb() listed below. The
> down_read/up_read protection doesn't seen safe. If several threads are
> rushing thru here, deferred_pages could be getting changed as they
> look at it. I don't think there any protection when
> list_replace_init() calls INIT_LIST_HEAD().
> 
> I changed the down_read()/up_read() around list_replace_init() to
> down_write()/up_write() and my test runs fine.
> 
> 
> void global_flush_tlb(void)
> {
>         struct page *pg, *next;
>         struct list_head l;
> 
>         down_read(&init_mm.mmap_sem); // XXX should be down_write()???
>         list_replace_init(&deferred_pages, &l);
>         up_read(&init_mm.mmap_sem); // XXX should be up_write()????
>         flush_map(&l);
> 
>         list_for_each_entry_safe(pg, next, &l, lru) {
>                 ClearPagePrivate(pg);
>                 __free_page(pg);
>         }
> }

Seems to be already fixed in current git tree.

---
~Randy
