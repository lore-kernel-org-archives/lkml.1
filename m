Return-Path: <linux-kernel-owner+w=401wt.eu-S1761128AbXHCSe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761128AbXHCSe4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 14:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbXHCSet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 14:34:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38245 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753785AbXHCSer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 14:34:47 -0400
Date: Fri, 3 Aug 2007 11:34:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, matthias@wspse.de
Subject: Re: Processes spinning forever, apparently in lock_timer_base()?
Message-Id: <20070803113407.0b04d44e.akpm@linux-foundation.org>
In-Reply-To: <46B10BB7.60900@redhat.com>
References: <46B10BB7.60900@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(attempting to cc Matthias.  If I have the wrong one, please fix it up)

(please generally cc reporters when forwarding their bug reports)

On Wed, 01 Aug 2007 18:39:51 -0400
Chuck Ebbert <cebbert@redhat.com> wrote:

> Looks like the same problem with spinlock unfairness we've seen
> elsewhere: it seems to be looping here? Or is everyone stuck
> just waiting for writeout?
> 
> lock_timer_base():
>         for (;;) {
>                 tvec_base_t *prelock_base = timer->base;
>                 base = tbase_get_base(prelock_base);
>                 if (likely(base != NULL)) {
>                         spin_lock_irqsave(&base->lock, *flags);
>                         if (likely(prelock_base == timer->base))
>                                 return base;
>                         /* The timer has migrated to another CPU */
>                         spin_unlock_irqrestore(&base->lock, *flags);
>                 }
>                 cpu_relax();
>         }
> 
> The problem goes away completely if filesystem are mounted
> *without* noatime. Has happened in 2.6.20 through 2.6.22...
> 
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=249563
> 
> Part of sysrq-t listing:
> 
> mysqld        D 000017c0  2196 23162   1562
>        e383fcb8 00000082 61650954 000017c0 e383fc9c 00000000 c0407208 e383f000 
>        a12b0434 00004d1d c6ed2c00 c6ed2d9c c200fa80 00000000 c0724640 f6c60540 
>        c4ff3c70 00000508 00000286 c042ffcb e383fcc8 00014926 00000000 00000286 
> Call Trace:
>  [<c0407208>] do_IRQ+0xbd/0xd1
>  [<c042ffcb>] lock_timer_base+0x19/0x35
>  [<c04300df>] __mod_timer+0x9a/0xa4
>  [<c060bb55>] schedule_timeout+0x70/0x8f
>  [<c042fd37>] process_timeout+0x0/0x5
>  [<c060bb50>] schedule_timeout+0x6b/0x8f
>  [<c060b67c>] io_schedule_timeout+0x39/0x5d
>  [<c0465eea>] congestion_wait+0x50/0x64
>  [<c0438539>] autoremove_wake_function+0x0/0x35
>  [<c04620e2>] balance_dirty_pages_ratelimited_nr+0x148/0x193
>  [<c045e7fd>] generic_file_buffered_write+0x4c7/0x5d3

I expect the lock_timer_base() this is just stack gunk.  Matthias's trace
also includes

mysqld        S 000017c0  2524  1623   1562
       f6ce3b44 00000082 60ca34b2 000017c0 f6ce3b28 00000000 f6ce3b54 f6ce3000 
       57c63d9c 00004d1d f6c90000 f6c9019c c200fa80 00000000 c0724640 f6c60540 
       000007d0 c07e1f00 00000286 c042ffcb f6ce3b54 000290ef 00000000 00000286 
Call Trace:
 [<c042ffcb>] lock_timer_base+0x19/0x35
 [<c04300df>] __mod_timer+0x9a/0xa4
 [<c060bb55>] schedule_timeout+0x70/0x8f
 [<c042fd37>] process_timeout+0x0/0x5
 [<c060bb50>] schedule_timeout+0x6b/0x8f
 [<c04857c7>] do_select+0x36d/0x3c4
 [<c0485da0>] __pollwait+0x0/0xac
 [<c04e934d>] __next_cpu+0x12/0x1e
 [<c0420130>] find_busiest_group+0x1c4/0x553
 [<c0420ada>] update_curr+0x23b/0x25c
 [<c04eb700>] rb_insert_color+0x8c/0xad
 [<c042128f>] enqueue_entity+0x276/0x294

and it appears that schedule_timeout() always leaves a copy of
lock_timer_base+0x19 on the stack.  Enabling CONFIG_FRAME_POINTER might
help sort that out.

I think.  Or perhaps lock_timer_base() really has gone and got stuck.  One
possibility is that gcc has decided to cache timer->base in a register
rather than rereading it around that loop, which would be bad.  Do:

gdb vmlinux
(gdb) x/100i lock_timer_base

Is the machine really completely dead?  Or are some tasks running?  If the
latter, it might be dirty-memory windup - perhaps some device driver has
died and we're not getting writes out to disk.

Are all the CPUs running flat-out?  If so, yup, maybe it's
lock_timer_base().  Hit sysrq-P ten times, see where things are stuck.


Please leave `vmstat 1' running in an ssh seesion next time, let's see the
output just prior to the hang.

And do this:

while true
do
	echo
	cat /proc/meminfo
	sleep 1
done

in another ssh session so we can see what the memory looked like when it
died too.
