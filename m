Return-Path: <linux-kernel-owner+w=401wt.eu-S1752785AbZI1RPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbZI1RPJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 13:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbZI1RPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 13:15:08 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:40039 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbZI1RPH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 13:15:07 -0400
Date: Mon, 28 Sep 2009 19:15:06 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc1
Message-ID: <20090928191506.40b61793@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <alpine.LFD.2.01.0909280829100.3349@localhost.localdomain>
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain>
	<4AC060AE.1090401@gmail.com>
	<alpine.LFD.2.01.0909280829100.3349@localhost.localdomain>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Sep 2009 08:39:31 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 28 Sep 2009, Eric Dumazet wrote:
> > Linus Torvalds a écrit :
> > > 
> > > Go wild, test it out, and let us know about any regressions you find,
> > 
> > Something seems wrong with process time accounting.
> > 
> > Following program should consume 10*8 seconds of cpu on a 8 cpu machine, but
> > with 2.6.32-rc1 numbers are crazy.
> 
> Ok, so the top-level process time looks sane _while_ the thing is running 
> (sum of all threads), but the per-thread times look broken (as if they had 
> randomly had the times of the other threads added into them - looks to me 
> like they on average had half the other threads' time accounted into 
> them).
> 
> And then at the end, it looks like the time of the threads (which was 
> over-accounted) get re-accounted back into the main process, so the final 
> time is indeed wildly inflated.
> 
> IOW, looks like we're adding thread times multiple times to other threads 
> (and then finally to the parent).
> 
> I'm adding the usual suspects to the cc, and leaving your results and 
> test-program quoted here for them.. Thomas, Martin, John - if you're not 
> the people I should blame for this, let me know.

Uh-oh.. usual suspects, eh?

For starters I run the test program on an s390 with
VIRT_CPU_ACCOUNTING=y:

time ./burn-cpu 
  PID TTY      STAT   TIME COMMAND 
 2979 pts/0    -      0:08 ./burn-cpu
    - -        Sl+    0:00 -         
    - -        Rl+    0:01 -         
    - -        Rl+    0:01 -         
    - -        Rl+    0:01 -         
    - -        Rl+    0:01 -         
    - -        Rl+    0:01 -         
    - -        Rl+    0:01 -         
    - -        Rl+    0:01 -         
    - -        Rl+    0:01 -         
  PID TTY      STAT   TIME COMMAND   
 2979 pts/0    -      0:16 ./burn-cpu
    - -        Sl+    0:00 -         
    - -        Rl+    0:02 -         
    - -        Rl+    0:02 -         
    - -        Rl+    0:02 -         
    - -        Rl+    0:02 -         
    - -        Rl+    0:02 -         
    - -        Rl+    0:02 -         
    - -        Rl+    0:02 -         
    - -        Rl+    0:02 -         
  PID TTY      STAT   TIME COMMAND   
 2979 pts/0    -      0:25 ./burn-cpu
    - -        Sl+    0:00 -         
    - -        Rl+    0:03 -         
    - -        Rl+    0:03 -         
    - -        Rl+    0:03 -         
    - -        Rl+    0:03 -         
    - -        Rl+    0:03 -         
    - -        Rl+    0:03 -         
    - -        Rl+    0:03 -         
    - -        Rl+    0:03 -         
  PID TTY      STAT   TIME COMMAND   
 2979 pts/0    -      0:33 ./burn-cpu
    - -        Sl+    0:00 -         
    - -        Rl+    0:04 -         
    - -        Rl+    0:04 -         
    - -        Rl+    0:04 -         
    - -        Rl+    0:04 -         
    - -        Rl+    0:04 -         
    - -        Rl+    0:04 -         
    - -        Rl+    0:04 -         
    - -        Rl+    0:04 -         
  PID TTY      STAT   TIME COMMAND   
 2979 pts/0    -      0:41 ./burn-cpu
    - -        Sl+    0:00 -         
    - -        Rl+    0:05 -         
    - -        Rl+    0:05 -         
    - -        Rl+    0:05 -         
    - -        Rl+    0:05 -         
    - -        Rl+    0:05 -         
    - -        Rl+    0:05 -         
    - -        Rl+    0:05 -         
    - -        Rl+    0:05 -         
  PID TTY      STAT   TIME COMMAND   
 2979 pts/0    -      0:50 ./burn-cpu
    - -        Sl+    0:00 -
    - -        Rl+    0:06 -
    - -        Rl+    0:06 -
    - -        Rl+    0:06 -
    - -        Rl+    0:06 -
    - -        Rl+    0:06 -
    - -        Rl+    0:06 -
    - -        Rl+    0:06 -
    - -        Rl+    0:06 -
  PID TTY      STAT   TIME COMMAND
 2979 pts/0    -      0:58 ./burn-cpu
    - -        Sl+    0:00 -
    - -        Rl+    0:07 -
    - -        Rl+    0:07 -
    - -        Rl+    0:07 -
    - -        Rl+    0:07 -
    - -        Rl+    0:07 -
    - -        Rl+    0:07 -
    - -        Rl+    0:07 -
    - -        Rl+    0:07 -
  PID TTY      STAT   TIME COMMAND
 2979 pts/0    -      1:07 ./burn-cpu
    - -        Sl+    0:00 -
    - -        Rl+    0:08 -
    - -        Rl+    0:08 -
    - -        Rl+    0:08 -
    - -        Rl+    0:08 -
    - -        Rl+    0:08 -
    - -        Rl+    0:08 -
    - -        Rl+    0:08 -
    - -        Rl+    0:08 -
  PID TTY      STAT   TIME COMMAND
 2979 pts/0    -      1:15 ./burn-cpu
    - -        Sl+    0:00 -
    - -        Rl+    0:09 -
    - -        Rl+    0:09 -
    - -        Rl+    0:09 -
    - -        Rl+    0:09 -
    - -        Rl+    0:09 -
    - -        Rl+    0:09 -
    - -        Rl+    0:09 -
    - -        Rl+    0:09 -
  PID TTY      STAT   TIME COMMAND
 2979 pts/0    -      1:25 ./burn-cpu
    - -        S+     1:25 -

real    0m10.708s
user    1m25.051s
sys     0m0.174s

looks better, gives an average of 10.63 seconds per thread and the per
thread numbers are fine. I'll see what happens with the test case on my
pc@home.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

