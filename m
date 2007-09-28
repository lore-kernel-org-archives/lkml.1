Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbXI1JRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbXI1JRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 05:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758344AbXI1JRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 05:17:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53633 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045AbXI1JRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 05:17:19 -0400
Subject: Re: Strange system hangs
From: Peter Zijlstra <peterz@infradead.org>
To: Krzysztof Oledzki <olel@ans.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0709281005340.17152@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0709281005340.17152@bizon.gios.gov.pl>
Content-Type: text/plain
Date: Fri, 28 Sep 2007 11:17:15 +0200
Message-Id: <1190971035.31636.35.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-28 at 10:42 +0200, Krzysztof Oledzki wrote:
> Hello,
> 
> I am experiencing weird system hangs. Once about 2-5 weeks system freezes 
> and stops accepting remote connections, so it is no longer possible to 
> connect to most important services: smtp (postfix), www (squid) or even 
> ssh. Such connection is accepted but then it hangs.
> 
> What is strange, that previously established ssh session is usable. It is 
> possible to work on such system until you do something stupid like "less 
> /var/log/all.log".

So it takes weeks to reproduce this?


>                           free                        sibling
>    task             PC    stack   pid father child younger older
> syslogd       D F5C83C60     0  2162      1 (NOTLB)
>         f5c83c74 00000082 00000002 f5c83c60 f5c83c5c 00000000 00000000 78538d20
>         00000009 00000001 f7f6a070 f7cb8030 82c47e5f 0001cfed 00000a43 f7f6a17c
>         7a016980 f705dc80 78404217 7812c708 00000000 00000213 f5c83c84 1e7a64bb
> Call Trace:
>   [<78404217>] _spin_unlock_irqrestore+0xf/0x23
>   [<7812c708>] __mod_timer+0x92/0x9c
>   [<78402b34>] schedule_timeout+0x70/0x8d
>   [<7812c521>] process_timeout+0x0/0x5
>   [<78402548>] io_schedule_timeout+0x1e/0x28
>   [<7814d41e>] congestion_wait+0x50/0x64
>   [<78134abc>] autoremove_wake_function+0x0/0x35
>   [<781493e7>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
>   [<78145bd0>] generic_file_buffered_write+0x4ee/0x605
>   [<783c55a1>] unix_dgram_recvmsg+0x1b4/0x1c8
>   [<78128c8e>] current_fs_time+0x41/0x46
>   [<78146167>] __generic_file_aio_write_nolock+0x480/0x4df
>   [<7814621b>] generic_file_aio_write+0x55/0xb3
>   [<78194b28>] ext3_file_write+0x24/0x8f
>   [<7815f34f>] do_sync_readv_writev+0xc1/0xfe
>   [<78134abc>] autoremove_wake_function+0x0/0x35
>   [<784041ae>] _spin_unlock+0xd/0x21
>   [<781a8c38>] log_wait_commit+0xc3/0xe3
>   [<7814448b>] find_get_pages_tag+0x76/0x80
>   [<7815f204>] rw_copy_check_uvector+0x50/0xaa
>   [<7815f9d4>] do_readv_writev+0x99/0x164
>   [<78194b04>] ext3_file_write+0x0/0x8f
>   [<7815fadc>] vfs_writev+0x3d/0x48
>   [<7815feb5>] sys_writev+0x41/0x67
>   [<78103d6a>] sysenter_past_esp+0x5f/0x85
>   =======================

This trace puzzles me, what is: unix_dgram_recvmsg doing there.
Also, it has two invocations of: ext3_file_write
do you have a stacked filesystem of sorts, ext3 on loopback on ext3?



> freshclam     D 00000282     0  2866      1 (NOTLB)
>         f36e3cc4 00000082 00000009 00000282 7a0173c0 00000002 00000000 0000007b
>         00000009 00000001 f7cb8030 f7c72030 82c4884d 0001cfed 000009ee f7cb813c
>         7a016980 f66c0b80 78404217 7812c708 00000000 00000213 f36e3cd4 1e7a64bb
> Call Trace:
>   [<78404217>] _spin_unlock_irqrestore+0xf/0x23
>   [<7812c708>] __mod_timer+0x92/0x9c
>   [<78402b34>] schedule_timeout+0x70/0x8d
>   [<7812c521>] process_timeout+0x0/0x5
>   [<78402548>] io_schedule_timeout+0x1e/0x28
>   [<7814d41e>] congestion_wait+0x50/0x64
>   [<78134abc>] autoremove_wake_function+0x0/0x35
>   [<781493e7>] balance_dirty_pages_ratelimited_nr+0x16e/0x1dc
>   [<78145bd0>] generic_file_buffered_write+0x4ee/0x605
>   [<7819cdb4>] __ext3_journal_stop+0x19/0x34
>   [<7840408f>] _spin_lock+0xd/0x5a
>   [<78176f3d>] __mark_inode_dirty+0xdd/0x16f
>   [<78128c8e>] current_fs_time+0x41/0x46
>   [<78146167>] __generic_file_aio_write_nolock+0x480/0x4df
>   [<7814621b>] generic_file_aio_write+0x55/0xb3
>   [<78103159>] setup_sigcontext+0x105/0x189
>   [<78194b28>] ext3_file_write+0x24/0x8f
>   [<7815f453>] do_sync_write+0xc7/0x10a
>   [<78134abc>] autoremove_wake_function+0x0/0x35
>   [<781085d2>] convert_fxsr_from_user+0x15/0xd5
>   [<7815f38c>] do_sync_write+0x0/0x10a
>   [<7815fbb6>] vfs_write+0x8a/0x10c
>   [<78160123>] sys_write+0x41/0x67
>   [<78103d6a>] sysenter_past_esp+0x5f/0x85
>   =======================

single write, no networking, also stuck in balance_dirty_pages().

