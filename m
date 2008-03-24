Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbYCXQD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbYCXQD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 12:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYCXQDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 12:03:19 -0400
Received: from mail.fieldses.org ([66.93.2.214]:51160 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbYCXQDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 12:03:18 -0400
Date: Mon, 24 Mar 2008 12:03:03 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Neil Brown <neilb@suse.de>, Roland Dreier <rolandd@cisco.com>,
       Tom Tucker <tom@opengridcomputing.com>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] SVCRDMA: Use only 1 RDMA read scatter entry for iWARP
	adapters
Message-ID: <20080324160303.GB23736@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>

The iWARP protocol limits RDMA read requests to a single scatter
entry.  NFS/RDMA has code in rdma_read_max_sge() that is supposed to
limit the sge_count for RDMA read requests to 1, but the code to do
that is inside an #ifdef RDMA_TRANSPORT_IWARP block.  In the mainline
kernel at least, RDMA_TRANSPORT_IWARP is an enum and not a
preprocessor #define, so the #ifdef'ed code is never compiled.

In my test of a kernel build with -j8 on an NFS/RDMA mount, this
problem eventually leads to trouble starting with:

    svcrdma: Error posting send = -22
    svcrdma : RDMA_READ error = -22

and things go downhill from there.

The trivial fix is to delete the #ifdef guard.  The check seems to be
a remnant of when the NFS/RDMA code was not merged and needed to
compile against multiple kernel versions, although I don't think it
ever worked as intended.  In any case now that the code is upstream
there's no need to test whether the RDMA_TRANSPORT_IWARP constant is
defined or not.

Without this patch, my kernel build on an NFS/RDMA mount using NetEffect
adapters quickly and 100% reproducibly failed with an error like:

    ld: final link failed: Software caused connection abort

With the patch applied I was able to complete a kernel build on the
same setup.

(Tom Tucker says this is "actually an _ancient_ remnant when it had to
compile against iWARP vs. non-iWARP enabled OFA trees.")

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Acked-by: Tom Tucker <tom@opengridcomputing.com>
Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
---
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

This is a bugfix appropriate for 2.6.25.--b.

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index ab54a73..9712716 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -237,14 +237,12 @@ static void rdma_set_ctxt_sge(struct svc_rdma_op_ctxt *ctxt,
 
 static int rdma_read_max_sge(struct svcxprt_rdma *xprt, int sge_count)
 {
-#ifdef RDMA_TRANSPORT_IWARP
 	if ((RDMA_TRANSPORT_IWARP ==
 	     rdma_node_get_transport(xprt->sc_cm_id->
 				     device->node_type))
 	    && sge_count > 1)
 		return 1;
 	else
-#endif
 		return min_t(int, sge_count, xprt->sc_max_sge);
 }
 
-- 
1.5.5.rc1

