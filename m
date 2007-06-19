Return-Path: <linux-kernel-owner+w=401wt.eu-S1760254AbXFSRT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254AbXFSRT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 13:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757582AbXFSRTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 13:19:19 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:59412 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbXFSRTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 13:19:19 -0400
From: Vernon Mauery <vernux@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [-RT] multiple streams have degraded performance
Date: Tue, 19 Jun 2007 10:19:07 -0700
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
       Ingo Molnar <mingo@elte.hu>
References: <200706182212.22633.vernux@us.ibm.com> <200706190725.30414.vernux@us.ibm.com> <1182267530.7348.367.camel@twins>
In-Reply-To: <1182267530.7348.367.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706191019.08770.vernux@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 June 2007 8:38:50 am Peter Zijlstra wrote:
> On Tue, 2007-06-19 at 07:25 -0700, Vernon Mauery wrote:
> > On Monday 18 June 2007 11:51:38 pm Peter Zijlstra wrote:
> > > On Mon, 2007-06-18 at 22:12 -0700, Vernon Mauery wrote:
> > > > In looking at the performance characteristics of my network I found
> > > > that 2.6.21.5-rt15 suffers from degraded thoughput with multiple
> > > > threads.  The test that I did this with is simply invoking 1, 2, 4,
> > > > and 8 instances of netperf at a time and measuring the total
> > > > throughput.  I have two 4-way machines connected with 10GbE cards.  I
> > > > tested several kernels (some older and some newer) and found that the
> > > > only thing in common was that with -RT kernels the performance went
> > > > down with concurrent streams.
> > > >
> > > > While the test was showing the numbers for receiving as well as
> > > > sending, the receiving numbers are not reliable because that machine
> > > > was running a -RT kernel for these tests.
> > > >
> > > > I was just wondering if anyone had seen this problem before or would
> > > > have any idea on where to start hunting for the solution.
> > >
> > > could you enable CONFIG_LOCK_STAT
> > >
> > > echo 0 > /proc/lock_stat
> > >
> > > <run your test>
> > >
> > > and report the output of (preferably not 80 column wrapped):
> > >
> > > grep : /proc/lock_stat | head
> >
> > /proc/lock_stat stayed empty for the duration of the test.  I am guessing
> > this means there was no lock contention.
>
> Most likely caused by the issue below.
>
> > I do see this on the console:
> > BUG: scheduling with irqs disabled: IRQ-8414/0x00000000/9494
> > caller is wait_for_completion+0x85/0xc4
> >
> > Call Trace:
> >  [<ffffffff8106f3b2>] dump_trace+0xaa/0x32a
> >  [<ffffffff8106f673>] show_trace+0x41/0x64
> >  [<ffffffff8106f6ab>] dump_stack+0x15/0x17
> >  [<ffffffff8106566f>] schedule+0x82/0x102
> >  [<ffffffff81065774>] wait_for_completion+0x85/0xc4
> >  [<ffffffff81092043>] set_cpus_allowed+0xa1/0xc8
> >  [<ffffffff810986e2>] do_softirq_from_hardirq+0x105/0x12d
> >  [<ffffffff810ca6cc>] do_irqd+0x2a8/0x32f
> >  [<ffffffff8103469d>] kthread+0xf5/0x128
> >  [<ffffffff81060f68>] child_rip+0xa/0x12
> >
> > INFO: lockdep is turned off.
> >
> > I haven't seen this until I enabled lock_stat and ran the test.
>
> I think this is what causes the lack of output. It disables all lock
> tracking features...
>
> > > or otherwise if there are any highly contended network locks listed?
> >
> > Any other ideas for debugging this?
>
> fixing the above bug would help :-)
>
> Ingo says that should be fixed in -rt17, so if you could give that a
> spin...

I just tested with -rt17 and the BUG message is gone, but I still don't see 
any entries in.  I don't see any other suspicious message so I think it is 
really strange that is not listing any locks at all.

--Vernon
