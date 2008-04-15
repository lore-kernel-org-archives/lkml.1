Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbYDOX1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbYDOX1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 19:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbYDOX05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 19:26:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753181AbYDOX04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 19:26:56 -0400
Date: Tue, 15 Apr 2008 16:26:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com
Subject: Re: [PATCH] PRINTK: Decouple input locking from output locking and
 move render outside lock
Message-Id: <20080415162606.50fcfaaa.akpm@linux-foundation.org>
In-Reply-To: <20080408180129.21772.9835.stgit@warthog.procyon.org.uk>
References: <20080408180129.21772.9835.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Apr 2008 19:01:29 +0100
David Howells <dhowells@redhat.com> wrote:

> Decouple the printk input locking from the output locking using a dual-tailed
> ring buffer, and move the render (vscnprintf) and processing (log level token
> inclusion and timestamp inclusion) outside of the input locked section.
> 
> 	+---------+
> 	|         |
> 	| vprintk |
> 	|         |
> 	+---------+                                   +-----------------+
> 	     |                                        |                 |
> 	     V                                   +--->| Syslog syscall  |
> 	+---------+                              |    |                 |
> 	|         |                              |    +-----------------+
> 	| Render  |                              |
> 	|         |                              |    +-----------------+
> 	+---------+      +-------------------+   |    |                 |
> 	     |           | Ring buffer       |   +--->| /proc/kmsg      |
> 	     V           |   +---------------+   |    |                 |
> 	+---------+      |   | syslog queue  |---+    +-----------------+
> 	|         |      |   +---------------+
> 	| Process |----->|                   |
> 	|         |      |   +---------------+
> 	+---------+      |   | console queue |---+    +-----------------+
> 	                 |   +---------------+   |    |                 |
> 	                 |                   |   +--->| Console drivers |
> 	                 +-------------------+        |                 |
> 	                                              +-----------------+
> 
> 
> New/renamed global variables:
> 
>  (*) printk_insertion_point is the point in the ring buffer at which data is
>      inserted.  It may only be moved if printk_insertion_lock is held.
> 
>  (*) log_extraction_point is the point in the ring buffer from which data is
>      read out by do_syslog().  It may only be moved if log_extraction_lock is
>      held.
> 
>  (*) con_extraction_point is the point in the ring buffer from which data is
>      read out to be fed to the console drivers.  It may only be moved if
>      console_sem is held.  No spinlock needs to be held whilst writing to the
>      console.
> 
>  (*) console_anytime is the number of registered drivers that have CON_ANYTIME
>      flagged.  This avoids the need to walk the console list regularly before
>      the CPU is officially online.
> 
> 
> This patch has the following effects:
> 
>  (1) vprintk() spends much less time within the insertion critical section.
> 
>  (2) vprintk() can be filling the buffer whilst do_syslog() and
>      release_console_sem are emptying it.  Memory barriers are employed to
>      prevent out-of-order access between the buffers and the pointers.
> 
>  (3) Instead of a single render buffer, vprintk() has two render buffers per
>      CPU.  This allows multiple CPUs to be rendering and processing their
>      rendered texts at the same time without the need for this to be within a
>      spinlock.
> 
>  (4) vprintk() first prints the string into the first buffer for that CPU, and
>      then post-processes it into the CPU's second buffer to make sure metadata
>      is present (log level and timestamp)
> 
>      As the rendering is done into a temporary buffer rather than a ring
>      buffer, the printed output is more likely to get truncated as there's less
>      room for metadata.  This can be alleviated by increasing the size of the
>      processing output buffer.
> 
>      These render buffers amount to 2KB * NR_CPUS in total instead of 1KB.
> 
>  (5) The timestamp inserted by vprintk() into a line is the time at which the
>      rendered line is processed, not the time it hits the buffer.  This means:
> 
>      (a) all those calls to do_div() and snprintf() are done outside the
>      	 critical section (except for recursion messages), and
> 
>      (b) lines from different CPUs may appear to be out of order (this can be
>      	 solved by throwing a lock around the processing section, a lock that's
>      	 not printk_insertion_lock).
> 
>  (6) A partial vprintk() on one CPU (ie: not ending in "\n") will have a
>      newline inserted after it if another CPU gets a line in first.
> 
>  (7) release_console_sem() does not need to take any spinlocks; console_sem is
>      probably sufficient locking for talking to console drivers.  Although the
>      function disables IRQs too, this may be unnecessary, provided the IRQ
>      handler doesn't try filling up the ring buffer without being able to empty
>      it because someone further up the stack holds console_sem.
> 
>  (8) vprintk() may have to discard messages under high load:
> 
>      (a) If the console queue can't be emptied fast enough, new messages are
>      	 discarded wholly or in part.  Possibly old messages should be
>      	 discarded instead.
> 
>      (b) If the syslog queue can't be emptied fast enough, then if vprintk()
>      	 can immediately get the appropriate lock, it will advance the
>      	 extraction point by at least 1024 characters, rounded up to the next
>      	 newline, thus discarding some old messages.  Failing that, new
>      	 messages will be discarded wholly or in part instead.
> 
> 
> Why this patch?
> ===============
> 
> We're seeing the kernel spit messages out about CPUs getting stuck on the
> console locks.  This appears to be due to I/O errors in a just-disconnected
> iSCSI block device causing lots and lots of printks.  The system on which this
> is being seen is a ppc64 system with spinlocks that yield to the hypervisor,
> which I suspect is exacerbating the situation.
> 
> This patch attempts to alleviate the situation by shortening the amount of time
> spent in the kernel logging critical sections by breaking up the locking and
> moving out stuff that can be done outside of the critical section.
> 
> 
> Testing
> =======
> 
> I've used my FRV test board (32-bit/BE/UP) firstly to step through the code and
> check the various values with GDB under various cases, and secondly to generate
> a sequence of numbered printks, which I've checked have all been correctly
> displayed, and correctly ordered.
> 
> I've also run this up on my x86_64 box with 2 CPUs (64-bit/LE/SMP), checking
> that it correctly handles output from FS-Cache and CacheFiles with full
> debugging output turned on, both in printing to tty and serial consoles and in
> extraction via syslog().
> 
> ...
> 
>  kernel/printk.c |  820 +++++++++++++++++++++++++++++++++++--------------------

geeze, that didn't do much to simplify the printk code :(

Wouldn't it be better to teach the offending iscsi code about
printk_ratelimit()?  Because I'd expect that even with this change,
undesirable things will still happen with (say) a serial console?

