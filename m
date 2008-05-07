Return-Path: <linux-kernel-owner+w=401wt.eu-S1750834AbYEGVa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750834AbYEGVa4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYEGVao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:30:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:51388 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbYEGVam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:30:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=JEZ5S2nQXC3CjcPw4iq8vQF/eDxm1VQov+XWNQujUKz1xtQxjPY5DdtBZszAHgpkIl4GhXhUVmrpssGcJNwAqpt8LhiT/oAVpSp7xV0vmSSHLHODssOaF006wDkyySWlUaKQp6MvJzyoH8bPwASeigDqJnnh0LjSFP9MDoDZt9Y=
Date: Thu, 8 May 2008 02:26:01 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, travis@sgi.com
Subject: [PATCH 2/5] Fix bitmap_scnprintf_len()
Message-ID: <20080507222601.GB14375@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bitmap_scnprintf_len() returns 36 (thirty six) for NR_CPUS=2 which is
ridiculous. So, rewrite the whole thing. Fixed version allows correct
seq_bitmap/seq_cpumask.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/bitmap.h |    2 +-
 lib/bitmap.c           |   12 ++++--------
 2 files changed, 5 insertions(+), 9 deletions(-)

--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -110,7 +110,7 @@ extern int __bitmap_weight(const unsigned long *bitmap, int bits);
 
 extern int bitmap_scnprintf(char *buf, unsigned int len,
 			const unsigned long *src, int nbits);
-extern int bitmap_scnprintf_len(unsigned int len);
+extern int bitmap_scnprintf_len(unsigned int nr_bits);
 extern int __bitmap_parse(const char *buf, unsigned int buflen, int is_user,
 			unsigned long *dst, int nbits);
 extern int bitmap_parse_user(const char __user *ubuf, unsigned int ulen,
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -318,16 +318,12 @@ EXPORT_SYMBOL(bitmap_scnprintf);
 /**
  * bitmap_scnprintf_len - return buffer length needed to convert
  * bitmap to an ASCII hex string.
- * @len: number of bits to be converted
+ * @nr_bits: number of bits to be converted
  */
-int bitmap_scnprintf_len(unsigned int len)
+int bitmap_scnprintf_len(unsigned int nr_bits)
 {
-	/* we need 9 chars per word for 32 bit words (8 hexdigits + sep/null) */
-	int bitslen = ALIGN(len, CHUNKSZ);
-	int wordlen = CHUNKSZ / 4;
-	int buflen = (bitslen / wordlen) * (wordlen + 1) * sizeof(char);
-
-	return buflen;
+	unsigned int nr_nibbles = ALIGN(nr_bits, 4) / 4;
+	return nr_nibbles + ALIGN(nr_nibbles, CHUNKSZ / 4) / (CHUNKSZ / 4) - 1;
 }
 EXPORT_SYMBOL(bitmap_scnprintf_len);
 

