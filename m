Return-Path: <linux-kernel-owner+w=401wt.eu-S1758769AbZAMJh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbZAMJh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 04:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbZAMJht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 04:37:49 -0500
Received: from mail.gmx.net ([213.165.64.20]:44799 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751312AbZAMJhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 04:37:48 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+UOSRenMiU+evb9UrroLale/mTyZa1y2AkX1kFjT
	BskNUZ3FCGvsyH
Subject: Re: Performance regression of specjbb2005/aim7 with 2.6.29-rc1
From: Mike Galbraith <efault@gmx.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, ming.m.lin@intel.com,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1231837036.11429.27.camel@ymzhang>
References: <1231837036.11429.27.camel@ymzhang>
Content-Type: text/plain; charset=utf-8
Date: Tue, 13 Jan 2009 10:37:44 +0100
Message-Id: <1231839464.14655.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-13 at 16:57 +0800, Zhang, Yanmin wrote:
> Comparing with 2.6.28's results, specjbb2005 has about 7% regression with 2.6.29-rc1
> on my a couple of x86_64 machines. aim7 has about 1.7% regression.
> 
> Ming did a quick bisect with aim7 and located below patch.
> 
> ﻿commit 0a582440ff546e2c6610d1acec325e91b4efd313
> Author: Mike Galbraith <efault@gmx.de>
> Date:   Fri Jan 2 12:16:42 2009 +0100
> 
>     sched: fix sched_slice()
>     
>     Impact: fix bad-interactivity buglet
>     
>     Fix sched_slice() to emit a sane result whether a task is currently
>     enqueued or not.
>     
>     Signed-off-by: Mike Galbraith <efault@gmx.de>
>     Tested-by: Jayson King <dev@jaysonking.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> After we revert the patch, aim7 regression disappeared. specjbb2005 regression becomes
> less than 1.5% on 8-core stokley and disappears on 16-core tigerton. I don't know what
> causes the last 1.5% regression.
> 
> As tbench has about 5% improvement and oltp(mysql+sysbench) has 5% improvement, we also tested
> to make sure such improvement isn't related to above patch. volanoMark's improvement is also not
> related to the patch. So it seems safe to revert it.

No, it's not safe to just revert.  You can replace it with something
else, but as long as sched_slice() is called for unqueued tasks, it must
emit sane slices, otherwise you can experience a latency-hit-from-hell.

See thread: problem with "sched: revert back to per-rq vruntime"?

	-Mike

