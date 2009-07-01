Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbZGARGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbZGARGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 13:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZGARGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 13:06:35 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:44738 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbZGARGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 13:06:34 -0400
X-IronPort-AV: E=Sophos;i="4.42,326,1243814400"; 
   d="scan'208";a="182185898"
From: Roland Dreier <rdreier@cisco.com>
To: tyhicks@linux.vnet.ibm.com, kirkland@canonical.com,
       ecryptfs-devel@lists.launchpad.net
Cc: linux-kernel@vger.kernel.org
Subject: lockdep reported AB-BA problem in ecryptfs
X-Message-Flag: Warning: May contain useful information
Date: Wed, 01 Jul 2009 10:06:33 -0700
Message-ID: <adahbxwgwo6.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Jul 2009 17:06:35.0326 (UTC) FILETIME=[4A18DDE0:01C9FA6E]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have an Ubuntu 9.10 system, using ecryptfs for my home directory,
running a 2.6.31-rc1+git kernel with lockdep enabled, and I got the
report below on login.  This looks like a valid AB-BA issue; there are
two paths through the code, first:

  ecryptfs_new_file_context() ->
    ecryptfs_copy_mount_wide_sigs_to_inode_sigs() ->

	mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);

	  -> ecryptfs_add_keysig() ->

		mutex_lock(&crypt_stat->keysig_list_mutex);

so global_auth_tok_list_mutex is taken before keysig_list_mutex.

and second:

  ecryptfs_generate_key_packet_set() ->

	mutex_lock(&crypt_stat->keysig_list_mutex);

	  -> ecryptfs_find_global_auth_tok_for_sig() ->

		mutex_lock(&mount_crypt_stat->global_auth_tok_list_mutex);

so keysig_list_mutex is taken before global_auth_tok_list_mutex here.

I'm not sure if this could actually deadlock in practice (ie can we have
threads racing on these two paths?) but it seems risky.

I'm not an expert on ecryptfs locking bug the simplest fix I see for
this particular issue is to move taking keysig_list_mutex to before
global_auth_tok_list_mutex in ecryptfs_copy_mount_wide_sigs_to_inode_sigs(),
since ecryptfs_add_keysig() has only one caller and so we can rely on
that caller to take the needed lock.  I can send a patch for this if
this sounds good.


here's the full report:

[   24.787210] =======================================================
[   24.787213] [ INFO: possible circular locking dependency detected ]
[   24.787216] 2.6.31-2-generic #14~rbd2
[   24.787217] -------------------------------------------------------
[   24.787219] gdm/2640 is trying to acquire lock:
[   24.787221]  (&mount_crypt_stat->global_auth_tok_list_mutex){+.+.+.}, at: [<ffffffff8121591e>] ecryptfs_find_global_auth_tok_for_sig+0x2e/0x90
[   24.787231] 
[   24.787231] but task is already holding lock:
[   24.787233]  (&crypt_stat->keysig_list_mutex){+.+.+.}, at: [<ffffffff81217728>] ecryptfs_generate_key_packet_set+0x58/0x2b0
[   24.787239] 
[   24.787239] which lock already depends on the new lock.
[   24.787240] 
[   24.787241] 
[   24.787242] the existing dependency chain (in reverse order) is:
[   24.787244] 
[   24.787244] -> #1 (&crypt_stat->keysig_list_mutex){+.+.+.}:
[   24.787248]        [<ffffffff8108c897>] check_prev_add+0x2a7/0x370
[   24.787253]        [<ffffffff8108cfc1>] validate_chain+0x661/0x750
[   24.787256]        [<ffffffff8108d2e7>] __lock_acquire+0x237/0x430
[   24.787259]        [<ffffffff8108d585>] lock_acquire+0xa5/0x150
[   24.787263]        [<ffffffff815526cd>] __mutex_lock_common+0x4d/0x3d0
[   24.787267]        [<ffffffff81552b56>] mutex_lock_nested+0x46/0x60
[   24.787270]        [<ffffffff8121526a>] ecryptfs_add_keysig+0x5a/0xb0
[   24.787273]        [<ffffffff81213299>] ecryptfs_copy_mount_wide_sigs_to_inode_sigs+0x59/0xb0
[   24.787276]        [<ffffffff81214b06>] ecryptfs_new_file_context+0xa6/0x1a0
[   24.787280]        [<ffffffff8120e42a>] ecryptfs_initialize_file+0x4a/0x140
[   24.787283]        [<ffffffff8120e54d>] ecryptfs_create+0x2d/0x60
[   24.787286]        [<ffffffff8113a7d4>] vfs_create+0xb4/0xe0
[   24.787290]        [<ffffffff8113a8c4>] __open_namei_create+0xc4/0x110
[   24.787293]        [<ffffffff8113d1c1>] do_filp_open+0xa01/0xae0
[   24.787296]        [<ffffffff8112d8d9>] do_sys_open+0x69/0x140
[   24.787300]        [<ffffffff8112d9f0>] sys_open+0x20/0x30
[   24.787303]        [<ffffffff81013132>] system_call_fastpath+0x16/0x1b
[   24.787308]        [<ffffffffffffffff>] 0xffffffffffffffff
[   24.787326] 
[   24.787326] -> #0 (&mount_crypt_stat->global_auth_tok_list_mutex){+.+.+.}:
[   24.787330]        [<ffffffff8108c675>] check_prev_add+0x85/0x370
[   24.787333]        [<ffffffff8108cfc1>] validate_chain+0x661/0x750
[   24.787337]        [<ffffffff8108d2e7>] __lock_acquire+0x237/0x430
[   24.787340]        [<ffffffff8108d585>] lock_acquire+0xa5/0x150
[   24.787343]        [<ffffffff815526cd>] __mutex_lock_common+0x4d/0x3d0
[   24.787346]        [<ffffffff81552b56>] mutex_lock_nested+0x46/0x60
[   24.787349]        [<ffffffff8121591e>] ecryptfs_find_global_auth_tok_for_sig+0x2e/0x90
[   24.787352]        [<ffffffff812177d5>] ecryptfs_generate_key_packet_set+0x105/0x2b0
[   24.787356]        [<ffffffff81212f49>] ecryptfs_write_headers_virt+0xc9/0x120
[   24.787359]        [<ffffffff8121306d>] ecryptfs_write_metadata+0xcd/0x200
[   24.787362]        [<ffffffff8120e44b>] ecryptfs_initialize_file+0x6b/0x140
[   24.787365]        [<ffffffff8120e54d>] ecryptfs_create+0x2d/0x60
[   24.787368]        [<ffffffff8113a7d4>] vfs_create+0xb4/0xe0
[   24.787371]        [<ffffffff8113a8c4>] __open_namei_create+0xc4/0x110
[   24.787374]        [<ffffffff8113d1c1>] do_filp_open+0xa01/0xae0
[   24.787377]        [<ffffffff8112d8d9>] do_sys_open+0x69/0x140
[   24.787380]        [<ffffffff8112d9f0>] sys_open+0x20/0x30
[   24.787383]        [<ffffffff81013132>] system_call_fastpath+0x16/0x1b
[   24.787386]        [<ffffffffffffffff>] 0xffffffffffffffff
[   24.787390] 
[   24.787390] other info that might help us debug this:
[   24.787391] 
[   24.787393] 2 locks held by gdm/2640:
[   24.787394]  #0:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff8113cb8b>] do_filp_open+0x3cb/0xae0
[   24.787401]  #1:  (&crypt_stat->keysig_list_mutex){+.+.+.}, at: [<ffffffff81217728>] ecryptfs_generate_key_packet_set+0x58/0x2b0
[   24.787407] 
[   24.787407] stack backtrace:
[   24.787410] Pid: 2640, comm: gdm Tainted: G         C 2.6.31-2-generic #14~rbd2
[   24.787412] Call Trace:
[   24.787416]  [<ffffffff8108b988>] print_circular_bug_tail+0xa8/0xf0
[   24.787419]  [<ffffffff8108c675>] check_prev_add+0x85/0x370
[   24.787423]  [<ffffffff81094912>] ? __module_text_address+0x12/0x60
[   24.787426]  [<ffffffff8108cfc1>] validate_chain+0x661/0x750
[   24.787429]  [<ffffffff81017275>] ? print_context_stack+0x85/0x140
[   24.787433]  [<ffffffff81089c68>] ? find_usage_backwards+0x38/0x160
[   24.787436]  [<ffffffff8108d2e7>] __lock_acquire+0x237/0x430
[   24.787439]  [<ffffffff8108d585>] lock_acquire+0xa5/0x150
[   24.787442]  [<ffffffff8121591e>] ? ecryptfs_find_global_auth_tok_for_sig+0x2e/0x90
[   24.787445]  [<ffffffff8108b0b0>] ? check_usage_backwards+0x0/0xb0
[   24.787448]  [<ffffffff815526cd>] __mutex_lock_common+0x4d/0x3d0
[   24.787451]  [<ffffffff8121591e>] ? ecryptfs_find_global_auth_tok_for_sig+0x2e/0x90
[   24.787454]  [<ffffffff8121591e>] ? ecryptfs_find_global_auth_tok_for_sig+0x2e/0x90
[   24.787458]  [<ffffffff8108c02c>] ? mark_held_locks+0x6c/0xa0
[   24.787461]  [<ffffffff81125b0d>] ? kmem_cache_alloc+0xfd/0x1a0
[   24.787464]  [<ffffffff8108c34d>] ? trace_hardirqs_on_caller+0x14d/0x190
[   24.787467]  [<ffffffff81552b56>] mutex_lock_nested+0x46/0x60
[   24.787470]  [<ffffffff8121591e>] ecryptfs_find_global_auth_tok_for_sig+0x2e/0x90
[   24.787473]  [<ffffffff812177d5>] ecryptfs_generate_key_packet_set+0x105/0x2b0
[   24.787476]  [<ffffffff81212f49>] ecryptfs_write_headers_virt+0xc9/0x120
[   24.787479]  [<ffffffff8121306d>] ecryptfs_write_metadata+0xcd/0x200
[   24.787482]  [<ffffffff81210240>] ? ecryptfs_init_persistent_file+0x60/0xe0
[   24.787485]  [<ffffffff8120e44b>] ecryptfs_initialize_file+0x6b/0x140
[   24.787488]  [<ffffffff8120e54d>] ecryptfs_create+0x2d/0x60
[   24.787491]  [<ffffffff8113a7d4>] vfs_create+0xb4/0xe0
[   24.787494]  [<ffffffff8113a8c4>] __open_namei_create+0xc4/0x110
[   24.787496]  [<ffffffff8113d1c1>] do_filp_open+0xa01/0xae0
[   24.787502]  [<ffffffff8129a93e>] ? _raw_spin_unlock+0x5e/0xb0
[   24.787505]  [<ffffffff8155410b>] ? _spin_unlock+0x2b/0x40
[   24.787508]  [<ffffffff81139e9b>] ? getname+0x3b/0x240
[   24.787511]  [<ffffffff81148a5a>] ? alloc_fd+0xfa/0x140
[   24.787515]  [<ffffffff8112d8d9>] do_sys_open+0x69/0x140
[   24.787517]  [<ffffffff81553b8f>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   24.787520]  [<ffffffff8112d9f0>] sys_open+0x20/0x30
[   24.787523]  [<ffffffff81013132>] system_call_fastpath+0x16/0x1b
