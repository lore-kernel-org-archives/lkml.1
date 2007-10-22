Return-Path: <linux-kernel-owner+w=401wt.eu-S1752454AbXJVJz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbXJVJz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbXJVJzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:55:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33961 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751047AbXJVJzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:55:20 -0400
Date: Mon, 22 Oct 2007 02:55:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem Bityutskiy <dedekind@yandex.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: forcing write-back from FS - again
Message-Id: <20071022025516.848198f3.akpm@linux-foundation.org>
In-Reply-To: <471C6FA8.30500@yandex.ru>
References: <471BB45D.8070509@nokia.com>
	<20071021135526.57db7519.akpm@linux-foundation.org>
	<471C64D1.3020904@yandex.ru>
	<20071022020559.aa3fc59c.akpm@linux-foundation.org>
	<471C6FA8.30500@yandex.ru>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 12:38:48 +0300 Artem Bityutskiy <dedekind@yandex.ru> wrote:

> Andrew Morton wrote:
> >> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> >> @@ -28,6 +28,7 @@ static inline int task_is_pdflush(struct task_struct *task)
> >>    */
> >>   enum writeback_sync_modes {
> >>          WB_SYNC_NONE,   /* Don't wait on anything */
> >> +       WB_SYNC_NONE_PG,/* Don't wait on anything, don't touch locked pages */
> >>          WB_SYNC_ALL,    /* Wait on every mapping */
> >>          WB_SYNC_HOLD,   /* Hold the inode on sb_dirty for sys_sync() */
> >>   };
> > 
> > It would be simpler/safer/saner to add a new bitflag to writeback_control
> > and use that directly.  The WB_SYNC_foo flags are a holdover from an
> > earlier time and really should be made to go away, in favour of directly
> > setting up an appropriate writeback_control.
> 
> You mean something like (wbc->flags & WB_SYNC_NONE) etc? But below you used 
> wbc->skip_locked_pages, I'm confused.

take a look at struct writeback_control:

        unsigned nonblocking:1;         /* Don't get stuck on request queues */
        unsigned encountered_congestion:1; /* An output: a queue is full */
        unsigned for_kupdate:1;         /* A kupdate writeback */
        unsigned for_reclaim:1;         /* Invoked from the page allocator */
        unsigned for_writepages:1;      /* This is a writepages() call */
        unsigned range_cyclic:1;        /* range_start is cyclic */
        unsigned more_io:1;             /* more io to be dispatched */

Add another one...
