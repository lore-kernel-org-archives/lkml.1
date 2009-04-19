Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZDSR2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZDSR2x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 13:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbZDSR2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 13:28:44 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:59683 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbZDSR2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 13:28:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EaxfWyarL6lZmvKLQfylGkms+R4R0s3ghDk6C3LbGh5tID1fl7swjmRzeughXoUaHp
         L6XEWholQwJVUEeMYblaIZwbNtFLA5+Py4oKB2U3MvqBjQA7tp2iMKwz1MGzq4QfE1io
         YNi+4BpD47/tGeejpgr2wmlNkje9t0Mr+fHVg=
Date: Sun, 19 Apr 2009 19:28:38 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] tracing/core: Add current context on tracing recursion
	warning
Message-ID: <20090419172837.GA5992@nowhere>
References: <1240117295-6873-1-git-send-email-fweisbec@gmail.com> <49EAC15E.7080702@cn.fujitsu.com> <20090419123430.GA5967@nowhere> <20090419134927.GA6262@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090419134927.GA6262@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19, 2009 at 03:49:28PM +0200, Frederic Weisbecker wrote:
> On Sun, Apr 19, 2009 at 02:34:32PM +0200, Frederic Weisbecker wrote:
> > On Sun, Apr 19, 2009 at 02:14:54PM +0800, Li Zefan wrote:
> > > Frederic Weisbecker wrote:
> > > > Hi,
> > > > 
> > > > Here is the v3 of the __string() field patchset.
> > > > It applies suggestions from Steven and Peter with some arrangements.
> > > > 
> > > > This time, filtering is not supported (though it is ready in a pending patch).
> > > > I wanted to provide it but it looks like filtering has been broken recently.
> > > > Once I set a usual string filter, no more traces appear, and clearing it
> > > > doesn't change anything.
> > > > 
> > > 
> > > I tried it, and triggered a WARNING, and ring buffers was
> > > disabled permanently:
> > 
> > 
> > I've also seen this warning but on another event.
> > I don't think this is related to this patchset but
> > more about the tracing recursion detection.
> > 
> > For exemple, here we are in an Irq event, which doesn't
> > use the __string() thing. For such off-case, the only change
> > is a variable declaration and a + 0 operation.
> > 
> > Another thing: I've only seen it in a selftest.
> 
> 
> Worst: I can't reproduce it anymore.
> What were you doing when you got such warning? Were you
> in a selftest, or trying a usual event?



Now I can reproduce it. It seems to happen when I set a filter,
but also on other situations:

Bisected back to:

commit 261842b7c9099f56de2eb969c8ad65402d68e00e
tracing: add same level recursion detection

It might be caused by a bug in this patch or
by real tracing recursions on some places.

Another example:

111.119821] ------------[ cut here ]------------
[  111.119829] WARNING: at kernel/trace/ring_buffer.c:1498 ring_buffer_lock_reserve+0x1b7/0x1d0()
[  111.119835] Hardware name: AMILO Li 2727                  
[  111.119839] Modules linked in:
[  111.119846] Pid: 5731, comm: Xorg Tainted: G        W  2.6.30-rc1 #69
[  111.119851] Call Trace:
[  111.119863]  [<ffffffff8025ce68>] warn_slowpath+0xd8/0x130
[  111.119873]  [<ffffffff8028a30f>] ? __lock_acquire+0x19f/0x1ae0
[  111.119882]  [<ffffffff8028a30f>] ? __lock_acquire+0x19f/0x1ae0
[  111.119891]  [<ffffffff802199b0>] ? native_sched_clock+0x20/0x70
[  111.119899]  [<ffffffff80286dee>] ? put_lock_stats+0xe/0x30
[  111.119906]  [<ffffffff80286eb8>] ? lock_release_holdtime+0xa8/0x150
[  111.119913]  [<ffffffff802c8ae7>] ring_buffer_lock_reserve+0x1b7/0x1d0
[  111.119921]  [<ffffffff802cd110>] trace_buffer_lock_reserve+0x30/0x70
[  111.119930]  [<ffffffff802ce000>] trace_current_buffer_lock_reserve+0x20/0x30
[  111.119939]  [<ffffffff802474e8>] ftrace_raw_event_sched_switch+0x58/0x100
[  111.119948]  [<ffffffff808103b7>] __schedule+0x3a7/0x4cd
[  111.119957]  [<ffffffff80211b56>] ? ftrace_call+0x5/0x2b
[  111.119964]  [<ffffffff80211b56>] ? ftrace_call+0x5/0x2b
[  111.119971]  [<ffffffff80810c08>] schedule+0x18/0x40
[  111.119977]  [<ffffffff80810e09>] preempt_schedule+0x39/0x60
[  111.119985]  [<ffffffff80813bd3>] _read_unlock+0x53/0x60
[  111.119993]  [<ffffffff807259d2>] sock_def_readable+0x72/0x80
[  111.120002]  [<ffffffff807ad5ed>] unix_stream_sendmsg+0x24d/0x3d0
[  111.120011]  [<ffffffff807219a3>] sock_aio_write+0x143/0x160
[  111.120019]  [<ffffffff80211b56>] ? ftrace_call+0x5/0x2b
[  111.120026]  [<ffffffff80721860>] ? sock_aio_write+0x0/0x160
[  111.120033]  [<ffffffff80721860>] ? sock_aio_write+0x0/0x160
[  111.120042]  [<ffffffff8031c283>] do_sync_readv_writev+0xf3/0x140
[  111.120049]  [<ffffffff80211b56>] ? ftrace_call+0x5/0x2b
[  111.120057]  [<ffffffff80276ff0>] ? autoremove_wake_function+0x0/0x40
[  111.120067]  [<ffffffff8045d489>] ? cap_file_permission+0x9/0x10
[  111.120074]  [<ffffffff8045c1e6>] ? security_file_permission+0x16/0x20
[  111.120082]  [<ffffffff8031cab4>] do_readv_writev+0xd4/0x1f0
[  111.120089]  [<ffffffff80211b56>] ? ftrace_call+0x5/0x2b
[  111.120097]  [<ffffffff80211b56>] ? ftrace_call+0x5/0x2b
[  111.120105]  [<ffffffff8031cc18>] vfs_writev+0x48/0x70
[  111.120111]  [<ffffffff8031cd65>] sys_writev+0x55/0xc0
[  111.120119]  [<ffffffff80211e32>] system_call_fastpath+0x16/0x1b
[  111.120125] ---[ end trace 15605f4e98d5ccb5 ]---


Frederic.

 
> Also, could you test the following patch. It will give us
> more informations about the tracing recursion.
> 
> You can find it on:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing tracing/recursion
> 
> It's against tip/tracing/core
> 
> Thanks!
> 
> ---
> From d13bf59ca011b976c561f623e3189a4a5b94370e Mon Sep 17 00:00:00 2001
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Sun, 19 Apr 2009 15:30:19 +0200
> Subject: [PATCH] tracing/core: Add current context on tracing recursion warning
> 
> In case of tracing recursion detection, we only get the stacktrace.
> But the current context may be very useful to debug the issue.
> 
> This patch adds the softirq/hardirq/nmi context with the warning
> using lockdep context display to have a familiar output.
> 
> [ Impact: more information in tracing recursion ]
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/ring_buffer.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index b421b0e..27a6e7d 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -1493,8 +1493,21 @@ static int trace_recursive_lock(void)
>  	level = trace_irq_level();
>  
>  	if (unlikely(current->trace_recursion & (1 << level))) {
> +		static atomic_t warned;
> +
>  		/* Disable all tracing before we do anything else */
>  		tracing_off_permanent();
> +
> +		if (atomic_inc_return(&warned) == 1) {
> +			printk(KERN_WARNING "Tracing recursion: "
> +				"[HC%u[%lu]:SC%u[%lu]:NMI[%lu]:HE%u:SE%u]\n",
> +				current->hardirq_context,
> +				hardirq_count() >> HARDIRQ_SHIFT,
> +				current->softirq_context,
> +				softirq_count() >> SOFTIRQ_SHIFT,
> +				in_nmi(), current->hardirqs_enabled,
> +				current->softirqs_enabled);
> +		}
>  		WARN_ON_ONCE(1);
>  		return -1;
>  	}
> -- 
> 1.6.1
> 
> 

