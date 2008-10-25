Return-Path: <linux-kernel-owner+w=401wt.eu-S1752769AbYJYOEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbYJYOEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 10:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751952AbYJYOE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 10:04:27 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:11433 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbYJYOE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 10:04:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=W8rNRsv+CWGbW8PPM8U5j/6jLM1Dnv2SMCZ/dGfCs2tNuFvXucbvvaaOvHjJX58CIB
         qS5iR8SnR+j490kO4sLFVUb7SmcjaWseVlToTPUpuss4BsNEOkPQVqINLDa0YybFLmS7
         XhFwnYZS28RjnPAvPzDvulqbJzauTPl0aKK4o=
Date: Sat, 25 Oct 2008 17:04:29 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, zanussi@comcast.net,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] hard-lock with kmemtrace, relayfs, and splice
Message-ID: <20081025140429.GA5222@localhost>
References: <20080923212914.GB5237@localhost> <1223386477.28348.42.camel@penberg-laptop> <1223623191.8959.26.camel@penberg-laptop> <1223628687.8959.37.camel@penberg-laptop> <1223629803.8959.40.camel@penberg-laptop> <1223631723.8959.46.camel@penberg-laptop> <804dabb00810232144w4a618737l28c1d63108594d1e@mail.gmail.com> <1224857756.5519.5.camel@penberg-laptop> <804dabb00810241756x2b7a35e0v8593451285582267@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804dabb00810241756x2b7a35e0v8593451285582267@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2008 at 08:56:07AM +0800, Peter Teoh wrote:
> ok.   just ignore it.   i think based on "git log" of
> "git://repo.or.cz/linux-2.6/kmemtrace.git":
> 
> commit 0441e5ff6ab71cf7a3e9ec3116f14d0fd7d20d51
> Author: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> Date:   Thu Jul 10 20:20:05 2008 +0300
> 
>     kmemtrace: SLOB hooks.
> 
> the repo seemed way out of date.   But a clone of Pekka's slab-2.6's
> topic/kmemtrace branch have no problem.   The steps are as follows:
> 
> 1.   git clone git://git.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git
> 2.   git checkout -m  origin/topic/kmemtrace
> 3.   git checkout -b kmemtrace

Hi,

Yes, that repo may be outdated, please use Pekka's for the latest
working stuff.

> git log gives:
> 
> commit 51b19be3535c8fbcce6b6f838d89b9a6a4cc5b92
> Author: Tom Zanussi <zanussi@comcast.net>
> Date:   Fri Oct 10 23:58:51 2008 -0500
> 
>     relayfs: fix infinite loop with splice()
> 
> But the userspace tool I still get it from: git://repo.or.cz/kmemtrace-user.git
> 
> Correct?

Yes, I maintain this one and it's up-to-date.

> Now I have some problems:
> 
> a.   I would like to extract out all the commit as diff - may I know
> how to do that? ("git log" only gives the descriptive part).

You can use "git-log -p" to get diffs along with commit history.

> b.   boot-time memory profiling....how can it be done (or extracted
> out)?  (kmemtrace-user does not have that?)

If you enable kmemtrace at boot-time using the "kmemtrace.enabled=yes"
parameter, kmemtrace will start logging just after kmem_cache_init()
finishes. There are plans for making tracing possible even earlier,
however it involves quite a big rework of how relay allocates its
buffers.

> c.   please provide some pointers to documentation:   how do I
> interpret the following:
> 
> Allocation #83468 (CPU0) already exists!
>         by __kmalloc_track_caller+25
>         last touched by __kmalloc_track_caller
> Allocation #83740 (CPU0) already exists!
>         by __kmalloc_track_caller+25
>         last touched by __kmalloc_track_caller

The userspace app writes out those messages when it looks like a memory
region has been allocated twice. In reality, it's most likely a free
hasn't been traced (because a misc free function isn't traced).

> For my purpose, I would like to trace how and where is memory
> allocated - just one one single userspace program which access the
> mmap("/dev/mem") to read the memory.   How can it be done?   "Tracing
> memory" in my context will mean list all the kernel-function +
> memory-allocated-within-the-function + its-PFN-or-PTE-information (to
> pinpoint the exact physical page).   My understanding is that these
> can be done, via checking the value of "current", as each userspace
> program started will have a unique "current" context value, and
> therefore within any kernel function, just check this value, to focus
> tracing on just one particular userspace program.   Correct?

I have made provisions for exporting the whole stack trace, however it
is not yet implemented.

> d.   The following:
> 
> /sys/kernel/debug/kmemtrace>ls -al
> ???? 0
> drwxr-xr-x 2 root root          0 2008-10-25 .
> drwxr-xr-x 9 root root          0 2008-10-25 ..
> -r-------- 1 root root          0 2008-10-25 abi_version
> -r-------- 1 root root 2946936192 2008-10-25 cpu0
> -r-------- 1 root root 1701263952 2008-10-25 cpu1
> -rw------- 1 root root          0 2008-10-25 enabled
> -r-------- 1 root root          0 2008-10-25 total_overruns
> 
> So the information is stored in memory, right?   Is it possible to
> reset it?   I don't want these information to clog up the memory.

Relay uses fixed size buffers, so there is no point in clearing them.

> e.   The balance between cpu0 and cpu1 does not seemed equal, any
> implications on the scheduler/ IO Scheduler?   or memory allocation
> scheduler (if there exists one :-))....sorry about that....my
> knowledge is limited.

Much of the booting sequence is done on a single CPU, then the kernel
switches to SMP. It is natural to see one CPU log more allocations.

> -- 
> Regards,
> Peter Teoh

Thanks for testing.


	Cheers,
	Eduard

