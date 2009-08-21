Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbZHUKhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbZHUKhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 06:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755376AbZHUKhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 06:37:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331AbZHUKhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 06:37:46 -0400
Date: Fri, 21 Aug 2009 12:40:59 +0200
From: Michal Schmidt <mschmidt@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Mark McLoughlin <markmc@redhat.com>, linux-kernel@vger.kernel.org
Subject: DomU crashes during xenfb initialization
Message-ID: <20090821124059.17ab93fa@leela>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Fedora Rawhide kernels do not boot for me under Xen. It is reproducible
with current vanilla kernel too.

The guest seems to panic, though the panic message does not make it to
the console. Examining the guest with xenctx gives:

[root@hammerfall ~]# /usr/lib64/xen/bin/xenctx
-s /tmp/System.map-2.6.31-rc6 6 rip: ffffffff81017376
native_read_tsc+0x6 rsp: ffff88003e03d358
rax: 2af0dc51	rbx: 2acec4f3	rcx: 2af0dc2f	rdx:
00001315 rsi: 00000000	rdi: 0024ab09	rbp: ffff88003e03d358
 r8: 00000000	 r9: 00000000	r10: 00000000	r11:
00000000 r12: 0024ab09	r13: 00000009	r14:
ffff88003e040000	r15: 00000001 cs: 0000e033	 ds:
00000000	 fs: 00000000	 gs: 00000000

Stack:
 ffff88003e03d378 ffffffff8112088d 000000000000bdd6 ffffffff812b1160
 ffff88003e03d388 ffffffff811208ca ffff88003e03d398 ffffffff811208f5
 ffff88003e03d418 ffffffff811d6f6d 0000000000000000 ffff88003e040000
 ffffffff00000008 ffff88003e03d428 ffff88003e03d3d8 ffffffff81308000

Code:
89 f0 48 89 e5 e6 70 89 f8 e6 71 c9 c3 66 90 55 48 89 e5 0f 31 <89> c1
48 89 d0 48 c1 e0 20 89 c9 

Call Trace:
  [<ffffffff81017376>] native_read_tsc+0x6 <--
  [<ffffffff8112088d>] delay_tsc+0x2d
  [<ffffffff811208ca>] __delay+0xa
  [<ffffffff811208f5>] __const_udelay+0x25
  [<ffffffff811d6f6d>] panic+0x11c
  [<ffffffff810314bb>] do_exit+0x59b
  [<ffffffff810314fa>] do_exit+0x5da
  [<ffffffff8101484e>] oops_end+0x7e
  [<ffffffff8102104a>] no_context+0xea
  [<ffffffff810212e5>] __bad_area_nosemaphore+0x135
  [<ffffffff81052417>] __lock_acquire+0x1a7
  [<ffffffff8100e10d>] xen_force_evtchn_callback+0xd
  [<ffffffff8100e7e0>] check_events+0x12
  [<ffffffff810213ae>] bad_area_nosemaphore+0xe
  [<ffffffff810216f9>] do_page_fault+0x1c9
  [<ffffffff811d9ca5>] page_fault+0x25
  [<ffffffff8113eb0e>] notify_remote_via_irq+0xe
  [<ffffffff811d979c>] _spin_lock_irqsave+0x4c
  [<ffffffff8113c8c1>] xenfb_refresh+0x41
  [<ffffffff8113c7da>] xenfb_send_event+0x7a
  [<ffffffff8113c924>] xenfb_refresh+0xa4
  [<ffffffff8113a9dc>] sys_fillrect+0x18c
  [<ffffffff8100e10d>] xen_force_evtchn_callback+0xd
  [<ffffffff8100e7e0>] check_events+0x12
  [<ffffffff8113a2c0>] cfb_imageblit+0x500
  [<ffffffff8113cdd4>] xenfb_fillrect+0x34
  [<ffffffff81137845>] bit_clear_margins+0xf5
  [<ffffffff8115c240>] vc_do_resize+0x30
  [<ffffffff8113133c>] fbcon_clear_margins+0x4c
  [<ffffffff8113338c>] fbcon_prepare_logo+0x35c
  [<ffffffff8113671e>] fbcon_init+0x27e
  [<ffffffff8100e7cd>] xen_restore_fl_direct_reloc+0x4
  [<ffffffff81157380>] visual_init+0xa0
  [<ffffffff811598ac>] bind_con_driver+0x18c
  [<ffffffff81159ab4>] take_over_console+0x44
  [<ffffffff81133453>] fbcon_takeover+0x53
  [<ffffffff8113757d>] fbcon_event_notify+0x70d
  [<ffffffff8100e7e0>] check_events+0x12
  [<ffffffff8100e7cd>] xen_restore_fl_direct_reloc+0x4
  [<ffffffff81052f85>] lock_release+0xd5
  [<ffffffff811d950d>] _spin_unlock_irq+0x2d
  [<ffffffff811d90ec>] __down_read+0xac
  [<ffffffff81048dd7>] notifier_call_chain+0x47
  [<ffffffff81049155>] __blocking_notifier_call_chain+0x55
  [<ffffffff81049191>] blocking_notifier_call_chain+0x11
  [<ffffffff8112a346>] fb_notifier_call_chain+0x16
  [<ffffffff8112b513>] register_framebuffer+0x233
  [<ffffffff8113c44c>] xenfb_init_shared_page+0x6c
  [<ffffffff811d5c6f>] xenfb_probe+0x346
  [<ffffffff8114249b>] xenbus_dev_probe+0x7b
  [<ffffffff81169248>] driver_probe_device+0x88
  [<ffffffff811693db>] __driver_attach+0x9b
  [<ffffffff81169340>] driver_probe_device+0x180
  [<ffffffff81168794>] bus_for_each_dev+0x64
  [<ffffffff811690a9>] driver_attach+0x19
  [<ffffffff81168a3b>] bus_add_driver+0xbb
  [<ffffffff81324c07>] fb_console_init+0x121
  [<ffffffff811696c1>] driver_register+0x71
  [<ffffffff8100e7cd>] xen_restore_fl_direct_reloc+0x4
  [<ffffffff81324c07>] fb_console_init+0x121
  [<ffffffff811423c4>] xenbus_register_driver_common+0x24
  [<ffffffff811423f9>] __xenbus_register_frontend+0x29
  [<ffffffff81324ae6>] fb_console_setup+0x23a
  [<ffffffff81324c49>] xenfb_init+0x42
  [<ffffffff8100a06a>] do_one_initcall+0x3a
  [<ffffffff8105fe0f>] register_irq_proc+0x9f
  [<ffffffff81310620>] kernel_init+0x98
  [<ffffffff8102a34e>] schedule_tail+0xe
  [<ffffffff810119ca>] child_rip+0xa
  [<ffffffff81011524>] retint_restore_args+0x5
  [<ffffffff810119c0>] kernel_thread+0xe0

So it crashes during Xen framebuffer initialization. And indeed,
disabling CONFIG_XEN_FBDEV_FRONTEND helps, the kernel then boots fine.

I git-bisected it and found that the bug was introduced by this commit:
commit ced40d0f3e8833bb8d7d8e2cbfac7da0bf7008c4
Author: Jeremy Fitzhardinge <jeremy@goop.org>
Date:   Fri Feb 6 14:09:44 2009 -0800

    xen: pack all irq-related info together
    
    Put all irq info into one struct.  Also, use a union to keep
    event channel type-specific information, rather than overloading the
    index field.

After I reverted it (and three others that affected the same file to
avoid conflicts), the current kernel booted with a working Xen
framebuffer.

Michal
