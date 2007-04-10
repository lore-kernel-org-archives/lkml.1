Return-Path: <linux-kernel-owner+w=401wt.eu-S932840AbXDJDJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840AbXDJDJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 23:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932886AbXDJDJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 23:09:20 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:37710 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932840AbXDJDJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 23:09:19 -0400
Message-ID: <461AFED6.3000407@hitachi.com>
Date: Tue, 10 Apr 2007 12:04:54 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Bill Davidsen <davidsen@tmr.com>, yumiko.sugita.yf@hitachi.com,
       masami.hiramatsu.pt@hitachi.com, hidehiro.kawai.ez@hitachi.com,
       yuji.kakutani.uw@hitachi.com, soshima@redhat.com, haoki@redhat.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/2] VM throttling: Start writeback at dirty_writeback_start_ratio
References: <45F7EDC6.5090303@hitachi.com>	<20070315110745.af867b10.akpm@linux-foundation.org>	<45FD53DB.5000207@tmr.com>	<460218D2.40701@hitachi.com>	<46026B78.3080401@tmr.com>	<4607A01D.1060401@hitachi.com>	<4607FECD.1090101@tmr.com>	<4612306C.2040600@hitachi.com> <20070405173125.c1aed842.akpm@linux-foundation.org>
In-Reply-To: <20070405173125.c1aed842.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,
Thank you for your comments.

Andrew Morton wrote:
> On Tue, 03 Apr 2007 19:46:04 +0900
> Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com> wrote:
>> If % of Dirty+Writeback > `dirty_writeback_start_ratio', generators of
>> dirty pages start writeback of dirty pages by themselves. At that time,
>> these processes are not blocked in balance_dirty_pages(), but they may
>> be blocked if the write-requests-queue of the written disk is full
>> (that is, the length of the queue > `nr_requests'). By this behavior,
>> we can throttle only processes which write to the disks with heavy load,
>> and can allow processes to write to the other disks without blocking.
>>
>> If % of Dirty+Writeback > `dirty_ratio', generators of dirty pages
>> are throttled as current Linux does, not to fill up memory with dirty
>> pages.
> 
> Does this actually solve the problem?  If the request queue is sufficiently
> large (relative to the various dirty-memory thresholds) then I'd expect
> that a heavy-writer will be able to very quickly take the total
> dirty+writeback memory up to the dirty_ratio (should be renamed
> throttle_threshold, but it's too late for that).
> 
> I suspect the reason why this patch was successful in your testing was
> because dirty_start_writeback_ratio happens to exceed the size of the disk
> request queues, so the heavy writer is getting stuck on disk request queue
> exhaustion.
> 
> But that won't work if we have a lot of processes writing to a lot of
> disks, and it won't work if the request queue size is large, or if the
> dirty-memory thresholds are small (relative to the request queue size).
> 
> Do the patches still work after
> `echo 10000 > /sys/block/sda/queue/nr_requests'?

As you pointed out, this patch has no effect if nr_requests is too large,
because it distinguishes heavy disks depending on the length of the write-
requests queue of each disk.

This patch is for providing the system administrators with room to avoid
the problem by adjusting parameters appropriately, rather than an automatic
solution for any possible situations.

Could you please tell me some situations in which we should set nr_request
that large?

Thanks,
-- 
Tomoki Sekiyama
Hitachi, Ltd., Systems Development Laboratory
