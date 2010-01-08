Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202Ab0AHWWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0AHWWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 17:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959Ab0AHWWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 17:22:14 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:34465 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab0AHWWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 17:22:13 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, Michal Schmidt <mschmidt@redhat.com>,
       Dave Jones <davej@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: mmotm 2010-01-06-14-34 - crash in CPUfreq
In-Reply-To: Your message of "Wed, 06 Jan 2010 14:34:36 PST."
             <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1262989299_4176P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 08 Jan 2010 17:21:39 -0500
Message-ID: <4486.1262989299@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4B47AFF4.0119,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1262989299_4176P
Content-Type: text/plain; charset=us-ascii

On Wed, 06 Jan 2010 14:34:36 PST, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-01-06-14-34 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

Seeing a 100% reproducible crash, bisected down to this commit:
(Saw crash in -mmotm1210, but haven't had time/etc to bisect till now)

46aeb7430f79cb4d03e17fedd6399884ab3aa697 is the first bad commit
commit 46aeb7430f79cb4d03e17fedd6399884ab3aa697
Author: Thomas Renninger <trenn@suse.de>
Date:   Mon Dec 14 11:44:11 2009 +0100

    [CPUFREQ] Fix race in cpufreq_update_policy()
    
    An update can come in asynchronous, e.g. through an acpi notify event/irq.
    If the policy is assigned before the locking and lock_policy_rwsem_write is
    held by onlining/offlining CPU code, the info may be stale
    (and the policy freed) when the locked code gets entered.
    
    Fix that by assigning the policy inside the lock.
    Michal added some cleanups to properly exit on failure cases -> thanks.
    
    Signed-off-by: Thomas Renninger <trenn@suse.de>
    CC: Michal Schmidt <mschmidt@redhat.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

Here's the crash:

[    4.840569] iTCO_wdt: Found a ICH9M-E TCO device (Version=2, TCOBASE=0x1060)
[    4.840832] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    4.840963] iTCO_vendor_support: vendor-support=0
[    4.841404] device-mapper: ioctl: 4.16.0-ioctl (2009-11-05) initialised: dm-devel@redhat.com
[    4.841551] EDAC MC: Ver: 2.1.0 Jan  8 2010
[    4.842049] ------------[ cut here ]------------
[    4.842160] kernel BUG at drivers/cpufreq/cpufreq.c:88!
[    4.842271] invalid opcode: 0000 [#1] PREEMPT SMP 
[    4.842643] last sysfs file: 
[    4.842750] CPU 1 
[    4.842941] Pid: 1, comm: swapper Not tainted 2.6.32-08667-g46aeb74 #15 0X564R/Latitude E6500                  
[    4.843031] RIP: 0010:[<ffffffff813942f4>]  [<ffffffff813942f4>] lock_policy_rwsem_write+0x43/0xad
[    4.843126] RSP: 0000:ffff88011f87fd40  EFLAGS: 00010202
[    4.843126] RAX: 00000000000104b0 RBX: 0000000000000001 RCX: 000000000000003e
[    4.843126] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff81ae1f88
[    4.843126] RBP: ffff88011f87fd60 R08: 0000000000000000 R09: ffffffff81b04810
[    4.843126] R10: ffffffff8103b7fa R11: ffffffff8184f00d R12: 00000000ffffffff
[    4.843126] R13: 0000000000000000 R14: 0000000000000002 R15: 0000000000000000
[    4.843126] FS:  0000000000000000(0000) GS:ffff880028300000(0000) knlGS:0000000000000000
[    4.843126] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    4.843126] CR2: 00000034478a8440 CR3: 0000000001a1c000 CR4: 00000000000406e0
[    4.843126] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    4.843126] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    4.843126] Process swapper (pid: 1, threadinfo ffff88011f87e000, task ffff88011f87c040)
[    4.843126] Stack:
[    4.843126]  ffff88011f87c040 0000000000000000 0000000000000000 00000000ffffffea
[    4.843126] <0> ffff88011f87feb0 ffffffff8139558c ffff88011f87fd90 ffffffff810641a8
[    4.843126] <0> 0000000000000000 0000000000000000 ffff88011f87fe50 ffffffff81527c4c
[    4.843126] Call Trace:
[    4.843126]  [<ffffffff8139558c>] cpufreq_update_policy+0x20/0xfc
[    4.843126]  [<ffffffff810641a8>] ? debug_mutex_free_waiter+0x2e/0x6a
[    4.843126]  [<ffffffff81527c4c>] ? __mutex_lock_common+0x58b/0x5aa
[    4.843126]  [<ffffffff8103b7fa>] ? cpu_maps_update_begin+0x12/0x14
[    4.843126]  [<ffffffff815291b0>] ? _raw_spin_unlock_irqrestore+0x72/0x80
[    4.843126]  [<ffffffff8103b7fa>] ? cpu_maps_update_begin+0x12/0x14
[    4.843126]  [<ffffffff81527478>] ? __mutex_unlock_slowpath+0x136/0x17b
[    4.843126]  [<ffffffff81066494>] ? trace_hardirqs_on_caller+0x118/0x13c
[    4.843126]  [<ffffffff810664c5>] ? trace_hardirqs_on+0xd/0xf
[    4.843126]  [<ffffffff815274ac>] ? __mutex_unlock_slowpath+0x16a/0x17b
[    4.843126]  [<ffffffff815274c6>] ? mutex_unlock+0x9/0xb
[    4.843126]  [<ffffffff8103b80c>] ? cpu_maps_update_done+0x10/0x12
[    4.843126]  [<ffffffff815113c7>] ? register_cpu_notifier+0x28/0x32
[    4.843126]  [<ffffffff81b48568>] cpufreq_stats_init+0x85/0xad
[    4.843126]  [<ffffffff81b484e3>] ? cpufreq_stats_init+0x0/0xad
[    4.843126]  [<ffffffff810001ef>] do_one_initcall+0x59/0x14e
[    4.843126]  [<ffffffff81b21667>] kernel_init+0x15f/0x1b5
[    4.843126]  [<ffffffff810031d4>] kernel_thread_helper+0x4/0x10
[    4.843126]  [<ffffffff81529ac0>] ? restore_args+0x0/0x30
[    4.843126]  [<ffffffff81b21508>] ? kernel_init+0x0/0x1b5
[    4.843126]  [<ffffffff810031d0>] ? kernel_thread_helper+0x0/0x10
[    4.843126] Code: 88 1f ae 81 53 31 db 48 83 ec 08 48 8b 14 d5 60 46 b0 81 44 8b 24 10 41 83 fc ff 0f 94 c3 31 d2 89 de e8 f4 42 d0 ff 85 db 74 04 <0f> 0b eb fe 4d 63 e4 48 c7 c3 c0 04 01 00 48 89 df 4a 03 3c e5 
[    4.843126] RIP  [<ffffffff813942f4>] lock_policy_rwsem_write+0x43/0xad
[    4.843126]  RSP <ffff88011f87fd40>
[    4.862279] ---[ end trace b837c2c8cb05be90 ]---
[    4.862402] Kernel panic - not syncing: Attempted to kill init!
[    4.862523] Pid: 1, comm: swapper Tainted: G      D    2.6.32-08667-g46aeb74 #15
[    4.862669] Call Trace:
[    4.862792]  [<ffffffff81526031>] panic+0x7f/0x13a
[    4.862919]  [<ffffffff81066392>] ? trace_hardirqs_on_caller+0x16/0x13c
[    4.863049]  [<ffffffff8103db1a>] do_exit+0xd7/0x8d6
[    4.863161]  [<ffffffff8103a328>] ? spin_unlock_irqrestore+0x9/0xb
[    4.863288]  [<ffffffff8103af22>] ? kmsg_dump+0x136/0x150
[    4.863402]  [<ffffffff8152a904>] oops_end+0x89/0x8e
[    4.863520]  [<ffffffff81005dd1>] die+0x55/0x5e
[    4.863631]  [<ffffffff8152a324>] do_trap+0x11c/0x12b
[    4.863752]  [<ffffffff81003ac9>] do_invalid_op+0x8f/0x98
[    4.863865]  [<ffffffff813942f4>] ? lock_policy_rwsem_write+0x43/0xad
[    4.863980]  [<ffffffff8152899f>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[    4.864104]  [<ffffffff8103b7fa>] ? cpu_maps_update_begin+0x12/0x14
[    4.864218]  [<ffffffff81529af0>] ? irq_return+0x0/0x2
[    4.864365]  [<ffffffff81003055>] invalid_op+0x15/0x20
[    4.864478]  [<ffffffff8103b7fa>] ? cpu_maps_update_begin+0x12/0x14
[    4.864597]  [<ffffffff813942f4>] ? lock_policy_rwsem_write+0x43/0xad
[    4.864711]  [<ffffffff8139558c>] cpufreq_update_policy+0x20/0xfc
[    4.864825]  [<ffffffff810641a8>] ? debug_mutex_free_waiter+0x2e/0x6a
[    4.864944]  [<ffffffff81527c4c>] ? __mutex_lock_common+0x58b/0x5aa
[    4.865066]  [<ffffffff8103b7fa>] ? cpu_maps_update_begin+0x12/0x14
[    4.865185]  [<ffffffff815291b0>] ? _raw_spin_unlock_irqrestore+0x72/0x80
[    4.865311]  [<ffffffff8103b7fa>] ? cpu_maps_update_begin+0x12/0x14
[    4.865434]  [<ffffffff81527478>] ? __mutex_unlock_slowpath+0x136/0x17b
[    4.865548]  [<ffffffff81066494>] ? trace_hardirqs_on_caller+0x118/0x13c
[    4.865662]  [<ffffffff810664c5>] ? trace_hardirqs_on+0xd/0xf
[    4.865782]  [<ffffffff815274ac>] ? __mutex_unlock_slowpath+0x16a/0x17b
[    4.865897]  [<ffffffff815274c6>] ? mutex_unlock+0x9/0xb
[    4.866037]  [<ffffffff8103b80c>] ? cpu_maps_update_done+0x10/0x12
[    4.866153]  [<ffffffff815113c7>] ? register_cpu_notifier+0x28/0x32
[    4.866278]  [<ffffffff81b48568>] cpufreq_stats_init+0x85/0xad
[    4.866391]  [<ffffffff81b484e3>] ? cpufreq_stats_init+0x0/0xad
[    4.866505]  [<ffffffff810001ef>] do_one_initcall+0x59/0x14e
[    4.866624]  [<ffffffff81b21667>] kernel_init+0x15f/0x1b5
[    4.866737]  [<ffffffff810031d4>] kernel_thread_helper+0x4/0x10
[    4.866860]  [<ffffffff81529ac0>] ? restore_args+0x0/0x30
[    4.866971]  [<ffffffff81b21508>] ? kernel_init+0x0/0x1b5
[    4.867099]  [<ffffffff810031d0>] ? kernel_thread_helper+0x0/0x10


--==_Exmh_1262989299_4176P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLR6/zcC3lWbTT17ARAhs/AKC+0GfTmRJ+8DLqA5w1k64D065E7ACg7bRJ
GyE0PPlAwnFwU5QVaifb7Xk=
=qu/S
-----END PGP SIGNATURE-----

--==_Exmh_1262989299_4176P--

