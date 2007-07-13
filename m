Return-Path: <linux-kernel-owner+w=401wt.eu-S1762775AbXGMRDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762775AbXGMRDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 13:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbXGMRDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 13:03:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbXGMRDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 13:03:43 -0400
Message-ID: <4697B056.9080508@redhat.com>
Date: Fri, 13 Jul 2007 19:03:18 +0200
From: Michal Schmidt <mschmidt@redhat.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] destroy_workqueue() can livelock
References: <20070713131655.GA1033@tv-sign.ru>
In-Reply-To: <20070713131655.GA1033@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> Pointed out by Michal Schmidt <mschmidt@redhat.com>.
> 
> The bug was introduced in 2.6.22 by me.
> 
> cleanup_workqueue_thread() does flush_cpu_workqueue(cwq) in a loop until
> ->worklist becomes empty. This is live-lockable, a re-niced caller can
> get CPU after wake_up() and insert a new barrier before the lower-priority
> cwq->thread has a chance to clear ->current_work.
> 
> Change cleanup_workqueue_thread() to do flush_cpu_workqueue(cwq) only once.
> We can rely on the fact that run_workqueue() won't return until it flushes
> all works. So it is safe to call kthread_stop() after that, the "should stop"
> request won't be noticed until run_workqueue() returns.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

I confirm the patch fixes the bug I was seeing.

Michal

