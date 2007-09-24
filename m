Return-Path: <linux-kernel-owner+w=401wt.eu-S1758730AbXIXNxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730AbXIXNxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 09:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbXIXNxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 09:53:14 -0400
Received: from canuck.infradead.org ([209.217.80.40]:36857 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbXIXNxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 09:53:13 -0400
Date: Mon, 24 Sep 2007 15:53:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, nickpiggin@yahoo.com.au,
       trond.myklebust@fys.uio.no
Subject: Re: + git-nfs-vs-nfs-convert-to-new-aops.patch added to -mm tree
Message-ID: <20070924155303.101c6cdf@twins>
In-Reply-To: <20070920132047.7c2ee42a@twins>
References: <200708202301.l7KN1GAH028291@imap1.linux-foundation.org>
	<20070920132047.7c2ee42a@twins>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 13:20:47 +0200 Peter Zijlstra
<peterz@infradead.org> wrote:

> /me continues the mmap write on nfs adventure...

My test prog reliably hangs like so:

mm_tester     D 000000000040b305     0  2701   2699
6042cef0 602ca520 617dfa50 617de000 617dfa90 60010b62 617dfa80 6002785d
       617de000 60583840 6042bcc0 6042ca40 617dfad0 6019e3c2 00080000 617de000
       617dfae0 ffffc0e7 617dfb38 00000002 617dfb60 6019eb20 616e7ae0 6048bd00 Call Trace:
Call Trace:
617dfa58:  [<60010b62>] _switch_to+0x81/0xf5
617dfa68:  [<6002785d>] pick_next_entity+0x1a/0x38
617dfa98:  [<6019e3c2>] schedule+0x1b8/0x23f
617dfad8:  [<6019eb20>] schedule_timeout+0xa2/0xcb
617dfaf8:  [<60035dc3>] process_timeout+0x0/0xb
617dfb10:  [<6019eb1b>] schedule_timeout+0x9d/0xcb
617dfb68:  [<6019ea62>] io_schedule_timeout+0xf/0x17
617dfb78:  [<6004f0d1>] sync_page+0x6b/0x6f
617dfb88:  [<6019ecd3>] __wait_on_bit_lock+0x42/0x78
617dfbb0:  [<6004fa2a>] find_lock_page+0xb4/0x155
617dfbc8:  [<6004f806>] __lock_page+0x73/0xb3
617dfbf0:  [<60040585>] wake_bit_function+0x0/0x2a
617dfc38:  [<6004fa3c>] find_lock_page+0xc6/0x155
617dfc48:  [<600570c9>] do_page_cache_readahead+0x52/0x5f
617dfc78:  [<600508ea>] filemap_fault+0x151/0x2c2
617dfce8:  [<6005e9c8>] __do_fault+0x6c/0x444
617dfd68:  [<6005edd1>] do_linear_fault+0x31/0x33
617dfd88:  [<6005f04e>] handle_mm_fault+0x130/0x228
617dfda8:  [<6011e2d7>] __up_read+0x73/0x7b
617dfde8:  [<600131d4>] handle_page_fault+0x120/0x2d9
617dfe08:  [<601242c8>] tty_write+0x1f7/0x212
617dfe48:  [<60013513>] segv+0xac/0x286
617dff28:  [<60013461>] segv_handler+0x68/0x6e
617dff48:  [<600232c9>] get_skas_faultinfo+0x9c/0xa1
617dff68:  [<6002386f>] userspace+0x13a/0x19d
617dffc8:  [<60010d4c>] fork_handler+0x86/0x8d


A new nfs_sync_page() method tells me:

sleeping on page: 0000000060ba05c0 held by: [<000000006004f5d1>] add_to_page_cache_lru+0xf/0x3a


And a rather crude printk() and dump_stack() in add_to_page_cache_lru()
match:

page: 0000000060ba05c0
Call Trace:
605eda88:  [<6004f5f4>] add_to_page_cache_lru+0x32/0x3a
605edaa8:  [<60056ddc>] read_cache_pages+0x4a/0x8f
605edae8:  [<600f8e49>] nfs_readpages+0x116/0x164
605edb38:  [<600f86bb>] nfs_pagein_one+0x0/0xd2
605edb98:  [<60056e58>] read_pages+0x37/0x9b
605edbd8:  [<60056fbc>] __do_page_cache_readahead+0x100/0x146
605edc48:  [<600570dd>] do_page_cache_readahead+0x52/0x5f
605edc78:  [<600508f4>] filemap_fault+0x145/0x2c2
605edca8:  [<60022b7d>] run_syscall_stub+0xd1/0xdd
605edce8:  [<6005e9dc>] __do_fault+0x6c/0x444
605edd68:  [<6005ede5>] do_linear_fault+0x31/0x33
605edd88:  [<6005f062>] handle_mm_fault+0x130/0x228
605edda8:  [<6011e2eb>] __up_read+0x73/0x7b
605edde8:  [<600131d4>] handle_page_fault+0x120/0x2d9
605ede08:  [<601242dc>] tty_write+0x1f7/0x212
605ede48:  [<60013513>] segv+0xac/0x286
605edf28:  [<60013461>] segv_handler+0x68/0x6e
605edf48:  [<600232c9>] get_skas_faultinfo+0x9c/0xa1
605edf68:  [<6002386f>] userspace+0x13a/0x19d
605edfc8:  [<60010d4c>] fork_handler+0x86/0x8d


/me wonders, missing RPC request or locking mistake...
