Return-Path: <linux-kernel-owner+w=401wt.eu-S1759504AbYFMOoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504AbYFMOoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 10:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755621AbYFMOn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 10:43:58 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:37667 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755549AbYFMOn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 10:43:58 -0400
Date: Fri, 13 Jun 2008 18:46:05 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarek Poplawski <jarkao2@o2.pl>, Max Krasnyansky <maxk@qualcomm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] workqueues: implement flush_work()
Message-ID: <20080613144605.GB9147@tv-sign.ru>
References: <20080613142801.GA9165@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613142801.GA9165@tv-sign.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13, Oleg Nesterov wrote:
>
> Add the new helper, flush_work(work), which waits for the completion of the
> specific work_struct.
>
> By its nature it requires that this work must not be re-queued, and thus its
> usage is limited. For example, this code
>
> 	queue_work(wq, work);
> 	/* WINDOW */
> 	queue_work(wq, work);
>
> 	flush_work(work);
>
> is not right. What can happen in the WINDOW above is
>
> 	- wq starts the execution of work->func()
>
> 	- the caller migrates to another CPU
>
> now, after the 2nd queue_work() this work is active on the previous CPU, and
> at the same time it is queued on another.

To clarify, in the scenario above, flush_work() behaves correctly. It "flushes"
the result of the last queue_work() which is visible to the caller. We can add
another simple helper,

	int flush_work_sync(work)
	{
		return flush_work(work) || wait_on_work(work);
	}

but I think it is not needed.

In short: flush_work() should be use with care when it is really needed.

Oleg.

