Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbYB1PIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbYB1PIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 10:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756103AbYB1PIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 10:08:05 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45045 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144AbYB1PIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 10:08:04 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 28 Feb 2008 16:07:55 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: hfsplus_unlink...hfsplus_block_free: lockdep warning
To: linux-kernel@vger.kernel.org
cc: Roman Zippel <zippel@linux-m68k.org>,
       Peter Zijlstra <peterz@infradead.org>
Message-ID: <tkrat.9bcd69644c113f6d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got this with 2.6.25-rc3 when doing an rm -rf on a HFS+ filesystem:


[ INFO: possible recursive locking detected ]
2.6.25-rc3 #6
---------------------------------------------
rm/7564 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#8){--..}, at: [<ffffffff880fc4ba>] hfsplus_block_free+0x57/0x209 [hfsplus]

but task is already holding lock:
 (&sb->s_type->i_mutex_key#8){--..}, at: [<ffffffff80284f1c>] vfs_unlink+0x41/0xb7

other info that might help us debug this:
2 locks held by rm/7564:
 #0:  (&type->i_mutex_dir_key#5/1){--..}, at: [<ffffffff80286cac>] do_unlinkat+0x6c/0x154
 #1:  (&sb->s_type->i_mutex_key#8){--..}, at: [<ffffffff80284f1c>] vfs_unlink+0x41/0xb7

stack backtrace:
Pid: 7564, comm: rm Not tainted 2.6.25-rc3 #6

Call Trace:
 [<ffffffff802497bb>] __lock_acquire+0x849/0xbd5
 [<ffffffff880fc4ba>] :hfsplus:hfsplus_block_free+0x57/0x209
 [<ffffffff80249efd>] lock_acquire+0x51/0x6c
 [<ffffffff880fc4ba>] :hfsplus:hfsplus_block_free+0x57/0x209
 [<ffffffff80246b71>] debug_mutex_lock_common+0x16/0x23
 [<ffffffff80418eb0>] mutex_lock_nested+0xd9/0x268
 [<ffffffff880fc4ba>] :hfsplus:hfsplus_block_free+0x57/0x209
 [<ffffffff880f647f>] :hfsplus:hfsplus_free_extents+0x54/0x9b
 [<ffffffff880f6a92>] :hfsplus:hfsplus_file_truncate+0xa4/0x2ce
 [<ffffffff880f52de>] :hfsplus:hfsplus_delete_inode+0x57/0x5d
 [<ffffffff880f77e6>] :hfsplus:hfsplus_unlink+0xd0/0x158
 [<ffffffff80284f36>] vfs_unlink+0x5b/0xb7
 [<ffffffff80286cf1>] do_unlinkat+0xb1/0x154
 [<ffffffff80419e4c>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff80248b03>] trace_hardirqs_on+0xf3/0x117
 [<ffffffff80419e4c>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff880fb4a5>] :hfsplus:hfsplus_uni2asc+0x251/0x29f
 [<ffffffff8020b0bb>] system_call_after_swapgs+0x7b/0x80


Is this merely a case for annotation?
-- 
Stefan Richter
-=====-==--- --=- ===--
http://arcgraph.de/sr/

