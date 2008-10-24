Return-Path: <linux-kernel-owner+w=401wt.eu-S1756673AbYJXNoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbYJXNoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 09:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYJXNnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 09:43:52 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:29580 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbYJXNnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 09:43:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uso+vd09Z9wG8n7EBPND/mbVosVhB7+h2VjKL8VlzVqdh8mJhaC5FPnvnW+72KqvmF
         9cjH56U9L4rvkXiXWoYM97FUs++Rn4mHQL42l4Rq3zTrTtZm4gn88SF16iz44stE8qUh
         QBAR2wacno1g/j2vk9UUXgjDyFCy5G93RjLVI=
Message-ID: <c62985530810240643q467a9060kaf906eb7865f0a7@mail.gmail.com>
Date: Fri, 24 Oct 2008 15:43:49 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH 5/5] tracing/ftrace: Introduce the big kernel lock tracer
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Steven Rostedt" <rostedt@goodmis.org>, systemtap@sources.redhat.com
In-Reply-To: <y0mmygv18le.fsf@ton.toronto.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48F10B0B.406@gmail.com>
	 <c62985530810210528t416c82b2lbe8471322e8359c@mail.gmail.com>
	 <y0mmygv18le.fsf@ton.toronto.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/23 Frank Ch. Eigler <fche@redhat.com>:
> For comparison, this is how this sort of analysis may be done with
> systemtap, just for fun collecting locking latency on a
> per-locker/unlocker (stack traceback) basis.  We don't have the stack
> traceback extended right into userspace yet, but will before too long.
>
>
> % cat bkl.stp
> probe kernel.function("lock_kernel") {
>        locker=backtrace()
>        locktime=gettimeofday_us()
> }
>
> probe kernel.function("lock_kernel").return {
>        unlocktime=gettimeofday_us()
>        delay = unlocktime-locktime
>        lockhistory[locker,unlocker] <<< delay
> }
>
> probe kernel.function("unlock_kernel") {
>        unlocker=backtrace()
> }
>
> global locker, unlocker, locktime, lockhistory
>
> probe end,timer.s(30) { // interrupt any time; automatic ending in 30s
>        foreach ([l,u] in lockhistory+) { // in increasing order of @count()
>
>                println("locker:") print_stack (l)
>                println("unlocker:") print_stack (u)
>
>                println(@hist_log (lockhistory[l,u]))
>
>                if (@max (lockhistory[l,u]) > 100)
>                   println("--- holy cow, that can take a long time ---")
>        }
>        exit()
> }
>
>
>
> % sudo stap bkl.stp
> [...]
> locker:
>  0xffffffff812bdcec : lock_kernel+0x1/0x37 [kernel]
>  0xffffffff812bf12b : kretprobe_trampoline_holder+0x4/0x50 [kernel]
>  0xffffffff811b067b : write_chan+0x273/0x338 [kernel]
>  0xffffffff810305e0 : default_wake_function+0x0/0xf [kernel]
>  0xffffffff811ade5f : tty_write+0x184/0x213 [kernel]
>  0xffffffff811b0408 : write_chan+0x0/0x338 [kernel]
>  0x00000ffffffff810
> unlocker:
>  0xffffffff812bdca9 : unlock_kernel+0x1/0x31 [kernel]
>  0xffffffff811b064e : write_chan+0x246/0x338 [kernel]
>  0xffffffff810305e0 : default_wake_function+0x0/0xf [kernel]
>  0xffffffff811ade5f : tty_write+0x184/0x213 [kernel]
>  0xffffffff811b0408 : write_chan+0x0/0x338 [kernel]
>  0xffffffff810b6f89 : vfs_write+0xae/0x157 [kernel]
>  0x00000fffffffff7f
> value |-------------------------------------------------- count
>    0 |                                                     3
>    1 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    570
>    2 |@@@@@@@@@@@@@                                      159
>    4 |                                                     9
>    8 |@                                                   16
>   16 |                                                     3
>   32 |@@                                                  35
>   64 |                                                     5
>  128 |                                                     0
>  256 |                                                     0
>
> locker:
>  0xffffffff812bdcec : lock_kernel+0x1/0x37 [kernel]
>  0xffffffff812bf12b : kretprobe_trampoline_holder+0x4/0x50 [kernel]
>  0xffffffff810305e0 : default_wake_function+0x0/0xf [kernel]
>  0xffffffff811ade5f : tty_write+0x184/0x213 [kernel]
>  0xffffffff811b0408 : write_chan+0x0/0x338 [kernel]
>  0xffffffff810b6f89 : vfs_write+0xae/0x157 [kernel]
>  0x00000fffffffff7f
> unlocker:
>  0xffffffff812bdca9 : unlock_kernel+0x1/0x31 [kernel]
>  0xffffffff811b064e : write_chan+0x246/0x338 [kernel]
>  0xffffffff810305e0 : default_wake_function+0x0/0xf [kernel]
>  0xffffffff811ade5f : tty_write+0x184/0x213 [kernel]
>  0xffffffff811b0408 : write_chan+0x0/0x338 [kernel]
>  0xffffffff810b6f89 : vfs_write+0xae/0x157 [kernel]
>  0x00000fffffffff7f
> value |-------------------------------------------------- count
>    0 |                                                     0
>    1 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@      454
>    2 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  497
>    4 |@@                                                  21
>    8 |@                                                   15
>   16 |                                                     1
>   32 |@@@                                                 33
>   64 |                                                     2
>  128 |                                                     0
>  256 |                                                     0
>
>
>
> NB: Observed lock times in the 1-2 us range indicate no contention, as
> that's on the order of magnitude of the (un)lock_kernel kprobe
> overheads.

That's a great and powerful tool.

But just one sorrow:
I just think that's a pity that we have to use/learn a new scripting
language to use it.
I would rather prefer to use an API that provides functions/objects
for most common scripting languages.
