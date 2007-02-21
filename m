Return-Path: <linux-kernel-owner+w=401wt.eu-S1423128AbXBUVTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423128AbXBUVTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 16:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423133AbXBUVTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 16:19:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50473 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423128AbXBUVTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 16:19:30 -0500
Date: Wed, 21 Feb 2007 22:13:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070221211355.GA7302@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.9
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.9 required=5.9 tests=ALL_TRUSTED,BAYES_05 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0340]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

this is the v3 release of the syslet/threadlet subsystem:

   http://redhat.com/~mingo/syslet-patches/

This release came a few days later than i originally wanted, because 
i've implemented many fundamental changes to the code. The biggest 
highlights of v3 are:

 - "Threadlets": the introduction of the 'threadlet' execution concept.

 - syslets: multiple rings support with no kernel-side footprint, the 
   elimination of mlock() pinning, no async_register/unregister() calls 
   needed anymore and more.

"Threadlets" are basically the user-space equivalent of syslets: small 
functions of execution that the kernel attempts to execute without 
scheduling. If the threadlet blocks, the kernel creates a real thread 
from it, and execution continues in that thread. The 'head' context (the 
context that never blocks) returns to the original function that called 
the threadlet. Threadlets are very easy to use:

long my_threadlet_fn(void *data)
{
	char *name = data;
	int fd;

	fd = open(name, O_RDONLY);
	if (fd < 0)
		goto out;

	fstat(fd, &stat);
	read(fd, buf, count)
	...

out:
	return threadlet_complete();
}


main()
{
	done = threadlet_exec(threadlet_fn, new_stack, &user_head);
	if (!done)
		reqs_queued++;
}

There is no limitation whatsoever about how a threadlet function can 
look like: it can use arbitrary system-calls and all execution will be 
procedural. There is no 'registration' needed when running threadlets 
either: the kernel will take care of all the details, user-space just 
runs a threadlet without any preparation and that's it.

Completion of async threadlets can be done from user-space via any of 
the existing APIs: in threadlet-test.c (see the async-test-v3.tar.gz 
user-space examples at the URL above) i've for example used a futex 
between the head and the async threads to do threadlet notification. But 
select(), poll() or signals can be used too - whichever is most 
convenient to the application writer.

Threadlets can also be thought of as 'optional threads': they execute in 
the original context as long as they do not block, but once they block, 
they are moved off into their separate thread context - and the original 
context can continue execution.

Threadlets can also be thought of as 'on-demand parallelism': user-space 
does not have to worry about setting up, sizing and feeding a thread 
pool - the kernel will execute the workload in a single-threaded manner 
as long as it makes sense, but once the context blocks, a parallel 
context is created. So parallelism inside applications is utilized in a 
natural way. (The best place to do this is in the kernel - user-space 
has no idea about what level of parallelism is best for any given 
moment.)

I believe this threadlet concept is what user-space will want to use for 
programmable parallelism.

[ Note that right now there's a pair of system-calls: sys_threadlet_on() 
  and sys_threadlet_off() that demarks the beginning and the end of a 
  syslet function, which enter the kernel even in the 'cached' case - 
  but my plan is to do these two system calls via a vsyscall, without 
  having to enter the kernel at all. That will reduce cached threadlet 
  execution NULL-overhead to around 10 nsecs - making it essentially 
  zero. ]

Threadlets share much of the scheduling infrastructure with syslets.

Syslets (small, kernel-side, scripted "syscall plugins") are still 
supported - they are (much...) harder to program than threadlets but 
they allow the highest performance. Core infrastructure libraries like 
glibc/libaio are expected to use syslets. Jens Axboe's FIO tool already 
includes support for v2 syslets, and the following patch updates FIO to 
the v3 API:

   http://redhat.com/~mingo/syslet-patches/fio-syslet-v3.patch

Furthermore, the syslet code and API has been significantly enhanced as 
well:

 - support for multiple completion rings has been added

 - there is no more mlock()ing of the completion ring(s)

 - sys_async_register()/unregister() has been removed as it is not 
   needed anymore. sys_async_exec() can be called straight away.

 - there is no kernel-side resource used up by async completion rings at 
   all (all the state is in user-space), so an arbitrary number of
   completion rings are supported.

plus lots of bugs were fixed and a good number of cleanups were done as 
well. The v3 code is ABI-incompatible with v2, due to these fundamental 
changes.

As always, comments, suggestions, reports are welcome.

	Ingo
