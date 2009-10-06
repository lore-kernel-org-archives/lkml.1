Return-Path: <linux-kernel-owner+w=401wt.eu-S1756957AbZJFKMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbZJFKMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 06:12:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756915AbZJFKMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 06:12:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50708 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889AbZJFKMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 06:12:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/2] mlock use lru_add_drain_all_async()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <1254820131.21044.126.camel@laptop>
References: <20091006114052.5FAA.A69D9226@jp.fujitsu.com> <1254820131.21044.126.camel@laptop>
Message-Id: <20091006190507.126C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  6 Oct 2009 19:11:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 2009-10-06 at 11:41 +0900, KOSAKI Motohiro wrote:
> > Recently, Peter Zijlstra reported RT-task can lead to prevent mlock
> > very long time.
> > 
> >   Suppose you have 2 cpus, cpu1 is busy doing a SCHED_FIFO-99 while(1),
> >   cpu0 does mlock()->lru_add_drain_all(), which does
> >   schedule_on_each_cpu(), which then waits for all cpus to complete the
> >   work. Except that cpu1, which is busy with the RT task, will never run
> >   keventd until the RT load goes away.
> > 
> >   This is not so much an actual deadlock as a serious starvation case.
> > 
> > Actually, mlock() doesn't need to wait to finish lru_add_drain_all().
> > Thus, this patch replace it with lru_add_drain_all_async().
> > 
> > Cc: Oleg Nesterov <onestero@redhat.com>
> > Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl> 
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> It was actually Mike Galbraith who brought it to my attention.
> 
> Patch looks sane enough, altough I'm not sure I'd have split it in two
> like you did (leaves the first without a real changelog too).

Ah, yes. they shold be folded. thanks.
In my local patch queue, this patch series have another two caller.

  - lumpy reclaim: currently, PCP often cause failure large order allocation.
  - page migration: in almost case, PCP doesn't hold the migration target page.

but they are still testing.





