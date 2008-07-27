Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbYG0QaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbYG0QaA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 12:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYG0Q3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 12:29:52 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:42641 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbYG0Q3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 12:29:51 -0400
Date: Sun, 27 Jul 2008 20:33:23 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       balbir@linux.vnet.ibm.com, matt@bluehost.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] task IO accounting: improve code readability
Message-ID: <20080727163323.GA1802@tv-sign.ru>
References: <1217172555-8335-1-git-send-email-righi.andrea@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217172555-8335-1-git-send-email-righi.andrea@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27, Andrea Righi wrote:
>
> Put all i/o statistics in struct proc_io_accounting and use inline functions to
> initialize and increment statistics, removing a lot of single variable
> assignments.

Imho, the change like this is obviously good, but can't we simplify
this a little bit? Just make

	struct task_io_accounting
	{
	#ifdef CONFIG_TASK_XACCT
		/* bytes read */
		u64 rchar;
		/*  bytes written */
		u64 wchar;
		/* # of read syscalls */
		u64 syscr;
		/* # of write syscalls */
		u64 syscw;
	#endif /* CONFIG_TASK_XACCT */

	#ifdef CONFIG_TASK_IO_ACCOUNTING
		/*
		 * The number of bytes which this task has caused to be read from
		 * storage.
		 */
		u64 read_bytes;

		/*
		 * The number of bytes which this task has caused, or shall cause to be
		 * written to disk.
		 */
		u64 write_bytes;

		/*
		 * A task can cause "negative" IO too.  If this task truncates some
		 * dirty pagecache, some IO which another task has been accounted for
		 * (in its write_bytes) will not be happening.  We _could_ just
		 * subtract that from the truncating task's write_bytes, but there is
		 * information loss in doing that.
		 */
		u64 cancelled_write_bytes;
	#endif
	};

This should make the patch much smaller with the same effect, no?

Oleg.

