Return-Path: <linux-kernel-owner+w=401wt.eu-S1757694AbXEaSyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757694AbXEaSyK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759162AbXEaSx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:53:57 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756464AbXEaSx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:53:56 -0400
Date: Thu, 31 May 2007 11:53:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Subject: Re: 2.6.22-rc3-mm1
Message-Id: <20070531115319.967f9ff7.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705311136200.11008@schroedinger.engr.sgi.com>
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
	<465F0B83.2050100@googlemail.com>
	<20070531113155.1c6d7185.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705311136200.11008@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 11:41:22 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> > Perhaps a suitable fix would be local_irq_disable() in flush_slab().
> 
> As far as I can tell: Interrupts are always disabled when flush_slab is 
> run. 
> 
> Sometimes we use spin_lock_irqsave for the list_lock and at other times 
> spin_lock if interrupts are already disabled. Is that the problem?

Nope, the problem is in the part of my email which you deleted ;)

[ 4972.243670] 
[ 4972.243670] stack backtrace:
[ 4972.248166]  [<c0105281>] dump_trace+0x63/0x1eb
[ 4972.252755]  [<c0105423>] show_trace_log_lvl+0x1a/0x2f
[ 4972.257969]  [<c0106061>] show_trace+0x12/0x14
[ 4972.262463]  [<c0106079>] dump_stack+0x16/0x18
[ 4972.266974]  [<c0142ff8>] print_usage_bug+0x140/0x14a
[ 4972.272109]  [<c0143e1a>] mark_lock+0x29e/0x557
[ 4972.276708]  [<c0144cda>] __lock_acquire+0x4f1/0xd36
[ 4972.281740]  [<c01455bd>] lock_acquire+0x9e/0xb8
[ 4972.286416]  [<c0348993>] _spin_lock+0x38/0x62
[ 4972.290936]  [<c0181288>] add_partial+0xe/0x27
[ 4972.295458]  [<c0181cd7>] deactivate_slab+0x67/0x179
[ 4972.300497]  [<c0181e56>] flush_slab+0x6d/0x72
[ 4972.305018]  [<c0181e8c>] __flush_cpu_slab+0x31/0x36
[ 4972.310049]  [<c01836e8>] slab_cpuup_callback+0x38/0x5b
[ 4972.315348]  [<c01325d2>] notifier_call_chain+0x2b/0x4a
[ 4972.320637]  [<c013261e>] __raw_notifier_call_chain+0x19/0x1e
[ 4972.326473]  [<c013263d>] raw_notifier_call_chain+0x1a/0x1c
[ 4972.332117]  [<c014bb62>] _cpu_down+0x19c/0x25a
[ 4972.336724]  [<c014bc48>] cpu_down+0x28/0x3a
[ 4972.341063]  [<c027f800>] store_online+0x27/0x5a
[ 4972.345757]  [<c027c854>] sysdev_store+0x20/0x25
[ 4972.350443]  [<c01c2739>] sysfs_write_file+0xc5/0xfd
[ 4972.355482]  [<c0187243>] vfs_write+0xd1/0x15a
[ 4972.360004]  [<c0187873>] sys_write+0x3d/0x72
[ 4972.364411]  [<c01041e0>] syscall_call+0x7/0xb
[ 4972.368924]  [<b7ff0410>] 0xb7ff0410
[ 4972.372562]  =======================
[ 4975.412963] lockdep: not fixing up alternatives.

we're not disbling local irqs on the cpu hotplug path.

Could do local_irq_disable() in slab_cpuup_callback(), I guess.
