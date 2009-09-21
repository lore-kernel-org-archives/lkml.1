Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZIUIvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZIUIvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 04:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755371AbZIUIvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 04:51:54 -0400
Received: from mtagate7.de.ibm.com ([195.212.17.167]:33137 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbZIUIvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 04:51:53 -0400
Date: Mon, 21 Sep 2009 10:51:55 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org
Subject: [BUG] events process running on wrong cpu
Message-ID: <20090921085155.GB4649@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with todays git from time to time I get this (s390 defconfig):


BUG: using smp_processor_id() in preemptible [00000000] code: events/1/16
caller is vmstat_update+0x28/0x74
CPU: 0 Not tainted 2.6.31-06618-gebc79c4-dirty #3
Process events/1 (pid: 16, task: 000000003fcbea00, ksp: 000000003fcd7cd8)
000000003fcd7da8 000000003fcd7d28 0000000000000002 0000000000000000 
       000000003fcd7dc8 000000003fcd7d40 000000003fcd7d40 00000000003fe46a 
       000000000001ffff 000000003fcd7e70 000000000192b128 ffffffffffffc000 
       000000000000000d 000000000000000c 000000003fcd7d90 0000000000000000 
       0000000000000000 0000000000016bda 000000003fcd7d28 000000003fcd7d68 
Call Trace:
([<0000000000016aea>] show_trace+0xe6/0x134)
 [<0000000000202a5e>] debug_smp_processor_id+0x112/0x12c
 [<00000000000b302c>] vmstat_update+0x28/0x74
 [<000000000005fb9a>] worker_thread+0x19a/0x27c
 [<0000000000065f80>] kthread+0xa0/0xa8
 [<000000000001b786>] kernel_thread_starter+0x6/0xc
 [<000000000001b780>] kernel_thread_starter+0x0/0xc

Please note that events/1 is running in cpu 0 (!).

But (with a patched procfs output):

[root@h4245004 ~]# cat /proc/16/status 
Name:   events/1
State:  S (sleeping)
Tgid:   16
Pid:    16
PPid:   2
TracerPid:      0
Uid:    0       0       0       0
Gid:    0       0       0       0
FDSize: 64
Groups:
Threads:        1
SigQ:   0/4096
SigPnd: 0000000000000000
ShdPnd: 0000000000000000
SigBlk: 0000000000000000
SigIgn: ffffffffffffffff
SigCgt: 0000000000000000
CapInh: 0000000000000000
CapPrm: ffffffffffffffff
CapEff: fffffffffffffeff
CapBnd: fffffffffffffeff
Cpus_allowed:   00000002  <----------
Cpus_allowed_list:      1 <----------
task: 000000003fcbea00, ksp: 000000003fcd7cd8
User PSW : 0704000180000000 000000000001b780
User GPRS: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
           0000000000000000 0000000000000000 0000000000000000 0000000000000000
           0000000000000000 0000000000065ee0 000000003fe73cf8 000000000004d414
           0000000000000000 0000000000000000 0000000000000000 000000003fcd7eb8
User ACRS: 00000000 00000000 00000000 00000000
           00000000 00000000 00000000 00000000
           00000000 00000000 00000000 00000000
           00000000 00000000 00000000 00000000
voluntary_ctxt_switches:        55
nonvoluntary_ctxt_switches:     1

So the cpus_allowed mask is correct (later on at least). Looks like the
created kthread ran before its cpus_allowed mask was set.
Looking at the code this shouldn't happen. But still...
