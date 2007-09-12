Return-Path: <linux-kernel-owner+w=401wt.eu-S933648AbXILJAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933648AbXILJAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 05:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbXILJA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 05:00:28 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:53379 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757175AbXILJA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 05:00:27 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix hci_sock build with CONFIG_COMPAT=n
Date: Wed, 12 Sep 2007 11:59:48 +0300
User-Agent: KMail/1.9.7
Cc: davem@davemloft.net, Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200709121159.49183.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

Commit 66eb50d5c972cc16df2be730497b7f06d75d8132 introduces runtime check of CONFIG_COMPAT but without following patch compiliation failed with following error;

...
  CC [M]  net/bluetooth/hci_event.o
  CC [M]  net/bluetooth/hci_sock.o
net/bluetooth/hci_sock.c: In function `hci_sock_cmsg':
net/bluetooth/hci_sock.c:352: error: storage size of 'ctv' isn't known
net/bluetooth/hci_sock.c:352: warning: unused variable `ctv'
make[2]: *** [net/bluetooth/hci_sock.o] Hata 1
make[1]: *** [net/bluetooth] Hata 2
make: *** [net] Hata 2

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>

 net/bluetooth/hci_sock.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index d16ca8e..1364a90 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -347,7 +347,7 @@ static inline void hci_sock_cmsg(struct sock *sk, struct msghdr *msg, struct sk_
 		int len;
 
 		skb_get_timestamp(skb, &tv);
-
+#ifdef CONFIG_COMPAT
 		if (msg->msg_flags & MSG_CMSG_COMPAT) {
 			struct compat_timeval ctv;
 			ctv.tv_sec = tv.tv_sec;
@@ -355,9 +355,12 @@ static inline void hci_sock_cmsg(struct sock *sk, struct msghdr *msg, struct sk_
 			data = &ctv;
 			len = sizeof(ctv);
 		} else {
+#endif
 			data = &tv;
 			len = sizeof(tv);
+#ifdef CONFIG_COMPAT
 		}
+#endif
 
 		put_cmsg(msg, SOL_HCI, HCI_CMSG_TSTAMP, len, data);
 	}


Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
