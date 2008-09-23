Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbYIWAtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbYIWAtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 20:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbYIWAt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 20:49:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752299AbYIWAt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 20:49:26 -0400
Date: Mon, 22 Sep 2008 17:48:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: chris@arachsys.com, linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com
Subject: Re: [PATCH] Memory management livelock
Message-Id: <20080922174829.57e0e511.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com>
References: <20080911101616.GA24064@agk.fab.redhat.com>
	<Pine.LNX.4.64.0809221705480.15511@hs20-bc2-1.build.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 17:10:04 -0400 (EDT)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> The bug happens when one process is doing sequential buffered writes to
> a block device (or file) and another process is attempting to execute
> sync(), fsync() or direct-IO on that device (or file). This syncing
> process will wait indefinitelly, until the first writing process
> finishes.
> 
> For example, run these two commands:
> dd if=/dev/zero of=/dev/sda1 bs=65536 &
> dd if=/dev/sda1 of=/dev/null bs=4096 count=1 iflag=direct
> 
> The bug is caused by sequential walking of address space in
> write_cache_pages and wait_on_page_writeback_range: if some other
> process is constantly making dirty and writeback pages while these
> functions run, the functions will wait on every new page, resulting in
> indefinite wait.

Shouldn't happen.  All the data-syncing functions should have an upper
bound on the number of pages which they attempt to write.  In the
example above, we end up in here:

int __filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
				loff_t end, int sync_mode)
{
	int ret;
	struct writeback_control wbc = {
		.sync_mode = sync_mode,
		.nr_to_write = mapping->nrpages * 2,	<<--
		.range_start = start,
		.range_end = end,
	};

so generic_file_direct_write()'s filemap_write_and_wait() will attempt
to write at most 2* the number of pages which are in cache for that inode.

I'd say that either a) that logic got broken or b) you didn't wait long
enough, and we might need to do something to make it not wait so long.

But before we patch anything we should fully understand what is
happening and why the current anti-livelock code isn't working in this
case.

