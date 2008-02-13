Return-Path: <linux-kernel-owner+w=401wt.eu-S1765896AbYBMHJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765896AbYBMHJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 02:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbYBMHJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 02:09:15 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45115 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755445AbYBMHJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 02:09:13 -0500
Date: Tue, 12 Feb 2008 23:07:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, john stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [stable 2.6.24] WARNING: at kernel/time/clockevents.c
Message-Id: <20080212230741.576b8004.akpm@linux-foundation.org>
In-Reply-To: <200802101440.22118.elendil@planet.nl>
References: <200802101440.22118.elendil@planet.nl>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Feb 2008 14:40:21 +0100 Frans Pop <elendil@planet.nl> wrote:

> Kernel: vanilla 2.6.24 x86_64 SMP
> Environment: Debian unstable
> Processor: Intel(R) Pentium(R) D CPU 3.20GHz (dual core)
> 
> I've been running this kernel without problems since its release, but 
> yesterday evening I suddenly got the following error, and this afternoon it 
> was repeated (below). The system had been powered down in between.
> 
> I have no idea yet what triggers it and am unsure if I'll be able to 
> reproduce.
> 
> WARNING: at kernel/time/clockevents.c:82 clockevents_program_event()
> Pid: 2210, comm: ld-linux-x86-64 Not tainted 2.6.24 #1
> 
> Call Trace:
>  [<ffffffff8024af78>] ktime_get+0xc/0x41
>  [<ffffffff8024ea21>] clockevents_program_event+0x3b/0x94
>  [<ffffffff8024f890>] tick_program_event+0x31/0x4d
>  [<ffffffff8024a2c3>] hrtimer_reprogram+0x3b/0x51
>  [<ffffffff8024a43e>] enqueue_hrtimer+0x66/0x102
>  [<ffffffff8024ad01>] hrtimer_start+0x105/0x128
>  [<ffffffff803f8c9c>] rt_mutex_slowlock+0x90/0x53a
>  [<ffffffff80277a00>] find_extend_vma+0x16/0x59
>  [<ffffffff8025097a>] get_futex_key+0x82/0x14e
>  [<ffffffff80251a8d>] futex_lock_pi+0x60f/0x90d
>  [<ffffffff8024a6d3>] hrtimer_wakeup+0x0/0x21
>  [<ffffffff803f8c9c>] rt_mutex_slowlock+0x90/0x53a
>  [<ffffffff80252793>] do_futex+0xa08/0xa3d
>  [<ffffffff8022bd23>] __dequeue_entity+0x1c/0x32
>  [<ffffffff803f8261>] thread_return+0x3a/0xab
>  [<ffffffff802528a8>] sys_futex+0xe0/0xfe
>  [<ffffffff8020befe>] system_call+0x7e/0x83
> 

	if (unlikely(expires.tv64 < 0)) {
		WARN_ON_ONCE(1);
		return -ETIME;
	}

the hrtimer code is preparing an invalid ktime_t.  Note that
clockevents_program_event() actually fails when this happens - I am
surprised that this is not causing observeable userspace problems.

The WARN_ON_ONCE() means that you'll only see this warning once per boot. 
But the actually error could be happening any number of times without being
reported.

Looks pretty serious?
