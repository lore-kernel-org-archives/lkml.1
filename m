Return-Path: <linux-kernel-owner+w=401wt.eu-S1759743AbZFIKPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743AbZFIKPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759351AbZFIKP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:15:28 -0400
Received: from kroah.org ([198.145.64.141]:59649 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758871AbZFIKP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:15:27 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:52 2009
Message-Id: <20090609094052.533568011@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:38:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 02/87] tcp: fix MSG_PEEK race check
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=tcp-fix-msg_peek-race-check.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>

[ Upstream commit 775273131810caa41dfc7f9e552ea5d8508caf40 ]

Commit 518a09ef11 (tcp: Fix recvmsg MSG_PEEK influence of
blocking behavior) lets the loop run longer than the race check
did previously expect, so we need to be more careful with this
check and consider the work we have been doing.

I tried my best to deal with urg hole madness too which happens
here:
	if (!sock_flag(sk, SOCK_URGINLINE)) {
		++*seq;
		...
by using additional offset by one but I certainly have very
little interest in testing that part.

Signed-off-by: Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>
Tested-by: Frans Pop <elendil@planet.nl>
Tested-by: Ian Zimmermann <itz@buug.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/tcp.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1286,6 +1286,7 @@ int tcp_recvmsg(struct kiocb *iocb, stru
 	struct task_struct *user_recv = NULL;
 	int copied_early = 0;
 	struct sk_buff *skb;
+	u32 urg_hole = 0;
 
 	lock_sock(sk);
 
@@ -1497,7 +1498,8 @@ do_prequeue:
 				}
 			}
 		}
-		if ((flags & MSG_PEEK) && peek_seq != tp->copied_seq) {
+		if ((flags & MSG_PEEK) &&
+		    (peek_seq - copied - urg_hole != tp->copied_seq)) {
 			if (net_ratelimit())
 				printk(KERN_DEBUG "TCP(%s:%d): Application bug, race in MSG_PEEK.\n",
 				       current->comm, task_pid_nr(current));
@@ -1518,6 +1520,7 @@ do_prequeue:
 				if (!urg_offset) {
 					if (!sock_flag(sk, SOCK_URGINLINE)) {
 						++*seq;
+						urg_hole++;
 						offset++;
 						used--;
 						if (!used)


