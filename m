Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbZIWSFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbZIWSFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 14:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbZIWSFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 14:05:49 -0400
Received: from zcars04e.nortel.com ([47.129.242.56]:62129 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182AbZIWSFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 14:05:47 -0400
Message-ID: <4ABA631A.8030306@nortel.com>
Date: Wed, 23 Sep 2009 12:04:10 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Userspace RCU: (ab)using futexes to save cpu cycles and
 energy
References: <20090923174820.GA12827@Krystal>
In-Reply-To: <20090923174820.GA12827@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Sep 2009 18:05:47.0947 (UTC) FILETIME=[7A52CFB0:01CA3C78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2009 11:48 AM, Mathieu Desnoyers wrote:

> Here are the primitives I've created. I'd like to have feedback on my
> futex use, just to make sure I did not do any incorrect assumptions.

> /*
>  * Wake-up any waiting defer thread. Called from many concurrent threads.
>  */
> static void wake_up_defer(void)
> {
>         if (unlikely(atomic_read(&defer_thread_futex) == -1))
>                 atomic_set(&defer_thread_futex, 0);
>                 futex(&defer_thread_futex, FUTEX_WAKE,
>                       0, NULL, NULL, 0);
> }

Is it a problem if multiple threads all hit the defer_thread_futex==-1
case simultaneously?  If so, maybe this should use an atomic
test-and-set operation so that only one thread actually calls futex().

> /*
>  * Defer thread waiting. Single thread.
>  */
> static void wait_defer(void)
> {
>         atomic_dec(&defer_thread_futex);
>         if (atomic_read(&defer_thread_futex) == -1)
>                 futex(&defer_thread_futex, FUTEX_WAIT, -1,
>                       NULL, NULL, 0);
> }

Is it a problem if the value of defer_thread_futex changes to zero after
the dec but before the test?

Chris
