Return-Path: <linux-kernel-owner+w=401wt.eu-S935613AbZFOWUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935613AbZFOWUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 18:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760191AbZFOWUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 18:20:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43924 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758806AbZFOWUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 18:20:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 16 Jun 2009 00:20:12 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: 2.6.30-rc1 regression? -- epoll: BUG: sleeping function called from
 invalid context
To: Davide Libenzi <davidel@xmailserver.org>
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.dc33b782c61692c7@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like a regression after 2.6.29, before 2.6.30-rc1, caused by
commit 5071f97ec6d74f006072de0ce89b67c8792fe5a1, "epoll: fix epoll's own
poll" (since this introduced ep_scan_ready_list), but I haven't fully
investigated yet whether this is really the cause.

Test case:  Run any libraw1394 or libdc1394 based program on
firewire-core on a kernel with the usual selection of debugging options
configured in.  I didn't have these options enabled for a while, hence
noticed only now.

BUG: sleeping function called from invalid context at kernel/mutex.c:278
in_atomic(): 1, irqs_disabled(): 0, pid: 8301, name: dvgrab
no locks held by dvgrab/8301.
Pid: 8301, comm: dvgrab Tainted: G	  W  2.6.30 #2
Call Trace:
[<ffffffff80250bb2>] ? __debug_show_held_locks+0x22/0x24
[<ffffffff8022a91f>] __might_sleep+0x120/0x122
[<ffffffff8045192b>] mutex_lock_nested+0x25/0x2eb
[<ffffffff80253c25>] ? __lock_acquire+0x705/0x793
[<ffffffff802b8f5a>] ep_scan_ready_list+0x3c/0x185
[<ffffffff802b997f>] ? ep_read_events_proc+0x0/0x6c
[<ffffffff802b90b5>] ep_poll_readyevents_proc+0x12/0x14
[<ffffffff802b8b4f>] ep_call_nested+0x9f/0xfa
[<ffffffff802b90a3>] ? ep_poll_readyevents_proc+0x0/0x14
[<ffffffff802b8bf7>] ep_eventpoll_poll+0x4d/0x5b
[<ffffffff8029d525>] do_sys_poll+0x1b4/0x3b5
[<ffffffff8029e17a>] ? __pollwait+0x0/0xce
[<ffffffff8029e248>] ? pollwake+0x0/0x52
[<ffffffff8025162b>] ? mark_held_locks+0x4d/0x6a
[<ffffffff8020b900>] ? restore_args+0x0/0x30
[<ffffffff80251753>] ? trace_hardirqs_on_caller+0x10b/0x12f
[<ffffffff8025162b>] ? mark_held_locks+0x4d/0x6a
[<ffffffff8020b900>] ? restore_args+0x0/0x30
[<ffffffff80253c25>] ? __lock_acquire+0x705/0x793
[<ffffffff80251753>] ? trace_hardirqs_on_caller+0x10b/0x12f
[<ffffffff80251784>] ? trace_hardirqs_on+0xd/0xf
[<ffffffff80235a69>] ? timespec_add_safe+0x34/0x61
[<ffffffff802b9070>] ? ep_scan_ready_list+0x152/0x185
[<ffffffff802483f9>] ? ktime_get_ts+0x49/0x4e
[<ffffffff8029d26b>] ? poll_select_set_timeout+0x5c/0x7f
[<ffffffff8029d778>] sys_poll+0x52/0xb2
[<ffffffff8020aeab>] system_call_fastpath+0x16/0x1b

Any idea how to approach this?
-- 
Stefan Richter
-=====-==--= -==- =----
http://arcgraph.de/sr/

