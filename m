Return-Path: <linux-kernel-owner+w=401wt.eu-S1759034AbXHUGJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbXHUGJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 02:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbXHUGI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 02:08:56 -0400
Received: from mx10.go2.pl ([193.17.41.74]:50541 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753378AbXHUGIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 02:08:55 -0400
Date: Tue, 21 Aug 2007 08:09:56 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Dan Aloni <da-x@monatomic.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W\. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] tty_io.c: don't use flush_scheduled_work()
Message-ID: <20070821060956.GA1778@ff.dom.local>
References: <20070701153749.GA111@tv-sign.ru> <20070816115349.GA26908@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070816115349.GA26908@localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 02:53:50PM +0300, Dan Aloni wrote:
> On Sun, Jul 01, 2007 at 07:37:49PM +0400, Oleg Nesterov wrote:
> > I don't know how to test this patch, the ack/nack from maintainer is wanted.
> > 
> > flush_scheduled_work() is evil and should be avoided. Change tty_set_ldisc()
> > and release_dev() to use cancel_delayed_work_sync/cancel_work_sync.
> > 
> > I am not sure we really need to call do_tty_hangup() when cancel_work_sync()
> > returns true, but this matches the current behaviour.
> 
> I also noticed this problem recently with 2.6.22, on a 2-CPU box where there 
> was one SCHED_RR userspace process stuck in a busy loop. The box was completely 

IMHO, it was rather a busy sleep.

> responsive but had this annoyance where all tty closings were stuck in 
> flush_scheduled_work(). It's especially noticable when you ssh to the machine
> and then try to log out.
> 
> A temporary workaround was to give just the workqueue events/* threads a 
> SCHED_FIFO static priority of 99, but I have kept that small patch to 
> myself (figured it's just too nasty).

It looks like there was something more than this one SCHED_RR:
probably some high priority task(s) could have preempted workqueue
thread, delaying run_workqueues. Then it should be an interesting test
for this new, 2.6.23 scheduler.

Regards,
Jarek P.

PS: sorry for so delayed responsing.
