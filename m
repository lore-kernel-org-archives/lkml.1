Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbZGAXIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbZGAXIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 19:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbZGAXIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 19:08:14 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:13505 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbZGAXIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 19:08:13 -0400
X-IronPort-AV: E=Sophos;i="4.42,328,1243814400"; 
   d="scan'208";a="182323841"
From: Roland Dreier <rdreier@cisco.com>
To: tyhicks@linux.vnet.ibm.com, kirkland@canonical.com,
       ecryptfs-devel@lists.launchpad.net
Cc: linux-kernel@vger.kernel.org
Subject: Another lockdep issue reported with ecryptfs
References: <adahbxwgwo6.fsf@cisco.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 01 Jul 2009 16:08:16 -0700
In-Reply-To: <adahbxwgwo6.fsf@cisco.com> (Roland Dreier's message of "Wed, 01
	Jul 2009 10:06:33 -0700")
Message-ID: <ada1vp0dmsf.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Jul 2009 23:08:16.0901 (UTC) FILETIME=[D13E6B50:01C9FAA0]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Same setup as before: ecryptfs home directory on Ubuntu 9.10, with the
lockdep fix for ecryptfs I just posted (so lockdep is not being
instantly disabled on login); I got the following on a system with an
idle firefox-3.5 window:

 =============================================
 [ INFO: possible recursive locking detected ]
 2.6.31-2-generic #14~rbd3
 ---------------------------------------------
 firefox-3.5/4162 is trying to acquire lock:
  (&s->s_vfs_rename_mutex){+.+.+.}, at: [<ffffffff81139d31>] lock_rename+0x41/0xf0
 
 but task is already holding lock:
  (&s->s_vfs_rename_mutex){+.+.+.}, at: [<ffffffff81139d31>] lock_rename+0x41/0xf0
 
 other info that might help us debug this:
 3 locks held by firefox-3.5/4162:
  #0:  (&s->s_vfs_rename_mutex){+.+.+.}, at: [<ffffffff81139d31>] lock_rename+0x41/0xf0
  #1:  (&sb->s_type->i_mutex_key#11/1){+.+.+.}, at: [<ffffffff81139d5a>] lock_rename+0x6a/0xf0
  #2:  (&sb->s_type->i_mutex_key#11/2){+.+.+.}, at: [<ffffffff81139d6f>] lock_rename+0x7f/0xf0
 
 stack backtrace:
 Pid: 4162, comm: firefox-3.5 Tainted: G         C 2.6.31-2-generic #14~rbd3
 Call Trace:
  [<ffffffff8108ae74>] print_deadlock_bug+0xf4/0x100
  [<ffffffff8108ce26>] validate_chain+0x4c6/0x750
  [<ffffffff8108d2e7>] __lock_acquire+0x237/0x430
  [<ffffffff8108d585>] lock_acquire+0xa5/0x150
  [<ffffffff81139d31>] ? lock_rename+0x41/0xf0
  [<ffffffff815526ad>] __mutex_lock_common+0x4d/0x3d0
  [<ffffffff81139d31>] ? lock_rename+0x41/0xf0
  [<ffffffff81139d31>] ? lock_rename+0x41/0xf0
  [<ffffffff8120eaf9>] ? ecryptfs_rename+0x99/0x170
  [<ffffffff81552b36>] mutex_lock_nested+0x46/0x60
  [<ffffffff81139d31>] lock_rename+0x41/0xf0
  [<ffffffff8120eb2a>] ecryptfs_rename+0xca/0x170
  [<ffffffff81139a9e>] vfs_rename_dir+0x13e/0x160
  [<ffffffff8113ac7e>] vfs_rename+0xee/0x290
  [<ffffffff8113c212>] ? __lookup_hash+0x102/0x160
  [<ffffffff8113d512>] sys_renameat+0x252/0x280
  [<ffffffff81133eb4>] ? cp_new_stat+0xe4/0x100
  [<ffffffff8101316a>] ? sysret_check+0x2e/0x69
  [<ffffffff8108c34d>] ? trace_hardirqs_on_caller+0x14d/0x190
  [<ffffffff8113d55b>] sys_rename+0x1b/0x20
  [<ffffffff81013132>] system_call_fastpath+0x16/0x1b

haven't tried to debug this yet.
