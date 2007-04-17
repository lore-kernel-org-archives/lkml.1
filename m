Return-Path: <linux-kernel-owner+w=401wt.eu-S1754267AbXDQCCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267AbXDQCCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 22:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbXDQCCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 22:02:00 -0400
Received: from ns1.suse.de ([195.135.220.2]:56197 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267AbXDQCB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 22:01:59 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 17 Apr 2007 12:01:41 +1000
Message-Id: <1070417020141.28483@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Greg Banks <gnb@melbourne.sgi.com>
Cc: Gabriel Barazer <gabriel@oxeva.fr>
Cc: stable@kernel.org
Subject: [PATCH 001 of 2] knfsd: Use a spinlock to protect sk_info_authunix
References: <20070417115242.28047.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


sk_info_authunix is not being protected properly so the object that
it points to can be cache_put twice, leading to corruption.

We borrow svsk->sk_defer_lock to provide the protection.  We should probably
rename that lock to have a more generic name - later.

Thanks to Gabriel for reporting this.

Cc: Greg Banks <gnb@melbourne.sgi.com>
Cc: Gabriel Barazer <gabriel@oxeva.fr>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./net/sunrpc/svcauth_unix.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff .prev/net/sunrpc/svcauth_unix.c ./net/sunrpc/svcauth_unix.c
--- .prev/net/sunrpc/svcauth_unix.c	2007-04-17 11:42:14.000000000 +1000
+++ ./net/sunrpc/svcauth_unix.c	2007-04-17 11:42:21.000000000 +1000
@@ -383,7 +383,10 @@ void svcauth_unix_purge(void)
 static inline struct ip_map *
 ip_map_cached_get(struct svc_rqst *rqstp)
 {
-	struct ip_map *ipm = rqstp->rq_sock->sk_info_authunix;
+	struct ip_map *ipm;
+	struct svc_sock *svsk = rqstp->rq_sock;
+	spin_lock_bh(&svsk->sk_defer_lock);
+	ipm = svsk->sk_info_authunix;
 	if (ipm != NULL) {
 		if (!cache_valid(&ipm->h)) {
 			/*
@@ -391,12 +394,14 @@ ip_map_cached_get(struct svc_rqst *rqstp
 			 * remembered, e.g. by a second mount from the
 			 * same IP address.
 			 */
-			rqstp->rq_sock->sk_info_authunix = NULL;
+			svsk->sk_info_authunix = NULL;
+			spin_unlock_bh(&svsk->sk_defer_lock);
 			cache_put(&ipm->h, &ip_map_cache);
 			return NULL;
 		}
 		cache_get(&ipm->h);
 	}
+	spin_unlock_bh(&svsk->sk_defer_lock);
 	return ipm;
 }
 
@@ -405,9 +410,15 @@ ip_map_cached_put(struct svc_rqst *rqstp
 {
 	struct svc_sock *svsk = rqstp->rq_sock;
 
-	if (svsk->sk_sock->type == SOCK_STREAM && svsk->sk_info_authunix == NULL)
-		svsk->sk_info_authunix = ipm;	/* newly cached, keep the reference */
-	else
+	spin_lock_bh(&svsk->sk_defer_lock);
+	if (svsk->sk_sock->type == SOCK_STREAM &&
+	    svsk->sk_info_authunix == NULL) {
+		/* newly cached, keep the reference */
+		svsk->sk_info_authunix = ipm;
+		ipm = NULL;
+	}
+	spin_unlock_bh(&svsk->sk_defer_lock);
+	if (ipm)
 		cache_put(&ipm->h, &ip_map_cache);
 }
 
