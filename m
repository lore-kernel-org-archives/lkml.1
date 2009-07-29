Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbZG2MhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbZG2MhN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754622AbZG2MhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:37:13 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:54269 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbZG2MhL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:37:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=M8HKZC/sHmpgRHGfHIlcEX80oryOUVJgbG+xckeHmxQKFGcHSHwbVPkq+ap3rxGM5S
         1o6J2TXxrJEcLfDoJTDzwDXA8uVQ83WkYzJRtmB7SFL+3ZXko2SqKFCAMLR8S8oSoI2G
         zwHYv1FB8tNYiADomcMvgP+aqgJhuLQLLUHos=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <1248869948.6987.3083.camel@twins>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com>
	 <1248869948.6987.3083.camel@twins>
Date: Wed, 29 Jul 2009 14:37:10 +0200
Message-ID: <7c86c4470907290537q42195dc6s61d0f6d4a3a70154@mail.gmail.com>
Subject: Re: perf_counters issue with self-sampling threads
From: stephane eranian <eranian@googlemail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Wed, Jul 29, 2009 at 2:19 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> On Mon, 2009-07-27 at 18:51 +0200, stephane eranian wrote:
>> I believe there is a problem with the current perf_counters (PCL)
>> code for self-sampling threads. The problem is related to sample
>> notifications via signal.
>>
>> PCL (just like perfmon) is using SIGIO, an asynchronous signal,
>> to notify user applications of the availability of data in the event
>> buffer.
>>
>> POSIX does not mandate that asynchronous signals be delivered
>> to the thread in which they originated. Any thread in the process
>> may process the signal, assuming it does not have the signal
>> blocked.
>
> This signal stuff makes my head spin a little, however:
>
> fcntl(2) for F_SETOWN says:
>
> If a non-zero value is given to F_SETSIG  in  a  multi‐ threaded
> process running with a threading library that supports thread groups
> (e.g., NPTL),  then  a  positive value  given  to  F_SETOWN  has  a
> different  meaning: instead of being a process ID identifying a whole
> pro‐ cess,  it  is a thread ID identifying a specific thread within a
> process.  Consequently, it may be necessary to pass  F_SETOWN  the
> result of gettid(2) instead of get‐ pid(2) to get sensible results
> when F_SETSIG  is  used.  (In  current  Linux  threading
> implementations, a main thread’s thread ID is the same as its process
> ID.  This means  that  a  single-threaded program can equally use
> gettid(2) or getpid(2) in this scenario.)   Note,  how‐ ever,  that
> the  statements  in  this paragraph do not apply to the SIGURG signal
> generated  for  out-of-band data  on a socket: this signal is always
> sent to either a process or a process group, depending  on  the  value
> given  to  F_SETOWN.   Note  also  that Linux imposes a limit on the
> number of real-time signals  that  may  be queued  to  a  process (see
> getrlimit(2) and signal(7)) and if this limit is reached, then the
> kernel  reverts to  delivering  SIGIO,  and this signal is delivered
> to the entire process rather than to a specific thread.
>
>
> Which seems to imply that when we feed fcntl(F_SETOWN) a TID instead of
> a PID it should deliver SIGIO to the thread instead of the whole process
> -- which, to me, seems a sane semantic.
>
Yes, I remember that manpage. I got the same impression and in fact that is
what I document in some of my test programs. So you read this right.

> However,
>
>  kill_fasync(SIGIO)
>    __kill_fasync()
>      send_sigio()
>        /* if pid_type is a PIDTYPE_PID and pid a TID this should
>           only iterate the one thread, I think */
>        do_each_pid_task() {
>          send_sigio_to_task();
>        } while_each_pid_task();
>
> where:
>
>  send_sigio_to_task()
>    group_send_sig_info()
>      __group_send_sig_info()
>        send_signal(.group = 1) /* uh-ow trouble */
>          __send_signal()
>            if (group)
>               pending = &t->signal->shared_pending
>
> which will result in the signal being send to the whole process anyway.
>
Exactly! That is the code path and this is why this does not work as
expected. Nowhere along that path is there special casing for that
F_SETOWN of tid vs. pid. kill_fasync() implies group.


>
> Now I was considering teaching send_sigio_to_task() to use
> specific_send_sig_info() when fown->pid != fown->group_leader->pid or
> something, but I'm not sure that won't break anything.
>
Yes, that's the problem with touching this. I don't know if this will break
things. That's why I was suggested creating a parallel code path which
does what we want without modifying the existing path. Unless you know
some signal expert at redhat or elsewhere.

> Alternatively, I've missed a detail and I either read the manpage wrong,
> or the code, or both of them.
>
The code does not correspond to the manpage. Not clear which one
is correct though. This F_SETOWN trick looks very Linux specific.
