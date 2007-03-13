Return-Path: <linux-kernel-owner+w=401wt.eu-S933058AbXCMLMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058AbXCMLMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 07:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933063AbXCMLMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 07:12:25 -0400
Received: from smtp103.plus.mail.mud.yahoo.com ([68.142.206.236]:38412 "HELO
	smtp103.plus.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933058AbXCMLMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 07:12:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Q2onVogaqGkv2/A5MxuGZh/jn1brZQF5DQnXFFhhFmvDs/KkST1KVlFY6MkcnyxCLhJ9B6sRp+g04ZSQ+JnLMZUHOuVQwrj+YSU0E2cGw6r9xPHMdtHxcKstlIVsYnMDsB1c8u25MSKo+kx5wXADHgNHkhlw9fJLi0vYEVhxkdo=  ;
X-YMail-OSG: hUY4OUEVM1mNMPe_KcuB9QMqLLovqMUynYLAcLH7GMOdz1Z.Tw7l65QnseHTedWiN6Os70vZ9cqilZoIruC2NZaF..ChF6ATAOlIgOpc4zVWCUOsagQVvTw2X_E9WtHzzaW.BNCXeYBt6LI-
Message-ID: <45F68713.9040608@yahoo.com.au>
Date: Tue, 13 Mar 2007 22:12:19 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrea Arcangeli <andrea@suse.de>
CC: Anton Blanchard <anton@samba.org>, Rik van Riel <riel@redhat.com>,
       Lorenzo Allegrucci <l_allegrucci@yahoo.it>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: SMP performance degradation with sysbench
References: <1172425476.5489.11.camel@odyssey.lan> <45E21FEC.9060605@redhat.com> <45E2E244.8040009@yahoo.com.au> <20070312220042.GA807@kryten> <45F63266.1080509@yahoo.com.au> <20070313094559.GC8992@v2.random> <45F67796.4040508@yahoo.com.au> <20070313103134.GF8992@v2.random> <45F67F02.5020401@yahoo.com.au> <20070313105742.GG8992@v2.random>
In-Reply-To: <20070313105742.GG8992@v2.random>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> On Tue, Mar 13, 2007 at 09:37:54PM +1100, Nick Piggin wrote:
> 
>>Well it wasn't iowait time. From Anton's analysis, I would probably
>>say it was time waiting for either the glibc malloc mutex or MySQL
>>heap mutex.
> 
> 
> So it again makes little sense to me that this is idle time, unless
> some userland mutex has a usleep in the slow path which would be very
> wrong, in the worst case they should yield() (yield can still waste
> lots of cpu if two tasks in the slow paths calls it while the holder
> is not scheduled, but at least it wouldn't be idle time).

They'll be sleeping in futex_wait in the kernel, I think. One thread
will hold the critical mutex, some will be off doing their own thing,
but importantly there will be many sleeping for the mutex to become
available.

> Idle time is suspicious for a kernel issue in the scheduler or some
> userland inefficiency (the latter sounds more likely).

That is what I first suspected, because the dropoff appeared to happen
exactly after we saturated the CPU count: it seems like a scheduler
artifact.

However, I tested with a bigger system and actually the idle time
comes before we saturate all CPUs. Also, increasing the aggressiveness
of the load balancer did not drop idle time at all, so it is not a case
of some runqueues idle while others have many threads on them.


I guess googlemalloc (tcmalloc?) isn't suitable for a general purpose
glibc allocator. But I wonder if there are other improvements that glibc
can do here?

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
