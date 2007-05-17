Return-Path: <linux-kernel-owner+w=401wt.eu-S1762564AbXEQFoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762564AbXEQFoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 01:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037AbXEQFoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 01:44:10 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:38339 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531AbXEQFoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 01:44:09 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Thu, 17 May 2007 11:13:36 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: akpm@linux-foundation.org
cc: David Miller <davem@davemloft.net>, Marcel Holtmann <marcel@holtmann.org>,
       Jiri Kosina <jikos@jikos.cz>, Greg KH <gregkh@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, maxk@qualcomm.com,
       Cedric Le Goater <clg@fr.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] bluetooth: fix locking in hci_sock_dev_event()
Message-ID: <Pine.LNX.4.64.0705171106550.9262@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] bluetooth: fix locking in hci_sock_dev_event()

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

Cc: David Miller <davem@davemloft.net>
Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

---

  net/bluetooth/hci_sock.c |    6 ++++--
  1 file changed, 4 insertions(+), 2 deletions(-)

---

diff -ruNp a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
--- a/net/bluetooth/hci_sock.c	2007-05-16 17:31:06.000000000 +0530
+++ b/net/bluetooth/hci_sock.c	2007-05-16 17:38:35.000000000 +0530
@@ -665,7 +665,8 @@ static int hci_sock_dev_event(struct not
  		/* Detach sockets from device */
  		read_lock(&hci_sk_list.lock);
  		sk_for_each(sk, node, &hci_sk_list.head) {
-			lock_sock(sk);
+			local_bh_disable();
+			bh_lock_sock_nested(sk);
  			if (hci_pi(sk)->hdev == hdev) {
  				hci_pi(sk)->hdev = NULL;
  				sk->sk_err = EPIPE;
@@ -674,7 +675,8 @@ static int hci_sock_dev_event(struct not

  				hci_dev_put(hdev);
  			}
-			release_sock(sk);
+			bh_unlock_sock(sk);
+			local_bh_enable();
  		}
  		read_unlock(&hci_sk_list.lock);
  	}

