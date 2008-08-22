Return-Path: <linux-kernel-owner+w=401wt.eu-S1758675AbYHVVtN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675AbYHVVtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 17:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbYHVVs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 17:48:57 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:59757 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbYHVVs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 17:48:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=bls7lpX899U5WdptQjEn/vT7nnMk92c7MOaOE01ZgAqrcCvUlesNfUPrjqXDm4CR2L
         G/Vg/qSZqXD5fP6gZXwuwshgujtcyuPfLKf+ZK1CC/MhKjS6HaiHtjogSZ4Uav5YZzo7
         kyQmb+0wPtcAh2p2K+7BCEYS4gB8ktGVLyQNQ=
Message-ID: <6278d2220808221448l24e98c61t83a2680f9df314f2@mail.gmail.com>
Date: Fri, 22 Aug 2008 22:48:55 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: [2.6.27-rc4] SLUB list_lock vs obj_hash.lock...
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting 2.6.27-rc4 with SLUB and debug_objects=1, we see (after
some activity) lock ordering issues with obj_hash.lock and SLUB's
list_lock [1].

Thanks,
  Daniel

--- [1]

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.27-rc4-224c #1
-------------------------------------------------------
hald/4680 is trying to acquire lock:
 (&n->list_lock){++..}, at: [<ffffffff802bfa26>] add_partial+0x26/0x80

but task is already holding lock:
 (&obj_hash[i].lock){++..}, at: [<ffffffff8041cfdc>]
debug_object_free+0x5c/0x120

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&obj_hash[i].lock){++..}:
       [<ffffffff8026b011>] __lock_acquire+0xdb1/0x1150
       [<ffffffff8026b441>] lock_acquire+0x91/0xc0
       [<ffffffff80641b29>] _spin_lock_irqsave+0x49/0x90
       [<ffffffff8041cd0e>] __debug_check_no_obj_freed+0x6e/0x170
       [<ffffffff8041ce25>] debug_check_no_obj_freed+0x15/0x20
       [<ffffffff8029accf>] free_hot_cold_page+0x11f/0x240
       [<ffffffff8029ae80>] free_hot_page+0x10/0x20
       [<ffffffff8029b36d>] __free_pages+0x3d/0x50
       [<ffffffff802bfffe>] __free_slab+0x7e/0x90
       [<ffffffff802c0028>] discard_slab+0x18/0x40
       [<ffffffff802c1d2b>] kmem_cache_shrink+0x17b/0x220
       [<ffffffff80442521>] acpi_os_purge_cache+0xe/0x12
       [<ffffffff80459db9>] acpi_purge_cached_objects+0x15/0x3d
       [<ffffffff80459e49>] acpi_initialize_objects+0x4e/0x59
       [<ffffffff808a64ea>] acpi_init+0x91/0x226
       [<ffffffff80209265>] do_one_initcall+0x45/0x190
       [<ffffffff80887c53>] kernel_init+0x145/0x1a2
       [<ffffffff8020d749>] child_rip+0xa/0x11
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (&n->list_lock){++..}:
       [<ffffffff8026b0f5>] __lock_acquire+0xe95/0x1150
       [<ffffffff8026b441>] lock_acquire+0x91/0xc0
       [<ffffffff806419c6>] _spin_lock+0x36/0x70
       [<ffffffff802bfa26>] add_partial+0x26/0x80
       [<ffffffff802c0156>] __slab_free+0x106/0x110
       [<ffffffff802c0507>] kmem_cache_free+0xa7/0x110
       [<ffffffff8041cc48>] free_object+0x68/0xc0
       [<ffffffff8041d033>] debug_object_free+0xb3/0x120
       [<ffffffff8063f35e>] schedule_timeout+0x7e/0xe0
       [<ffffffff802d5439>] do_sys_poll+0x3b9/0x440
       [<ffffffff802d57d8>] sys_poll+0x38/0xa0
       [<ffffffff8020c74b>] system_call_fastpath+0x16/0x1b
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

1 lock held by hald/4680:
 #0:  (&obj_hash[i].lock){++..}, at: [<ffffffff8041cfdc>]
debug_object_free+0x5c/0x120

stack backtrace:
Pid: 4680, comm: hald Not tainted 2.6.27-rc4-224c #1

Call Trace:
 [<ffffffff80268d1f>] print_circular_bug_tail+0x9f/0xe0
 [<ffffffff8026b0f5>] __lock_acquire+0xe95/0x1150
 [<ffffffff8026b441>] lock_acquire+0x91/0xc0
 [<ffffffff802bfa26>] ? add_partial+0x26/0x80
 [<ffffffff806419c6>] _spin_lock+0x36/0x70
 [<ffffffff802bfa26>] ? add_partial+0x26/0x80
 [<ffffffff802bfa26>] add_partial+0x26/0x80
 [<ffffffff802c0156>] __slab_free+0x106/0x110
 [<ffffffff802c0507>] kmem_cache_free+0xa7/0x110
 [<ffffffff8041cc48>] ? free_object+0x68/0xc0
 [<ffffffff8041cc48>] free_object+0x68/0xc0
 [<ffffffff8041d033>] debug_object_free+0xb3/0x120
 [<ffffffff8063f35e>] schedule_timeout+0x7e/0xe0
 [<ffffffff8024c200>] ? process_timeout+0x0/0x10
 [<ffffffff8063f342>] ? schedule_timeout+0x62/0xe0
 [<ffffffff802d5439>] do_sys_poll+0x3b9/0x440
 [<ffffffff802d5f00>] ? __pollwait+0x0/0x120
 [<ffffffff8023a720>] ? default_wake_function+0x0/0x10
 [<ffffffff8023a720>] ? default_wake_function+0x0/0x10
 [<ffffffff8023a720>] ? default_wake_function+0x0/0x10
 [<ffffffff8023a720>] ? default_wake_function+0x0/0x10
 [<ffffffff8023a720>] ? default_wake_function+0x0/0x10
 [<ffffffff8023a720>] ? default_wake_function+0x0/0x10
 [<ffffffff8023a720>] ? default_wake_function+0x0/0x10
 [<ffffffff8023a720>] ? default_wake_function+0x0/0x10
 [<ffffffff8023a720>] ? default_wake_function+0x0/0x10
 [<ffffffff8023a720>] ? default_wake_function+0x0/0x10
 [<ffffffff8064128e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff802d57d8>] sys_poll+0x38/0xa0
 [<ffffffff8020c74b>] system_call_fastpath+0x16/0x1b
-- 
Daniel J Blueman
