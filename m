Return-Path: <linux-kernel-owner+w=401wt.eu-S1765543AbXIMVsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765543AbXIMVsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 17:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757204AbXIMVsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 17:48:22 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3763 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757303AbXIMVsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 17:48:21 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: some bad numbers with Java/database threading
Date: Thu, 13 Sep 2007 14:47:36 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKIEHLGMAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
In-Reply-To: <46E9893C.1060709@nagafix.co.uk>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 13 Sep 2007 14:48:20 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 13 Sep 2007 14:48:21 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


First, let me apologize if the tone of my other post came through as angry or frustrated. Text can sometimes be misleading as to tone. I certainly wasn't angry.

Second, let me say that I'm definitely not suggesting that you were wrong to bring this to everyone's attention. Even if it turns out that your code is horribly broken and it's all your fault, any apparent regression still has to be investigated. It is virtually certain that we will learn something interesting about either your code, CFS, or both.

I was definitely *not* saying "how dare you challenge CFS' supremacy without a perfect test case".

Antoine Martin wrote:

> >> Now, even if they're using separate tables, your test is still very
> >> sensitive to execution order. If thread A runs to completion and then
> >> thread B does, the database data will fit better into cache. 
> >> If thread A
> >> runs partially, then thread B runs partially, when thread A 
> >> runs again, its
> >> database stuff will not be hot.

> You are correct, it is very sensitive to the execution order and
> caching. When I vary the thread pause, the total execution time varies
> widely. 10ms just happens to be the sweet spot which provides the best
> contrast in the results (for both kernels and rdbms)

> >> Or is
> >> there some sane reason to force suboptimal scheduling when 
> >> you're trying to
> >> benchmark a scheduler? Are you trying to see how it deals with 
> >> pathological
> >> patterns? ;)

> I know it sounds sub-optimal, but this benchmark wasn't designed to test
> the scheduler! It is meant to thrash just one database table. It isn't
> meant to be anything like TPC either.
> Previously it did uncover some very noticeable differences in JVM
> performance when stress-tested with a large amount of threads.

The problem is that because your access pattern is pathological, schedulers that are objectively worse may turn in much better performance. For example, a scheduler that completely ignores your attempt to sleep will probably perform significantly better than a scheduler that goes out of its way to honor it.

That the execution time is very sensitive to the pause is strong evidence of this.

The problem is simply that your test program doesn't do a fixed amount of work. It does a variable amount of work, and that amount depends upon scheduler details. It's like a job that has fifty threads that do this:

1) Increment a shared variable.
2) Do a math problem a number of times equal to the value of that shared variable.
3) Decrement the shared variable.

The problem is that the number of times the math problem is done depends upon the execution order of the threads. To be fair, you would need to benchmark how many times the math problem gets done, not how long the threads take to complete.

Now, imagine if I insert a yield between steps 1 and 2. The more a scheduler honors your yield request, the worse it will appear to perform. The scheduler that ignores it (which is legal, but definitely not The Right Thing) will seem to perform *much* better.

Of course, it's also possible that this is not what's going on.

DS


