Return-Path: <linux-kernel-owner+w=401wt.eu-S932145AbXBMOYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbXBMOYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 09:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932141AbXBMOYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 09:24:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33113 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932126AbXBMOXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 09:23:44 -0500
Date: Tue, 13 Feb 2007 15:20:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system call support
Message-ID: <20070213142010.GA638@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20060529212109.GA2058@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm pleased to announce the first release of the "Syslet" kernel feature 
and kernel subsystem, which provides generic asynchrous system call 
support:

   http://redhat.com/~mingo/syslet-patches/

Syslets are small, simple, lightweight programs (consisting of 
system-calls, 'atoms') that the kernel can execute autonomously (and, 
not the least, asynchronously), without having to exit back into 
user-space. Syslets can be freely constructed and submitted by any 
unprivileged user-space context - and they have access to all the 
resources (and only those resources) that the original context has 
access to.

because the proof of the pudding is eating it, here are the performance 
results from async-test.c which does open()+read()+close() of 1000 small 
random files (smaller is better):

                  synchronous IO      |   Syslets:
                  --------------------------------------------
  uncached:       45.8 seconds        |  34.2 seconds   ( +33.9% )
  cached:         31.6 msecs          |  26.5 msecs     ( +19.2% )

("uncached" results were done via "echo 3 > /proc/sys/vm/drop_caches". 
The default IO scheduler was the deadline scheduler, the test was run on 
ext3, using a single PATA IDE disk.)

So syslets, in this particular workload, are a nice speedup /both/ in 
the uncached and in the cached case. (note that i used only a single
disk, so the level of parallelism in the hardware is quite limited.)

the testcode can be found at:

     http://redhat.com/~mingo/syslet-patches/async-test-0.1.tar.gz

The boring details:

Syslets consist of 'syslet atoms', where each atom represents a single 
system-call. These atoms can be chained to each other: serially, in 
branches or in loops. The return value of an executed atom is checked 
against the condition flags. So an atom can specify 'exit on nonzero' or 
'loop until non-negative' kind of constructs.

Syslet atoms fundamentally execute only system calls, thus to be able to 
manipulate user-space variables from syslets i've added a simple special 
system call: sys_umem_add(ptr, val). This can be used to increase or 
decrease the user-space variable (and to get the result), or to simply 
read out the variable (if 'val' is 0).

So a single syslet (submitted and executed via a single system call) can 
be arbitrarily complex. For example it can be like this:

       --------------------
       |     accept()     |-----> [ stop if returns negative ]
       --------------------
                |
                V
  -------------------------------
  |   setsockopt(TCP_NODELAY)   |-----> [ stop if returns negative ]
  -------------------------------
                |
                v
       --------------------
       |      read()      |<---------
       --------------------         | [ loop while positive ]
           |    |                   |
           |    ---------------------
           |
        -----------------------------------------
        | decrease and read user space variable |
        -----------------------------------------                    A
                    |                                                |
                    -------[ loop back to accept() if positive ]------

(you can find a VFS example and a hello.c example in the user-space 
testcode.)

A syslet is executed opportunistically: i.e. the syslet subsystem 
assumes that the syslet will not block, and it will switch to a 
cachemiss kernel thread from the scheduler. This means that even a 
single-atom syslet (i.e. a pure system call) is very close in 
performance to a pure system call. The syslet NULL-overhead in the 
cached case is roughly 10% of the SYSENTER NULL-syscall overhead. This 
means that two atoms are a win already, even in the cached case.

When a 'cachemiss' occurs, i.e. if we hit schedule() and are about to 
consider other threads, the syslet subsystem picks up a 'cachemiss 
thread' and switches the current task's user-space context over to the 
cachemiss thread, and makes the cachemiss thread available. The original 
thread (which now becomes a 'busy' cachemiss thread) continues to block. 
This means that user-space will still be executed without stopping - 
even if user-space is single-threaded.

if the submitting user-space context /knows/ that a system call will 
block, it can request immediate 'cachemiss' via the SYSLET_ASYNC flag. 
This would be used if for example an O_DIRECT file is read() or 
write()n.

likewise, if user-space knows (or expects) that a system call takes alot 
of CPU time even in the cached case, and it wants to offload it to 
another asynchronous context, it can request that via the SYSLET_ASYNC 
flag too.

completions of asynchronous syslets are done via a user-space ringbuffer 
that the kernel fills and user-space clears. Waiting is done via the 
sys_async_wait() system call. Completion can be supressed on a per-atom 
basis via the SYSLET_NO_COMPLETE flag, for atoms that include some 
implicit notification mechanism. (such as sys_kill(), etc.)

As it might be obvious to some of you, the syslet subsystem takes many 
ideas and experience from my Tux in-kernel webserver :) The syslet code 
originates from a heavy rewrite of the Tux-atom and the Tux-cachemiss 
infrastructure.

Open issues:

 - the 'TID' of the 'head' thread currently varies depending on which 
   thread is running the user-space context.

 - signal support is not fully thought through - probably the head 
   should be getting all of them - the cachemiss threads are not really 
   interested in executing signal handlers.

 - sys_fork() and sys_async_exec() should be filtered out from the 
   syscalls that are allowed - first one only makes sense with ptregs, 
   second one is a nice kernel recursion thing :) I didnt want to 
   duplicate the sys_call_table though - maybe others have a better 
   idea.

See more details in Documentation/syslet-design.txt. The patchset is 
against v2.6.20, but should apply to the -git head as well.

Thanks to Zach Brown for the idea to drive cachemisses via the 
scheduler. Thanks to Arjan van de Ven for early review feedback.

Comments, suggestions, reports are welcome!

	Ingo
