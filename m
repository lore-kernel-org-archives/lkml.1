Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbYFVJ7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbYFVJ7K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 05:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYFVJ66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 05:58:58 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:18092 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbYFVJ65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 05:58:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ck3EoeZUtW6Nn/agilWcPrw5vpxhwgCgbjA7w04ZTQ+BiOxTY4u9mIYaBxHAVw4GdN
         3QExXVhFb/WVuQ7j661xDMNqPWc0MOoq5w989XWU262Pf7nIaPBt3y8jDer6TOpAqh/8
         ozw4lG7x+JfxKK/ZIZ7212QreHLeQl2Sw0nPk=
Message-ID: <6278d2220806220258p28de00c1x615ad7b2f708e3f8@mail.gmail.com>
Date: Sun, 22 Jun 2008 10:58:56 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>, "Mel Gorman" <mel@csn.ul.ie>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: [2.6.26-rc7] shrink_icache from pagefault locking (nee: nfsd hangs for a few sec)...
Cc: "Alexander Beregalov" <a.beregalov@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <6278d2220806220256g674304ectb945c14e7e09fede@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220806220256g674304ectb945c14e7e09fede@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing a similar issue [2] to what was recently reported [1] by
Alexander, but with another workload involving XFS and memory
pressure.

SLUB allocator is in use and config is at http://quora.org/config-client-debug .

Let me know if you'd like more details/vmlinux objdump etc.

Thanks,
 Daniel

--- [1]

http://groups.google.com/group/fa.linux.kernel/browse_thread/thread/e673c9173d45a735/db9213ef39e4e11c

--- [2]

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.26-rc7-210c #2
-------------------------------------------------------
AutopanoPro/4470 is trying to acquire lock:
 (iprune_mutex){--..}, at: [<ffffffff802d94fd>] shrink_icache_memory+0x7d/0x290

but task is already holding lock:
 (&mm->mmap_sem){----}, at: [<ffffffff805e3e15>] do_page_fault+0x255/0x890

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&mm->mmap_sem){----}:
      [<ffffffff80278f4d>] __lock_acquire+0xbdd/0x1020
      [<ffffffff802793f5>] lock_acquire+0x65/0x90
      [<ffffffff805df5ab>] down_read+0x3b/0x70
      [<ffffffff805e3e3c>] do_page_fault+0x27c/0x890
      [<ffffffff805e16cd>] error_exit+0x0/0xa9
      [<ffffffffffffffff>] 0xffffffffffffffff

-> #1 (&(&ip->i_iolock)->mr_lock){----}:
      [<ffffffff80278f4d>] __lock_acquire+0xbdd/0x1020
      [<ffffffff802793f5>] lock_acquire+0x65/0x90
      [<ffffffff8026d746>] down_write_nested+0x46/0x80
      [<ffffffff8039df29>] xfs_ilock+0x99/0xa0
      [<ffffffff8039e0cf>] xfs_ireclaim+0x3f/0x90
      [<ffffffff803ba889>] xfs_finish_reclaim+0x59/0x1a0
      [<ffffffff803bc199>] xfs_reclaim+0x109/0x110
      [<ffffffff803c9541>] xfs_fs_clear_inode+0xe1/0x110
      [<ffffffff802d906d>] clear_inode+0x7d/0x110
      [<ffffffff802d93aa>] dispose_list+0x2a/0x100
      [<ffffffff802d96af>] shrink_icache_memory+0x22f/0x290
      [<ffffffff8029d868>] shrink_slab+0x168/0x1d0
      [<ffffffff8029e0b6>] kswapd+0x3b6/0x560
      [<ffffffff8026921d>] kthread+0x4d/0x80
      [<ffffffff80227428>] child_rip+0xa/0x12
      [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (iprune_mutex){--..}:
      [<ffffffff80278db7>] __lock_acquire+0xa47/0x1020
      [<ffffffff802793f5>] lock_acquire+0x65/0x90
      [<ffffffff805dedd5>] mutex_lock_nested+0xb5/0x300
      [<ffffffff802d94fd>] shrink_icache_memory+0x7d/0x290
      [<ffffffff8029d868>] shrink_slab+0x168/0x1d0
      [<ffffffff8029db38>] try_to_free_pages+0x268/0x3a0
      [<ffffffff802979d6>] __alloc_pages_internal+0x206/0x4b0
      [<ffffffff80297c89>] __alloc_pages_nodemask+0x9/0x10
      [<ffffffff802b2bc2>] alloc_page_vma+0x72/0x1b0
      [<ffffffff802a3642>] handle_mm_fault+0x462/0x7b0
      [<ffffffff805e3ecc>] do_page_fault+0x30c/0x890
      [<ffffffff805e16cd>] error_exit+0x0/0xa9
      [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

2 locks held by AutopanoPro/4470:
 #0:  (&mm->mmap_sem){----}, at: [<ffffffff805e3e15>] do_page_fault+0x255/0x890
 #1:  (shrinker_rwsem){----}, at: [<ffffffff8029d732>] shrink_slab+0x32/0x1d0

stack backtrace:
Pid: 4470, comm: AutopanoPro Not tainted 2.6.26-rc7-210c #2

Call Trace:
 [<ffffffff80276823>] print_circular_bug_tail+0x83/0x90
 [<ffffffff80275e09>] ? print_circular_bug_entry+0x49/0x60
 [<ffffffff80278db7>] __lock_acquire+0xa47/0x1020
 [<ffffffff802793f5>] lock_acquire+0x65/0x90
 [<ffffffff802d94fd>] ? shrink_icache_memory+0x7d/0x290
 [<ffffffff805dedd5>] mutex_lock_nested+0xb5/0x300
 [<ffffffff802d94fd>] ? shrink_icache_memory+0x7d/0x290
 [<ffffffff802d94fd>] shrink_icache_memory+0x7d/0x290
 [<ffffffff8029d732>] ? shrink_slab+0x32/0x1d0
 [<ffffffff8029d868>] shrink_slab+0x168/0x1d0
 [<ffffffff8029db38>] try_to_free_pages+0x268/0x3a0
 [<ffffffff8029c240>] ? isolate_pages_global+0x0/0x40
 [<ffffffff802979d6>] __alloc_pages_internal+0x206/0x4b0
 [<ffffffff80297c89>] __alloc_pages_nodemask+0x9/0x10
 [<ffffffff802b2bc2>] alloc_page_vma+0x72/0x1b0
 [<ffffffff802a3642>] handle_mm_fault+0x462/0x7b0
 [<ffffffff80277e2f>] ? trace_hardirqs_on+0xbf/0x150
 [<ffffffff805e3e15>] ? do_page_fault+0x255/0x890
 [<ffffffff805e3ecc>] do_page_fault+0x30c/0x890
 [<ffffffff805e16cd>] error_exit+0x0/0xa9
-- 
Daniel J Blueman
