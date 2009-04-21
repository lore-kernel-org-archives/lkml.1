Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbZDUBf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbZDUBf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbZDUBfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:35:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51359 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbZDUBfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:35:10 -0400
Date: Mon, 20 Apr 2009 21:35:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [BUG] NULL pointer crash in early NMI handler
Message-ID: <alpine.DEB.2.00.0904202113520.10097@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm hitting this bug in latest Linus tree:

[    0.161089] Setting APIC routing to flat
[    0.171346] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.180001] BUG: unable to handle kernel NULL pointer dereference at 
(null)
[    0.180001] IP: [<ffffffff8063f8a6>] nmi_watchdog_tick+0xd0/0x27d

[...]

[    0.180001] Call Trace:
[    0.180001]  <NMI> <0> [<ffffffff8063e9b7>] do_nmi+0x12e/0x3af
[    0.180001]  [<ffffffff8063e59a>] nmi+0x1a/0x2c
[    0.180001]  [<ffffffff806415c2>] ? add_preempt_count+0xdc/0x18b
[    0.180001]  <<EOE>> <0> [<ffffffff8040944c>] delay_tsc+0xa7/0x13b
[    0.180001]  [<ffffffff804092df>] __delay+0xf/0x11
[    0.180001]  [<ffffffff80409322>] __const_udelay+0x41/0x43
[    0.180001]  [<ffffffff80f18539>] timer_irq_works+0x4e/0xb0
[    0.180001]  [<ffffffff80f18ad4>] setup_IO_APIC+0x539/0xb26
[    0.180001]  [<ffffffff8041b840>] ? debug_smp_processor_id+0x38/0x170
[    0.180001]  [<ffffffff80226152>] ? setup_apic_nmi_watchdog+0xb8/0xdb
[    0.180001]  [<ffffffff80f14231>] native_smp_prepare_cpus+0x606/0x6be
[    0.180001]  [<ffffffff80f05a30>] kernel_init+0x56/0x1fc
[    0.180001]  [<ffffffff8020d7fa>] child_rip+0xa/0x20
[    0.180001]  [<ffffffff8020d1c0>] ? restore_args+0x0/0x30
[    0.180001]  [<ffffffff80f059da>] ? kernel_init+0x0/0x1fc
[    0.180001]  [<ffffffff8020d7f0>] ? child_rip+0x0/0x20


Looking into exactly where it crashed, it seems to be when it accesses the 
CPU mask variable backtrace_mask.

When the APIC routing is set to flat, it somehow starts triggering the NMI 
watchdog. This happens before we run "check_nmi_watchdog" which is what 
allocates the backtrace_mask cpu mask.

Yes I have CONFIG_CPUMASK_OFFSTACK=y.

When I disable it, the box boots up fine.

-- Steve

