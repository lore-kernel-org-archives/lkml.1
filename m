Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbYHUU1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbYHUU1D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 16:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbYHUU0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 16:26:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753373AbYHUU0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 16:26:52 -0400
Date: Thu, 21 Aug 2008 13:26:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: vegard.nossum@gmail.com, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: latest -git: suspend: unable to handle kernel paging request
 (was Re: no_console_suspend doesn't work?)
Message-Id: <20080821132642.8208f082.akpm@linux-foundation.org>
In-Reply-To: <200808212222.45444.rjw@sisk.pl>
References: <19f34abd0808211028w7889587fke523ff244339e7c5@mail.gmail.com>
	<200808212137.52757.rjw@sisk.pl>
	<19f34abd0808211308t2ee63a37kc204a5849231af45@mail.gmail.com>
	<200808212222.45444.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008 22:22:44 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Thursday, 21 of August 2008, Vegard Nossum wrote:
> > On Thu, Aug 21, 2008 at 9:37 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > Can you switch to SLAB and retest?  I don't really think SLUB is the issue
> > > here, but SLAB may give us additional information.
> > 
> > Got this with SLAB:
> 
> Well, it looks like this happened while devices were suspended, but I can't say
> what's going wrong.  Andrew?  Who's the right person to CC?

Pekka, I guess.

> > BUG: unable to handle kernel NULL pointer dereference at 00000000
> > IP: [<c03897ac>] list_del+0xc/0x90
> > *pdpt = 0000000031480001 *pde = 0000000000000000
> > Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> > Pid: 7, comm: events/0 Not tainted (2.6.27-rc4-00003-gef9b1bc #33)
> > EIP: 0060:[<c03897ac>] EFLAGS: 00010082 CPU: 0
> > EIP is at list_del+0xc/0x90
> > EAX: 00000000 EBX: f556afa0 ECX: f54a5380 EDX: f54e3128
> > ESI: f54f1ef0 EDI: f556afa0 EBP: f68b7ee0 ESP: f68b7ec8
> >  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> > Process events/0 (pid: 7, ti=f68b6000 task=f689c338 task.ti=f68b6000)
> > Stack: c015b62e f68b7ed4 c015b66d f68b7efc 00000046 f54f1f20 f68b7f1c c01b4054
> >        00000000 f689c338 f54e315c 00000001 f54f1f20 f54a5380 00000000 f54e3128
> >        f55b3348 00000000 f54f1f20 f54f1ef0 00000001 f68b7f3c c01b41ba 00000000
> > Call Trace:
> >  [<c015b62e>] ? get_lock_stats+0x1e/0x50
> >  [<c015b66d>] ? put_lock_stats+0xd/0x30
> >  [<c01b4054>] ? free_block+0xa4/0x1b0
> >  [<c01b41ba>] ? drain_array+0x5a/0xb0
> >  [<c01b4f82>] ? cache_reap+0x72/0x230
> >  [<c014ada7>] ? run_workqueue+0x107/0x200
> >  [<c014ae0a>] ? run_workqueue+0x16a/0x200
> >  [<c014ada7>] ? run_workqueue+0x107/0x200
> >  [<c01b4f10>] ? cache_reap+0x0/0x230
> >  [<c014b94d>] ? worker_thread+0x7d/0xe0
> >  [<c014e4f0>] ? autoremove_wake_function+0x0/0x50
> >  [<c014b8d0>] ? worker_thread+0x0/0xe0
> >  [<c014e1e2>] ? kthread+0x42/0x70
> >  [<c014e1a0>] ? kthread+0x0/0x70
> >  [<c0105cf3>] ? kernel_thread_helper+0x7/0x14
> >  =======================
> > Code: e8 01 89 44 24 04 e8 d4 1d db ff 8b 55 04 b8 48 2f 7a c0 e8 47 d8 dd ff e8
> >  c2 dc d7 ff eb a9 55 89 e5 53 89 c3 83 ec 14 8b 40 04 <8b> 00 39 d8 75 24 8b 13
> >  8b 42 04 39 d8 75 41 8b 43 04 89 42 04
> > EIP: [<c03897ac>] list_del+0xc/0x90 SS:ESP 0068:f68b7ec8

But slab hasn't changed in quite some time.  I expect something else
has reached over and scribbled on it.   Bisection time?


