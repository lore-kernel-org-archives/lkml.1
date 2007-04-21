Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbXDUNPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbXDUNPd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 09:15:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbXDUNPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 09:15:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510AbXDUNPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 09:15:31 -0400
Date: Sat, 21 Apr 2007 09:15:24 -0400
From: Jeff Layton <jlayton@redhat.com>
To: nfs@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] RPC: add wrapper for svc_reserve to account for checksum
Message-ID: <20070421131523.GA18100@dantu.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When the kernel calls svc_reserve to downsize the expected size of an RPC
reply, it fails to account for the possibility of a checksum at the end of
the packet. If a client mounts a NFSv2/3 with sec=krb5i/p, and does I/O then
you'll generally see messages similar to this in the server's ring buffer:

RPC request reserved 164 but used 208

While I was never able to verify it, I suspect that this problem is also the
root cause of some oopses I've seen under these conditions:

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=227726

This is probably also a problem for other sec= types and for NFSv4. The large
reserved size for NFSv4 compound packets seems to generally paper over the
problem, however.

This patch adds a wrapper for svc_reserve that accounts for the possibility of
a checksum. It also fixes up the appropriate callers of svc_reserve to call
the wrapper. For now, it just uses a hardcoded value that I determined via
testing. That value may need to be revised upward as things change, or we
may want to eventually add a new auth_op that attempts to calculate this
somehow.

Unfortunately, there doesn't seem to be a good way to reliably determine the
expected checksum length prior to actually calculating it, particularly with
schemes like spkm3.

Signed-off-by: Jeff Layton <jlayton@redhat.com>

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index f61142a..7d47c16 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -175,7 +175,7 @@ nfsd3_proc_read(struct svc_rqst *rqstp, struct nfsd3_readargs *argp,
 	if (NFSSVC_MAXBLKSIZE < resp->count)
 		resp->count = NFSSVC_MAXBLKSIZE;
 
-	svc_reserve(rqstp, ((1 + NFS3_POST_OP_ATTR_WORDS + 3)<<2) + resp->count +4);
+	svc_reserve_auth(rqstp, ((1 + NFS3_POST_OP_ATTR_WORDS + 3)<<2) + resp->count +4);
 
 	fh_copy(&resp->fh, &argp->fh);
 	nfserr = nfsd_read(rqstp, &resp->fh, NULL,
diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 4e06810..21f2ff7 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -154,7 +154,7 @@ nfsd_proc_read(struct svc_rqst *rqstp, struct nfsd_readargs *argp,
 				argp->count);
 		argp->count = NFSSVC_MAXBLKSIZE;
 	}
-	svc_reserve(rqstp, (19<<2) + argp->count + 4);
+	svc_reserve_auth(rqstp, (19<<2) + argp->count + 4);
 
 	resp->count = argp->count;
 	nfserr = nfsd_read(rqstp, fh_copy(&resp->fh, &argp->fh), NULL,
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 94350f5..60f24d6 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -326,4 +326,24 @@ int		   svc_register(struct svc_serv *, int, unsigned short);
 void		   svc_wake_up(struct svc_serv *);
 void		   svc_reserve(struct svc_rqst *rqstp, int space);
 
+/*
+ * When we want to reduce the size of the reserved space in the response
+ * buffer, we need to take into account the size of any checksum data that
+ * may be at the end of the packet. For now, just use a hardcoded value
+ * for each possible authflavor. This will need to be updated when new
+ * encryption types or algorithms are added, or we'll have to come up with
+ * a way to reasonably calculate this on the fly (maybe via a new auth_op).
+ */
+static inline void 
+svc_reserve_auth(struct svc_rqst *rqstp, int space)
+{
+	int			added_space = 0;
+
+	switch(rqstp->rq_authop->flavour) {
+		case RPC_AUTH_GSS:
+			added_space = 56; /* determined empirically */
+	}
+	return svc_reserve(rqstp, space + added_space);
+}
+
 #endif /* SUNRPC_SVC_H */
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 0aab5b5..2d390d1 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -379,7 +379,7 @@ svc_process(struct svc_serv *serv, struct svc_rqst *rqstp)
 	 * better idea of reply size
 	 */
 	if (procp->pc_xdrressize)
-		svc_reserve(rqstp, procp->pc_xdrressize<<2);
+		svc_reserve_auth(rqstp, procp->pc_xdrressize<<2);
 
 	/* Call the function that processes the request. */
 	if (!versp->vs_dispatch) {
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
