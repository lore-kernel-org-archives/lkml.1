Return-Path: <linux-kernel-owner+w=401wt.eu-S1030264AbXBGALD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030264AbXBGALD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 19:11:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030272AbXBGALD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 19:11:03 -0500
Received: from cantor.suse.de ([195.135.220.2]:58763 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030264AbXBGALA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 19:11:00 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@osdl.org>
Date: Wed, 7 Feb 2007 11:10:26 +1100
Message-Id: <1070207001026.9413@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: stable@kernel.org
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] knfsd: Fix a race in closing NFSd connections.
References: <20070207110636.9166.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is a bug introduced in 2.6.19 that can cause badness in the NFS
server, particularly if you get clients closing connections while the server
is trying to write a reply.

This patch fixed the bug and improves the handling of socket closing.

The patch was made against -mm, and applies correctly with a little bit of
fuzz to 2.6.19 and 2.6.20.  It should be considered at least for 2.6.20.1.

Thanks,
NeilBrown


### Comments for Changeset

If you lose this race, it can iput a socket inode twice and you
get a BUG in fs/inode.c

When I added the option for user-space to close a socket,
I added some cruft to svc_delete_socket so that I could call
that function when closing a socket per user-space request.

This was the wrong thing to do.  I should have just set SK_CLOSE
and let normal mechanisms do the work.

Not only wrong, but buggy.  The locking is all wrong and it openned
up a race where-by a socket could be closed twice.

So this patch:
  Introduces svc_close_socket which sets SK_CLOSE then either leave
  the close up to a thread, or calls svc_delete_socket if it can
  get SK_BUSY.

  Adds a bias to sk_busy which is removed when SK_DEAD is set,
  This avoid races around shutting down the socket.

  Changes several 'spin_lock' to 'spin_lock_bh' where the _bh 
  was missing.

Bugzilla-url: http://bugzilla.kernel.org/show_bug.cgi?id=7916

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./include/linux/sunrpc/svcsock.h |    2 -
 ./net/sunrpc/svc.c               |    4 +--
 ./net/sunrpc/svcsock.c           |   52 ++++++++++++++++++++++++++++-----------
 3 files changed, 41 insertions(+), 17 deletions(-)

diff .prev/include/linux/sunrpc/svcsock.h ./include/linux/sunrpc/svcsock.h
--- .prev/include/linux/sunrpc/svcsock.h	2007-02-07 10:27:52.000000000 +1100
+++ ./include/linux/sunrpc/svcsock.h	2007-02-06 13:22:05.000000000 +1100
@@ -66,7 +66,7 @@ struct svc_sock {
  * Function prototypes.
  */
 int		svc_makesock(struct svc_serv *, int, unsigned short, int flags);
-void		svc_delete_socket(struct svc_sock *);
+void		svc_close_socket(struct svc_sock *);
 int		svc_recv(struct svc_rqst *, long);
 int		svc_send(struct svc_rqst *);
 void		svc_drop(struct svc_rqst *);

diff .prev/net/sunrpc/svc.c ./net/sunrpc/svc.c
--- .prev/net/sunrpc/svc.c	2007-02-07 10:27:52.000000000 +1100
+++ ./net/sunrpc/svc.c	2007-02-06 14:51:40.000000000 +1100
@@ -386,7 +386,7 @@ svc_destroy(struct svc_serv *serv)
 		svsk = list_entry(serv->sv_tempsocks.next,
 				  struct svc_sock,
 				  sk_list);
-		svc_delete_socket(svsk);
+		svc_close_socket(svsk);
 	}
 	if (serv->sv_shutdown)
 		serv->sv_shutdown(serv);
@@ -395,7 +395,7 @@ svc_destroy(struct svc_serv *serv)
 		svsk = list_entry(serv->sv_permsocks.next,
 				  struct svc_sock,
 				  sk_list);
-		svc_delete_socket(svsk);
+		svc_close_socket(svsk);
 	}
 	
 	cache_clean_deferred(serv);

diff .prev/net/sunrpc/svcsock.c ./net/sunrpc/svcsock.c
--- .prev/net/sunrpc/svcsock.c	2007-02-07 10:27:52.000000000 +1100
+++ ./net/sunrpc/svcsock.c	2007-02-07 10:57:23.000000000 +1100
@@ -64,6 +64,12 @@
  *		after a clear, the socket must be read/accepted
  *		 if this succeeds, it must be set again.
  *	SK_CLOSE can set at any time. It is never cleared.
+ *      sk_inuse contains a bias of '1' until SK_DEAD is set.
+ *             so when sk_inuse hits zero, we know the socket is dead
+ *             and no-one is using it.
+ *      SK_DEAD can only be set while SK_BUSY is held which ensures
+ *             no other thread will be using the socket or will try to
+ *	       set SK_DEAD.
  *
  */
 
@@ -72,6 +78,7 @@
 
 static struct svc_sock *svc_setup_socket(struct svc_serv *, struct socket *,
 					 int *, int);
+static void		svc_delete_socket(struct svc_sock *svsk);
 static void		svc_udp_data_ready(struct sock *, int);
 static int		svc_udp_recvfrom(struct svc_rqst *);
 static int		svc_udp_sendto(struct svc_rqst *);
@@ -366,8 +373,9 @@ void svc_reserve(struct svc_rqst *rqstp,
 static inline void
 svc_sock_put(struct svc_sock *svsk)
 {
-	if (atomic_dec_and_test(&svsk->sk_inuse) &&
-			test_bit(SK_DEAD, &svsk->sk_flags)) {
+	if (atomic_dec_and_test(&svsk->sk_inuse)) {
+		BUG_ON(! test_bit(SK_DEAD, &svsk->sk_flags));
+
 		dprintk("svc: releasing dead socket\n");
 		if (svsk->sk_sock->file)
 			sockfd_put(svsk->sk_sock);
@@ -590,7 +598,7 @@ svc_sock_names(char *buf, struct svc_ser
 
 	if (!serv)
 		return 0;
-	spin_lock(&serv->sv_lock);
+	spin_lock_bh(&serv->sv_lock);
 	list_for_each_entry(svsk, &serv->sv_permsocks, sk_list) {
 		int onelen = one_sock_name(buf+len, svsk);
 		if (toclose && strcmp(toclose, buf+len) == 0)
@@ -598,12 +606,12 @@ svc_sock_names(char *buf, struct svc_ser
 		else
 			len += onelen;
 	}
-	spin_unlock(&serv->sv_lock);
+	spin_unlock_bh(&serv->sv_lock);
 	if (closesk)
 		/* Should unregister with portmap, but you cannot
 		 * unregister just one protocol...
 		 */
-		svc_delete_socket(closesk);
+		svc_close_socket(closesk);
 	else if (toclose)
 		return -ENOENT;
 	return len;
@@ -787,6 +795,11 @@ svc_udp_recvfrom(struct svc_rqst *rqstp)
 		return svc_deferred_recv(rqstp);
 	}
 
+	if (test_bit(SK_CLOSE, &svsk->sk_flags)) {
+		svc_delete_socket(svsk);
+		return 0;
+	}
+
 	clear_bit(SK_DATA, &svsk->sk_flags);
 	while ((skb = skb_recv_datagram(svsk->sk_sk, 0, 1, &err)) == NULL) {
 		if (err == -EAGAIN) {
@@ -1294,7 +1307,8 @@ svc_tcp_sendto(struct svc_rqst *rqstp)
 		       rqstp->rq_sock->sk_server->sv_name,
 		       (sent<0)?"got error":"sent only",
 		       sent, xbufp->len);
-		svc_delete_socket(rqstp->rq_sock);
+		set_bit(SK_CLOSE, &rqstp->rq_sock->sk_flags);
+		svc_sock_enqueue(rqstp->rq_sock);
 		sent = -EAGAIN;
 	}
 	return sent;
@@ -1615,7 +1629,7 @@ static struct svc_sock *svc_setup_socket
 	svsk->sk_odata = inet->sk_data_ready;
 	svsk->sk_owspace = inet->sk_write_space;
 	svsk->sk_server = serv;
-	atomic_set(&svsk->sk_inuse, 0);
+	atomic_set(&svsk->sk_inuse, 1);
 	svsk->sk_lastrecv = get_seconds();
 	spin_lock_init(&svsk->sk_defer_lock);
 	INIT_LIST_HEAD(&svsk->sk_deferred);
@@ -1740,7 +1754,7 @@ bummer:
 /*
  * Remove a dead socket
  */
-void
+static void
 svc_delete_socket(struct svc_sock *svsk)
 {
 	struct svc_serv	*serv;
@@ -1766,16 +1780,26 @@ svc_delete_socket(struct svc_sock *svsk)
 	 * while still attached to a queue, the queue itself
 	 * is about to be destroyed (in svc_destroy).
 	 */
-	if (!test_and_set_bit(SK_DEAD, &svsk->sk_flags))
+	if (!test_and_set_bit(SK_DEAD, &svsk->sk_flags)) {
+		BUG_ON(atomic_read(&svsk->sk_inuse)<2);
+		atomic_dec(&svsk->sk_inuse);
 		if (test_bit(SK_TEMP, &svsk->sk_flags))
 			serv->sv_tmpcnt--;
+	}
 
-	/* This atomic_inc should be needed - svc_delete_socket
-	 * should have the semantic of dropping a reference.
-	 * But it doesn't yet....
-	 */
-	atomic_inc(&svsk->sk_inuse);
 	spin_unlock_bh(&serv->sv_lock);
+}
+
+void svc_close_socket(struct svc_sock *svsk)
+{
+	set_bit(SK_CLOSE, &svsk->sk_flags);
+	if (test_and_set_bit(SK_BUSY, &svsk->sk_flags))
+		/* someone else will have to effect the close */
+		return;
+
+	atomic_inc(&svsk->sk_inuse);
+	svc_delete_socket(svsk);
+	clear_bit(SK_BUSY, &svsk->sk_flags);
 	svc_sock_put(svsk);
 }
 
