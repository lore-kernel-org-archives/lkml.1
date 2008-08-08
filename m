Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbYHHKuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbYHHKuU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 06:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbYHHKtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 06:49:55 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:45072 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbYHHKtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 06:49:53 -0400
Subject: Re: INFO: possible recursive locking detected ps2_command
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       Rabin Vincent <rabin@rab.in>
In-Reply-To: <20080801030444.GB18953@anvil.corenet.prv>
References: <c4e36d110807310241n512b01e4v898e883d740de879@mail.gmail.com>
	 <20080731145739.fe8923be.akpm@linux-foundation.org>
	 <20080801030444.GB18953@anvil.corenet.prv>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 12:49:49 +0200
Message-Id: <1218192589.8625.88.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-31 at 23:04 -0400, Dmitry Torokhov wrote:
> On Thu, Jul 31, 2008 at 02:57:39PM -0700, Andrew Morton wrote:
> > 
> > (cc linux-input)
> > 
> > On Thu, 31 Jul 2008 11:41:25 +0200
> > "Zdenek Kabelac" <zdenek.kabelac@gmail.com> wrote:
> > 
> > > Hi
> > > 
> > > During mouse unplugging from psaux connector from the laptops' docking
> > > station I've got attached INFO trace.
> > > (laptops still has synaptics device)
> > > 
> 
> Dell?
> 
> > > Also for unknown reason to me  psaux mouse & synaptic device do not
> > > work somehow together - is it hw limitation
> > > of /dev/input/mice  interface?
> > > (USB mouse and synaptics do work quite well together)
> > > 
> > > [ INFO: possible recursive locking detected ]
> > > 2.6.27-rc1 #48
> > 
> > (it's 2.6.27-rc1)
> > 
> 
> Peter, here is the trace we talked about long time ago. For some reason
> lockdep annotation only works once. If reconnect is forced or psmouse
> module is reloaded lockdep starts complaining about passthrough port.

Bit puzzling - and I don't have any ps2 hardware around to test with
(nor do I normally use modules - but that is fixable of course).

Does Rabin's patch help?

  http://lkml.org/lkml/2008/8/7/329

> > > ---------------------------------------------
> > > kseriod/166 is trying to acquire lock:
> > >  (&ps2dev->cmd_mutex){--..}, at: [<ffffffff8126e9ae>] ps2_command+0x5e/0x460
> > > 
> > > but task is already holding lock:
> > >  (&ps2dev->cmd_mutex){--..}, at: [<ffffffff8126e9ae>] ps2_command+0x5e/0x460
> > > 
> > > other info that might help us debug this:
> > > 4 locks held by kseriod/166:
> > >  #0:  (serio_mutex){--..}, at: [<ffffffff8126cc1e>] serio_thread+0x3e/0x410
> > >  #1:  (&serio->drv_mutex){--..}, at: [<ffffffff8126bf8b>]
> > > serio_connect_driver+0x2b/0x50
> > >  #2:  (psmouse_mutex){--..}, at: [<ffffffffa009aa00>]
> > > psmouse_connect+0x30/0x2c0 [psmouse]
> > >  #3:  (&ps2dev->cmd_mutex){--..}, at: [<ffffffff8126e9ae>]
> > > ps2_command+0x5e/0x460
> > > 
> > > stack backtrace:
> > > Pid: 166, comm: kseriod Not tainted 2.6.27-rc1 #48
> > > 
> > > Call Trace:
> > >  [<ffffffff81068bda>] __lock_acquire+0xcea/0x13b0
> > >  [<ffffffff81066401>] ? trace_hardirqs_off_caller+0x21/0xc0
> > >  [<ffffffff810664ad>] ? trace_hardirqs_off+0xd/0x10
> > >  [<ffffffff8126e9ae>] ? ps2_command+0x5e/0x460
> > >  [<ffffffff81069336>] lock_acquire+0x96/0xe0
> > >  [<ffffffff8126e9ae>] ? ps2_command+0x5e/0x460
> > >  [<ffffffff81313861>] mutex_lock_nested+0xc1/0x340
> > >  [<ffffffff8126e9ae>] ? ps2_command+0x5e/0x460
> > >  [<ffffffff810135a0>] ? native_sched_clock+0x90/0xb0
> > >  [<ffffffff8126e9ae>] ps2_command+0x5e/0x460
> > >  [<ffffffff81066401>] ? trace_hardirqs_off_caller+0x21/0xc0
> > >  [<ffffffff81065834>] ? get_lock_stats+0x34/0x70
> > >  [<ffffffffa009977d>] psmouse_sliced_command+0x2d/0x90 [psmouse]
> > >  [<ffffffff8126e838>] ? ps2_sendbyte+0x48/0x130
> > >  [<ffffffffa009b8f7>] synaptics_pt_write+0x27/0x60 [psmouse]
> > >  [<ffffffff81315acd>] ? _spin_unlock_irq+0x3d/0x80
> > >  [<ffffffff8126e84d>] ps2_sendbyte+0x5d/0x130
> > >  [<ffffffff81319840>] ? sub_preempt_count+0x80/0x120
> > >  [<ffffffff8126ea4d>] ps2_command+0xfd/0x460
> > >  [<ffffffff81319840>] ? sub_preempt_count+0x80/0x120
> > >  [<ffffffff81315acd>] ? _spin_unlock_irq+0x3d/0x80
> > >  [<ffffffffa0099917>] psmouse_probe+0x27/0xa0 [psmouse]
> > >  [<ffffffff8126c1e1>] ? serio_open+0x11/0x50
> > >  [<ffffffffa009ab48>] psmouse_connect+0x178/0x2c0 [psmouse]
> > >  [<ffffffff8126bf96>] serio_connect_driver+0x36/0x50
> > >  [<ffffffff8126bfcb>] serio_driver_probe+0x1b/0x20
> > >  [<ffffffff81221112>] driver_probe_device+0xa2/0x1e0
> > >  [<ffffffff812212e0>] ? __device_attach+0x0/0x10
> > >  [<ffffffff812212e9>] __device_attach+0x9/0x10
> > >  [<ffffffff8122050b>] bus_for_each_drv+0x6b/0xa0
> > >  [<ffffffff812213b8>] device_attach+0x88/0x90
> > >  [<ffffffff812202d5>] bus_attach_device+0x55/0x80
> > >  [<ffffffff8121ee99>] device_add+0x4f9/0x610
> > >  [<ffffffff81319840>] ? sub_preempt_count+0x80/0x120
> > >  [<ffffffff8126ce1c>] serio_thread+0x23c/0x410
> > >  [<ffffffff810571a0>] ? autoremove_wake_function+0x0/0x40
> > >  [<ffffffff8126cbe0>] ? serio_thread+0x0/0x410
> > >  [<ffffffff81056de9>] kthread+0x49/0x90
> > >  [<ffffffff8100d669>] child_rip+0xa/0x11
> > >  [<ffffffff8103b757>] ? finish_task_switch+0x57/0x110
> > >  [<ffffffff81315acd>] ? _spin_unlock_irq+0x3d/0x80
> > >  [<ffffffff8100cc73>] ? restore_args+0x0/0x30
> > >  [<ffffffff810664ad>] ? trace_hardirqs_off+0xd/0x10
> > >  [<ffffffff81056da0>] ? kthread+0x0/0x90
> > >  [<ffffffff8100d65f>] ? child_rip+0x0/0x11

