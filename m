Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbYDOVZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbYDOVZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932697AbYDOVYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:24:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39653 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932513AbYDOVYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:24:49 -0400
Date: Tue, 15 Apr 2008 23:24:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [bug] SLUB + mm/slab.c boot crash in -rc9
Message-ID: <20080415212430.GA5467@elte.hu>
References: <20080415161532.GA15088@elte.hu> <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org> <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com> <20080415195430.GA23015@elte.hu> <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com> <20080415201734.GA25628@elte.hu> <4805115D.5030703@cs.helsinki.fi> <20080415204025.GA29784@elte.hu> <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org> <20080415211359.GA1531@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415211359.GA1531@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> ok, will try that now.

btw., as i progress with that bisection effort, i triggered new crash 
patterns, which lappen later during bootup:

[    0.775886] initcall 0xc0b00559 ran for 0 msecs: ksysfs_init+0x0/0x96()
[    0.777885] Calling initcall 0xc0b01eb8: filelock_init+0x0/0x27()
[    0.780137] BUG: unable to handle kernel NULL pointer dereference at 00000001
[    0.782883] IP: [<c0293981>] strlen+0xb/0x15
[    0.784884] *pde = 00000000 
[    0.786889] Oops: 0000 [#1] SMP 
[    0.787880] 
[    0.787880] Pid: 1, comm: swapper Not tainted (2.6.24-05281-g6232665 #3)
[    0.787880] EIP: 0060:[<c0293981>] EFLAGS: 00010286 CPU: 0
[    0.787880] EIP is at strlen+0xb/0x15
[    0.787880] EAX: 00000000 EBX: 00040000 ECX: ffffffff EDX: 00040000
[    0.787880] ESI: c0915320 EDI: 00000001 EBP: f7c23f08 ESP: f7c23f04
[    0.787880]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.787880] Process swapper (pid: 1, ti=f7c22000 task=f7c20000 task.ti=f7c22000)
[    0.787880] Stack: f7c1f540 f7c23f18 c015b138 00000094 c016b45a f7c23f48 c015c92c c016b45a 
[    0.787880]        00000025 c0915320 f7c1f540 000000d0 f7c23f58 00000282 f7c1f540 00000000 
[    0.787880]        00000000 f7c23f84 c015cbc8 00000060 00000000 00040000 c016b45a c0133e81 
[    0.787880] Call Trace:
[    0.787880]  [<c015b138>] ? kmem_cache_flags+0x3d/0x5b
[    0.787880]  [<c016b45a>] ? init_once+0x0/0xc
[    0.787880]  [<c015c92c>] ? kmem_cache_open+0x64/0x128
[    0.787880]  [<c016b45a>] ? init_once+0x0/0xc
[    0.787880]  [<c015cbc8>] ? kmem_cache_create+0x14e/0x1d6
[    0.787880]  [<c016b45a>] ? init_once+0x0/0xc
[    0.787880]  [<c0133e81>] ? ktime_get_ts+0x3b/0x3f
[    0.787880]  [<c0133e96>] ? ktime_get+0x11/0x2f
[    0.787880]  [<c0b01ed6>] ? filelock_init+0x1e/0x27
[    0.787880]  [<c016b45a>] ? init_once+0x0/0xc
[    0.787880]  [<c0af176d>] ? kernel_init+0x13f/0x298
[    0.787880]  [<c0103b46>] ? ret_from_fork+0x6/0x20
[    0.787880]  [<c0af162e>] ? kernel_init+0x0/0x298
[    0.787880]  [<c0af162e>] ? kernel_init+0x0/0x298
[    0.787880]  [<c0104ed7>] ? kernel_thread_helper+0x7/0x10
[    0.787880]  =======================
[    0.787880] Code: 5d c3 55 89 e5 56 89 c6 89 d0 88 c4 ac 38 e0 74 09 84 c0 75 f7 be 01 00 00 00 89 f0 48 5e 5d c3 55 89 e5 57 89 c7 31 c0 83 c9 ff <f2> ae f7 d1 49 89 c8 5f 5d c3 55 89 e5 57 89 c7 89 d0 31 d2 85 
[    0.787880] EIP: [<c0293981>] strlen+0xb/0x15 SS:ESP 0068:f7c23f04
[    0.787906] ---[ end trace ca143223eefdc828 ]---
[    0.788890] Kernel panic - not syncing: Attempted to kill init!
[    0.789899] Rebooting in 10 seconds..

	Ingo
