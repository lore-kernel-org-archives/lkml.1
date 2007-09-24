Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbXIXGRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbXIXGRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 02:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbXIXGRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 02:17:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37441 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191AbXIXGRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 02:17:43 -0400
Date: Sun, 23 Sep 2007 23:17:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 24/25] r/o bind mounts: track number of mount writers
Message-Id: <20070923231713.f81ee0db.akpm@linux-foundation.org>
In-Reply-To: <20070920195320.38C8E20D@kernel>
References: <20070920195249.852667D5@kernel>
	<20070920195320.38C8E20D@kernel>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007 12:53:20 -0700 Dave Hansen <haveblue@us.ibm.com> wrote:

> This is the real meat of the entire series.  It actually
> implements the tracking of the number of writers to a mount.
> However, it causes scalability problems because there can
> be hundreds of cpus doing open()/close() on files on the
> same mnt at the same time.  Even an atomic_t in the mnt
> has massive scalaing problems because the cacheline gets
> so terribly contended.
> 
> This uses a statically-allocated percpu variable.  All
> operations are local to a cpu as long that cpu operates on
> the same mount, and there are no writer count imbalances.
> Writer count imbalances happen when a write is taken on one
> cpu, and released on another, like when an open/close pair
> is performed on two different cpus because the task moved.


Did you test with lockdep enabled?

=============================================
[ INFO: possible recursive locking detected ]
2.6.23-rc7-mm1 #1
---------------------------------------------
swapper/1 is trying to acquire lock:
 (&writer->lock){--..}, at: [<c0197a32>] lock_and_coalesce_cpu_mnt_writer_counts+0x32/0x70

but task is already holding lock:
 (&writer->lock){--..}, at: [<c0197a32>] lock_and_coalesce_cpu_mnt_writer_counts+0x32/0x70

other info that might help us debug this:
1 lock held by swapper/1:
 #0:  (&writer->lock){--..}, at: [<c0197a32>] lock_and_coalesce_cpu_mnt_writer_counts+0x32/0x70

stack backtrace:
 [<c0103ffa>] show_trace_log_lvl+0x1a/0x30
 [<c0104b82>] show_trace+0x12/0x20
 [<c0104c96>] dump_stack+0x16/0x20
 [<c0144dc5>] __lock_acquire+0xde5/0x10a0
 [<c01450fa>] lock_acquire+0x7a/0xa0
 [<c03e734c>] _spin_lock+0x2c/0x40
 [<c0197a32>] lock_and_coalesce_cpu_mnt_writer_counts+0x32/0x70
 [<c01982c6>] mntput_no_expire+0x36/0xc0
 [<c0188f15>] path_release_on_umount+0x15/0x20
 [<c0198930>] sys_umount+0x40/0x230
 [<c010070b>] name_to_dev_t+0x9b/0x270
 [<c05230c2>] prepare_namespace+0x62/0x1b0
 [<c05226ca>] kernel_init+0x21a/0x320
 [<c0103b47>] kernel_thread_helper+0x7/0x10
 =======================

It look like a false positive to me, but really, for a patchset of this
complexity and maturity I cannot fathom how it could have escaped any
lockdep testing.

