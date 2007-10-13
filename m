Return-Path: <linux-kernel-owner+w=401wt.eu-S1763688AbXJMO71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763688AbXJMO71 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762302AbXJMOpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:45:33 -0400
Received: from 1wt.eu ([62.212.114.60]:3057 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762245AbXJMOp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:45:29 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143444.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:27 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Gerrit Renker <gerrit@erg.abdn.ac.uk>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 05/35] DCCP: Fix DCCP GFP_KERNEL allocation in atomic context
Content-Disposition: inline; filename=0029-DCCP-Fix-DCCP-GFP_KERNEL-allocation-in-atomic-conte.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following bug reported in syslog:

[ 4039.051658] BUG: sleeping function called from invalid context at /usr/src/davem-2.6/mm/slab.c:3032
[ 4039.051668] in_atomic():1, irqs_disabled():0
[ 4039.051670] INFO: lockdep is turned off.
[ 4039.051674]  [<c0104c0f>] show_trace_log_lvl+0x1a/0x30
[ 4039.051687]  [<c0104d4d>] show_trace+0x12/0x14
[ 4039.051691]  [<c0104d65>] dump_stack+0x16/0x18
[ 4039.051695]  [<c011371e>] __might_sleep+0xaf/0xbe
[ 4039.051700]  [<c0157b66>] __kmalloc+0xb1/0xd0
[ 4039.051706]  [<f090416f>] ccid2_hc_tx_alloc_seq+0x35/0xc3 [dccp_ccid2]
[ 4039.051717]  [<f09048d6>] ccid2_hc_tx_packet_sent+0x27f/0x2d9 [dccp_ccid2]
[ 4039.051723]  [<f085486b>] dccp_write_xmit+0x1eb/0x338 [dccp]
[ 4039.051741]  [<f085603d>] dccp_sendmsg+0x113/0x18f [dccp]
[ 4039.051750]  [<c03907fc>] inet_sendmsg+0x2e/0x4c
[ 4039.051758]  [<c033a47d>] sock_aio_write+0xd5/0x107
[ 4039.051766]  [<c015abc1>] do_sync_write+0xcd/0x11c
[ 4039.051772]  [<c015b296>] vfs_write+0x118/0x11f
[ 4039.051840]  [<c015b932>] sys_write+0x3d/0x64
[ 4039.051845]  [<c0103e7c>] syscall_call+0x7/0xb
[ 4039.051848]  =======================

The problem was that GFP_KERNEL was used; fixed by using gfp_any().

Signed-off-by: Gerrit Renker <gerrit@erg.abdn.ac.uk>
Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/dccp/ccids/ccid2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Index: 2.6/net/dccp/ccids/ccid2.c
===================================================================
--- 2.6.orig/net/dccp/ccids/ccid2.c
+++ 2.6/net/dccp/ccids/ccid2.c
@@ -298,7 +298,7 @@ static void ccid2_hc_tx_packet_sent(stru
 		int rc;
 
 		ccid2_pr_debug("allocating more space in history
");
-		rc = ccid2_hc_tx_alloc_seq(hctx, CCID2_SEQBUF_LEN, GFP_KERNEL);
+		rc = ccid2_hc_tx_alloc_seq(hctx, CCID2_SEQBUF_LEN, gfp_any());
 		BUG_ON(rc); /* XXX what do we do? */
 
 		next = hctx->ccid2hctx_seqh->ccid2s_next;

-- 
