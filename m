Return-Path: <linux-kernel-owner+w=401wt.eu-S1759584AbYGFUbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584AbYGFUbR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 16:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbYGFUbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 16:31:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36948 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753893AbYGFUbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 16:31:04 -0400
Date: Sun, 6 Jul 2008 13:31:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: Kernel oops (bug) in fs/buffers.c:create_empty_buffers
Message-Id: <20080706133100.8d8ed269.akpm@linux-foundation.org>
In-Reply-To: <20080706132302.5ca87f4f@infradead.org>
References: <20080706132302.5ca87f4f@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jul 2008 13:23:02 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> Hi,
> 
> caught this one on kerneloops.org: 
> http://www.kerneloops.org/searchweek.php?search=create_empty_buffers
> 
> void create_empty_buffers(struct page *page,
>                         unsigned long blocksize, unsigned long b_state)
> {
>         struct buffer_head *bh, *head, *tail;
> 
>         head = alloc_page_buffers(page, blocksize, 1);
>         bh = head;
>         do {
>                 bh->b_state |= b_state;
>                 tail = bh;
>                 bh = bh->b_this_page;
>         } while (bh);
> 
> 
> turns out, alloc_page_buffers() can fail and return NULL (for AIO for
> example)... yet this code blindly dereferences the result, getting a
> predictable NULL pointer fault.
> 
> It's not directly clear what to do about... make this function return
> the failure to the caller?

isofs has a habit of returning impossible block sizes and the

	while ((offset -= size) >= 0) {

consequently loops zero times and alloc_page_buffers() returns null.

Someone was having a look at it - maybe Jan?

I assume that the kernloops.org records link back to the original
report somewhere but I can't find it?

