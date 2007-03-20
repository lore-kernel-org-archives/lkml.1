Return-Path: <linux-kernel-owner+w=401wt.eu-S965527AbXCTSCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965527AbXCTSCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 14:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965552AbXCTSCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 14:02:05 -0400
Received: from smtp.nokia.com ([131.228.20.170]:63650 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965527AbXCTSCC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 14:02:02 -0400
Subject: Re: JFFS2: BUG: sleeping function called from invalid context
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <45FFBCC6.8010800@nokia.com>
References: <45FFBCC6.8010800@nokia.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 20 Mar 2007 20:01:37 +0200
Message-Id: <1174413697.17249.126.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 20 Mar 2007 18:01:37.0937 (UTC) FILETIME=[CE17D010:01C76B19]
X-eXpurgate-Category: 1/0
X-eXpurgate-ID: 149371::070320200152-5FF47BB0-7B2304C7/0-0/0-1
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 12:51 +0200, Adrian Hunter wrote:
> BUG: sleeping function called from invalid context at include/linux/writeback.h:76
> in_atomic():1, irqs_disabled():0
> 2 locks held by jffs2_gcd_mtd0/5710:
>  #0:  (&c->wbuf_sem){----}, at: [<f8b09814>] jffs2_flash_writev+0x67/0x5c0 [jffs2]
>  #1:  (&c->erase_completion_lock){--..}, at: [<f8b085f8>] jffs2_wbuf_recover+0xb03/0x11f1 [jffs2]
>  [<c01040df>] show_trace_log_lvl+0x1a/0x30
>  [<c0104806>] show_trace+0x12/0x14
>  [<c01048aa>] dump_stack+0x16/0x18
>  [<c011cee4>] __might_sleep+0xb8/0xcb
>  [<c0181ed9>] ifind_fast+0x48/0x86
>  [<c01821d9>] iget_locked+0x2a/0x133
>  [<f8b06713>] jffs2_gc_fetch_inode+0x18e/0x229 [jffs2]
>  [<f8b08853>] jffs2_wbuf_recover+0xd5e/0x11f1 [jffs2]
>  [<f8b0909c>] __jffs2_flush_wbuf+0x3b6/0x791 [jffs2]
>  [<f8b09b14>] jffs2_flash_writev+0x367/0x5c0 [jffs2]
>  [<f8afb59f>] jffs2_write_dnode+0x180/0x403 [jffs2]
>  [<f8b02626>] jffs2_garbage_collect_dnode+0x7d3/0x8cd [jffs2]
>  [<f8b004b8>] jffs2_garbage_collect_live+0x242/0x31e [jffs2]
>  [<f8b00148>] jffs2_garbage_collect_pass+0x99b/0xac9 [jffs2]
>  [<f8b04ad7>] jffs2_garbage_collect_thread+0x341/0x396 [jffs2]
>  [<c0103d53>] kernel_thread_helper+0x7/0x14
>  =======================

This function seems to be completely broken. JFF2 calls iget() while
holding c->erase_completion_lock spinlock. This is one problem. Iget can
sleep.

The other one is that JFFS2 calls jffs2_gc_fetch_inode() while holding
c->alloc_sem and c->wbuf_sem semaphores. What happens if JFFS2 races
with pdflush, and pdflush wins, clears inode, then VFS calls
read_inode() to satisfy JFFS2's iget() request. It is a _deadlock_
because the in read_inode JFFS2 will try to lock the above semaphores
again.

The wbuf recovery function has to be re-worked or just disabled -
because returning error is better then fall into a deadlock.

David,
comments, ideas?

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

