Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbXJVI44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbXJVI44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 04:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbXJVI4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 04:56:49 -0400
Received: from smtp.nokia.com ([131.228.20.173]:55262 "EHLO
	mgw-ext14.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbXJVI4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 04:56:48 -0400
Message-ID: <471C64D1.3020904@yandex.ru>
Date: Mon, 22 Oct 2007 11:52:33 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: forcing write-back from FS - again
References: <471BB45D.8070509@nokia.com> <20071021135526.57db7519.akpm@linux-foundation.org>
In-Reply-To: <20071021135526.57db7519.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Oct 2007 08:52:34.0628 (UTC) FILETIME=[E393C840:01C81488]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> but it does not dot actually work, because if we have two processes forcing 
>> write-back from write_page(), they will mutually deadlock (A waits in 
>> write_cache_pages() on a page B has locked, B waits on inode or page A has locked).
> 
> Yeah, I was just thinking that as I read this ;)
>  
>> So this way is not ok, do you have any other ideas?
>>
>> We could mark page clean temporarily before doing write-back, and mark it dirty 
>> again, but this seems to be inefficient (although I'm not sure, need to dig 
>> these functions deeper, but they _seem_ to traverse the radix tree and change 
>> tags, so marking one page dirty may need to change many tags, but again, I did 
>> not really dig tis yet).
> 
> We could just skip locked pages altogether in writeback.  Perhaps in
> WB_SYNC_NONE mode, or perhaps add a new flag in writeback_control to select
> this behaviour.

Yeah, certanly not WB_SYNC_ALL, because this is a deadlocky - the process which 
forces write-back from the ->prepare_write() is having page X locked, pdflush 
may have some inode A locked and sleep on page X, while the FS would sleep on 
inode A.

> It _should_ be the case that the number of locked-and-dirty pages which
> writeback encounters is very small, so skipping locked pages during
> writeback-for-memory-flushing won't have any significant effect.  The first
> step should be to add a new /proc/vmstat field to count these pages and
> then do broad testing (especially on blocksize<pagesize filesystems) to
> confirm the theory.
> 
> We'll still need to synchronously lock the page in
> writeback-for-data-integrity mode though.

Thanks for suggestion. It sounds as a separate big job to enhance existing 
WB_SYNC_NONE. I've just introduced new WB mode, and it seems to work fine:

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
@@ -28,6 +28,7 @@ static inline int task_is_pdflush(struct task_struct *task)
   */
  enum writeback_sync_modes {
         WB_SYNC_NONE,   /* Don't wait on anything */
+       WB_SYNC_NONE_PG,/* Don't wait on anything, don't touch locked pages */
         WB_SYNC_ALL,    /* Wait on every mapping */
         WB_SYNC_HOLD,   /* Hold the inode on sb_dirty for sys_sync() */
  };
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
@@ -641,6 +641,10 @@ retry:
                 for (i = 0; i < nr_pages; i++) {
                         struct page *page = pvec.pages[i];

+                       if (wbc->sync_mode == WB_SYNC_NONE_PG &&
+                           PageLocked(page))
+                               continue;
+

My only concern is - what if the page we skipped because of WB_SYNC_NONE_PG 
will somehow loose its dirty TAG and will never be written-back? But it is 
because of my poor knowledge of Linux MM internals. Could you please comment on 
this?

Thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

