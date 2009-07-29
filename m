Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbZG2MQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbZG2MQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbZG2MQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:16:21 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:65449 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474AbZG2MQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:16:20 -0400
X-SourceIP: 213.93.53.227
Subject: Re: perf_counters issue with self-sampling threads
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>,
       Michael Kerrisk <mtk.manpages@googlemail.com>, oleg <oleg@redhat.com>
In-Reply-To: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Jul 2009 14:19:08 +0200
Message-Id: <1248869948.6987.3083.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-27 at 18:51 +0200, stephane eranian wrote:
> I believe there is a problem with the current perf_counters (PCL)
> code for self-sampling threads. The problem is related to sample
> notifications via signal.
> 
> PCL (just like perfmon) is using SIGIO, an asynchronous signal,
> to notify user applications of the availability of data in the event
> buffer.
> 
> POSIX does not mandate that asynchronous signals be delivered
> to the thread in which they originated. Any thread in the process
> may process the signal, assuming it does not have the signal
> blocked.

This signal stuff makes my head spin a little, however:

fcntl(2) for F_SETOWN says:

If a non-zero value is given to F_SETSIG  in  a  multi‐ threaded
process running with a threading library that supports thread groups
(e.g., NPTL),  then  a  positive value  given  to  F_SETOWN  has  a
different  meaning: instead of being a process ID identifying a whole
pro‐ cess,  it  is a thread ID identifying a specific thread within a
process.  Consequently, it may be necessary to pass  F_SETOWN  the
result of gettid(2) instead of get‐ pid(2) to get sensible results
when F_SETSIG  is  used.  (In  current  Linux  threading
implementations, a main thread’s thread ID is the same as its process
ID.  This means  that  a  single-threaded program can equally use
gettid(2) or getpid(2) in this scenario.)   Note,  how‐ ever,  that
the  statements  in  this paragraph do not apply to the SIGURG signal
generated  for  out-of-band data  on a socket: this signal is always
sent to either a process or a process group, depending  on  the  value
given  to  F_SETOWN.   Note  also  that Linux imposes a limit on the
number of real-time signals  that  may  be queued  to  a  process (see
getrlimit(2) and signal(7)) and if this limit is reached, then the
kernel  reverts to  delivering  SIGIO,  and this signal is delivered
to the entire process rather than to a specific thread.


Which seems to imply that when we feed fcntl(F_SETOWN) a TID instead of
a PID it should deliver SIGIO to the thread instead of the whole process
-- which, to me, seems a sane semantic.

However, 

  kill_fasync(SIGIO)
    __kill_fasync()
      send_sigio()
	/* if pid_type is a PIDTYPE_PID and pid a TID this should
           only iterate the one thread, I think */
        do_each_pid_task() {
          send_sigio_to_task();
        } while_each_pid_task();

where:

  send_sigio_to_task()
    group_send_sig_info()
      __group_send_sig_info()
        send_signal(.group = 1) /* uh-ow trouble */
          __send_signal()
            if (group)
               pending = &t->signal->shared_pending

which will result in the signal being send to the whole process anyway.


Now I was considering teaching send_sigio_to_task() to use
specific_send_sig_info() when fown->pid != fown->group_leader->pid or
something, but I'm not sure that won't break anything.

Alternatively, I've missed a detail and I either read the manpage wrong,
or the code, or both of them.



