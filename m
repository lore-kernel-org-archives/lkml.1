Return-Path: <linux-kernel-owner+w=401wt.eu-S1759062AbXGaPdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759062AbXGaPdi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 11:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbXGaPda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 11:33:30 -0400
Received: from mcclure-nat.wal.novell.com ([130.57.22.22]:21814 "EHLO
	mcclure.wal.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750861AbXGaPd3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 11:33:29 -0400
Message-Id: <46AF1DA6.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 31 Jul 2007 11:33:26 -0400
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, <linux-kernel@vger.kernel.org>,
       <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 0/2][RFC] VFCIPI v3
References: <20070731132153.4790.37217.stgit@novell1.haskins.net>
 <1185891957.12034.12.camel@twins>
In-Reply-To: <1185891957.12034.12.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Tue, Jul 31, 2007 at 10:25 AM, in message <1185891957.12034.12.camel@twins>,
Peter Zijlstra <peterz@infradead.org> wrote: 

> Hi Gregory,
> 
> This patch set approaches the problem from the wrong angle (and has a
> few problems due to that).
> 
> The idea to use a workqueue (or in your case workqueue-like) solution to
> the problem is valid, however instead of re-using (and improving) the
> current workqueue infrastructure, you re-implement it 

This was partially due to my own ignorance of the full workqueue facilities.  I was only familiar with "schedule_work" and I had it banged into my head that you can't guarantee which CPU a workqueue runs on *ever*.  I wasn't familiar with schedule_work_on_cpu() or its ability to direct the desination, which is very cool.  Thanks to you and Ingo for pointing it out to me.

The other side to my decision (and the reason why I didnt actually go dig into the code to see if I could fix the previously mentioned "limitation") was that I was trying to avoid disrupting a primary datapath like workqueue.  I thought I could hang this thing on the side so that it only affected the smp_call facility.

I see now that that was a mistake.  I will tackle the implementation again with this new approach.

>(with mistakes).

If there was anything more than what you already mention here, please point them out so I don't "port" them over to the workqueues implemenation ;)

> 
> Your idea that GFP_ATOMIC is broken in -rt is unfortunate, it isn't. The
> whole allocator is preemptable - that is a feature!

Heh...that may be, and I can see how it is useful to have the allocatorr be generally preemptible.  However, I would have thought that "GFP_ATOMIC" means I can call it from atomic code, which is not the case apparently.  It's probably just my own ignorance again of what that flag should really mean ;)

In any case I abstracted the heap_allocator away so that I could make an in_atomic friendly allocation.  If the GFP_ATOMIC allocator ever supports in_atomic in the future, all we have to do is change vfcipi/heap.h.  I am open to other suggestions to this problem, of course.

Regards,
-Greg

