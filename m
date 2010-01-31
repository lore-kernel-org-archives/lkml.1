Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab0AaXzO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 18:55:14 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:35779 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753324Ab0AaXzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 18:55:12 -0500
X-Trace: 336759001/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.93.110/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.93.110
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: Alpine 2.00 (LSU 1167 2008-08-23)
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlcBAJunZUtPRV1u/2dsb2JhbAAI1VWERQQ
X-IronPort-AV: E=Sophos;i="4.49,379,1262563200"; 
   d="scan'208,223";a="336759001"
Date: Sun, 31 Jan 2010 23:55:08 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jens Axboe <jens.axboe@oracle.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: lockdep warning during elevator_switch
Message-ID: <alpine.LSU.2.00.1001312327260.7190@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2.6.33-rc3 onwards, PROVE_LOCKING=y gives me the warning below when
I "echo deadline >/sys/block/sdb/queue/scheduler" to change it from cfq.

Backing out 846f99749ab68bbc7f75c74fec305de675b1a1bf "sysfs: Add lockdep
annotations for the sysfs active reference" stops the warning -
but I realize that doesn't mean the actual problem (if any) is fixed.

(An orthogonal irritation which I don't recall anyone mentioning before:
lockdep's stacktrace involves a console_verbose() to make sure it goes to
console, which is never cancelled: so from that point on my console is
spammed with wireless authentication debug messages every twenty minutes.
But perhaps that's a feature, without which I'd have ignored the lockdep
report for longer; and /proc/sys/kernel/printk can restore the loglevel.)

Hugh

=============================================
[ INFO: possible recursive locking detected ]
2.6.33-rc6 #1
---------------------------------------------
sh/889 is trying to acquire lock:
 (s_active){++++.+}, at: [<7820a975>] sysfs_addrm_finish+0x27/0x4e

but task is already holding lock:
 (s_active){++++.+}, at: [<7820ab82>] sysfs_get_active_two+0x18/0x3e

other info that might help us debug this:
4 locks held by sh/889:
 #0:  (&buffer->mutex){+.+.+.}, at: [<7820984e>] sysfs_write_file+0x20/0x99
 #1:  (s_active){++++.+}, at: [<7820ab82>] sysfs_get_active_two+0x18/0x3e
 #2:  (s_active){++++.+}, at: [<7820ab91>] sysfs_get_active_two+0x27/0x3e
 #3:  (&q->sysfs_lock){+.+.+.}, at: [<78289e95>] queue_attr_store+0x2e/0x68

stack backtrace:
Pid: 889, comm: sh Not tainted 2.6.33-rc6 #1
Call Trace:
 [<784a6966>] ? printk+0xf/0x11
 [<781752a1>] print_deadlock_bug+0x99/0xa3
 [<781753c6>] check_deadlock+0x11b/0x140
 [<781763e5>] validate_chain+0x4ec/0x4f9
 [<78176a68>] __lock_acquire+0x676/0x6cf
 [<78176b64>] lock_acquire+0xa3/0xbc
 [<7820a975>] ? sysfs_addrm_finish+0x27/0x4e
 [<7820a37a>] sysfs_deactivate+0x6c/0xa4
 [<7820a975>] ? sysfs_addrm_finish+0x27/0x4e
 [<7820a975>] sysfs_addrm_finish+0x27/0x4e
 [<7820aa3a>] sysfs_remove_dir+0x62/0x72
 [<7829d6dd>] kobject_del+0x11/0x32
 [<78283406>] __elv_unregister_queue+0x18/0x20
 [<78283c66>] elevator_switch+0x6d/0x11b
 [<78283d92>] elv_iosched_store+0x7e/0x9b
 [<78289eb8>] queue_attr_store+0x51/0x68
 [<78209894>] sysfs_write_file+0x66/0x99
 [<781cd460>] vfs_write+0x8a/0x108
 [<781cd578>] sys_write+0x3c/0x63
 [<78125b90>] sysenter_do_call+0x12/0x36
