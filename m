Return-Path: <linux-kernel-owner+w=401wt.eu-S1752937AbZIZSy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937AbZIZSy1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 14:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbZIZSy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 14:54:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:36396 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbZIZSyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 14:54:19 -0400
Date: Sat, 26 Sep 2009 20:51:50 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       hpa@zytor.com, tglx@tglx.de
Subject: [PATCH 4/9] Simplify bound checks in the MTRR code
Message-ID: <20090926205150.30797709@infradead.org>
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
Subject: [PATCH 4/9] Simplify bound checks in the MTRR code
CC: mingo@elte.hu
CC: hpa@zytor.com
CC: tglx@tglx.de

The current bound checks for copy_from_user in the MTRR driver
are not as obvious as they could be, and gcc agrees with that.

This patch simplifies the boundary checks to the point that gcc
can now prove to itself that the copy_from_user() is never going
past its bounds.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index f04e725..3c1b12d 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -96,17 +96,24 @@ mtrr_write(struct file *file, const char __user *buf, size_t len, loff_t * ppos)
 	unsigned long long base, size;
 	char *ptr;
 	char line[LINE_SIZE];
+	int length;
 	size_t linelen;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (!len)
-		return -EINVAL;
 
 	memset(line, 0, LINE_SIZE);
-	if (len > LINE_SIZE)
-		len = LINE_SIZE;
-	if (copy_from_user(line, buf, len - 1))
+
+	length = len;
+	length--;
+
+	if (length > LINE_SIZE - 1)
+		length = LINE_SIZE - 1;
+
+	if (length < 0)
+		return -EINVAL;
+
+	if (copy_from_user(line, buf, length))
 		return -EFAULT;
 
 	linelen = strlen(line);



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
