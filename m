Return-Path: <linux-kernel-owner+w=401wt.eu-S967646AbXILMMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967646AbXILMMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 08:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764401AbXILMMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 08:12:25 -0400
Received: from 74-93-104-98-Washington.hfc.comcastbusiness.net ([74.93.104.98]:42049
	"EHLO picasso.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1764385AbXILMMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 08:12:24 -0400
Date: Wed, 12 Sep 2007 05:12:12 -0700 (PDT)
Message-Id: <20070912.051212.112608750.davem@davemloft.net>
To: greg@kroah.com
Cc: andre@finow14.de, torvalds@osdl.org, marcel@holtmann.org,
       linux-kernel@vger.kernel.org
Subject: Re: hci_sock.c build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070912120253.GA13003@kroah.com>
References: <20070912092929.GA2878@ahaupt-debian-vm.localdomain>
	<20070912120253.GA13003@kroah.com>
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <greg@kroah.com>
Date: Wed, 12 Sep 2007 05:02:53 -0700

> It's not even a randconfig issue, my build dies too (this is Linus's
> current tree.)
> 
> Time to poke through the 10 bluetooth patches that were just added...

I'll push the following fix to Linus.

>From 1da97f83a843f92678b614fcaebdb3e4ebd6c9dd Mon Sep 17 00:00:00 2001
From: David S. Miller <davem@kimchee.(none)>
Date: Wed, 12 Sep 2007 14:10:58 +0200
Subject: [PATCH] [BLUETOOTH]: Fix non-COMPAT build of hci_sock.c

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/bluetooth/hci_sock.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index d16ca8e..5ccea5f 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -348,16 +348,17 @@ static inline void hci_sock_cmsg(struct sock *sk, struct msghdr *msg, struct sk_
 
 		skb_get_timestamp(skb, &tv);
 
+		data = &tv;
+		len = sizeof(tv);
+#ifdef CONFIG_COMPAT
 		if (msg->msg_flags & MSG_CMSG_COMPAT) {
 			struct compat_timeval ctv;
 			ctv.tv_sec = tv.tv_sec;
 			ctv.tv_usec = tv.tv_usec;
 			data = &ctv;
 			len = sizeof(ctv);
-		} else {
-			data = &tv;
-			len = sizeof(tv);
 		}
+#endif
 
 		put_cmsg(msg, SOL_HCI, HCI_CMSG_TSTAMP, len, data);
 	}
-- 
1.5.2.4

