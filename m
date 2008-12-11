Return-Path: <linux-kernel-owner+w=401wt.eu-S1759034AbYLKTYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbYLKTYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 14:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757534AbYLKTSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 14:18:25 -0500
Received: from kroah.org ([198.145.64.141]:55952 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757319AbYLKTSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 14:18:13 -0500
Date: Thu, 11 Dec 2008 11:14:11 -0800
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
       alan@lxorguk.ukuu.org.uk, Chas Williams <chas@cmf.nrl.navy.mil>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 19/83] ATM: CVE-2008-5079: duplicate listen() on socket
	corrupts the vcc table
Message-ID: <20081211191411.GS5894@kroah.com>
References: <20081211190201.612240183@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="atm-cve-2008-5079-duplicate-listen-on-socket-corrupts-the-vcc-table.patch"
In-Reply-To: <20081211191014.GA5759@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chas Williams <chas@cmf.nrl.navy.mil>

commit 17b24b3c97498935a2ef9777370b1151dfed3f6f upstream.

As reported by Hugo Dias that it is possible to cause a local denial
of service attack by calling the svc_listen function twice on the same
socket and reading /proc/net/atm/*vc

Signed-off-by: Chas Williams <chas@cmf.nrl.navy.mil>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/atm/svc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/atm/svc.c
+++ b/net/atm/svc.c
@@ -293,7 +293,10 @@ static int svc_listen(struct socket *soc
 		error = -EINVAL;
 		goto out;
 	}
-	vcc_insert_socket(sk);
+	if (test_bit(ATM_VF_LISTEN, &vcc->flags)) {
+		error = -EADDRINUSE;
+		goto out;
+        }
 	set_bit(ATM_VF_WAITING, &vcc->flags);
 	prepare_to_wait(sk->sk_sleep, &wait, TASK_UNINTERRUPTIBLE);
 	sigd_enq(vcc,as_listen,NULL,NULL,&vcc->local);
@@ -307,6 +310,7 @@ static int svc_listen(struct socket *soc
 		goto out;
 	}
 	set_bit(ATM_VF_LISTEN,&vcc->flags);
+	vcc_insert_socket(sk);
 	sk->sk_max_ack_backlog = backlog > 0 ? backlog : ATM_BACKLOG_DEFAULT;
 	error = -sk->sk_err;
 out:

