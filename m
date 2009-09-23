Return-Path: <linux-kernel-owner+w=401wt.eu-S1752520AbZIWXNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbZIWXNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 19:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbZIWXNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 19:13:52 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:49066 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZIWXNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 19:13:52 -0400
Message-ID: <4ABAAB4F.2060905@nortel.com>
Date: Wed, 23 Sep 2009 17:12:15 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Userspace RCU: (ab)using futexes to save cpu cycles and
 energy
References: <20090923174820.GA12827@Krystal> <4ABA631A.8030306@nortel.com> <20090923190337.GA16983@Krystal> <20090923223204.GA2921@Krystal>
In-Reply-To: <20090923223204.GA2921@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Sep 2009 23:13:53.0326 (UTC) FILETIME=[8477CCE0:01CA3CA3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2009 04:32 PM, Mathieu Desnoyers wrote:


> /*
>  * Defer thread waiting. Single thread.
>  */
> static void wait_defer(void)
> {
>         atomic_dec(&defer_thread_futex);
>         smp_mb();       /* Write futex before read queue */
>         if (rcu_defer_num_callbacks()) {
>                 smp_mb();       /* Read queue before write futex */
>                 /* Callbacks are queued, don't wait. */
>                 atomic_set(&defer_thread_futex, 0);
>         } else {
>                 smp_rmb();      /* Read queue before read futex */
>                 if (atomic_read(&defer_thread_futex) == -1)
>                         futex(&defer_thread_futex, FUTEX_WAIT, -1,
>                               NULL, NULL, 0);
>         }
> }

> The goal here is that if call_rcu() enqueues a callback (even if it
> races with defer thread going to sleep), there should not be a
> potentially infinite delay before it gets executed.

It doesn't seem like the test for the number of callbacks should be
necessary.  I don't see anything like that in the glibc code, nor do I
remember anything like that in the futex sample code.

I'm still not totally convinced that you can avoid race conditions
without using atomic test-and-set or compare-and-exchange.  I haven't
sat down and worked it out completely though.

Chris
