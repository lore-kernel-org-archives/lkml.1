Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbZBZFfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbZBZFfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 00:35:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758800AbZBZFey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 00:34:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:38347 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758605AbZBZFex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 00:34:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,269,1233561600"; 
   d="scan'208";a="668629567"
Date: Thu, 26 Feb 2009 13:34:50 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: recursive slqb_lock
Message-ID: <20090226053450.GA31108@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

I got a lockdep warning. It looks like the slqb_lock will be taken
twice in the call chain:

        s_start()  => take slqb_lock
          s_show()
            gather_stats()  => take slqb_lock again

Thanks,
Fengguang
---

[ 2229.013986] =============================================
[ 2229.017469] [ INFO: possible recursive locking detected ]
[ 2229.017469] 2.6.29-rc5-next-20090220 #57
[ 2229.017469] ---------------------------------------------
[ 2229.017469] mcookie/3167 is trying to acquire lock:
[ 2229.017469]  (slqb_lock){+++++.}, at: [<ffffffff810d7960>] s_show+0x60/0x1f0
[ 2229.017469]
[ 2229.017469] but task is already holding lock:
[ 2229.017469]  (slqb_lock){+++++.}, at: [<ffffffff810d7c09>] s_start+0x29/0xa0
[ 2229.017469]
[ 2229.017469] other info that might help us debug this:
[ 2229.017469] 2 locks held by mcookie/3167:
[ 2229.017469]  #0:  (&p->lock){+.+.+.}, at: [<ffffffff810fa79a>] seq_read+0x3a/0x3c0
[ 2229.017469]  #1:  (slqb_lock){+++++.}, at: [<ffffffff810d7c09>] s_start+0x29/0xa0
[ 2229.017469]
[ 2229.017469] stack backtrace:
[ 2229.017469] Pid: 3167, comm: mcookie Not tainted 2.6.29-rc5-next-20090220 #57
[ 2229.017469] Call Trace:
[ 2229.017469]  [<ffffffff810705f0>] __lock_acquire+0xf90/0x1ad0
[ 2229.017469]  [<ffffffff8106f605>] ? check_irq_usage+0xa5/0x100
[ 2229.017469]  [<ffffffff8106c97c>] ? lockdep_init_map+0x4c/0x640
[ 2229.017469]  [<ffffffff81071194>] lock_acquire+0x64/0x90
[ 2229.017469]  [<ffffffff810d7960>] ? s_show+0x60/0x1f0
[ 2229.017469]  [<ffffffff8149666b>] down_read+0x4b/0x80
[ 2229.017469]  [<ffffffff810d7960>] ? s_show+0x60/0x1f0
[ 2229.017469]  [<ffffffff810d7960>] s_show+0x60/0x1f0
[ 2229.017469]  [<ffffffff810fa84b>] seq_read+0xeb/0x3c0
[ 2229.017469]  [<ffffffff811ffead>] ? _raw_spin_unlock+0x7d/0xa0
[ 2229.017469]  [<ffffffff810fa760>] ? seq_read+0x0/0x3c0
[ 2229.017469]  [<ffffffff8111f469>] proc_reg_read+0x79/0xb0
[ 2229.017469]  [<ffffffff810decc8>] vfs_read+0xc8/0x180
[ 2229.017469]  [<ffffffff810dee70>] sys_read+0x50/0x90
[ 2229.017469]  [<ffffffff8100c3f2>] system_call_fastpath+0x16/0x1b


