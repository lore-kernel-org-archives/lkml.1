Return-Path: <linux-kernel-owner+w=401wt.eu-S1763329AbYBTNsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763329AbYBTNsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 08:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755562AbYBTNrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 08:47:24 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54344 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbYBTNrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 08:47:20 -0500
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "=?utf-8?q?Ilpo=20J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: [RFC PATCH 1/8] [NET]: uninline skb_put, de-bloats a lot
Date: Wed, 20 Feb 2008 15:47:11 +0200
Message-Id: <1203515238-22848-2-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: git-send-email 1.5.4.2.156.ge3c5
In-Reply-To: <1203515238-22848-1-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1203515238-22848-1-git-send-email-ilpo.jarvinen@helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

~500 files changed
...
kernel/uninlined.c:
  skb_put                       | +104
 1 function changed, 104 bytes added, diff: +104

vmlinux.o:
 869 functions changed, 198 bytes added, 111003 bytes removed, diff: -110805

This change is INCOMPLETE, I think that the call to current_text_addr()
should be rethought but I don't have a clue how to do that.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 include/linux/skbuff.h |   20 +-------------------
 net/core/skbuff.c      |   21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 412672a..5925435 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -896,25 +896,7 @@ static inline unsigned char *__skb_put(struct sk_buff *skb, unsigned int len)
 	return tmp;
 }
 
-/**
- *	skb_put - add data to a buffer
- *	@skb: buffer to use
- *	@len: amount of data to add
- *
- *	This function extends the used data area of the buffer. If this would
- *	exceed the total buffer size the kernel will panic. A pointer to the
- *	first byte of the extra data is returned.
- */
-static inline unsigned char *skb_put(struct sk_buff *skb, unsigned int len)
-{
-	unsigned char *tmp = skb_tail_pointer(skb);
-	SKB_LINEAR_ASSERT(skb);
-	skb->tail += len;
-	skb->len  += len;
-	if (unlikely(skb->tail > skb->end))
-		skb_over_panic(skb, len, current_text_addr());
-	return tmp;
-}
+extern unsigned char *skb_put(struct sk_buff *skb, unsigned int len);
 
 static inline unsigned char *__skb_push(struct sk_buff *skb, unsigned int len)
 {
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 4e35422..661d439 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -857,6 +857,27 @@ free_skb:
 	return err;
 }
 
+/**
+ *	skb_put - add data to a buffer
+ *	@skb: buffer to use
+ *	@len: amount of data to add
+ *
+ *	This function extends the used data area of the buffer. If this would
+ *	exceed the total buffer size the kernel will panic. A pointer to the
+ *	first byte of the extra data is returned.
+ */
+unsigned char *skb_put(struct sk_buff *skb, unsigned int len)
+{
+	unsigned char *tmp = skb_tail_pointer(skb);
+	SKB_LINEAR_ASSERT(skb);
+	skb->tail += len;
+	skb->len  += len;
+	if (unlikely(skb->tail > skb->end))
+		skb_over_panic(skb, len, current_text_addr());
+	return tmp;
+}
+EXPORT_SYMBOL(skb_put);
+
 /* Trims skb to length len. It can change skb pointers.
  */
 
-- 
1.5.2.2

