Return-Path: <linux-kernel-owner+w=401wt.eu-S1161229AbXBAHNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161229AbXBAHNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 02:13:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161232AbXBAHNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 02:13:10 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46031 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161229AbXBAHNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 02:13:08 -0500
Date: Wed, 31 Jan 2007 23:12:53 -0800
From: Andrew Morton <akpm@osdl.org>
To: David Chinner <dgc@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.20-rc6-mm3
Message-Id: <20070131231253.fdebc9f5.akpm@osdl.org>
In-Reply-To: <20070201062018.GC33919298@melbourne.sgi.com>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	<Pine.LNX.4.64.0701311559310.11853@schroedinger.engr.sgi.com>
	<20070131162422.6bccc52c.akpm@osdl.org>
	<Pine.LNX.4.64.0701311626160.12104@schroedinger.engr.sgi.com>
	<20070131163638.290f40c1.akpm@osdl.org>
	<20070201062018.GC33919298@melbourne.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Feb 2007 17:20:18 +1100 David Chinner <dgc@sgi.com> wrote:

> What are the new unplugging rules introduced by the git-block
> patch?

Pretty simple: you read the largely-useless changelog then call the bravely
uncommented blk_plug_current() when you're about to submit some IO and you
call the audaciously uncommented blk_unplug_current() when you've finished
and you're ready to let it rip.

But usually none of that is necessary, because io_schedule() does all the
work for you.

err, this might help.

--- a/fs/xfs/linux-2.6/xfs_buf.c~git-block-xfs-fix
+++ a/fs/xfs/linux-2.6/xfs_buf.c
@@ -979,7 +979,7 @@ xfs_buf_wait_unpin(
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (atomic_read(&bp->b_pin_count) == 0)
 			break;
-		schedule();
+		io_schedule();
 	}
 	remove_wait_queue(&bp->b_waiters, &wait);
 	set_current_state(TASK_RUNNING);
_

