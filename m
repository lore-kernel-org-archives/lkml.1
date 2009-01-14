Return-Path: <linux-kernel-owner+w=401wt.eu-S1761544AbZANJsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761544AbZANJsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 04:48:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757217AbZANJrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 04:47:53 -0500
Received: from pan.madism.org ([88.191.52.104]:45979 "EHLO hermes.madism.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755690AbZANJrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 04:47:52 -0500
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jan 2009 04:47:52 EST
From: Pierre Habouzit <pierre.habouzit@intersec.com>
To: Wei Yongjun <yjwei@cn.fujitsu.com>,
       Vlad Yasevich <vladislav.yasevich@hp.com>,
       " David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org,
       Pierre Habouzit <pierre.habouzit@intersec.com>
Subject: [PATCH] sctp: if backlog is 0, listening shall not be deactivated.
Date: Wed, 14 Jan 2009 10:42:03 +0100
Message-Id: <1231926123-26196-1-git-send-email-pierre.habouzit@intersec.com>
X-Mailer: git-send-email 1.6.1.161.g5e07b.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

POSIX hints that when 0 is used for the listen backlog argument, the
kernel shall chose a default automatic value. TCP for example, works this
way.

Signed-off-by: Pierre Habouzit <pierre.habouzit@intersec.com>
---

 net/sctp/socket.c |   20 --------------------
 1 files changed, 0 insertions(+), 20 deletions(-)

    To put a bit of background, I stumbled against this while doing a code
    that basically did:

	struct sctp_event_subscribe events;
	/* ... */

	fd = socket(AF_INET, SOCK_SEQPACKETS, IPPROTO_SCTP);
	sctp_bindx(fd, ....);
	events = (struct sctp_event_subscribe){
	    .sctp_data_io_event     = 1,
	    .sctp_association_event = 1,
	};
	setsockopt(fd, SOL_SCTP, SCTP_EVENTS, &events, sizeof(events));
	listen(fd, 0);
	len = sctp_recvmsg(fd, .....);

    The latter call instead of blocking like I expected returned with
    errno == ENOTCONN.

    I know POSIX doesn't _require_ listen() to accept 0 as a valid backlog,
    but the other listen() implementation I have used in the kernel do, and
    it looks really surprising for the programmer (who really searches the
    error elsewhere).

    Fortunately I had another working code at hand and I managed to find the
    problem resorting to reverting the changes I made to the original code
    line per line (*sigh*).

    I'm unsure if the diff shouldn't do instead:

    if (!backlog)
        backlog = 1;

    I'm not really comfortable around the kernel core ;)


diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index ff0a8f8..da1d96a 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5866,16 +5866,6 @@ SCTP_STATIC int sctp_seqpacket_listen(struct sock *sk, int backlog)
 	if (!sctp_style(sk, UDP))
 		return -EINVAL;
 
-	/* If backlog is zero, disable listening. */
-	if (!backlog) {
-		if (sctp_sstate(sk, CLOSED))
-			return 0;
-
-		sctp_unhash_endpoint(ep);
-		sk->sk_state = SCTP_SS_CLOSED;
-		return 0;
-	}
-
 	/* Return if we are already listening. */
 	if (sctp_sstate(sk, LISTENING))
 		return 0;
@@ -5919,16 +5909,6 @@ SCTP_STATIC int sctp_stream_listen(struct sock *sk, int backlog)
 	struct sctp_sock *sp = sctp_sk(sk);
 	struct sctp_endpoint *ep = sp->ep;
 
-	/* If backlog is zero, disable listening. */
-	if (!backlog) {
-		if (sctp_sstate(sk, CLOSED))
-			return 0;
-
-		sctp_unhash_endpoint(ep);
-		sk->sk_state = SCTP_SS_CLOSED;
-		return 0;
-	}
-
 	if (sctp_sstate(sk, LISTENING))
 		return 0;
 
-- 
1.6.1.161.g5e07b.dirty

