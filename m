Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbXHAWkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbXHAWkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 18:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587AbXHAWkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 18:40:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620AbXHAWkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 18:40:24 -0400
Message-ID: <46B10BB7.60900@redhat.com>
Date: Wed, 01 Aug 2007 18:39:51 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>
Subject: Processes spinning forever, apparently in lock_timer_base()?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like the same problem with spinlock unfairness we've seen
elsewhere: it seems to be looping here? Or is everyone stuck
just waiting for writeout?

lock_timer_base():
        for (;;) {
                tvec_base_t *prelock_base = timer->base;
                base = tbase_get_base(prelock_base);
                if (likely(base != NULL)) {
                        spin_lock_irqsave(&base->lock, *flags);
                        if (likely(prelock_base == timer->base))
                                return base;
                        /* The timer has migrated to another CPU */
                        spin_unlock_irqrestore(&base->lock, *flags);
                }
                cpu_relax();
        }

The problem goes away completely if filesystem are mounted
*without* noatime. Has happened in 2.6.20 through 2.6.22...

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=249563

Part of sysrq-t listing:

mysqld        D 000017c0  2196 23162   1562
       e383fcb8 00000082 61650954 000017c0 e383fc9c 00000000 c0407208 e383f000 
       a12b0434 00004d1d c6ed2c00 c6ed2d9c c200fa80 00000000 c0724640 f6c60540 
       c4ff3c70 00000508 00000286 c042ffcb e383fcc8 00014926 00000000 00000286 
Call Trace:
 [<c0407208>] do_IRQ+0xbd/0xd1
 [<c042ffcb>] lock_timer_base+0x19/0x35
 [<c04300df>] __mod_timer+0x9a/0xa4
 [<c060bb55>] schedule_timeout+0x70/0x8f
 [<c042fd37>] process_timeout+0x0/0x5
 [<c060bb50>] schedule_timeout+0x6b/0x8f
 [<c060b67c>] io_schedule_timeout+0x39/0x5d
 [<c0465eea>] congestion_wait+0x50/0x64
 [<c0438539>] autoremove_wake_function+0x0/0x35
 [<c04620e2>] balance_dirty_pages_ratelimited_nr+0x148/0x193
 [<c045e7fd>] generic_file_buffered_write+0x4c7/0x5d3


named         D 000017c0  2024  1454      1
       f722acb0 00000082 6165ed96 000017c0 c1523e80 c16f0c00 c16f20e0 f722a000 
       a12be87d 00004d1d f768ac00 f768ad9c c200fa80 00000000 00000000 f75bda80 
       c0407208 00000508 00000286 c042ffcb f722acc0 00020207 00000000 00000286 
Call Trace:
 [<c0407208>] do_IRQ+0xbd/0xd1
 [<c042ffcb>] lock_timer_base+0x19/0x35
 [<c04300df>] __mod_timer+0x9a/0xa4
 [<c060bb55>] schedule_timeout+0x70/0x8f
 [<c042fd37>] process_timeout+0x0/0x5
 [<c060bb50>] schedule_timeout+0x6b/0x8f
 [<c060b67c>] io_schedule_timeout+0x39/0x5d
 [<c0465eea>] congestion_wait+0x50/0x64
 [<c0438539>] autoremove_wake_function+0x0/0x35
 [<c04620e2>] balance_dirty_pages_ratelimited_nr+0x148/0x193
 [<c045e7fd>] generic_file_buffered_write+0x4c7/0x5d3


mysqld        D 000017c0  2196 23456   1562
       e9293cb8 00000082 616692ed 000017c0 e9293c9c 00000000 e9293cc8 e9293000 
       a12c8dd0 00004d1d c3d5ac00 c3d5ad9c c200fa80 00000000 c0724640 f6c60540 
       e9293d10 c07e1f00 00000286 c042ffcb e9293cc8 0002b57f 00000000 00000286 
Call Trace:
 [<c042ffcb>] lock_timer_base+0x19/0x35
 [<c04300df>] __mod_timer+0x9a/0xa4
 [<c060bb55>] schedule_timeout+0x70/0x8f
 [<c042fd37>] process_timeout+0x0/0x5
 [<c060bb50>] schedule_timeout+0x6b/0x8f
 [<c060b67c>] io_schedule_timeout+0x39/0x5d
 [<c0465eea>] congestion_wait+0x50/0x64
 [<c0438539>] autoremove_wake_function+0x0/0x35
 [<c04620e2>] balance_dirty_pages_ratelimited_nr+0x148/0x193
 [<c045e7fd>] generic_file_buffered_write+0x4c7/0x5d3
