Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbYGBQbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbYGBQbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 12:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbYGBQbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 12:31:09 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:53740 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389AbYGBQbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 12:31:08 -0400
Date: Wed, 2 Jul 2008 20:33:31 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] workqueues: implement flush_work()
Message-ID: <20080702163331.GA565@tv-sign.ru>
References: <20080629144926.GA4347@tv-sign.ru> <20080630132512.GA2663@ami.dom.local> <20080701125018.GA99@tv-sign.ru> <20080701210300.GA3272@ami.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080701210300.GA3272@ami.dom.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01, Jarek Poplawski wrote:
>
> On Tue, Jul 01, 2008 at 04:50:18PM +0400, Oleg Nesterov wrote:
> ...
> > Yes, cwq can be "stale", but this doesn't matter and we can't have
> > the false positive here.
> > 
> > cwq->current_work is always changed under cwq->lock, and we hold this
> > lock. If we see "cwq->current_work == work" we can safely insert the
> > barrier and wait. Even if this work was already re-queued on another
> > CPU or another workqueue_struct.
> > 
> > Note also that rmb() can't really help here.
> 
> Right! The question is how "stale" this cwq could be when read without
> any lock or barrier. Of course, there can't be the false positive, but
> I wonder if we really do enough, to check if a work isn't current on
> some other cwq, even without any immediate re-queuing.

Not sure I understand...

Of course, the work can be current on _all_ CPUs. So no, we don't do
enough. Please look at the changelog, in particular the note about
flush_work_sync().

But without re-queuing cwq can't be wrong? Once again, flush_work()
flushes the result of the last visible queue_work(). If not requeued,
the work is either current, or it is pending and list_empty() == F.

Oleg.

