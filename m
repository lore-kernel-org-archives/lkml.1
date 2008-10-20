Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYJTRhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYJTRhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbYJTRgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:36:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbYJTRgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:36:51 -0400
Date: Mon, 20 Oct 2008 13:35:45 -0400
From: Jason Baron <jbaron@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 20
Message-ID: <20081020173545.GB3161@redhat.com>
References: <20081020235904.2f9a8db4.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020235904.2f9a8db4.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 11:59:04PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's tree will not build for powerpc allyesconfig (libc aborts the
> link due to a free() problem), sparc(32) defconfig and probably some
> other configurations.
> 

hmmm...yeah, on x86_64 i've hit:

  CC [M]  net/9p/protocol.o
  LD [M]  net/9p/9pnet.o
  LD [M]  net/9p/9pnet_virtio.o
  Building modules, stage 2.
  MODPOST 1616 modules
ERROR: "p9_debug_level" [net/9p/9pnet.ko] undefined!


seems to be resolved by this simple patch:


Signed-off-by: Jason Baron <jbaron@redhat.com>


diff --git a/net/9p/protocol.c b/net/9p/protocol.c
index 29be524..ebf819e 100644
--- a/net/9p/protocol.c
+++ b/net/9p/protocol.c
@@ -542,8 +542,10 @@ int p9pdu_finalize(struct p9_fcall *pdu)
 	err = p9pdu_writef(pdu, 0, "d", size);
 	pdu->size = size;
 
+#ifdef CONFIG_NET_9P_DEBUG
 	if ((p9_debug_level & P9_DEBUG_PKT) == P9_DEBUG_PKT)
 		p9pdu_dump(0, pdu);
+#endif
 
 	P9_DPRINTK(P9_DEBUG_9P, ">>> size=%d type: %d tag: %d\n", pdu->size,
 							pdu->id, pdu->tag);
