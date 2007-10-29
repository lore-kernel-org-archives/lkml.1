Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbXJ2UQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbXJ2UQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbXJ2UQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:16:33 -0400
Received: from brick.kernel.dk ([87.55.233.238]:13450 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbXJ2UQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:16:32 -0400
Date: Mon, 29 Oct 2007 21:16:27 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] [CRYPTO] tcrypt: Move sg_init_table out of timing loops
Message-ID: <20071029201627.GD7499@kernel.dk>
References: <20071026145905.GA13850@gondor.apana.org.au> <E1IlQfM-0003cO-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IlQfM-0003cO-00@gondolin.me.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26 2007, Herbert Xu wrote:
> [CRYPTO] tcrypt: Move sg_init_table out of timing loops
> 
> This patch moves the sg_init_table out of the timing loops for hash
> algorithms so that it doesn't impact on the speed test results.

Wouldn't it be better to just make sg_init_one() call sg_init_table?

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 4571231..ccc55a6 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -202,28 +202,6 @@ static inline void __sg_mark_end(struct scatterlist *sg)
 }
 
 /**
- * sg_init_one - Initialize a single entry sg list
- * @sg:		 SG entry
- * @buf:	 Virtual address for IO
- * @buflen:	 IO length
- *
- * Notes:
- *   This should not be used on a single entry that is part of a larger
- *   table. Use sg_init_table() for that.
- *
- **/
-static inline void sg_init_one(struct scatterlist *sg, const void *buf,
-			       unsigned int buflen)
-{
-	memset(sg, 0, sizeof(*sg));
-#ifdef CONFIG_DEBUG_SG
-	sg->sg_magic = SG_MAGIC;
-#endif
-	sg_mark_end(sg, 1);
-	sg_set_buf(sg, buf, buflen);
-}
-
-/**
  * sg_init_table - Initialize SG table
  * @sgl:	   The SG table
  * @nents:	   Number of entries in table
@@ -247,6 +225,24 @@ static inline void sg_init_table(struct scatterlist *sgl, unsigned int nents)
 }
 
 /**
+ * sg_init_one - Initialize a single entry sg list
+ * @sg:		 SG entry
+ * @buf:	 Virtual address for IO
+ * @buflen:	 IO length
+ *
+ * Notes:
+ *   This should not be used on a single entry that is part of a larger
+ *   table. Use sg_init_table() for that.
+ *
+ **/
+static inline void sg_init_one(struct scatterlist *sg, const void *buf,
+			       unsigned int buflen)
+{
+	sg_init_table(sg, 1);
+	sg_set_buf(sg, buf, buflen);
+}
+
+/**
  * sg_phys - Return physical address of an sg entry
  * @sg:	     SG entry
  *

-- 
Jens Axboe

