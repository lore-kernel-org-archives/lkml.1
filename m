Return-Path: <linux-kernel-owner+w=401wt.eu-S932983AbXA2ABm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983AbXA2ABm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 19:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932997AbXA2ABm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 19:01:42 -0500
Received: from mx1.suse.de ([195.135.220.2]:49945 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932983AbXA2ABl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 19:01:41 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@osdl.org>
Date: Mon, 29 Jan 2007 11:01:11 +1100
Message-Id: <1070129000111.30809@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] knfsd: Ratelimit some nfsd messages that are triggered by external events.
References: <20070129110005.30734.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Another nfsd patch suitable for 2.6.20, though it could wait for .21
if we feel it is time to be more cautious.
Thanks,
NeilBrown

### Comments for Changeset

Also remove {NFSD,RPC}_PARANOIA as having the defines doesn't
really add anything.

The printks covered by RPC_PARANOIA were tirggered by badly
formatted packets and so should be ratelimited.


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./fs/nfsd/export.c     |    1 -
 ./fs/nfsd/nfsfh.c      |   14 ++++++--------
 ./fs/nfsd/vfs.c        |    1 -
 ./net/sunrpc/svc.c     |   33 ++++++++++++++++-----------------
 ./net/sunrpc/svcsock.c |   12 ++++++++----
 5 files changed, 30 insertions(+), 31 deletions(-)

diff .prev/fs/nfsd/export.c ./fs/nfsd/export.c
--- .prev/fs/nfsd/export.c	2007-01-22 09:08:21.000000000 +1100
+++ ./fs/nfsd/export.c	2007-01-29 09:54:42.000000000 +1100
@@ -34,7 +34,6 @@
 #include <linux/lockd/bind.h>
 
 #define NFSDDBG_FACILITY	NFSDDBG_EXPORT
-#define NFSD_PARANOIA 1
 
 typedef struct auth_domain	svc_client;
 typedef struct svc_export	svc_export;

diff .prev/fs/nfsd/nfsfh.c ./fs/nfsd/nfsfh.c
--- .prev/fs/nfsd/nfsfh.c	2007-01-22 09:08:23.000000000 +1100
+++ ./fs/nfsd/nfsfh.c	2007-01-29 10:56:39.000000000 +1100
@@ -24,8 +24,6 @@
 #include <linux/nfsd/nfsd.h>
 
 #define NFSDDBG_FACILITY		NFSDDBG_FH
-#define NFSD_PARANOIA 1
-/* #define NFSD_DEBUG_VERBOSE 1 */
 
 
 static int nfsd_nr_verified;
@@ -230,13 +228,12 @@ fh_verify(struct svc_rqst *rqstp, struct
 				error = nfserrno(PTR_ERR(dentry));
 			goto out;
 		}
-#ifdef NFSD_PARANOIA
+
 		if (S_ISDIR(dentry->d_inode->i_mode) &&
 		    (dentry->d_flags & DCACHE_DISCONNECTED)) {
 			printk("nfsd: find_fh_dentry returned a DISCONNECTED directory: %s/%s\n",
 			       dentry->d_parent->d_name.name, dentry->d_name.name);
 		}
-#endif
 
 		fhp->fh_dentry = dentry;
 		fhp->fh_export = exp;
@@ -267,12 +264,13 @@ fh_verify(struct svc_rqst *rqstp, struct
 	/* Finally, check access permissions. */
 	error = nfsd_permission(exp, dentry, access);
 
-#ifdef NFSD_PARANOIA_EXTREME
 	if (error) {
-		printk("fh_verify: %s/%s permission failure, acc=%x, error=%d\n",
-		       dentry->d_parent->d_name.name, dentry->d_name.name, access, (error >> 24));
+		dprintk("fh_verify: %s/%s permission failure, "
+			"acc=%x, error=%d\n",
+			dentry->d_parent->d_name.name,
+			dentry->d_name.name,
+			access, (error >> 24));
 	}
-#endif
 out:
 	if (exp && !IS_ERR(exp))
 		exp_put(exp);

diff .prev/fs/nfsd/vfs.c ./fs/nfsd/vfs.c
--- .prev/fs/nfsd/vfs.c	2007-01-24 18:32:10.000000000 +1100
+++ ./fs/nfsd/vfs.c	2007-01-29 09:56:13.000000000 +1100
@@ -59,7 +59,6 @@
 #include <asm/uaccess.h>
 
 #define NFSDDBG_FACILITY		NFSDDBG_FILEOP
-#define NFSD_PARANOIA
 
 
 /* We must ignore files (but only files) which might have mandatory

diff .prev/net/sunrpc/svc.c ./net/sunrpc/svc.c
--- .prev/net/sunrpc/svc.c	2007-01-23 11:14:49.000000000 +1100
+++ ./net/sunrpc/svc.c	2007-01-29 10:06:49.000000000 +1100
@@ -26,7 +26,6 @@
 #include <linux/sunrpc/clnt.h>
 
 #define RPCDBG_FACILITY	RPCDBG_SVCDSP
-#define RPC_PARANOIA 1
 
 /*
  * Mode for mapping cpus to pools.
@@ -872,15 +871,15 @@ svc_process(struct svc_rqst *rqstp)
 	return 0;
 
 err_short_len:
-#ifdef RPC_PARANOIA
-	printk("svc: short len %Zd, dropping request\n", argv->iov_len);
-#endif
+	if (net_ratelimit())
+		printk("svc: short len %Zd, dropping request\n", argv->iov_len);
+
 	goto dropit;			/* drop request */
 
 err_bad_dir:
-#ifdef RPC_PARANOIA
-	printk("svc: bad direction %d, dropping request\n", dir);
-#endif
+	if (net_ratelimit())
+		printk("svc: bad direction %d, dropping request\n", dir);
+
 	serv->sv_stats->rpcbadfmt++;
 	goto dropit;			/* drop request */
 
@@ -909,10 +908,10 @@ err_bad_prog:
 	goto sendit;
 
 err_bad_vers:
-#ifdef RPC_PARANOIA
-	printk("svc: unknown version (%d for prog %d, %s)\n",
-	       vers, prog, progp->pg_name);
-#endif
+	if (net_ratelimit())
+		printk("svc: unknown version (%d for prog %d, %s)\n",
+		       vers, prog, progp->pg_name);
+
 	serv->sv_stats->rpcbadfmt++;
 	svc_putnl(resv, RPC_PROG_MISMATCH);
 	svc_putnl(resv, progp->pg_lovers);
@@ -920,17 +919,17 @@ err_bad_vers:
 	goto sendit;
 
 err_bad_proc:
-#ifdef RPC_PARANOIA
-	printk("svc: unknown procedure (%d)\n", proc);
-#endif
+	if (net_ratelimit())
+		printk("svc: unknown procedure (%d)\n", proc);
+
 	serv->sv_stats->rpcbadfmt++;
 	svc_putnl(resv, RPC_PROC_UNAVAIL);
 	goto sendit;
 
 err_garbage:
-#ifdef RPC_PARANOIA
-	printk("svc: failed to decode args\n");
-#endif
+	if (net_ratelimit())
+		printk("svc: failed to decode args\n");
+
 	rpc_stat = rpc_garbage_args;
 err_bad:
 	serv->sv_stats->rpcbadfmt++;

diff .prev/net/sunrpc/svcsock.c ./net/sunrpc/svcsock.c
--- .prev/net/sunrpc/svcsock.c	2007-01-23 11:14:54.000000000 +1100
+++ ./net/sunrpc/svcsock.c	2007-01-29 10:56:08.000000000 +1100
@@ -1090,15 +1090,19 @@ svc_tcp_recvfrom(struct svc_rqst *rqstp)
 			 *  bit set in the fragment length header.
 			 *  But apparently no known nfs clients send fragmented
 			 *  records. */
-			printk(KERN_NOTICE "RPC: bad TCP reclen 0x%08lx (non-terminal)\n",
-			       (unsigned long) svsk->sk_reclen);
+			if (net_ratelimit())
+				printk(KERN_NOTICE "RPC: bad TCP reclen 0x%08lx"
+				       " (non-terminal)\n",
+				       (unsigned long) svsk->sk_reclen);
 			goto err_delete;
 		}
 		svsk->sk_reclen &= 0x7fffffff;
 		dprintk("svc: TCP record, %d bytes\n", svsk->sk_reclen);
 		if (svsk->sk_reclen > serv->sv_max_mesg) {
-			printk(KERN_NOTICE "RPC: bad TCP reclen 0x%08lx (large)\n",
-			       (unsigned long) svsk->sk_reclen);
+			if (net_ratelimit())
+				printk(KERN_NOTICE "RPC: bad TCP reclen 0x%08lx"
+				       " (large)\n",
+				       (unsigned long) svsk->sk_reclen);
 			goto err_delete;
 		}
 	}
