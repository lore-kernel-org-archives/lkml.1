Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbXEGAgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbXEGAgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 20:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbXEGAgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 20:36:11 -0400
Received: from ns2.suse.de ([195.135.220.15]:57803 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbXEGAgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 20:36:03 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 7 May 2007 10:35:38 +1000
Message-Id: <1070507003538.24137@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>
Cc: Neil Brown <neilb@suse.de>
Cc: Wei Yongjun <yjwei@cn.fujitsu.com>
Subject: [PATCH 004 of 8] knfsd: rpcgss : RPC_GSS_PROC_ DESTROY request will get a bad rpc
References: <20070507103211.23855.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Wei Yongjun <yjwei@cn.fujitsu.com>


If I send a RPC_GSS_PROC_DESTROY message to NFSv4 server, it will reply
with a bad rpc reply which lacks an authentication verifier.
Maybe this patch is needed.

Send/recv packets as following:

send:

RemoteProcedureCall
    xid
    rpcvers = 2
    prog = 100003
    vers = 4
    proc = 0
    cred = AUTH_GSS
        version = 1
        gss_proc = 3 (RPCSEC_GSS_DESTROY)
        service  = 1 (RPC_GSS_SVC_NONE)
    verf = AUTH_GSS
        checksum

reply:

RemoteProcedureReply
    xid
    msg_type
    reply_stat
    accepted_reply

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./net/sunrpc/auth_gss/svcauth_gss.c |    2 ++
 1 file changed, 2 insertions(+)

diff .prev/net/sunrpc/auth_gss/svcauth_gss.c ./net/sunrpc/auth_gss/svcauth_gss.c
--- .prev/net/sunrpc/auth_gss/svcauth_gss.c	2007-05-07 10:31:03.000000000 +1000
+++ ./net/sunrpc/auth_gss/svcauth_gss.c	2007-05-07 10:31:04.000000000 +1000
@@ -1106,6 +1106,8 @@ svcauth_gss_accept(struct svc_rqst *rqst
 		}
 		goto complete;
 	case RPC_GSS_PROC_DESTROY:
+		if (gss_write_verf(rqstp, rsci->mechctx, gc->gc_seq))
+			goto auth_err;
 		set_bit(CACHE_NEGATIVE, &rsci->h.flags);
 		if (resv->iov_len + 4 > PAGE_SIZE)
 			goto drop;
