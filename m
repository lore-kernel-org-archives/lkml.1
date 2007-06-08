Return-Path: <linux-kernel-owner+w=401wt.eu-S968188AbXFHIAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968188AbXFHIAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938510AbXFHH0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:26:12 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55405 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938502AbXFHH0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:26:10 -0400
Message-Id: <20070608072241.418537000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:22:21 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>, bunk@stusta.de,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Marcel Holtmann <marcel@holtmann.org>, Jiri Kosina <jkosina@suse.cz>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 54/54] BLUETOOTH: Fix locking in hci_sock_dev_event().
Content-Disposition: inline; filename=bluetooth-fix-locking-in-hci_sock_dev_event.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

We presently use lock_sock() to acquire a lock on a socket in
hci_sock_dev_event(), but this goes BUG because lock_sock()
can sleep and we're already holding a read-write spinlock at
that point. So, we must use the non-sleeping BH version,
bh_lock_sock().

However, hci_sock_dev_event() is called from user context and
hence using simply bh_lock_sock() will deadlock against a
concurrent softirq that tries to acquire a lock on the same
socket. Hence, disabling BH's before acquiring the socket lock
and enable them afterwards, is the proper solution to fix
socket locking in hci_sock_dev_event().

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/bluetooth/hci_sock.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- linux-2.6.21.4.orig/net/bluetooth/hci_sock.c
+++ linux-2.6.21.4/net/bluetooth/hci_sock.c
@@ -656,7 +656,8 @@ static int hci_sock_dev_event(struct not
 		/* Detach sockets from device */
 		read_lock(&hci_sk_list.lock);
 		sk_for_each(sk, node, &hci_sk_list.head) {
-			lock_sock(sk);
+			local_bh_disable();
+			bh_lock_sock_nested(sk);
 			if (hci_pi(sk)->hdev == hdev) {
 				hci_pi(sk)->hdev = NULL;
 				sk->sk_err = EPIPE;
@@ -665,7 +666,8 @@ static int hci_sock_dev_event(struct not
 
 				hci_dev_put(hdev);
 			}
-			release_sock(sk);
+			bh_unlock_sock(sk);
+			local_bh_enable();
 		}
 		read_unlock(&hci_sk_list.lock);
 	}

-- 
