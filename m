Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbZIZSyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbZIZSyo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 14:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbZIZSye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 14:54:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:36421 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837AbZIZSyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 14:54:25 -0400
Date: Sat, 26 Sep 2009 20:50:49 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu
Subject: [PATCH 2/9] Simplify bound checks in nvram for copy_from_user
Message-ID: <20090926205049.33703eea@infradead.org>
In-Reply-To: <20090926204951.424e567e@infradead.org>
References: <20090926204951.424e567e@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 2/9] Simplify bound checks in nvram for copy_from_user

The nvram driver's write() function has an interesting bound check.
Not only does it use the always-hard-to-read ? C operator, it also
has a magic "i" in there, which comes from the file position of
the file.

On first sight the check looks sane, however the value of "i" is not 
checked at all and I as human don't know if the C type rules guarantee
that the result is always within bounds.. and neither does gcc seem to
know.

This patch simplifies the checks and guarantees that the copy will not
overflow the destination buffer.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>


diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index 88cee40..b2a7eaf 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -267,7 +267,15 @@ static ssize_t nvram_write(struct file *file, const char __user *buf,
 	unsigned char *tmp;
 	int len;
 
-	len = (NVRAM_BYTES - i) < count ? (NVRAM_BYTES - i) : count;
+	len = count;
+	if (count > NVRAM_BYTES - i)
+		len = NVRAM_BYTES - i;
+
+	if (len > NVRAM_BYTES)
+		len = NVRAM_BYTES;
+	if (len < 0)
+		return -EINVAL;
+
 	if (copy_from_user(contents, buf, len))
 		return -EFAULT;
 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
