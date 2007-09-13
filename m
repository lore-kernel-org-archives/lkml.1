Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbXIMHTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbXIMHTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 03:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbXIMHTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 03:19:32 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2680 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbXIMHTc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 03:19:32 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux Kernel Development" <linux-kernel@vger.kernel.org>
Subject: RE: some bad numbers with Java/database threading
Date: Thu, 13 Sep 2007 00:18:36 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEDIGMAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <46E871FE.9010908@nagafix.co.uk>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 13 Sep 2007 00:19:11 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 13 Sep 2007 00:19:13 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I was working on some unit tests and thought I'd give CFS a whirl to see
> if it had any impact on my workloads (to see what the fuss was about),
> and I came up with some pretty disturbing numbers:
> http://devloop.org.uk/documentation/database-performance/Linux-Ker
> nels/Kernels-ManyThreads-CombinedTests-noload2.png
> As above but also showing the load average:
> http://devloop.org.uk/documentation/database-performance/Linux-Ker
> nels/Kernels-ManyThreads-CombinedTests2.png
> Looks like a regression to me...

I've tried reasonalby diligently to figure out what the hell you're doing and gone through quite a bit of your documentation, and I just can't figure it out. This could entirely be the result of your test's sensitivity to execution order.

For example, if you run ten threads that all insert, query, and delete from the *same* table, then the exact interleaving pattern will determine the size of the results. A slight change in the scheduling quantum could multiply the size of the result data by a huge factor. There is a big difference between:

1) Thread A inserts data.
2) Thread A queries data.
3) Thread A deletes data.
4) Thread B inserts data.
...


and
1) Thread A inserts data.
2) Thread B insers data.
...
101) Thread A queries data.
102) Thread B queries data.
...

Now, even if they're using separate tables, your test is still very sensitive to execution order. If thread A runs to completion and then thread B does, the database data will fit better into cache. If thread A runs partially, then thread B runs partially, when thread A runs again, its database stuff will not be hot.

>* java threads are created first and the data is prepared, then all the
>threads are started in a tight loop. Each thread runs multiple queries
>with a 10ms pause (to allow the other threads to get scheduled)

There are a number of ways you might be measuring nothing but how the scheduler chooses to interleave your threads. Benchmarking threads that yield suggests just this type of thing -- if a thread has useful work to do and another thread is not going to help it, *why* *yield*?

Are you worried the scheduler isn't going to schedule other threads?! Or is there some sane reason to force suboptimal scheduling when you're trying to benchmark a scheduler? Are you trying to see how it deals with pathological patterns? ;)

The only documentation I can see about what you're actually *doing* says things like "The schema and statements are almost identical to the non-threaded tests." Do you see why that's not helpful?

DS


