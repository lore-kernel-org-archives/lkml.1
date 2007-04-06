Return-Path: <linux-kernel-owner+w=401wt.eu-S1767282AbXDFAb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767282AbXDFAb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 20:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767328AbXDFAb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 20:31:56 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59208 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767282AbXDFAby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 20:31:54 -0400
Date: Thu, 5 Apr 2007 17:31:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Bill Davidsen <davidsen@tmr.com>,
       yumiko.sugita.yf@hitachi.com, masami.hiramatsu.pt@hitachi.com,
       hidehiro.kawai.ez@hitachi.com, yuji.kakutani.uw@hitachi.com,
       soshima@redhat.com, haoki@redhat.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] VM throttling: Start writeback at
 dirty_writeback_start_ratio
Message-Id: <20070405173125.c1aed842.akpm@linux-foundation.org>
In-Reply-To: <4612306C.2040600@hitachi.com>
References: <45F7EDC6.5090303@hitachi.com>
	<20070315110745.af867b10.akpm@linux-foundation.org>
	<45FD53DB.5000207@tmr.com>
	<460218D2.40701@hitachi.com>
	<46026B78.3080401@tmr.com>
	<4607A01D.1060401@hitachi.com>
	<4607FECD.1090101@tmr.com>
	<4612306C.2040600@hitachi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Apr 2007 19:46:04 +0900
Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com> wrote:

> This patchset is to avoid the problem that write(2) can be blocked for a
> long time if a system has several disks with different speed and is
> under heavy I/O pressure.
> 
> -Description of the problem:
> While Dirty+Writeback pages get more than 40%(`dirty_ratio') of memory,
> generators of dirty pages are blocked in balance_dirty_pages() until
> they start writeback of a specific number (`write_chunk', typically=1536)
> of dirty pages on the disks they write to.
> 
> Under this rule, if a process writes to the disk which has only a few
> (less than 1536) dirty pages, that process will be blocked until
> writeback of the other disks is completed and % of Dirty+Writeback goes
> below 40%.
> 
> Thus, if a slow device (such as a USB disk) has many dirty pages, the
> processes which write small data to the other disks can be blocked for
> quite a long time.
> 
> -Solution:
> This patch introduces high/low-watermark algorithm in
> balance_dirty_pages() in order to throttle only the processes which
> write to disks with heavy load.
> 
> This patch adds `dirty_start_writeback_ratio' for the low-watermark,
> and modifies get_dirty_limits() to calculate and return the writeback
> starting level of dirty pages based on `dirty_start_writeback_ratio'.
> 
> If % of Dirty+Writeback > `dirty_writeback_start_ratio', generators of
> dirty pages start writeback of dirty pages by themselves. At that time,
> these processes are not blocked in balance_dirty_pages(), but they may
> be blocked if the write-requests-queue of the written disk is full
> (that is, the length of the queue > `nr_requests'). By this behavior,
> we can throttle only processes which write to the disks with heavy load,
> and can allow processes to write to the other disks without blocking.
> 
> If % of Dirty+Writeback > `dirty_ratio', generators of dirty pages
> are throttled as current Linux does, not to fill up memory with dirty
> pages.

Does this actually solve the problem?  If the request queue is sufficiently
large (relative to the various dirty-memory thresholds) then I'd expect
that a heavy-writer will be able to very quickly take the total
dirty+writeback memory up to the dirty_ratio (should be renamed
throttle_threshold, but it's too late for that).

I suspect the reason why this patch was successful in your testing was
because dirty_start_writeback_ratio happens to exceed the size of the disk
request queues, so the heavy writer is getting stuck on disk request queue
exhaustion.

But that won't work if we have a lot of processes writing to a lot of
disks, and it won't work if the request queue size is large, or if the
dirty-memory thresholds are small (relative to the request queue size).

Do the patches still work after
`echo 10000 > /sys/block/sda/queue/nr_requests'?
