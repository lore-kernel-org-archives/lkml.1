Return-Path: <linux-kernel-owner+w=401wt.eu-S1759472AbYDTLcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472AbYDTLcc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 07:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYDTLcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 07:32:24 -0400
Received: from main.gmane.org ([80.91.229.2]:48072 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbYDTLcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 07:32:23 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Possible circular lockdep when doing modprobe -r hostap_pci
Date: Sun, 20 Apr 2008 11:32:12 +0000 (UTC)
Message-ID: <fuf9js$8ap$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc3-cwma2-0-0-cust739.swan.cable.ntl.com
User-Agent: Pan/0.129 (Benson & Hedges Moscow Gold)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing modprobe -r hostap_pci on latest git the following output was 
printed:
[ 2040.662987] =======================================================
[ 2040.663006] [ INFO: possible circular locking dependency detected ]
[ 2040.663016] 2.6.25skw #10
[ 2040.663021] -------------------------------------------------------
[ 2040.663029] ifconfig/5608 is trying to acquire lock:
[ 2040.663036]  (events){--..}, at: [<c012fb70>] flush_workqueue+0x0/0x60
[ 2040.663070] 
[ 2040.663072] but task is already holding lock:
[ 2040.663078]  (rtnl_mutex){--..}, at: [<c029ae5f>] rtnl_lock+0xf/0x20
[ 2040.663103] 
[ 2040.663105] which lock already depends on the new lock.
[ 2040.663109] 
[ 2040.663114] 
[ 2040.663116] the existing dependency chain (in reverse order) is:
[ 2040.663122] 
[ 2040.663124] -> #2 (rtnl_mutex){--..}:
[ 2040.663134]        [<c0140413>] __lock_acquire+0xe63/0xf60
[ 2040.663161]        [<c014056e>] lock_acquire+0x5e/0x80
[ 2040.663179]        [<c02ef468>] mutex_lock_nested+0x78/0x230
[ 2040.663209]        [<c029ae5f>] rtnl_lock+0xf/0x20
[ 2040.663209]        [<c029c3a8>] linkwatch_event+0x8/0x30
[ 2040.663209]        [<c012f40f>] run_workqueue+0x11f/0x1d0
[ 2040.663209]        [<c012fdd7>] worker_thread+0x97/0xf0
[ 2040.663209]        [<c01327e2>] kthread+0x42/0x70
[ 2040.663209]        [<c010477b>] kernel_thread_helper+0x7/0x1c
[ 2040.663209]        [<ffffffff>] 0xffffffff
[ 2040.663209] 
[ 2040.663209] -> #1 ((linkwatch_work).work){--..}:
[ 2040.663209]        [<c0140413>] __lock_acquire+0xe63/0xf60
[ 2040.663209]        [<c014056e>] lock_acquire+0x5e/0x80
[ 2040.663209]        [<c012f40a>] run_workqueue+0x11a/0x1d0
[ 2040.663209]        [<c012fdd7>] worker_thread+0x97/0xf0
[ 2040.663209]        [<c01327e2>] kthread+0x42/0x70
[ 2040.663209]        [<c010477b>] kernel_thread_helper+0x7/0x1c
[ 2040.663209]        [<ffffffff>] 0xffffffff
[ 2040.663209] 
[ 2040.663209] -> #0 (events){--..}:
[ 2040.663209]        [<c013ffa5>] __lock_acquire+0x9f5/0xf60
[ 2040.663209]        [<c014056e>] lock_acquire+0x5e/0x80
[ 2040.663209]        [<c012fba8>] flush_workqueue+0x38/0x60
[ 2040.663209]        [<c012fbdd>] flush_scheduled_work+0xd/0x10
[ 2040.663209]        [<e88b09c5>] prism2_close+0x35/0x110 [hostap]
[ 2040.663209]        [<c0291b46>] dev_close+0x46/0x60
[ 2040.663209]        [<c029197d>] dev_change_flags+0x7d/0x180
[ 2040.663209]        [<c02cf1d7>] devinet_ioctl+0x4c7/0x660
[ 2040.663209]        [<c02cf791>] inet_ioctl+0x61/0x80
[ 2040.663209]        [<c0284f27>] sock_ioctl+0xb7/0x210
[ 2040.663209]        [<c01879f0>] vfs_ioctl+0x20/0x70
[ 2040.663209]        [<c0187a97>] do_vfs_ioctl+0x57/0x240
[ 2040.663209]        [<c0187ce0>] sys_ioctl+0x60/0x70
[ 2040.663209]        [<c0103b65>] sysenter_past_esp+0x6a/0xb1
[ 2040.663209]        [<ffffffff>] 0xffffffff
[ 2040.663209] 
[ 2040.663209] other info that might help us debug this:
[ 2040.663209] 
[ 2040.663209] 1 lock held by ifconfig/5608:
[ 2040.663209]  #0:  (rtnl_mutex){--..}, at: [<c029ae5f>] rtnl_lock
+0xf/0x20
[ 2040.663209] 
[ 2040.663209] stack backtrace:
[ 2040.663209] Pid: 5608, comm: ifconfig Not tainted 2.6.25skw #10
[ 2040.663209]  [<c013e1ce>] print_circular_bug_tail+0x6e/0x80
[ 2040.663209]  [<c013d903>] ? print_circular_bug_entry+0x43/0x50
[ 2040.663209]  [<c013ffa5>] __lock_acquire+0x9f5/0xf60
[ 2040.663209]  [<c02f0cc7>] ? _spin_unlock_irqrestore+0x47/0x60
[ 2040.663209]  [<c013f0d5>] ? trace_hardirqs_on+0xb5/0x140
[ 2040.663209]  [<c014056e>] lock_acquire+0x5e/0x80
[ 2040.663209]  [<c012fb70>] ? flush_workqueue+0x0/0x60
[ 2040.663209]  [<c012fba8>] flush_workqueue+0x38/0x60
[ 2040.663209]  [<c012fb70>] ? flush_workqueue+0x0/0x60
[ 2040.663209]  [<c012fbdd>] flush_scheduled_work+0xd/0x10
[ 2040.663209]  [<e88b09c5>] prism2_close+0x35/0x110 [hostap]
[ 2040.663209]  [<c0291b46>] dev_close+0x46/0x60
[ 2040.663209]  [<c029197d>] dev_change_flags+0x7d/0x180
[ 2040.663209]  [<c02900ce>] ? __dev_get_by_name+0x7e/0xa0
[ 2040.663209]  [<c02cf1d7>] devinet_ioctl+0x4c7/0x660
[ 2040.663209]  [<c01e181e>] ? copy_to_user+0x3e/0x60
[ 2040.663209]  [<c02cf791>] inet_ioctl+0x61/0x80
[ 2040.663209]  [<c0284f27>] sock_ioctl+0xb7/0x210
[ 2040.663209]  [<c02f2846>] ? do_page_fault+0x176/0x640
[ 2040.663209]  [<c0284e70>] ? sock_ioctl+0x0/0x210
[ 2040.663209]  [<c01879f0>] vfs_ioctl+0x20/0x70
[ 2040.663209]  [<c0187a97>] do_vfs_ioctl+0x57/0x240
[ 2040.663209]  [<c0187ce0>] sys_ioctl+0x60/0x70
[ 2040.663209]  [<c0103b65>] sysenter_past_esp+0x6a/0xb1
[ 2040.663209]  =======================

-- 
Sitsofe | http://sucs.org/~sits/

