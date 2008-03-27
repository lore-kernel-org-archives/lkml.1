Return-Path: <linux-kernel-owner+w=401wt.eu-S1760758AbYC0Mjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758AbYC0Mjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757758AbYC0MiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:38:20 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42424 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759598AbYC0MiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:38:10 -0400
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       "=?utf-8?q?Ilpo=20J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: [PATCH 4/7] [NET]: uninline skb_push, de-bloats a lot
Date: Thu, 27 Mar 2008 14:38:03 +0200
Message-Id: <1206621486-5408-5-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: git-send-email 1.5.4.2.156.ge3c5
In-Reply-To: <1206621486-5408-4-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1206621486-5408-1-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1206621486-5408-2-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1206621486-5408-3-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1206621486-5408-4-git-send-email-ilpo.jarvinen@helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allyesconfig (v2.6.24-mm1):

-21593  356 funcs, 2418 +, 24011 -, diff: -21593 --- skb_push

Without many debug related CONFIGs (v2.6.25-rc2-mm1):

-13890  341 funcs, 189 +, 14079 -, diff: -13890 --- skb_push
skb_push                      |  +46

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 include/linux/skbuff.h |   19 +------------------
 net/core/skbuff.c      |   19 +++++++++++++++++++
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 01a11b0..1baf4d4 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -902,6 +902,7 @@ static inline unsigned char *__skb_put(struct sk_buff *skb, unsigned int len)
 	return tmp;
 }
 
+extern unsigned char *skb_push(struct sk_buff *skb, unsigned int len);
 static inline unsigned char *__skb_push(struct sk_buff *skb, unsigned int len)
 {
 	skb->data -= len;
@@ -909,24 +910,6 @@ static inline unsigned char *__skb_push(struct sk_buff *skb, unsigned int len)
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
-
 extern unsigned char *skb_pull(struct sk_buff *skb, unsigned int len);
 static inline unsigned char *__skb_pull(struct sk_buff *skb, unsigned int len)
 {
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 0daf5c0..a37127b 100644
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
+		skb_under_panic(skb, len, __builtin_return_address(0));
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

