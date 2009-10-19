Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbZJSGyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbZJSGyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 02:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZJSGyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 02:54:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58227 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380AbZJSGyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 02:54:44 -0400
Date: Mon, 19 Oct 2009 08:54:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Arjan van de Ven <arjan@infradead.org>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nfs mount fail
Message-ID: <20091019065433.GA29550@elte.hu>
References: <86802c440910171825j22556a4bofbf0bd6cd134d53c@mail.gmail.com> <84144f020910181935q4aed9f0dx7a8a149d8b8743c7@mail.gmail.com> <20091019114339.4b67d947@infradead.org> <1255921080.839.2.camel@penberg-laptop> <86802c440910182252v4648a7d1k249d091799583e37@mail.gmail.com> <1255933848.11116.2.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1255933848.11116.2.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> > yes. something miss merged again...
> > 
> > need change some lines.
> 
> This doesn't match mainline either. To do so, the above kfree() has to 
> be at the end of the "Opt_xprt_rdma:" case...

it's from a test patch in tip:out-of-tree:

  d40bc6b: <not-for-merge> nfs: fix nfs_parse_mount_options() double kfree()

(attached below)

that fix is wrong apparently - is there a correct fix upstream perhaps?

	Ingo


------------->
>From d40bc6bd8d2353700dea06d398d91a3f54887da6 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 3 Apr 2009 09:06:15 +0200
Subject: [PATCH] <not-for-merge> nfs: fix nfs_parse_mount_options() double kfree()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Impact: fix crash

Yinghai Lu reported the following crash:

> mpk12-3214-189-158:~ # sh x
> [   63.198629] ------------[ cut here ]------------
> [   63.202589] kernel BUG at mm/slub.c:2753!
> [   63.202589] invalid opcode: 0000 [#1] SMP
> [   63.202589] last sysfs file: /sys/devices/virtual/net/sit0/type
> [   63.202589] CPU 0
> [   63.202589] Modules linked in:
> [   63.202589] Pid: 10027, comm: mount.nfs Not tainted 2.6.29-07100-g833bb30 #21 Sun Fire X4440
> [   63.202589] RIP: 0010:[<ffffffff802e0015>]  [<ffffffff802e0015>] kfree+0x5a/0xcd
> [   63.202589] RSP: 0018:ffff882042ceb9f8  EFLAGS: 00010246
> [   63.202589] RAX: 0200000000000000 RBX: 0000000000000005 RCX: ffffffff80a7dc1f
> [   63.202589] RDX: ffffe20000000000 RSI: ffffc2000000f470 RDI: ffffe2001c018950
> [   63.202589] RBP: ffff882042ceba18 R08: 0000000000000000 R09: ffffffff811019c0
> [   63.202589] R10: 000000004262ce02 R11: ffff882042ceba18 R12: ffff880800706475
> [   63.202589] R13: ffff882042886000 R14: ffff882042cebbd8 R15: ffff882042cebbf0
> [   63.202589] FS:  00007fac729ed6f0(0000) GS:ffffc20000000000(0000) knlGS:0000000000000000
> [   63.202589] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   63.202589] CR2: 00007fac72c12000 CR3: 0000001841cbb000 CR4: 00000000000006e0
> [   63.202589] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [   63.202589] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [   63.202589] Process mount.nfs (pid: 10027, threadinfo ffff882042cea000, task ffff8820434dc290)
> [   63.202589] Stack:
> [   63.202589]  ffff882042ceba18 000000004262ce02 0000000000000005 ffff882042886028
> [   63.202589]  ffff882042ceba58 ffffffff80a7dc1f 000000004262ce02 ffff882042886000
> [   63.202589]  000000004262ce02 ffff882042886000 ffffffff80a7b4a6 ffff882042c9ee18
> [   63.202589] Call Trace:
> [   63.202589]  [<ffffffff80a7dc1f>] xs_destroy+0x67/0xac
> [   63.202589]  [<ffffffff80a7b4a6>] ? xprt_destroy+0x0/0xa7
> [   63.202589]  [<ffffffff80a7b532>] xprt_destroy+0x8c/0xa7
> [   63.202589]  [<ffffffff80a823b2>] ? put_rpccred+0x112/0x131
> [   63.202589]  [<ffffffff8051cdd5>] kref_put+0x65/0x87
> [   63.202589]  [<ffffffff80a7a9a9>] ? rpc_free_client+0x0/0xf9
> [   63.202589]  [<ffffffff80a7b490>] xprt_put+0x23/0x39
> [   63.202589]  [<ffffffff80a7aa7a>] rpc_free_client+0xd1/0xf9
> [   63.202589]  [<ffffffff80a83345>] ? unx_destroy+0x3c/0x57
> [   63.202589]  [<ffffffff8051cdd5>] kref_put+0x65/0x87
> [   63.202589]  [<ffffffff80a7aaa2>] ? rpc_free_auth+0x0/0x69
> [   63.202589]  [<ffffffff80a7aaf0>] rpc_free_auth+0x4e/0x69
> [   63.202589]  [<ffffffff8025b827>] ? __wake_up+0x52/0x75
> [   63.202589]  [<ffffffff8051cdd5>] kref_put+0x65/0x87
> [   63.202589]  [<ffffffff80a7a98e>] rpc_release_client+0x64/0x7f
> [   63.202589]  [<ffffffff80a8061c>] ? rpc_put_task+0xb0/0xcb
> [   63.202589]  [<ffffffff80a7abe0>] rpc_shutdown_client+0xd5/0xf8
> [   63.202589]  [<ffffffff80a7a893>] ? rpc_call_sync+0x63/0x80
> [   63.202589]  [<ffffffff803fc4ab>] nfs_mount+0x11f/0x1bf
> [   63.202589]  [<ffffffff803f3036>] nfs_get_sb+0x4ac/0x82a
> [   63.202589]  [<ffffffff802e8f24>] vfs_kern_mount+0x61/0xbf
> [   63.202589]  [<ffffffff802fea1d>] ? get_fs_type+0x58/0xc5
> [   63.202589]  [<ffffffff802e9015>] do_kern_mount+0x56/0x108
> [   63.202589]  [<ffffffff80302195>] do_mount+0x729/0x788
> [   63.202589]  [<ffffffff80300025>] ? copy_mount_options+0xdf/0x155
> [   63.202589]  [<ffffffff8030228c>] sys_mount+0x98/0xf8
> [   63.202589]  [<ffffffff80230d6b>] system_call_fastpath+0x16/0x1b
> [   63.202589] Code: 0c 48 ba 00 00 00 00 00 e2 ff ff 48 6b c0 38 48 8d 3c 10 48 8b 07 f6 c4 40 74 04 48 8b 7f 10 48 8b 07 84 c0 78 10 f6 c4 60 75 04 <0f> 0b eb fe e8 90 75 fd ff eb 4c 48 8b 4d 08 4c 8b 4f 10 9c 5b
> [   63.202589] RIP  [<ffffffff802e0015>] kfree+0x5a/0xcd
> [   63.202589]  RSP <ffff882042ceb9f8>
> [   63.524555] ---[ end trace cd0d38e02ad11d61 ]---

Pekka observed that a bogus pointer was passed to kfree().

This commit:

  a67d18f: NFS: load the rpc/rdma transport module automatically

Moved a kfree() of the options strings in nfs_parse_mount_options()
inadvertently and introduced a double kfree(). Fix it.

Reported-by: Yinghai Lu <yinghai@kernel.org>
Analyzed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/nfs/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index a2c18ac..482a2c3 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1231,6 +1231,7 @@ static int nfs_parse_mount_options(char *raw,
 				goto out_nomem;
 			token = match_token(string,
 					    nfs_xprt_protocol_tokens, args);
+			kfree(string);
 
 			switch (token) {
 			case Opt_xprt_udp:
@@ -1262,7 +1263,6 @@ static int nfs_parse_mount_options(char *raw,
 				goto out_nomem;
 			token = match_token(string,
 					    nfs_xprt_protocol_tokens, args);
-			kfree(string);
 
 			switch (token) {
 			case Opt_xprt_udp:

