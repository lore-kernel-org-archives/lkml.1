Return-Path: <linux-kernel-owner+w=401wt.eu-S1422797AbXCGRw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422797AbXCGRw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422779AbXCGRwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:52:49 -0500
Received: from ns.suse.de ([195.135.220.2]:43687 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422788AbXCGROk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:14:40 -0500
Message-Id: <20070307171302.887950128@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Neil Brown <neilb@suse.de>
Subject: [patch 032/101] Fix recently introduced problem with shutting down a busy NFS server.
Content-Disposition: inline; filename=fix-recently-introduced-problem-with-shutting-down-a-busy-nfs-server.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: NeilBrown <neilb@suse.de>


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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 include/linux/sunrpc/svcsock.h |    2 +-
 net/sunrpc/svc.c               |   23 ++++++++++-------------
 net/sunrpc/svcsock.c           |   16 +++++++++++++++-
 3 files changed, 26 insertions(+), 15 deletions(-)

--- linux-2.6.20.1.orig/include/linux/sunrpc/svcsock.h
+++ linux-2.6.20.1/include/linux/sunrpc/svcsock.h
@@ -63,7 +63,7 @@ struct svc_sock {
  * Function prototypes.
  */
 int		svc_makesock(struct svc_serv *, int, unsigned short);
-void		svc_close_socket(struct svc_sock *);
+void		svc_force_close_socket(struct svc_sock *);
 int		svc_recv(struct svc_rqst *, long);
 int		svc_send(struct svc_rqst *);
 void		svc_drop(struct svc_rqst *);
--- linux-2.6.20.1.orig/net/sunrpc/svc.c
+++ linux-2.6.20.1/net/sunrpc/svc.c
@@ -371,6 +371,7 @@ void
 svc_destroy(struct svc_serv *serv)
 {
 	struct svc_sock	*svsk;
+	struct svc_sock *tmp;
 
 	dprintk("RPC: svc_destroy(%s, %d)\n",
 				serv->sv_program->pg_name,
@@ -386,22 +387,18 @@ svc_destroy(struct svc_serv *serv)
 
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
-	
+	list_for_each_entry_safe(svsk, tmp, &serv->sv_permsocks, sk_list)
+		svc_force_close_socket(svsk);
+
+	BUG_ON(!list_empty(&serv->sv_permsocks));
+	BUG_ON(!list_empty(&serv->sv_tempsocks));
+
 	cache_clean_deferred(serv);
 
 	/* Unregister service with the portmapper */
--- linux-2.6.20.1.orig/net/sunrpc/svcsock.c
+++ linux-2.6.20.1/net/sunrpc/svcsock.c
@@ -80,6 +80,7 @@ static void		svc_delete_socket(struct sv
 static void		svc_udp_data_ready(struct sock *, int);
 static int		svc_udp_recvfrom(struct svc_rqst *);
 static int		svc_udp_sendto(struct svc_rqst *);
+static void		svc_close_socket(struct svc_sock *svsk);
 
 static struct svc_deferred_req *svc_deferred_dequeue(struct svc_sock *svsk);
 static int svc_deferred_recv(struct svc_rqst *rqstp);
@@ -1668,7 +1669,7 @@ svc_delete_socket(struct svc_sock *svsk)
 	spin_unlock_bh(&serv->sv_lock);
 }
 
-void svc_close_socket(struct svc_sock *svsk)
+static void svc_close_socket(struct svc_sock *svsk)
 {
 	set_bit(SK_CLOSE, &svsk->sk_flags);
 	if (test_and_set_bit(SK_BUSY, &svsk->sk_flags))
@@ -1681,6 +1682,19 @@ void svc_close_socket(struct svc_sock *s
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
 /*
  * Make a socket for nfsd and lockd
  */

--
