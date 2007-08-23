Return-Path: <linux-kernel-owner+w=401wt.eu-S933540AbXHWWbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540AbXHWWbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 18:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765360AbXHWW2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 18:28:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50700 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574AbXHWW2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 18:28:18 -0400
Date: Thu, 23 Aug 2007 15:26:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Gerrit Renker <gerrit@erg.abdn.ac.uk>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 08/28] DCCP: Fix DCCP GFP_KERNEL allocation in atomic
	context
Message-ID: <20070823222626.GI18559@kroah.com>
References: <20070823220656.101239233@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="dccp-fix-dccp-gfp_kernel-allocation-in-atomic-context.patch"
In-Reply-To: <20070823221811.GA18559@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Gerrit Renker <gerrit@erg.abdn.ac.uk>

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
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/dccp/ccids/ccid2.c
+++ b/net/dccp/ccids/ccid2.c
@@ -298,7 +298,7 @@ static void ccid2_hc_tx_packet_sent(stru
 		int rc;
 
 		ccid2_pr_debug("allocating more space in history\n");
-		rc = ccid2_hc_tx_alloc_seq(hctx, CCID2_SEQBUF_LEN, GFP_KERNEL);
+		rc = ccid2_hc_tx_alloc_seq(hctx, CCID2_SEQBUF_LEN, gfp_any());
 		BUG_ON(rc); /* XXX what do we do? */
 
 		next = hctx->ccid2hctx_seqh->ccid2s_next;

-- 
