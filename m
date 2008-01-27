Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbYA0UhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbYA0UhR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 15:37:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbYA0UhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 15:37:04 -0500
Received: from smtp.cs.aau.dk ([130.225.194.6]:43915 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbYA0UhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 15:37:01 -0500
Subject: Re: nfs server patches for 2.6.25
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
Cc: linux-nfs@vger.kernel.org, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
In-Reply-To: <20080125231521.GG25141@fieldses.org>
References: <20080125231521.GG25141@fieldses.org>
Content-Type: text/plain; charset=utf-8
Date: Sun, 27 Jan 2008 21:42:23 +0100
Message-Id: <1201466543.5006.21.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fre, 25 01 2008 kl. 18:15 -0500, skrev J. Bruce Fields: 
> Below is a summary of the nfs server patches which I expect to submit
> (any day now) for 2.6.25; please let me know if you notice anything
> wrong or missing.  I'll follow up to linux-nfs@vger.kernel.org with the
> full list of patches.

There are at least two patches that don't compile and break
bisectability. The errors should be obvious, just checkout and make
6f310df and 23b4e2e (patch no. 29 and 65 from the posting of the patch
set on linux-nfs).

[...] 
> J. Bruce Fields (34):
>       nfsd4: kill unnecessary same_name() in setclientid_confirm
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 508b256..d026c24 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -858,8 +857,7 @@ nfsd4_setclientid_confirm(struct svc_rqst *rqstp,
                }
        } else if ((conf && !unconf) ||
            ((conf && unconf) && 
-            (!same_verf(&conf->cl_verifier, &unconf->cl_verifier) ||
-             !same_name(conf->cl_recdir, unconf->cl_recdir)))) {
+            !same_verf(&conf->cl_verifier, &unconf->cl_verifier)) {
missing ending parenthesis ---------------------------------------^


[...] 
> Tom Tucker (47):
>       svc: Make close transport independent
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index f86538e..6dffdda 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1912,66 +1911,63 @@ static void svc_sock_free(struct svc_xprt *xprt)
 }
 
 /*
- * Remove a dead socket
+ * Remove a dead transport
  */
-static void
-svc_delete_socket(struct svc_sock *svsk)
+static void svc_delete_xprt(struct svc_xprt *xprt)
 {
-       struct svc_serv *serv;
-       struct sock     *sk;
-
-       dprintk("svc: svc_delete_socket(%p)\n", svsk);
-
-       serv = svsk->sk_xprt.xpt_server;
-       sk = svsk->sk_sk;
+       struct svc_serv *serv = xprt->xpt_server;
 
-       svsk->sk_xprt.xpt_ops->xpo_detach(&svsk->sk_xprt);
+       dprintk("svc: svc_delete_xprt(%p)\n", xprt);
+       xprt->xpt_ops->xpo_detach(xprt);
 
        spin_lock_bh(&serv->sv_lock);
-
-       if (!test_and_set_bit(XPT_DETACHED, &svsk->sk_xprt.xpt_flags))
-               list_del_init(&svsk->sk_list);
+       if (!test_and_set_bit(XPT_DETACHED, &xprt->xpt_flags))
+               list_del_init(&xprt->xpt_list);
        /*
-        * We used to delete the svc_sock from whichever list
-        * it's sk_ready node was on, but we don't actually
+        * We used to delete the transport from whichever list
+        * it's sk_xprt.xpt_ready node was on, but we don't actually
         * need to.  This is because the only time we're called
         * while still attached to a queue, the queue itself
         * is about to be destroyed (in svc_destroy).
         */
-       if (!test_and_set_bit(XPT_DEAD, &svsk->sk_xprt.xpt_flags)) {
-               BUG_ON(atomic_read(&svsk->sk_xprt.xpt_ref.refcount) <
2);
-               if (test_bit(XPT_TEMP, &svsk->sk_xprt.xpt_flags))
+       if (!test_and_set_bit(XPT_DEAD, &xprt->xpt_flags)) {
+               BUG_ON(atomic_read(&xprt->xpt_ref.refcount) < 2);
+               if (test_bit(XPT_TEMP, &xprt->xpt_flags))
                        serv->sv_tmpcnt--;
                svc_xprt_put(&svsk->sk_xprt);
should have been
                svc_xprt_put(&xprt);

There might be more errors in the next 15 patches or so; I didn't test
them with this error corrected.



Simon Holm Thøgersen

