Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbXJVJvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbXJVJvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbXJVJvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:51:11 -0400
Received: from smtp.nokia.com ([131.228.20.172]:18948 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbXJVJvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:51:10 -0400
Message-ID: <471C6FA8.30500@yandex.ru>
Date: Mon, 22 Oct 2007 12:38:48 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: forcing write-back from FS - again
References: <471BB45D.8070509@nokia.com>        <20071021135526.57db7519.akpm@linux-foundation.org>        <471C64D1.3020904@yandex.ru> <20071022020559.aa3fc59c.akpm@linux-foundation.org>
In-Reply-To: <20071022020559.aa3fc59c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Oct 2007 09:38:49.0769 (UTC) FILETIME=[59B0B190:01C8148F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
>> @@ -28,6 +28,7 @@ static inline int task_is_pdflush(struct task_struct *task)
>>    */
>>   enum writeback_sync_modes {
>>          WB_SYNC_NONE,   /* Don't wait on anything */
>> +       WB_SYNC_NONE_PG,/* Don't wait on anything, don't touch locked pages */
>>          WB_SYNC_ALL,    /* Wait on every mapping */
>>          WB_SYNC_HOLD,   /* Hold the inode on sb_dirty for sys_sync() */
>>   };
> 
> It would be simpler/safer/saner to add a new bitflag to writeback_control
> and use that directly.  The WB_SYNC_foo flags are a holdover from an
> earlier time and really should be made to go away, in favour of directly
> setting up an appropriate writeback_control.

You mean something like (wbc->flags & WB_SYNC_NONE) etc? But below you used 
wbc->skip_locked_pages, I'm confused.

> The code you have there looks racy: if someone else locks the page in that
> little window after the PageLocked() test we'll still block in lock_page().
>  That's unlikely to happen in your application (apart from a remaining
> ab/ba scenario) but we should make it robust:
> 
> 	if (wbc->skip_locked_pages) {
> 		if (TestSetPageLocked(page))
> 			continue;
> 	} else {
> 		lock_page(page);
> 	}

Yeah, thanks for the pointer! Thank you for your help on the issue!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
