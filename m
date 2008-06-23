Return-Path: <linux-kernel-owner+w=401wt.eu-S1757723AbYFWFyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723AbYFWFyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 01:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbYFWFx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 01:53:59 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:49861 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbYFWFx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 01:53:58 -0400
Date: Mon, 23 Jun 2008 14:53:41 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: linux-mm@kvack.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       xemul@openvz.org, linux-kernel@vger.kernel.org
Subject: [bad page] memcg: another bad page at page migration
 (2.6.26-rc5-mm3 + patch collection)
Message-Id: <20080623145341.0a365c67.nishimura@mxp.nes.nec.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

It seems the current -mm has been gradually stabilized,
but I encounter another bad page problem in my test(*1)
on 2.6.26-rc5-mm3 + patch collection(*2).

Compared to previous probrems fixed by the patch collection,
the frequency is law.

- 1 time in 1 hour running(1'st one was seen after 30 minutes)
- 3 times in 16 hours running(1'st one was seen after 4 hours)
- 10 times in 70 hours running(1'st one was seen after 8 hours)

All bad pages show similar message like below:

---
Bad page state in process 'switch.sh'
page:ffffe2000c8e59c0 flags:0x0200000000080018 mapping:000
0000000000000 mapcount:0 count:0
cgroup:ffff81062a817050
Trying to fix it up, but a reboot is needed
Backtrace:
Pid: 14980, comm: switch.sh Not tainted 2.6.26-rc5-mm3-mem
fix #1
Jun 19 20:10:23 opteron kernel:
Call Trace:
 [<ffffffff802747b0>] bad_page+0x97/0x131
 [<ffffffff80275ae6>] free_hot_cold_page+0xd4/0x19c
 [<ffffffff80275bcf>] __pagevec_free+0x21/0x2e
 [<ffffffff80278d51>] release_pages+0x18d/0x19f
 [<ffffffff80278e58>] ____pagevec_lru_add+0xf5/0x106
 [<ffffffff8027a5ea>] putback_lru_page+0x52/0xe9
 [<ffffffff8029baec>] migrate_pages+0x331/0x42a
 [<ffffffff8029070f>] new_node_page+0x0/0x2f
 [<ffffffff802915a9>] do_migrate_pages+0x19b/0x1e7
 [<ffffffff8025c827>] cpuset_migrate_mm+0x58/0x8f
 [<ffffffff8025d0fd>] cpuset_attach+0x8b/0x9e
 [<ffffffff8025a3e1>] cgroup_attach_task+0x3a3/0x3f5
 [<ffffffff8029db71>] __dentry_open+0x154/0x238
 [<ffffffff8025af06>] cgroup_common_file_write+0x150/0x1dd
 [<ffffffff8025aaf4>] cgroup_file_write+0x54/0x150
 [<ffffffff8030a335>] selinux_file_permission+0x56/0x117
 [<ffffffff8029f74d>] vfs_write+0xad/0x136
 [<ffffffff8029fc8a>] sys_write+0x45/0x6e
 [<ffffffff8020bef2>] tracesys+0xd5/0xda
Jun 19 20:10:23 opteron kernel:
Hexdump:
000: 28 00 08 00 00 00 00 02 01 00 00 00 00 00 00 00
010: 00 00 00 00 00 00 00 00 a1 f1 08 25 03 81 ff ff
020: 6e 06 90 f5 07 00 00 00 68 59 8e 0c 00 e2 ff ff
030: a8 a5 8c 0c 00 e2 ff ff 00 cf 11 25 03 81 ff ff
040: 18 00 08 00 00 00 00 02 00 00 00 00 ff ff ff ff
050: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
060: c0 08 00 00 00 00 00 00 00 01 10 00 00 c1 ff ff
070: 00 02 20 00 00 c1 ff ff 00 00 00 00 00 00 00 00
080: 08 00 04 00 00 00 00 02 00 00 00 00 ff ff ff ff
090: 03 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0a0: 7e 99 7a f6 07 00 00 00 28 9c 8d 0c 00 e2 ff ff
0b0: 28 16 86 0c 00 e2 ff ff 00 00 00 00 00 00 00 00
---

- page flags are 0x...80018, PG_uptodate/PG_dirty/PG_swapbacked,
  and count/map_count/mapping are all 0(no pproblem).
- contains "cgroup:..." line. this is the cause of bad page.

So, some pages that have not been uncharged by memcg
are beeing freed(I don't mount memcg, but don't specify
"cgroup_disable=memory").
I have not found yet the path where this can happen,
and I'm digging more.


Thanks,
Daisuke Nishimura.

*1 http://lkml.org/lkml/2008/6/17/367
*2 http://lkml.org/lkml/2008/6/19/62
