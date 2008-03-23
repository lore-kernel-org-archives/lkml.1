Return-Path: <linux-kernel-owner+w=401wt.eu-S1757707AbYCWV1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707AbYCWV1Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 17:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755425AbYCWV1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 17:27:15 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:62029 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbYCWV1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 17:27:13 -0400
To: Tom Tucker <tom@opengridcomputing.com>,
       "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>, Trond Myklebust <Trond.Myklebust@netapp.com>,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH for 2.6.25] SVCRDMA: Use only 1 RDMA read scatter entry for iWARP adapters
X-Message-Flag: Warning: May contain useful information
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 23 Mar 2008 14:27:12 -0700
Message-ID: <adaiqzdt9lb.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Mar 2008 21:27:12.0451 (UTC) FILETIME=[A8770930:01C88D2C]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
I guess this should probably go into 2.6.25 if possible, since things
get seriously screwed up in my testing once this bug is hit.

Not sure why this doesn't trigger on Chelsio or Ammasso adapters (or
does it?), but it's easily reproducible here on Neteffect adapters
(and that driver is now upstream for 2.6.25).

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
 
