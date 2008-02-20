Return-Path: <linux-kernel-owner+w=401wt.eu-S1763547AbYBTNsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763547AbYBTNsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 08:48:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbYBTNr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 08:47:26 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44100 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbYBTNrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 08:47:20 -0500
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "=?utf-8?q?Ilpo=20J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: [RFC PATCH 4/8] [NET]: uninline skb_push, de-bloats a lot
Date: Wed, 20 Feb 2008 15:47:14 +0200
Message-Id: <1203515238-22848-5-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: git-send-email 1.5.4.2.156.ge3c5
In-Reply-To: <1203515238-22848-4-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1203515238-22848-1-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-2-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-3-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1203515238-22848-4-git-send-email-ilpo.jarvinen@helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-21593  356 funcs, 2418 +, 24011 -, diff: -21593 --- skb_push

Again, current_text_addr() needs to addressed.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 include/linux/skbuff.h |   18 +-----------------
 net/core/skbuff.c      |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index df3cce2..c11f248 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -905,23 +905,7 @@ static inline unsigned char *__skb_push(struct sk_buff *skb, unsigned int len)
 	return skb->data;
 }
 
-/**
- *	skb_push - add data to the start of a buffer
- *	@skb: buffer to use
- *	@len: amount of data to add
- *
- *	This function extends the used data area of the buffer at the buffer
- *	start. If this would exceed the total buffer headroom the kernel will
- *	panic. A pointer to the first byte of the extra data is returned.
- */
-static inline unsigned char *skb_push(struct sk_buff *skb, unsigned int len)
-{
-	skb->data -= len;
-	skb->len  += len;
-	if (unlikely(skb->data<skb->head))
-		skb_under_panic(skb, len, current_text_addr());
-	return skb->data;
-}
+extern unsigned char *skb_push(struct sk_buff *skb, unsigned int len);
 
 static inline unsigned char *__skb_pull(struct sk_buff *skb, unsigned int len)
 {
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 081bffb..05d43fd 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -897,6 +897,25 @@ unsigned char *skb_put(struct sk_buff *skb, unsigned int len)
 EXPORT_SYMBOL(skb_put);
 
 /**
+ *	skb_push - add data to the start of a buffer
+ *	@skb: buffer to use
+ *	@len: amount of data to add
+ *
+ *	This function extends the used data area of the buffer at the buffer
+ *	start. If this would exceed the total buffer headroom the kernel will
+ *	panic. A pointer to the first byte of the extra data is returned.
+ */
+unsigned char *skb_push(struct sk_buff *skb, unsigned int len)
+{
+	skb->data -= len;
+	skb->len  += len;
+	if (unlikely(skb->data<skb->head))
+		skb_under_panic(skb, len, current_text_addr());
+	return skb->data;
+}
+EXPORT_SYMBOL(skb_push);
+
+/**
  *	skb_pull - remove data from the start of a buffer
  *	@skb: buffer to use
  *	@len: amount of data to remove
-- 
1.5.2.2

