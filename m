Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbXIMPPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbXIMPPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 11:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbXIMPPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 11:15:39 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:37985 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756280AbXIMPPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 11:15:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=SNNldjHvZPVC74bxdMnEzRqXjr9Uvfy8N7sWOzAD/W5FYm0cGcquAVtDqhOCXDm66bFmnmeZqLEAC1jXhugNN7hvd7HyuREuvLASAt4/0/J4dT0JJAZ21DYx8ut9irvlIt9x4xsa8tNGQe9GTQkCGJLSO6PfPPzquftTEu3u4No=  ;
X-YMail-OSG: BbKFCckVM1nzMgE8SRL2xddFxN9bcXYuknUY4q61igu_C9AeCImy_whZjDlBpS.d4t0pZQHXdRylW4b07vnkdiDXGsrYe.jjpaZ60NZ6VPuBLC1Wowo-
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: davids@webmaster.com, Antoine Martin <antoine@nagafix.co.uk>
Subject: Re: some bad numbers with Java/database threading
Date: Thu, 13 Sep 2007 09:33:51 +1000
User-Agent: KMail/1.9.5
Cc: "Linux Kernel Development" <linux-kernel@vger.kernel.org>
References: <MDEHLPKNGKAHNMBLJOLKOEDIGMAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKOEDIGMAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709130933.51278.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 September 2007 17:18, David Schwartz wrote:
> > I was working on some unit tests and thought I'd give CFS a whirl to see
> > if it had any impact on my workloads (to see what the fuss was about),
> > and I came up with some pretty disturbing numbers:
> > http://devloop.org.uk/documentation/database-performance/Linux-Ker
> > nels/Kernels-ManyThreads-CombinedTests-noload2.png
> > As above but also showing the load average:
> > http://devloop.org.uk/documentation/database-performance/Linux-Ker
> > nels/Kernels-ManyThreads-CombinedTests2.png
> > Looks like a regression to me...
>
> I've tried reasonalby diligently to figure out what the hell you're doing

(cc's readded please reply to all when replying to lkml)

Hi David,

You might be sounding a bit too abrasive here... I understand you're
also trying to help, but your tone just might be taken the wrong way.

Antonie is really doing the right thing here to test such a new feature
early and on the code he cares about as a user. And most importantly,
reporting it here. This is probably the most useful resource we have in
Linux.

Maybe the workload is quirky, but regardless, if it is a *regression*
from a previous kernel then it is really important to be brought to our
attention.


> and gone through quite a bit of your documentation, and I just can't figure
> it out. This could entirely be the result of your test's sensitivity to
> execution order.
>
> For example, if you run ten threads that all insert, query, and delete from
> the *same* table, then the exact interleaving pattern will determine the
> size of the results. A slight change in the scheduling quantum could
> multiply the size of the result data by a huge factor. There is a big
> difference between:
>
> 1) Thread A inserts data.
> 2) Thread A queries data.
> 3) Thread A deletes data.
> 4) Thread B inserts data.
> ...
>
>
> and
> 1) Thread A inserts data.
> 2) Thread B insers data.
> ...
> 101) Thread A queries data.
> 102) Thread B queries data.
> ...
>
> Now, even if they're using separate tables, your test is still very
> sensitive to execution order. If thread A runs to completion and then
> thread B does, the database data will fit better into cache. If thread A
> runs partially, then thread B runs partially, when thread A runs again, its
> database stuff will not be hot.
>
> >* java threads are created first and the data is prepared, then all the
> >threads are started in a tight loop. Each thread runs multiple queries
> >with a 10ms pause (to allow the other threads to get scheduled)
>
> There are a number of ways you might be measuring nothing but how the
> scheduler chooses to interleave your threads. Benchmarking threads that
> yield suggests just this type of thing -- if a thread has useful work to do
> and another thread is not going to help it, *why* *yield*?
>
> Are you worried the scheduler isn't going to schedule other threads?! Or is
> there some sane reason to force suboptimal scheduling when you're trying to
> benchmark a scheduler? Are you trying to see how it deals with pathological
> patterns? ;)
>
> The only documentation I can see about what you're actually *doing* says
> things like "The schema and statements are almost identical to the
> non-threaded tests." Do you see why that's not helpful?
