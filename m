Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbZILHZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbZILHZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 03:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbZILHZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 03:25:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33325 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754097AbZILHZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 03:25:40 -0400
Date: Sat, 12 Sep 2009 09:24:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>, Thomas Liu <tliu@redhat.com>,
       Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [origin tree boot crash] Revert "selinux: clean up avc node cache
	when disabling selinux"
Message-ID: <20090912072450.GA6767@elte.hu>
References: <a5388f3a349a38034ec677c64677afadd0541713.1252083485.git.zohar@linux.vnet.ibm.com> <alpine.LRH.2.00.0909071215530.3222@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0909071215530.3222@tundra.namei.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


James - i did not see a security pull request email from you in my 
lkml folder so i created this new thread. -tip testing found the 
easy crash below. It reverts cleanly so i went that easy route.

At a really quick 10-seconds glance the crash happens because we 
destroy the slab cache twice, if the sysctl is toggled twice?

	Ingo

----------------->
>From cb52c156f8eedbcd963e0178787c8e2a933a656b Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 12 Sep 2009 09:17:42 +0200
Subject: [PATCH] Revert "selinux: clean up avc node cache when disabling selinux"

This reverts commit 89c86576ecde504da1eeb4f4882b2189ac2f9c4a.

Causes this crash:

[   21.280240] async_continuing @ 1 after 0 usec
[   21.289992] Freeing unused kernel memory: 616k freed
[   21.289992] Write protecting the kernel read-only data: 10216k
[   21.586068] SELinux:  Disabled at runtime.
[   21.590018] =============================================================================
[   21.598233] BUG avc_node: Objects remaining on kmem_cache_close()
[   21.600000] -----------------------------------------------------------------------------
[   21.600000]
[   21.600000] INFO: Slab 0xffffea00015de088 objects=30 used=6 fp=0xffff88003f9d3330 flags=0x100000000000082
[   21.600000] Pid: 1, comm: init Not tainted 2.6.31-00127-g2490138-dirty #12971
[   21.600000] Call Trace:
[   21.600000]  [<ffffffff811179f7>] slab_err+0xb0/0xd2
[   21.600000]  [<ffffffff81085ba7>] ? __lock_acquire+0x982/0x9e6
[   21.600000]  [<ffffffff816b8090>] ? _spin_unlock+0x3a/0x55
[   21.600000]  [<ffffffff811176b2>] ? add_partial+0x2e/0x94
[   21.600000]  [<ffffffff8111d254>] ? kmem_cache_destroy+0xcb/0x223
[   21.600000]  [<ffffffff81118f3a>] list_slab_objects+0xbc/0x18e
[   21.600000]  [<ffffffff816b8358>] ? _spin_lock_irqsave+0x4e/0x6e
[   21.600000]  [<ffffffff8111d2af>] kmem_cache_destroy+0x126/0x223
[   21.600000]  [<ffffffff816b43b2>] ? printk+0x50/0x66
[   21.600000]  [<ffffffff812324a5>] avc_disable+0x2d/0x43
[   21.600000]  [<ffffffff8123bd37>] selinux_disable+0x53/0xb5
[   21.600000]  [<ffffffff8123c55c>] sel_write_disable+0xa2/0x118
[   21.600000]  [<ffffffff81127291>] vfs_write+0xc6/0x17a
[   21.600000]  [<ffffffff81127445>] sys_write+0x5b/0x98
[   21.600000]  [<ffffffff8100bf6b>] system_call_fastpath+0x16/0x1b
[   21.600000] INFO: Object 0xffff88003f9d3000 @offset=0
[   21.600000] INFO: Allocated in avc_alloc_node+0x36/0x1c0 age=2167 cpu=0 pid=0
[   21.600000] INFO: Object 0xffff88003f9d3088 @offset=136
[   21.600000] INFO: Allocated in avc_alloc_node+0x36/0x1c0 age=2167 cpu=0 pid=0
[   21.600000] INFO: Object 0xffff88003f9d3110 @offset=272
[   21.600000] INFO: Allocated in avc_alloc_node+0x36/0x1c0 age=2158 cpu=0 pid=0
[   21.600000] INFO: Object 0xffff88003f9d3198 @offset=408
[   21.600000] INFO: Allocated in avc_alloc_node+0x36/0x1c0 age=1797 cpu=0 pid=1
[   21.600000] INFO: Object 0xffff88003f9d3220 @offset=544
[   21.600000] INFO: Allocated in avc_alloc_node+0x36/0x1c0 age=1798 cpu=0 pid=1
[   21.600000] INFO: Object 0xffff88003f9d32a8 @offset=680
[   21.600000] INFO: Allocated in avc_alloc_node+0x36/0x1c0 age=1115 cpu=0 pid=1
[   21.600000] =============================================================================
[   21.600000] BUG avc_node: Objects remaining on kmem_cache_close()
[   21.600000] -----------------------------------------------------------------------------
[   21.600000]
[   21.600000] INFO: Slab 0xffffea000158b7d8 objects=30 used=4 fp=0xffff88003ead1220 flags=0x100000000000082
[   21.600000] Pid: 1, comm: init Not tainted 2.6.31-00127-g2490138-dirty #12971
[   21.600000] Call Trace:
[   21.600000]  [<ffffffff811179f7>] slab_err+0xb0/0xd2
[   21.600000]  [<ffffffff816b43b2>] ? printk+0x50/0x66
[   21.600000]  [<ffffffff812326b7>] ? avc_alloc_node+0x36/0x1c0
[   21.600000]  [<ffffffff81118f3a>] list_slab_objects+0xbc/0x18e
[   21.600000]  [<ffffffff816b8358>] ? _spin_lock_irqsave+0x4e/0x6e
[   21.600000]  [<ffffffff8111d2af>] kmem_cache_destroy+0x126/0x223
[   21.600000]  [<ffffffff816b43b2>] ? printk+0x50/0x66
[   21.600000]  [<ffffffff812324a5>] avc_disable+0x2d/0x43
[   21.600000]  [<ffffffff8123bd37>] selinux_disable+0x53/0xb5
[   21.600000]  [<ffffffff8123c55c>] sel_write_disable+0xa2/0x118
[   21.600000]  [<ffffffff81127291>] vfs_write+0xc6/0x17a
[   21.600000]  [<ffffffff81127445>] sys_write+0x5b/0x98
[   21.600000]  [<ffffffff8100bf6b>] system_call_fastpath+0x16/0x1b
[   21.600000] INFO: Object 0xffff88003ead1000 @offset=0
[   21.600000] INFO: Allocated in avc_alloc_node+0x36/0x1c0 age=2113 cpu=1 pid=13
[   21.600000] INFO: Object 0xffff88003ead1088 @offset=136
[   21.600000] INFO: Allocated in avc_alloc_node+0x36/0x1c0 age=70 cpu=1 pid=1
[   21.600000] INFO: Object 0xffff88003ead1110 @offset=272
[   21.600000] INFO: Allocated in avc_alloc_node+0x36/0x1c0 age=58 cpu=1 pid=1
[   21.600000] INFO: Object 0xffff88003ead1198 @offset=408
[   21.600000] INFO: Allocated in avc_alloc_node+0x36/0x1c0 age=55 cpu=1 pid=1
[   21.950006] SLUB avc_node: kmem_cache_destroy called for cache that still has objects.
[   21.960003] Pid: 1, comm: init Not tainted 2.6.31-00127-g2490138-dirty #12971
[   21.970002] Call Trace:
[   21.972460]  [<ffffffff8111d347>] kmem_cache_destroy+0x1be/0x223
[   21.978497]  [<ffffffff816b43b2>] ? printk+0x50/0x66
[   21.980004]  [<ffffffff812324a5>] avc_disable+0x2d/0x43
[   21.985241]  [<ffffffff8123bd37>] selinux_disable+0x53/0xb5
[   21.990004]  [<ffffffff8123c55c>] sel_write_disable+0xa2/0x118
[   22.000004]  [<ffffffff81127291>] vfs_write+0xc6/0x17a
[   22.005185]  [<ffffffff81127445>] sys_write+0x5b/0x98
[   22.010013]  [<ffffffff8100bf6b>] system_call_fastpath+0x16/0x1b
[   22.025687] khelper used greatest stack depth: 4104 bytes left
[   22.030152] SELinux:  Unregistering netfilter hooks
[   22.170024] type=1404 audit(1252760072.170:2): selinux=0 auid=4294967295 ses=4294967295
INIT: version 2.86 booting
[   22.280812] CRED: Invalid credentials
[   22.284469] CRED: At kernel/cred.c:295
[   22.288212] CRED: Specified credentials: ffff88003d467500
[   22.290007] CRED: ->magic=43736564, put_addr=(null)
[   22.294874] CRED: ->usage=1, subscr=0
[   22.300003] CRED: ->*uid = { 0,0,0,0 }
[   22.303749] CRED: ->*gid = { 0,0,0,0 }
[   22.307490] CRED: ->security is (null)
[   22.310011] ------------[ cut here ]------------
[   22.314624] kernel BUG at kernel/cred.c:823!
[   22.318893] invalid opcode: 0000 [#1] SMP
[   22.320000] last sysfs file:
[   22.320000] CPU 1
[   22.320000] Modules linked in:
[   22.320000] Pid: 1, comm: init Not tainted 2.6.31-00127-g2490138-dirty #12971 System Product Name
[   22.320000] RIP: 0010:[<ffffffff8107911e>]  [<ffffffff8107911e>] __invalid_creds+0x60/0x64
[   22.320000] RSP: 0018:ffff88003ea4be88  EFLAGS: 00010292
[   22.320000] RAX: 0000000000000000 RBX: 0000000000000127 RCX: 0000000000000000
[   22.320000] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88003ea4bd78
[   22.320000] RBP: ffff88003ea4beb8 R08: 00000000bb1f063d R09: 0000000000000000
[   22.320000] R10: 00000000bb1f063d R11: 0000000000018600 R12: ffffffff818e1647
[   22.320000] R13: ffff88003d467500 R14: 0000000000000004 R15: 00000000020f88f8
[   22.320000] FS:  00007f03df0ff780(0000) GS:ffff88000248f000(0000) knlGS:0000000000000000
[   22.320000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   22.320000] CR2: 000000311090e004 CR3: 000000003d599000 CR4: 00000000000006a0
[   22.320000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   22.320000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   22.320000] Process init (pid: 1, threadinfo ffff88003ea4a000, task ffff88003ea50000)
[   22.320000] Stack:
[   22.320000]  00000000bb1f063d 00000000bb1f063d 00000000bb1f063d ffff88003d467500
[   22.320000] <0> ffff88003ea50000 00000000ffffff9c ffff88003ea4bef8 ffffffff81079a7c
[   22.320000] <0> ffffffff8106445a ffff88003d618000 00000000bb1f063d 00000000bb1f063d
[   22.320000] Call Trace:
[   22.320000]  [<ffffffff81079a7c>] prepare_creds+0x107/0x133
[   22.320000]  [<ffffffff8106445a>] ? sigprocmask+0x46/0xfb
[   22.320000]  [<ffffffff81125512>] sys_faccessat+0x46/0x1d4
[   22.320000]  [<ffffffff811256cb>] sys_access+0x2b/0x41
[   22.320000]  [<ffffffff8100bf6b>] system_call_fastpath+0x16/0x1b
[   22.320000] Code: 89 da 4c 89 e6 48 c7 c7 fd 15 8e 81 31 c0 e8 5c b2 63 00 48 c7 c6 73 16 8e 81 4c 89 ef 65 48 8b 14 25 00 b0 00 00 e8 d6 fc ff ff <0f> 0b eb fe 55 48 89 e5 41 54 53 48 83 ec 10 0f 1f 44 00 00 65
[   22.320000] RIP  [<ffffffff8107911e>] __invalid_creds+0x60/0x64
[   22.320000]  RSP <ffff88003ea4be88>
[   22.520003] ---[ end trace f1d1365aeb345558 ]---
[   22.524612] Kernel panic - not syncing: Fatal exception
[   22.529826] Pid: 1, comm: init Tainted: G      D    2.6.31-00127-g2490138-dirty #12971
[   22.530001] Call Trace:
[   22.540008]  [<ffffffff816b42b2>] panic+0x89/0x139
[   22.544790]  [<ffffffff816b9686>] oops_end+0xb9/0xe0
[   22.550003]  [<ffffffff816b9746>] ? oops_begin+0x99/0xb7
[   22.555311]  [<ffffffff8100fd81>] die+0x6d/0x8c
[   22.559839]  [<ffffffff816b8ff8>] do_trap+0x11f/0x142
[   22.560004]  [<ffffffff81077d7d>] ? notify_die+0x3d/0x53
[   22.570004]  [<ffffffff8100db30>] do_invalid_op+0xab/0xcb
[   22.575397]  [<ffffffff8107911e>] ? __invalid_creds+0x60/0x64
[   22.580004]  [<ffffffff8100cd95>] invalid_op+0x15/0x20
[   22.585138]  [<ffffffff8107911e>] ? __invalid_creds+0x60/0x64
[   22.590004]  [<ffffffff8107911e>] ? __invalid_creds+0x60/0x64
[   22.595744]  [<ffffffff81079a7c>] prepare_creds+0x107/0x133
[   22.600004]  [<ffffffff8106445a>] ? sigprocmask+0x46/0xfb
[   22.605397]  [<ffffffff81125512>] sys_faccessat+0x46/0x1d4
[   22.610004]  [<ffffffff811256cb>] sys_access+0x2b/0x41
[   22.615137]  [<ffffffff8100bf6b>] system_call_fastpath+0x16/0x1b
[   22.620006] Rebooting in 1 seconds..Press any key to enter the menu

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 security/selinux/avc.c         |    6 ------
 security/selinux/hooks.c       |    3 ---
 security/selinux/include/avc.h |    3 ---
 3 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index e3d1901..d07cd64 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -855,9 +855,3 @@ u32 avc_policy_seqno(void)
 {
 	return avc_cache.latest_notif;
 }
-
-void avc_disable(void)
-{
-	if (avc_node_cachep)
-		kmem_cache_destroy(avc_node_cachep);
-}
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 417f7c9..d7afdb1 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5830,9 +5830,6 @@ int selinux_disable(void)
 	selinux_disabled = 1;
 	selinux_enabled = 0;
 
-	/* Try to destroy the avc node cache */
-	avc_disable();
-
 	/* Reset security_ops to the secondary module, dummy or capability. */
 	security_ops = secondary_ops;
 
diff --git a/security/selinux/include/avc.h b/security/selinux/include/avc.h
index e94e82f..e57f2ba 100644
--- a/security/selinux/include/avc.h
+++ b/security/selinux/include/avc.h
@@ -92,9 +92,6 @@ int avc_add_callback(int (*callback)(u32 event, u32 ssid, u32 tsid,
 int avc_get_hash_stats(char *page);
 extern unsigned int avc_cache_threshold;
 
-/* Attempt to free avc node cache */
-void avc_disable(void);
-
 #ifdef CONFIG_SECURITY_SELINUX_AVC_STATS
 DECLARE_PER_CPU(struct avc_cache_stats, avc_cache_stats);
 #endif

