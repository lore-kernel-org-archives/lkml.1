Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbXF3Xiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbXF3Xiz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 19:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbXF3Xis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 19:38:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:9141 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbXF3Xir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 19:38:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=HqKvG4Q5Qs31pXvl/WU5AH0Wm6/kQLi1zYmikHTyOyjuJcHu2HgubR3t2SCyg1Jhb9vmWvE2yAtxUpD24fIFwsrrp6ZFZgmG+Ucgb1sTugWTBSKOp7YMIpsaRgDyIJJPaTMH94a3Kbu3M6FmXwTdwOfWc6BJRvxorUMIvZRWmgM=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][isapnp] Fix a potential NULL pointer dereference in isapnp_read_tag()
Date: Sun, 1 Jul 2007 01:38:31 +0200
User-Agent: KMail/1.9.7
Cc: Jaroslav Kysela <perex@suse.cz>, Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707010138.32075.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted (as bug #809) that we dereference 'type' 
long before we actually test it against NULL in 
drivers/pnp/isapnp/core.c::isapnp_read_tag() - both branches of the 
'if (tag & 0x80)' dereference type, and since this 'if' is before the test 
against NULL and the return of -1, this will blow up is ever type is NULL.
This is easy to fix by simply moving the NULL test to the beginning of 
the function.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/pnp/isapnp/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
diff --git a/drivers/pnp/isapnp/core.c b/drivers/pnp/isapnp/core.c
index a0b1587..5696924 100644
--- a/drivers/pnp/isapnp/core.c
+++ b/drivers/pnp/isapnp/core.c
@@ -356,6 +356,8 @@ static int __init isapnp_read_tag(unsigned char *type, unsigned short *size)
 {
 	unsigned char tag, tmp[2];
 
+	if (!type)	/* wrong type */
+		return -1;
 	isapnp_peek(&tag, 1);
 	if (tag == 0)				/* invalid tag */
 		return -1;
@@ -370,8 +372,6 @@ static int __init isapnp_read_tag(unsigned char *type, unsigned short *size)
 #if 0
 	printk(KERN_DEBUG "tag = 0x%x, type = 0x%x, size = %i\n", tag, *type, *size);
 #endif
-	if (type == 0)				/* wrong type */
-		return -1;
 	if (*type == 0xff && *size == 0xffff)	/* probably invalid data */
 		return -1;
 	return 0;


