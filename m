Return-Path: <linux-kernel-owner+w=401wt.eu-S1766008AbYHDVuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766008AbYHDVuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964774AbYHDVj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:39:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:55021 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030189AbYHDVj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:39:56 -0400
Date: Mon, 4 Aug 2008 14:30:34 -0700
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
       alan@lxorguk.ukuu.org.uk, Marcel Holtmann <marcel@holtmann.org>
Subject: [patch 17/25] Bluetooth: Signal user-space for HIDP and BNEP
	socket errors
Message-ID: <20080804213034.GQ8014@suse.de>
References: <20080804203506.816201392@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="bluetooth-signal-user-space-for-hidp-and-bnep-socket-errors.patch"
In-Reply-To: <20080804212725.GA7944@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Marcel Holtmann <marcel@holtmann.org>

commit ec8dab36e0738d3059980d144e34f16a26bbda7d upstream

When using the HIDP or BNEP kernel support, the user-space needs to
know if the connection has been terminated for some reasons. Wake up
the application if that happens. Otherwise kernel and user-space are
no longer on the same page and weird behaviors can happen.

Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/bluetooth/bnep/core.c |    5 +++++
 net/bluetooth/hidp/core.c |   10 ++++++++++
 2 files changed, 15 insertions(+)

--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -507,6 +507,11 @@ static int bnep_session(void *arg)
 	/* Delete network device */
 	unregister_netdev(dev);
 
+	/* Wakeup user-space polling for socket errors */
+	s->sock->sk->sk_err = EUNATCH;
+
+	wake_up_interruptible(s->sock->sk->sk_sleep);
+
 	/* Release the socket */
 	fput(s->sock->file);
 
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -581,6 +581,12 @@ static int hidp_session(void *arg)
 		hid_free_device(session->hid);
 	}
 
+	/* Wakeup user-space polling for socket errors */
+	session->intr_sock->sk->sk_err = EUNATCH;
+	session->ctrl_sock->sk->sk_err = EUNATCH;
+
+	hidp_schedule(session);
+
 	fput(session->intr_sock->file);
 
 	wait_event_timeout(*(ctrl_sk->sk_sleep),
@@ -879,6 +885,10 @@ int hidp_del_connection(struct hidp_conn
 			skb_queue_purge(&session->ctrl_transmit);
 			skb_queue_purge(&session->intr_transmit);
 
+			/* Wakeup user-space polling for socket errors */
+			session->intr_sock->sk->sk_err = EUNATCH;
+			session->ctrl_sock->sk->sk_err = EUNATCH;
+
 			/* Kill session thread */
 			atomic_inc(&session->terminate);
 			hidp_schedule(session);

-- 
