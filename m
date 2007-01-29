Return-Path: <linux-kernel-owner+w=401wt.eu-S1751083AbXA2LVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751083AbXA2LVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 06:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbXA2LVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 06:21:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:12442 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbXA2LVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 06:21:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=nTqglPYfMQJPwQX44jqAnKunPReUaCfBOX36BdnWCHSEGKrQQI9r605OW5ndOa8+Y6fAyrbuFkVNuOcNlu6bHruF67Yiknc7B2iAEDpsQt0shvyPEKmFLAOyhNl77UwYfMnfDXDxkz5IC9eL+PwPCXDGIdBwwt+clKpz/yoSv58=
Date: Mon, 29 Jan 2007 11:21:41 +0000
From: Frederik Deweerdt <deweerdt@free.fr>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, trond.myklebust@fys.uio.no
Subject: [-mm patch] BUG at net/sunrpc/svc.c:128 (was Re: 2.6.20-rc6-mm2)
Message-ID: <20070129112141.GC2990@slug>
References: <20070129001207.71ea3470.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070129001207.71ea3470.akpm@osdl.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 29, 2007 at 12:12:07AM -0800, Andrew Morton wrote:
> 	ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm2/
> 

Hi,

The svc_pool_map_init_percpu() should get maxpool from the number of
online cpus, not the number of nodes.  The following BUG is triggered
when we try to check if the cpu index is smaller than the number of nodes.
(The system is multi cpu, single node).

[  133.196276] ------------[ cut here ]------------
[  133.196334] kernel BUG at net/sunrpc/svc.c:128!
[  133.196391] invalid opcode: 0000 [#1]
[  133.196444] PREEMPT SMP
[  133.196571] last sysfs file: /devices/pci0000:00/0000:00:00.0/class
[  133.196630] Modules linked in: nfsd exportfs lockd sunrpc ipv6 i2c_dev i2c_core video thermal sony_acpi processor fan button battery asus_acpi ac uhci_hcd ehci_hcd rng_core
[  133.197473] CPU:    0
[  133.197474] EIP:    0060:[<f8a5973c>]    Not tainted VLI
[  133.197475] EFLAGS: 00010202   (2.6.20-rc6-mm2 #1)
[  133.197656] EIP is at svc_pool_map_init_percpu+0x54/0x5a [sunrpc]
[  133.197715] eax: 00000002   ebx: f8a762e4   ecx: 00000002   edx: 00000008
[  133.197776] esi: 00000002   edi: f8aa71e0   ebp: c2fd3edc   esp: c2fd3ed4
[  133.197835] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[  133.197894] Process rpc.nfsd (pid: 3595, ti=c2fd2000 task=f7e22030 task.ti=c2fd2000)
[  133.197954] Stack: f8a7c081 00040000 c2fd3ee4 f8a597de c2fd3efc f8a59a55 c2fd3f10 00000000
[  133.198360]        00000008 00000801 c2fd3f54 f8a7c1ac f8a7c4e9 00000001 f8aa9480 fffdd1fe
[  133.198769]        00000292 f8aa9140 00015f90 0007dbcc 00078804 00000000 0000076e 00000008
[  133.199175] Call Trace:
[  133.199275]  [<c010390d>] show_trace_log_lvl+0x1a/0x30
[  133.199373]  [<c01039c4>] show_stack_log_lvl+0x8d/0xb1
[  133.199467]  [<c0103bf1>] show_registers+0x1c0/0x336
[  133.199561]  [<c0103efd>] die+0x11f/0x213
[  133.199654]  [<c010406a>] do_trap+0x79/0xa7
[  133.199748]  [<c010433b>] do_invalid_op+0xa3/0xad
[  133.199842]  [<c03ee3a4>] error_code+0x7c/0x84
[  133.199936]  [<f8a597de>] svc_pool_map_init+0x4c/0x60 [sunrpc]
[  133.200047]  [<f8a59a55>] svc_create_pooled+0x14/0x44 [sunrpc]
[  133.200156]  [<f8a7c1ac>] nfsd_create_serv+0x5a/0xd4 [nfsd]
[  133.200262]  [<f8a7c498>] nfsd_svc+0x50/0xa1 [nfsd]
[  133.200364]  [<f8a7ca1f>] write_svc+0x1a/0x20 [nfsd]
[  133.200466]  [<f8a7c98a>] nfsctl_transaction_write+0x4a/0x6d [nfsd]
[  133.200571]  [<c019f29e>] sys_nfsservctl+0xa3/0xe5
[  133.200666]  [<c0102a94>] sysenter_past_esp+0x5d/0x99
[  133.200762]  =======================
[  133.200816] Code: c1 77 22 83 fe 01 77 23 8b 43 0c ba 10 3f 54 c0 89 34 88 8b 43 08 89 0c b0 89 c8 83 c6 01 e8 4e 8f 7b c7 eb d7 5b 89 f0 5e 5d c3 <0f> 0b 89 f6 eb fc 55 ba 01 00 00 00 89 e5 56 31 f6 53 89 c3 e8
[  133.203330] EIP: [<f8a5973c>] svc_pool_map_init_percpu+0x54/0x5a [sunrpc] SS:ESP 0068:c2fd3ed4

The following patch fixes the problem for me.

Regards,
Frederik


Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index c8c7c55..a553f9f 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -115,7 +115,7 @@ fail:
 static int
 svc_pool_map_init_percpu(struct svc_pool_map *m)
 {
-	unsigned int maxpools = nr_node_ids;
+	unsigned int maxpools = num_online_cpus();
 	unsigned int pidx = 0;
 	unsigned int cpu;
 	int err;
