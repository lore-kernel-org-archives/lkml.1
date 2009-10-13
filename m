Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbZJMDS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbZJMDS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 23:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbZJMDS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 23:18:56 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36273 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbZJMDSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 23:18:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [resend][PATCH v2] mlock() doesn't wait to finish lru_add_drain_all()
Cc: kosaki.motohiro@jp.fujitsu.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Oleg Nesterov <onestero@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
In-Reply-To: <20091012185139.75c13648.akpm@linux-foundation.org>
References: <20091013090347.C752.A69D9226@jp.fujitsu.com> <20091012185139.75c13648.akpm@linux-foundation.org>
Message-Id: <20091013110409.C758.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 13 Oct 2009 12:18:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 13 Oct 2009 10:17:48 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > Hi
> > 
> > > On Fri,  9 Oct 2009 11:21:55 +0900 (JST)
> > > KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > 
> > > > Recently, Mike Galbraith reported mlock() makes hang-up very long time in
> > > > his system. Peter Zijlstra explainted the reason.
> > > > 
> > > >   Suppose you have 2 cpus, cpu1 is busy doing a SCHED_FIFO-99 while(1),
> > > >   cpu0 does mlock()->lru_add_drain_all(), which does
> > > >   schedule_on_each_cpu(), which then waits for all cpus to complete the
> > > >   work. Except that cpu1, which is busy with the RT task, will never run
> > > >   keventd until the RT load goes away.
> > > > 
> > > >   This is not so much an actual deadlock as a serious starvation case.
> > > > 
> > > > His system has two partions using cpusets and RT-task partion cpu doesn't
> > > > have any PCP cache. thus, this result was pretty unexpected.
> > > > 
> > > > The fact is, mlock() doesn't need to wait to finish lru_add_drain_all().
> > > > if mlock() can't turn on PG_mlock, vmscan turn it on later.
> > > > 
> > > > Thus, this patch replace it with lru_add_drain_all_async().
> > > 
> > > So why don't we just remove the lru_add_drain_all() call from sys_mlock()?
> > 
> > There are small reason. the administrators and the testers (include me)
> > look at Mlock field in /proc/meminfo.
> > They natually expect Mlock field match with actual number of mlocked pages
> > if the system don't have any stress. Otherwise, we can't make mlock test case ;)
> > 
> > 
> > > How did you work out why the lru_add_drain_all() is present in
> > > sys_mlock() anyway?  Neither the code nor the original changelog tell
> > > us.  Who do I thwap for that?  Nick and his reviewers.  Sigh.
> > 
> > [Umm, My dictionaly don't tell me the meaning of "thwap".  An meaning of
> > an imitative word strongly depend on culture. Thus, I probably
> > misunderstand this paragraph.]
> 
> "slap"?
> 
> > I've understand the existing reason by looooooong time review.
> > 
> > 
> > > There are many callers of lru_add_drain_all() all over the place.  Each
> > > of those is vulnerable to the same starvation issue, is it not?
> > 
> > There are.
> > 
> > > If so, it would be better to just fix up lru_add_drain_all().  Afaict
> > > all of its functions can be performed in hard IRQ context, so we can
> > > use smp_call_function()?
> > 
> > There is a option. but it have one downside, it require lru_add_pvecs
> > related function call irq_disable().
> 
> I don't know what this means.  ____pagevec_lru_add() (for example) can
> be trivially changed from spin_lock_irq() to spin_lock_irqsave().
> 
> In other cases we can perhaps split an existing
> 
> foo()
> {
> 	spin_lock_irq(zone->lock);
> }
> 
> into
> 
> __foo()
> {
> 	spin_lock(zone->lock);
> }
> 
> foo()
> {
> 	local_irq_disable()
> 	__foo();
> }
> 
> then call the new __foo().

The problem is in __lru_cache_add().

============================================================
void __lru_cache_add(struct page *page, enum lru_list lru)
{
        struct pagevec *pvec = &get_cpu_var(lru_add_pvecs)[lru];

        page_cache_get(page);
        if (!pagevec_add(pvec, page))
                ____pagevec_lru_add(pvec, lru);
        put_cpu_var(lru_add_pvecs);
}
============================================================

current typical scenario is
1. preempt disable
2. assign lru_add_pvec
3. page_cache_get()
4. pvec->pages[pvec->nr++] = page;
5. preempt enable

but the preempt disabling assume drain_cpu_pagevecs() run on process context.
we need to convert it with irq_disabling.

I don't know this how much serious. I haven't mesure it. Yes, I can.
I will report this result as another mail.

Thanks.

