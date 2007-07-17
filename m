Return-Path: <linux-kernel-owner+w=401wt.eu-S1758984AbXGQGRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbXGQGRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 02:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbXGQGRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 02:17:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40028 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752323AbXGQGRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 02:17:06 -0400
Date: Mon, 16 Jul 2007 23:16:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thanos Makatos <mcatos@ics.forth.gr>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Full buffer cache not working properly
Message-Id: <20070716231625.e2bdbc01.akpm@linux-foundation.org>
In-Reply-To: <469634B6.1070901@ics.forth.gr>
References: <469634B6.1070901@ics.forth.gr>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007 17:03:34 +0300 Thanos Makatos <mcatos@ics.forth.gr> wrote:

> I run several times the following test and what I've seen is that when 
> the buffer cache becomes full, unneeded dirty buffer heads are not evicted
> and no other memory allocation can happen (including reading a block 
> from the disk to the buffer cache). Should this happen?
> Here's the code that reproduces this issue:
> 
> for(i = 0; i < get_capacity(bdev->bd_disk)/8; i++) {
>         bh = __bread(bdev, i, PAGE_SIZE);
>         lock_buffer(bh);
>         memset(bh->b_data, 0, PAGE_SIZE);
>         set_buffer_dirty(bh);
>         unlock_buffer(bh);
>         __brelse(bh);
> }
> 
> I added some printks printing the buffer head's reference counter: after 
> the '__bread' ref count is 2, after '__brelse' ref count is 1. Shouldn't 
> these
> numbers be 1 and 0 respectively? I added an extra 'put_bh' before (or 
> after) the '__brelse' but I get a BUG().

You've been very unkind to the VFS.  Put a balance_dirty_pages() call in
that loop to give the system an opportunity to do some writeback and
throttling.

