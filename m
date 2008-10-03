Return-Path: <linux-kernel-owner+w=401wt.eu-S1752020AbYJCEoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbYJCEoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 00:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbYJCEoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 00:44:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:38256 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbYJCEoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 00:44:14 -0400
Date: Thu, 2 Oct 2008 21:43:53 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002214353.30873f98@infradead.org>
In-Reply-To: <20081002214000.89420bb3.akpm@linux-foundation.org>
References: <20081001200034.65eb67d6@infradead.org>
	<20081001215638.3a65134c.akpm@linux-foundation.org>
	<20081002062736.GR19428@kernel.dk>
	<20081001235501.2b7f50fe.akpm@linux-foundation.org>
	<20081002061236.3c71c877@infradead.org>
	<20081002132457.46ad8d05.akpm@linux-foundation.org>
	<20081002210117.0f5062f7@infradead.org>
	<20081002212355.621a4fb6@infradead.org>
	<20081002214000.89420bb3.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [  517.067572]  [<c042ee64>] warn_on_slowpath+0x41/0x65
> [  517.067652]  [<c070ec83>] io_schedule+0x77/0xb0
> [  517.067659]  [<c04abc72>] sync_buffer+0x33/0x37
> [  517.067666]  [<c070f010>] __wait_on_bit_lock+0x34/0x5e
> [  517.067682]  [<c070f0e5>] out_of_line_wait_on_bit_lock+0xab/0xb3
> [  517.067707]  [<c04abfa1>] __lock_buffer+0x24/0x2a
> [  517.067715]  [<c04dd7fc>] do_get_write_access+0x64/0x3b1
> [  517.067743]  [<c04ddb64>] journal_get_write_access+0x1b/0x2a
> [  517.067752]  [<c04da374>] __ext3_journal_get_write_access+0x19/0x3c
> [  517.067761]  [<c04cf672>] ext3_reserve_inode_write+0x34/0x68
> [  517.067769]  [<c04cf6d5>] ext3_mark_inode_dirty+0x2f/0x46
> [  517.067777]  [<c04cf7f7>] ext3_dirty_inode+0x53/0x67
> [  517.067784]  [<c04a7bed>] __mark_inode_dirty+0x29/0x144
> [  517.067794]  [<c049e60f>] file_update_time+0x80/0xa9
> [  517.067803]  [<c046b66c>] __generic_file_aio_write_nolock+0x2f0/0x41b
> [  517.067842]  [<c046bf0d>] generic_file_aio_write+0x5a/0xb7
> [  517.067850]  [<c04cdc65>] ext3_file_write+0x1a/0x89
> [  517.067858]  [<c048da41>] do_sync_write+0xab/0xe9
> [  517.067896]  [<c048e302>] vfs_write+0x8a/0x12e
> [  517.067903]  [<c048e43f>] sys_write+0x3b/0x60
> [  517.067910]  [<c0403b0b>] sysenter_do_call+0x12/0x2f
> [  517.067919]  =======================
> [  517.067923] ---[ end trace de523043f88bd9a7 ]---  

> That's the one - the lock_buffer() in do_get_write_access().  It's a
> major contention site and it'd be a major win if we could fix it.
> Even if we resorted to some nasty thing like taking a temp copy of the
> buffer's contents.

I also notice it's part of "file_update_time". Do we really need to go all the way 
down to this level of synchronicity for that?
(I also randomly wonder if we, in the write path, dirty the inode twice, once for size once for item, and
if we then also reserve two slots in the journal for that..... but I'm showing
my total ignorance of JBD internals here)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
