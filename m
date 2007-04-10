Return-Path: <linux-kernel-owner+w=401wt.eu-S1752306AbXDJHhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbXDJHhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 03:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbXDJHhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 03:37:38 -0400
Received: from smtp.osdl.org ([65.172.181.24]:47183 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbXDJHhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 03:37:37 -0400
Date: Tue, 10 Apr 2007 00:37:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Dave Jones <davej@redhat.com>, Robin Holt <holt@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
Message-Id: <20070410003702.f8a49b75.akpm@linux-foundation.org>
In-Reply-To: <461B3754.9040107@garzik.org>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
	<4616CBF0.7090606@garzik.org>
	<20070409172339.48d661d6.akpm@linux-foundation.org>
	<20070410015912.GE1994@redhat.com>
	<20070409193056.6b52c354.akpm@linux-foundation.org>
	<461B3754.9040107@garzik.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007 03:05:56 -0400 Jeff Garzik <jeff@garzik.org> wrote:

> My main 
> worry with keventd is that we might get stuck behind an unrelated 
> process for an undefined length of time.

I don't think it has ever been demonstrated that keventd latency is
excessive, or a problem.  I guess we could instrument it and fix stuff
easily enough.

The main problem with keventd has been flush_scheduled_work() deadlocks: the
caller of flush_scheduled_work() wants to flush work item A, but holds some
lock which is also needed by unrelated work item B.  Most of the time, it
works.  But if item B happens to be queued the flush_scheduled_work() will
deadlock.

The fix is to flush-and-cancel just item A: if it's not running yet, cancel
it.  If it is running, wait until it has finished.  Oleg's

	void cancel_work_sync(struct work_struct *work)

is queued for 2.6.22 and should permit some kthread->keventd conversions
which would previously been deadlocky.


The thing to concentrate on here is the per-cpu threads, which is where the
proliferation appears to be coming from.  Conversions to
schedule_work()+cancel_work_sync() and conversions to
create_singlethread_workqueue().


