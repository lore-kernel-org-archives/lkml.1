Return-Path: <linux-kernel-owner+w=401wt.eu-S1752526AbZI1PkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbZI1PkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 11:40:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbZI1PkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 11:40:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751482AbZI1PkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 11:40:14 -0400
Date: Mon, 28 Sep 2009 08:39:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Eric Dumazet <eric.dumazet@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       John Stultz <johnstul@us.ibm.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc1
In-Reply-To: <4AC060AE.1090401@gmail.com>
Message-ID: <alpine.LFD.2.01.0909280829100.3349@localhost.localdomain>
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain> <4AC060AE.1090401@gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Mon, 28 Sep 2009, Eric Dumazet wrote:
> Linus Torvalds a écrit :
> > 
> > Go wild, test it out, and let us know about any regressions you find,
> 
> Something seems wrong with process time accounting.
> 
> Following program should consume 10*8 seconds of cpu on a 8 cpu machine, but
> with 2.6.32-rc1 numbers are crazy.

Ok, so the top-level process time looks sane _while_ the thing is running 
(sum of all threads), but the per-thread times look broken (as if they had 
randomly had the times of the other threads added into them - looks to me 
like they on average had half the other threads' time accounted into 
them).

And then at the end, it looks like the time of the threads (which was 
over-accounted) get re-accounted back into the main process, so the final 
time is indeed wildly inflated.

IOW, looks like we're adding thread times multiple times to other threads 
(and then finally to the parent).

I'm adding the usual suspects to the cc, and leaving your results and 
test-program quoted here for them.. Thomas, Martin, John - if you're not 
the people I should blame for this, let me know.

		Linus

---
> $ gcc -O2 -o process process.c -lpthread
> $ ./process
>   PID TTY      STAT   TIME COMMAND
>  5532 pts/1    -      0:08 ./process
>     - -        Sl+    0:00 -
>     - -        Rl+    0:05 -
>     - -        Rl+    0:05 -
>     - -        Rl+    0:09 -
>     - -        Rl+    0:05 -
>     - -        Rl+    0:05 -
>     - -        Rl+    0:05 -
>     - -        Rl+    0:05 -
>     - -        Rl+    0:01 -
>   PID TTY      STAT   TIME COMMAND
>  5532 pts/1    -      0:16 ./process
>     - -        Sl+    0:00 -
>     - -        Rl+    0:14 -
>     - -        Rl+    0:06 -
>     - -        Rl+    0:14 -
>     - -        Rl+    0:10 -
>     - -        Rl+    0:06 -
>     - -        Rl+    0:06 -
>     - -        Rl+    0:10 -
>     - -        Rl+    0:02 -
>   PID TTY      STAT   TIME COMMAND
>  5532 pts/1    -      0:24 ./process
>     - -        Sl+    0:00 -
>     - -        Rl+    0:20 -
>     - -        Rl+    0:11 -
>     - -        Rl+    0:24 -
>     - -        Rl+    0:15 -
>     - -        Rl+    0:07 -
>     - -        Rl+    0:07 -
>     - -        Rl+    0:24 -
>     - -        Rl+    0:03 -
>   PID TTY      STAT   TIME COMMAND
>  5532 pts/1    -      0:32 ./process
>     - -        Sl+    0:00 -
>     - -        Rl+    0:29 -
>     - -        Rl+    0:12 -
>     - -        Rl+    0:29 -
>     - -        Rl+    0:21 -
>     - -        Rl+    0:08 -
>     - -        Rl+    0:08 -
>     - -        Rl+    0:29 -
>     - -        Rl+    0:04 -
>   PID TTY      STAT   TIME COMMAND
>  5532 pts/1    -      0:40 ./process
>     - -        Sl+    0:00 -
>     - -        Rl+    0:35 -
>     - -        Rl+    0:13 -
>     - -        Rl+    0:35 -
>     - -        Rl+    0:26 -
>     - -        Rl+    0:09 -
>     - -        Rl+    0:09 -
>     - -        Rl+    0:35 -
>     - -        Rl+    0:05 -
>   PID TTY      STAT   TIME COMMAND
>  5532 pts/1    -      0:48 ./process
>     - -        Sl+    0:00 -
>     - -        Rl+    0:40 -
>     - -        Rl+    0:14 -
>     - -        Rl+    0:40 -
>     - -        Rl+    0:31 -
>     - -        Rl+    0:10 -
>     - -        Rl+    0:10 -
>     - -        Rl+    0:40 -
>     - -        Rl+    0:06 -
>   PID TTY      STAT   TIME COMMAND
>  5532 pts/1    -      0:56 ./process
>     - -        Sl+    0:00 -
>     - -        Rl+    0:45 -
>     - -        Rl+    0:15 -
>     - -        Rl+    0:45 -
>     - -        Rl+    0:37 -
>     - -        Rl+    0:11 -
>     - -        Rl+    0:11 -
>     - -        Rl+    0:45 -
>     - -        Rl+    0:07 -
>   PID TTY      STAT   TIME COMMAND
>  5532 pts/1    -      1:05 ./process
>     - -        Sl+    0:00 -
>     - -        Rl+    0:51 -
>     - -        Rl+    0:21 -
>     - -        Rl+    0:55 -
>     - -        Rl+    0:46 -
>     - -        Rl+    0:12 -
>     - -        Rl+    0:12 -
>     - -        Rl+    0:59 -
>     - -        Rl+    0:08 -
>   PID TTY      STAT   TIME COMMAND
>  5532 pts/1    -      1:13 ./process
>     - -        Sl+    0:00 -
>     - -        Rl+    0:56 -
>     - -        Rl+    0:22 -
>     - -        Rl+    1:00 -
>     - -        Rl+    0:52 -
>     - -        Rl+    0:13 -
>     - -        Rl+    0:13 -
>     - -        Rl+    1:04 -
>     - -        Rl+    0:09 -
>   PID TTY      STAT   TIME COMMAND
>  5532 pts/1    -      5:13 ./process
>     - -        S+     5:13 -
> 
> 
> $ cat process.c
> #include <pthread.h>
> #include <time.h>
> #include <stdio.h>
> 
> /*
>  * Burn cpu cycles for about 10 seconds
>  */
> static void *do_unit(void *arg)
> {
>         time_t t0,t1;
> 
>         t0 = time(NULL);
>         do {
>                 t1 = time(NULL);
>         } while (t1 - t0 <= 10);
>         return NULL;
> }
> 
> 
> 
> 
> int main(int argc, char *argv[])
> {
>         pthread_t tids[8];
>         int i;
>         char cmd[128];
> 
>         sprintf(cmd, "ps m -p %d", getpid());
>         for (i = 0; i < 8 ; i++)
>                 pthread_create(&tids[i], NULL, do_unit, NULL);
>         for (i = 0; i < 9; i++) {
>                 sleep(1);
>                 system(cmd);
>         }
>         for (i = 0; i < 8 ; i++)
>                 pthread_join(tids[i], NULL);
>         system(cmd);
>         return 0;
> }
> 
