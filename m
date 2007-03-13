Return-Path: <linux-kernel-owner+w=401wt.eu-S1030275AbXCMMJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030275AbXCMMJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 08:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965702AbXCMMJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 08:09:05 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:28906 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965705AbXCMMJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 08:09:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=WvmcjPyyQ35UiU3a5BPJmyKruMZ9UQkzKAYkX69MBTn60ZcpKCg+/5h6G4WLKslDzmsdLLBah/wp4mTtL0p/kWNmw5OzY+vhTP2H7p3wQ+bj4MTdg/UXAOBzvXOhqai8GxqK1+ZPwA2ckR6V8+FVYBcVYjsdoMpfQaS2ov4HhIE=  ;
X-YMail-OSG: rSnmq_oVM1nrI.gydGAU73dx7CX_VyvAg00U7GzfAqBUHbIzsyN0P8hsorpvqWmUBGVrHtQYLQpOryMV1hzxwzpXshTa73Jx6CKL38iUmiWZYVjJ6pcThJPm9lQKK7oCC9oSerF4z_09_sI-
Message-ID: <45F6945B.2030309@yahoo.com.au>
Date: Tue, 13 Mar 2007 23:08:59 +1100
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
References: <45E21FEC.9060605@redhat.com> <45E2E244.8040009@yahoo.com.au> <20070312220042.GA807@kryten> <45F63266.1080509@yahoo.com.au> <20070313094559.GC8992@v2.random> <45F67796.4040508@yahoo.com.au> <20070313103134.GF8992@v2.random> <45F67F02.5020401@yahoo.com.au> <20070313105742.GG8992@v2.random> <45F68713.9040608@yahoo.com.au> <20070313114215.GI8992@v2.random>
In-Reply-To: <20070313114215.GI8992@v2.random>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea Arcangeli wrote:
> On Tue, Mar 13, 2007 at 10:12:19PM +1100, Nick Piggin wrote:
> 
>>They'll be sleeping in futex_wait in the kernel, I think. One thread
>>will hold the critical mutex, some will be off doing their own thing,
>>but importantly there will be many sleeping for the mutex to become
>>available.
> 
> 
> The initial assumption was that there was zero idle time with threads
> = cpus and the idle time showed up only when the number of threads
> increased to the double the number of cpus. If the idle time wouldn't
> increase with the number of threads, nothing would be suspect.

Well I think more threads ~= more probability that this guy is going to
be preempted while holding the mutex?

This might be why FreeBSD works much better, because it looks like MySQL
actually will set RT scheduling for those processes that take critical
resources.

>>However, I tested with a bigger system and actually the idle time
>>comes before we saturate all CPUs. Also, increasing the aggressiveness
>>of the load balancer did not drop idle time at all, so it is not a case
>>of some runqueues idle while others have many threads on them.
> 
> 
> It'd be interesting to see the sysrq+t after the idle time
> increased.
> 
> 
>>I guess googlemalloc (tcmalloc?) isn't suitable for a general purpose
>>glibc allocator. But I wonder if there are other improvements that glibc
>>can do here?
> 
> 
> My wild guess is that they're allocating memory after taking
> futexes. If they do, something like this will happen:
> 
>      taskA		taskB		taskC
>      user lock
> 			mmap_sem lock
>      mmap sem -> schedule
> 					user lock -> schedule
> 
> If taskB wouldn't be there triggering more random trashing over the
> mmap_sem, the lock holder wouldn't wait and task C wouldn't wait too.
> 
> I suspect the real fix is not to allocate memory or to run other
> expensive syscalls that can block inside the futex critical sections...


I would agree that it points to MySQL scalability issues, however the
fact that such large gains come from tcmalloc is still interesting.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
