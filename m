Return-Path: <linux-kernel-owner+w=401wt.eu-S1752414AbZIKA25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbZIKA25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 20:28:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZIKA25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 20:28:57 -0400
Received: from kroah.org ([198.145.64.141]:38021 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbZIKA24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 20:28:56 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Sep 10 17:24:09 2009
Message-Id: <20090911002409.099894354@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Sep 2009 17:22:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wei Yongjun <yjwei@cn.fujitsu.com>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 01/22] dccp: missing destroy of percpu counter variable while unload module
References: <20090911002246.666327880@mini.kroah.org>
Content-Disposition: inline; filename=dccp-missing-destroy-of-percpu-counter-variable-while-unload-module.patch
In-Reply-To: <20090911002616.GA12087@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Wei Yongjun <yjwei@cn.fujitsu.com>

[ Upstream commit 476181cb05c6a3aea3ef42309388e255c934a06f ]

percpu counter dccp_orphan_count is init in dccp_init() by
percpu_counter_init() while dccp module is loaded, but the
destroy of it is missing while dccp module is unloaded. We
can get the kernel WARNING about this. Reproduct by the
following commands:

  $ modprobe dccp
  $ rmmod dccp
  $ modprobe dccp

WARNING: at lib/list_debug.c:26 __list_add+0x27/0x5c()
Hardware name: VMware Virtual Platform
list_add corruption. next->prev should be prev (c080c0c4), but was (null). (next
=ca7188cc).
Modules linked in: dccp(+) nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc
Pid: 1956, comm: modprobe Not tainted 2.6.31-rc5 #55
Call Trace:
 [<c042f8fa>] warn_slowpath_common+0x6a/0x81
 [<c053a6cb>] ? __list_add+0x27/0x5c
 [<c042f94f>] warn_slowpath_fmt+0x29/0x2c
 [<c053a6cb>] __list_add+0x27/0x5c
 [<c053c9b3>] __percpu_counter_init+0x4d/0x5d
 [<ca9c90c7>] dccp_init+0x19/0x2ed [dccp]
 [<c0401141>] do_one_initcall+0x4f/0x111
 [<ca9c90ae>] ? dccp_init+0x0/0x2ed [dccp]
 [<c06971b5>] ? notifier_call_chain+0x26/0x48
 [<c0444943>] ? __blocking_notifier_call_chain+0x45/0x51
 [<c04516f7>] sys_init_module+0xac/0x1bd
 [<c04028e4>] sysenter_do_call+0x12/0x22

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/dccp/proto.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -1159,6 +1159,7 @@ static void __exit dccp_fini(void)
 	kmem_cache_destroy(dccp_hashinfo.bind_bucket_cachep);
 	dccp_ackvec_exit();
 	dccp_sysctl_exit();
+	percpu_counter_destroy(&dccp_orphan_count);
 }
 
 module_init(dccp_init);


