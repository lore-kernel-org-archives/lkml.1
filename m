Return-Path: <linux-kernel-owner+w=401wt.eu-S932824AbZJOPzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824AbZJOPzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 11:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762879AbZJOPzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 11:55:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762873AbZJOPzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 11:55:03 -0400
Date: Thu, 15 Oct 2009 08:53:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Oleg Nesterov <oleg@redhat.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Paul Fulghum <paulkf@microgate.com>,
       Boyan <btanastasov@yahoo.co.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
In-Reply-To: <20091015124730.GA9398@redhat.com>
Message-ID: <alpine.LFD.2.01.0910150848520.6146@localhost.localdomain>
References: <1255478932.19056.24.camel@localhost.localdomain> <4AD51D6B.7010509@microgate.com> <alpine.LFD.2.01.0910131744590.3404@localhost.localdomain> <20091014125846.1a3c8d40@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0910140804180.6146@localhost.localdomain>
 <alpine.LFD.2.01.0910140925440.6146@localhost.localdomain> <20091014182037.GA10076@redhat.com> <alpine.LFD.2.01.0910141131050.6146@localhost.localdomain> <20091014195215.GA12936@redhat.com> <alpine.LFD.2.01.0910141344250.6146@localhost.localdomain>
 <20091015124730.GA9398@redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Oct 2009, Oleg Nesterov wrote:

> On 10/14, Linus Torvalds wrote:
> >
> > It's just that we didn't have any way to do that "force the pending
> > delayed work to be scheduled", so instead we ran the scheduled function by
> > hand synchronously. Which then seems to have triggered other problems.
> 
> Yes. But I am not sure these problems are new.

Oh, I agree. I think the locking bug in the tty layer was long-standing, 
it just was impossible to trigger in practice as long as it was only 
called through keventd. The window is fairly small, and for many things 
(like the X keyboard), the amount of data transferred is tiny and you 
don't actually schedule the workqueue very often at all.

> I do not understand this code even remotely, but from a quick grep it 
> seems to me it is possible that flush_to_ldisc() can race with itself 
> even without tty_flush_to_ldisc() which calls work->func() by hand.

Yes, but only in the _very_ special case of scheduling the callback at 
just the right moment. And in fact, traditionally it was always scheduled 
with a timeout, which makes it even less likely to happen.

> Perhaps it makes sense to introduce something like
> 
> 	// same as queue_work(), but ensures work->func() can't race with itself
> 
> 	int queue_work_xxx(struct workqueue_struct *wq, struct work_struct *work)
> 	{
> 		int ret = 0;
> 
> 		if (!test_and_set_bit(WORK_STRUCT_PENDING, work_data_bits(work))) {
> 			struct cpu_workqueue_struct *cwq = get_wq_data(work);
> 			int cpu = get_cpu();
> 
> 			// "cwq->current_work != work" is not strictly needed,
> 			// but we don't want to pin this work to the single CPU.
> 
> 			if (!cwq || cwq->current_work != work)
> 				cwq = wq_per_cpu(wq, cpu);
> 
> 			__queue_work(cwq, work);

Yes. Looks good to me. Just forcing the new one to be on the same CPU as 
the previous one should solve it.

And it should even be good for performance to make it "sticky" to the CPU, 
so I think this could even be done without any new flags or functions.

The people who actually want to run work on multiple CPU's in parallel end 
up always having multiple work structures, so I think the CPU-stickiness 
is good for everybody.

			Linus
