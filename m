Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbYGKSBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbYGKSBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 14:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbYGKSBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 14:01:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753606AbYGKSBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 14:01:09 -0400
Date: Fri, 11 Jul 2008 10:58:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Roland McGrath <roland@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Elias Oltmanns <eo@nebensachen.de>,
       =?ISO-8859-15?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] x86_64: fix delayed signals
In-Reply-To: <20080711054605.GA17851@elte.hu>
Message-ID: <alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org>
References: <20080710215039.2A143154218@magilla.localdomain> <20080711054605.GA17851@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Jul 2008, Ingo Molnar wrote:
> 
> nice find! Roland, is this related to the thread started by Elias 
> Oltmanns yesterday:
> 
>     http://lkml.org/lkml/2008/7/10/57

No.

First off, the delayed sending of signals isn't actually delayed that 
much. It's the next kernel entry at the most - certainly *not* across 
scheduling points, which the fact that ^Z shows up in the xterm says 
happen.

Secondly, it seems to happen on x86-32 too, and it is claimed to be a 
regression. Neither of which would be true for this case.

Thirdly, there seems to be no other signals involved (ie it's a single 
signal).

I think the IO interactivity report is simply because of IO scheduling 
and/or paging out the shell too aggressively. No signals will be delivered 
while the process in in 'D' state (the new 'killable' thing being an 
exception in _some_ cases, but that's literally just for killing signals, 
not backgrounding).

So to look at the original report:

 "By sprinkling some printk()s all over the place, I've managed to
  establish the following sequence of events taking place in the event of
  delayed signal handling as described above:
  The first Ctrl+Z event enqueues a SIGTSTP signal which eventually
  results in a call to kick_process(). For some reason though, the signal
  isn't handled straight away but remains on the queue for some time."

the thing is, kick_process() only helps if the other thread is _running_ 
on the other CPU. If it's actively waiting for disk, it's a no-op: the 
signal handling code expects that the scheduler will either wake it up in 
"wake_up_state()" (which won't happen if it is in 'D' state, of course!) 
or that the process will just handle it in its own time when it wakes up 
when IO completes.

So if things have gotten worse latency, it's most likely simply because 
our IO has worse latency - probably because of having more requests 
outstanding, or because of unlucky/bad IO scheduler behaviour. The first 
thing to do (because it's fairly easy) is to start off testing different 
IO schedulers, but also see if there are some cases where we should try to 
return early.

In the particular case of Edwin Török, his latency problem seems to b with 
"find". That's interesting, because it's one of the cases where we *could* 
easily improve on latency, by making "readdir()" return early both for 
killable signals, but also for regular signals when we've filled the 
buffer partially (because unlike a "read()" system call, we don't promise 
to fill the whole buffer _anyway_).

It may be, for example, that the increased latency isn't actually because 
the *kernel* has increased latencies at all, but perhaps 'find' uses a 
much bigger buffer for it's readdir() code? Anyway, _if_ it's readdir() 
that has high latency, the appended patch might make a difference. I think 
it's probably a good idea regardless..

But it would be really good to have the thing bisected regardless of what 
it is.

			Linus

---

This makes 'readdir()' return early if it has a signal pending and it has 
filled at least one entry (the -EINTR will never be passed on to user 
space: the readdir() system call will return the length of the filled-in 
buffer)

 fs/readdir.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/readdir.c b/fs/readdir.c
index 4e026e5..ec8c192 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -159,6 +159,9 @@ static int filldir(void * __buf, const char * name, int namlen, loff_t offset,
 		return -EOVERFLOW;
 	dirent = buf->previous;
 	if (dirent) {
+		/* Only check signals if we have filled at least one entry! */
+		if (signal_pending(current))
+			return -EINTR;
 		if (__put_user(offset, &dirent->d_off))
 			goto efault;
 	}
@@ -241,6 +244,9 @@ static int filldir64(void * __buf, const char * name, int namlen, loff_t offset,
 		return -EINVAL;
 	dirent = buf->previous;
 	if (dirent) {
+		/* Only check signals if we have filled at least one entry! */
+		if (signal_pending(current))
+			return -EINTR;
 		if (__put_user(offset, &dirent->d_off))
 			goto efault;
 	}
