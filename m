Return-Path: <linux-kernel-owner+w=401wt.eu-S965748AbXCFCQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965748AbXCFCQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 21:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965747AbXCFCQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 21:16:48 -0500
Received: from ns.suse.de ([195.135.220.2]:47926 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933861AbXCFCQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 21:16:31 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 6 Mar 2007 13:15:15 +1100
Message-Id: <1070306021515.26922@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 003 of 4] knfsd: Fix recently introduced problem with shutting down a busy NFS server.
References: <20070306131103.26638.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When the last thread of nfsd exits, it shuts down all related sockets.
It currently uses svc_close_socket to do this, but that only is
immediately effective if the socket is not SK_BUSY.

If the socket is busy - i.e. if a request has arrived that has not yet
been processes - svc_close_socket is not effective and the shutdown
process spins.

So create a new svc_force_close_socket which removes the SK_BUSY flag
is set and then calls svc_close_socket.

Also change some open-codes loops in svc_destroy to use
list_for_each_entry_safe.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./include/linux/sunrpc/svcsock.h |    2 +-
 ./net/sunrpc/svc.c               |   21 +++++++++------------
 ./net/sunrpc/svcsock.c           |   16 +++++++++++++++-
 3 files changed, 25 insertions(+), 14 deletions(-)

diff .prev/include/linux/sunrpc/svcsock.h ./include/linux/sunrpc/svcsock.h
--- .prev/include/linux/sunrpc/svcsock.h	2007-03-06 12:19:18.000000000 +1100
+++ ./include/linux/sunrpc/svcsock.h	2007-03-06 12:19:23.000000000 +1100
@@ -66,7 +66,7 @@ struct svc_sock {
  * Function prototypes.
  */
 int		svc_makesock(struct svc_serv *, int, unsigned short, int flags);
-void		svc_close_socket(struct svc_sock *);
+void		svc_force_close_socket(struct svc_sock *);
 int		svc_recv(struct svc_rqst *, long);
 int		svc_send(struct svc_rqst *);
 void		svc_drop(struct svc_rqst *);

diff .prev/net/sunrpc/svc.c ./net/sunrpc/svc.c
--- .prev/net/sunrpc/svc.c	2007-03-06 12:02:18.000000000 +1100
+++ ./net/sunrpc/svc.c	2007-03-06 12:27:12.000000000 +1100
@@ -367,6 +367,7 @@ void
 svc_destroy(struct svc_serv *serv)
 {
 	struct svc_sock	*svsk;
+	struct svc_sock *tmp;
 
 	dprintk("svc: svc_destroy(%s, %d)\n",
 				serv->sv_program->pg_name,
@@ -382,21 +383,17 @@ svc_destroy(struct svc_serv *serv)
 
 	del_timer_sync(&serv->sv_temptimer);
 
-	while (!list_empty(&serv->sv_tempsocks)) {
-		svsk = list_entry(serv->sv_tempsocks.next,
-				  struct svc_sock,
-				  sk_list);
-		svc_close_socket(svsk);
-	}
+	list_for_each_entry_safe(svsk, tmp, &serv->sv_tempsocks, sk_list)
+		svc_force_close_socket(svsk);
+
 	if (serv->sv_shutdown)
 		serv->sv_shutdown(serv);
 
-	while (!list_empty(&serv->sv_permsocks)) {
-		svsk = list_entry(serv->sv_permsocks.next,
-				  struct svc_sock,
-				  sk_list);
-		svc_close_socket(svsk);
-	}
+	list_for_each_entry_safe(svsk, tmp, &serv->sv_permsocks, sk_list)
+		svc_force_close_socket(svsk);
+
+	BUG_ON(!list_empty(&serv->sv_permsocks));
+	BUG_ON(!list_empty(&serv->sv_tempsocks));
 
 	cache_clean_deferred(serv);
 

diff .prev/net/sunrpc/svcsock.c ./net/sunrpc/svcsock.c
--- .prev/net/sunrpc/svcsock.c	2007-03-06 11:12:40.000000000 +1100
+++ ./net/sunrpc/svcsock.c	2007-03-06 12:36:20.000000000 +1100
@@ -82,6 +82,7 @@ static void		svc_delete_socket(struct sv
 static void		svc_udp_data_ready(struct sock *, int);
 static int		svc_udp_recvfrom(struct svc_rqst *);
 static int		svc_udp_sendto(struct svc_rqst *);
+static void		svc_close_socket(struct svc_sock *svsk);
 
 static struct svc_deferred_req *svc_deferred_dequeue(struct svc_sock *svsk);
 static int svc_deferred_recv(struct svc_rqst *rqstp);
@@ -1787,7 +1788,7 @@ svc_delete_socket(struct svc_sock *svsk)
 	spin_unlock_bh(&serv->sv_lock);
 }
 
-void svc_close_socket(struct svc_sock *svsk)
+static void svc_close_socket(struct svc_sock *svsk)
 {
 	set_bit(SK_CLOSE, &svsk->sk_flags);
 	if (test_and_set_bit(SK_BUSY, &svsk->sk_flags))
@@ -1800,6 +1801,19 @@ void svc_close_socket(struct svc_sock *s
 	svc_sock_put(svsk);
 }
 
+void svc_force_close_socket(struct svc_sock *svsk)
+{
+	set_bit(SK_CLOSE, &svsk->sk_flags);
+	if (test_bit(SK_BUSY, &svsk->sk_flags)) {
+		/* Waiting to be processed, but no threads left,
+		 * So just remove it from the waiting list
+		 */
+		list_del_init(&svsk->sk_ready);
+		clear_bit(SK_BUSY, &svsk->sk_flags);
+	}
+	svc_close_socket(svsk);
+}
+
 /**
  * svc_makesock - Make a socket for nfsd and lockd
  * @serv: RPC server structure
