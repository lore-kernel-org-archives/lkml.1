Return-Path: <linux-kernel-owner+w=401wt.eu-S932273AbZHDDOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbZHDDOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 23:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbZHDDOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 23:14:53 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58933 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755049AbZHDDOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 23:14:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 4 Aug 2009 12:12:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: npiggin@suse.de
Cc: linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-07-30-05-01 uploaded
Message-Id: <20090804121259.d0c4e202.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <200907301204.n6UC4Saf019612@imap1.linux-foundation.org>
References: <200907301204.n6UC4Saf019612@imap1.linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jul 2009 05:04:28 -0700
akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2009-07-30-05-01 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://git.zen-sources.org/zen/mmotm.git
> 

I'm sorry if already reported. When using SLQB, this warning is shown.


[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at kernel/lockdep.c:2131 trace_hardirqs_on_caller+0xb1/0x12f()
[    0.000000] Hardware name: VMware Virtual Platform
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.31-rc4-mm1 #1
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81060189>] ? trace_hardirqs_on_caller+0xb1/0x12f
[    0.000000]  [<ffffffff8103e14a>] warn_slowpath_common+0x77/0xa4
[    0.000000]  [<ffffffff814c8f4c>] ? _spin_unlock_irq+0x2b/0x30
[    0.000000]  [<ffffffff8103e186>] warn_slowpath_null+0xf/0x11
[    0.000000]  [<ffffffff81060189>] trace_hardirqs_on_caller+0xb1/0x12f
[    0.000000]  [<ffffffff81060214>] trace_hardirqs_on+0xd/0xf
[    0.000000]  [<ffffffff814c8f4c>] _spin_unlock_irq+0x2b/0x30
[    0.000000]  [<ffffffff814c89f2>] ? __down_write_nested+0x1c/0xa9
[    0.000000]  [<ffffffff814c8a0f>] __down_write_nested+0x39/0xa9
[    0.000000]  [<ffffffff810b97f6>] ? kmem_cache_open+0x2b1/0x460
[    0.000000]  [<ffffffff814c8a8a>] __down_write+0xb/0xd
[    0.000000]  [<ffffffff814c802d>] down_write+0x4a/0x4e
[    0.000000]  [<ffffffff810b97f6>] ? kmem_cache_open+0x2b1/0x460
[    0.000000]  [<ffffffff810b97f6>] kmem_cache_open+0x2b1/0x460
[    0.000000]  [<ffffffff818247bc>] kmem_cache_init+0x4d/0x352
[    0.000000]  [<ffffffff8181b837>] ? mem_init+0x156/0x161
[    0.000000]  [<ffffffff81808adf>] start_kernel+0x1cd/0x3ab
[    0.000000]  [<ffffffff8180829a>] x86_64_start_reservations+0xaa/0xae
[    0.000000]  [<ffffffff8180837f>] x86_64_start_kernel+0xe1/0xe8
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000000] start_kernel(): bug: interrupts were enabled *very* early, fixing it

This is because down_write() uses spin_lock_irq(), not spin_lock_irqsave().
I think this is sane because down_write() is not called under irq-disabled.
By this, irq is enabled before init_IRQ().

SLUB don't have this bug because it uses special routine for initializing
kmalloc area. (See slub.c::create_kmalloc_cache(), it's commented.)

Thanks,
-Kame

