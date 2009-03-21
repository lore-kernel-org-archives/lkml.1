Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbZCUK70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbZCUK70 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 06:59:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbZCUK7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 06:59:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751754AbZCUK7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 06:59:15 -0400
Date: Sat, 21 Mar 2009 03:53:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jos Houtman <jos@hyves.nl>
Cc: <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Page Cache writeback too slow,   SSD/noop scheduler/ext2
Message-Id: <20090321035315.fc10cef6.akpm@linux-foundation.org>
In-Reply-To: <C5E99E4E.C0E0%jos@hyves.nl>
References: <C5E989F1.C0C7%jos@hyves.nl>
	<C5E99E4E.C0E0%jos@hyves.nl>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009 19:26:06 +0100 Jos Houtman <jos@hyves.nl> wrote:

> Hi,
> 
> We have hit a problem where the page-cache writeback algorithm is not
> keeping up.
> When memory gets low this will result in very irregular performance drops.
> 
> Our setup is as follows:
> 30 x Quad core machine with 64GB ram.
> These are single purpose machines running MySQL.
> Kernel version: 2.6.28.7
> A dedicated SSD drive for the ext2 database partition
> Noop scheduler for the ssd drive.
> 
> 
> The current hypothesis is as follows:
> The wk_update function does not write enough dirty pages, which allows the
> number of dirty pages to grow to the dirty_background limit.
> When memory is low,  __background_writeout() comes around and __forcefully__
> writes dirty pages to disk.
> This forced write fills the disk queue and starves read calls that MySQL is
> trying to do: basically killing performance  for a few seconds.
> This pattern repeats as soon as the cleared memory is filled again.
> 
> Decreasing the dirty_writeback_centisecs to 100 doesn__t help
> 
> I don__t know why this is, but I did some preliminary tracing using systemtap
> and it seems that the majority of times wk_update calls decides to do
> nothing.
> 
> Doubling /sys/block/sdb/queue/nr_requests  to 256, seems to help abit:  the
> nr_dirty pages is increasing more slowly.
> But I am unsure of side-effects and am afraid of increasing the starvation
> problem for mysql.
> 
> 
> I__am very much willing to work on this issue and see it fixed, but would
> like to tap into the knowledge of people here.
> So: 
> * Have more people seen this or simular issues?
> * Is the hypothesis above a viable one?
> * Suggestions/pointers for further research and statistics I should measure
> to improve the understanding of this problem.
> 

I don't think that noop-iosched tries to do anything to prevent
writes-starve-reads.  Do you get better behaviour from any of the other IO
schedulers?


