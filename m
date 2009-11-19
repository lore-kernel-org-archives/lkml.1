Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbZKSKZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbZKSKZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 05:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755236AbZKSKZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 05:25:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977AbZKSKZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 05:25:38 -0500
Date: Thu, 19 Nov 2009 11:25:43 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Zombie process when ptracing
Message-ID: <20091119102543.GB5602@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Running recent git kernel, I have a process stuck in Z state

bash          ? 0000000000000000     0  3188   3187 0x00000000
 ffff88012e24fec8 0000000000000046 0000000000000000 0000000000000012
 ffff88012e24fec8 ffff88012e24e000 ffff88012e24ffd8 ffff88012e24e000
 000000000000efc8 ffff88012e24e000 ffff88012ea82090 ffff88012ff78640
Call Trace:
 [<ffffffff8124baee>] ? proc_clear_tty+0x5e/0x70
 [<ffffffff810587a8>] ? exit_ptrace+0xb8/0x140
 [<ffffffff8105126a>] do_exit+0x58a/0x7c0
 [<ffffffff810514dd>] do_group_exit+0x3d/0xb0
 [<ffffffff81051562>] sys_exit_group+0x12/0x20
 [<ffffffff8100b3eb>] system_call_fastpath+0x16/0x1b

This was after stracing a few test programs.

It also seems to have lost job control (^C) at the same time.

Hmm, and the kernel just paniced with an nmi lockup while I was
trying to get more info.

Call Trace:
 <IRQ>
 [<ffffffff811e5aa3>] __const_udelay+0x43/0x50
 [<ffffffff810261bc>] arch_trigger_all_cpu_backtrace+0x4c/0x70
 [<ffffffff81264f79>] sysrq_handle_showallcpus+0x9/0x10
 [<ffffffff81264d10>] __handle_sysrq+0x120/0x180
 [<ffffffff81264de6>] handle_sysrq+0x26/0x30
 [<ffffffff81275af0>] serial8250_handle_port+0x210/0x2f0
 [<ffffffff81275c58>] serial8250_interrupt+0x88/0x120
 [<ffffffff810872e7>] handle_IRQ_event+0xa7/0x1e0
 [<ffffffff810891cc>] handle_edge_irq+0xbc/0x150
 [<ffffffff8100e2df>] handle_irq+0x1f/0x30
 [<ffffffff8100d86a>] do_IRQ+0x6a/0xe0
 [<ffffffff8100bc93>] ret_from_intr+0x0/0xa
 <EOI>
 [<ffffffff81013842>] ? default_idle+0xa2/0xc0
 [<ffffffff8106f8d1>] ? __atomic_notifier_call_chain+0x31/0x60
 [<ffffffff81013b1a>] ? c1e_idle+0x3a/0x100
 [<ffffffff8106f911>] ? atomic_notifier_call_chain+0x11/0x20
 [<ffffffff8100a66b>] ? cpu_idle+0x6b/0xc0
 [<ffffffff81439dc6>] ? start_secondary+0x17c/0x1d6

I'll update this space if I can repeat it again. Any ideas?

