Return-Path: <linux-kernel-owner+w=401wt.eu-S932266AbXGVMPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbXGVMPw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 08:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757966AbXGVMPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 08:15:43 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:38634 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759259AbXGVMPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 08:15:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=eqQZRkPMitTmg3OnwX4Jd0N7ZklYyuKPLmDy/zi6n9kvG+5rwftK4jKo6ajA3XarmvAAMS5zftymPUjaYa+yYgdBwV/VNwitxJ3wXv0binrwAQ6IAjTQDvDd6v5ktNbhNYYRsjWgA8EDEW7lvz7eOe/lyhVFi8tsD8YfwvjYtwg=
Message-ID: <46A349E6.3030207@googlemail.com>
Date: Sun, 22 Jul 2007 14:13:26 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: David Woodhouse <dwmw2@infradead.org>
Subject: drivers/mtd/devices/doc2000.c - address of 'eccbuf' will always evaluate
 as 'true' , warnings
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed this warnings on current git with gcc 4.2.1

....

drivers/mtd/devices/doc2000.c: In function 'doc_read':
drivers/mtd/devices/doc2000.c:635: warning: the address of 'eccbuf' will always evaluate as 'true'
drivers/mtd/devices/doc2000.c: In function 'doc_write':
drivers/mtd/devices/doc2000.c:899: warning: the address of 'eccbuf' will always evaluate as 'true'

....

This patch fixes it but maybe there is a better way to do it.


Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
---


diff --git a/drivers/mtd/devices/doc2000.c b/drivers/mtd/devices/doc2000.c
index c73e96b..ce8fbf5 100644
--- a/drivers/mtd/devices/doc2000.c
+++ b/drivers/mtd/devices/doc2000.c
@@ -632,7 +632,7 @@ static int doc_read(struct mtd_info *mtd, loff_t from, size_t len,
 			len = ((from | 0x1ff) + 1) - from;
 
 		/* The ECC will not be calculated correctly if less than 512 is read */
-		if (len != 0x200 && eccbuf)
+		if (len != 0x200 && eccbuf != NULL)
 			printk(KERN_WARNING
 			       "ECC needs a full sector read (adr: %lx size %lx)\n",
 			       (long) from, (long) len);
@@ -896,7 +896,7 @@ static int doc_write(struct mtd_info *mtd, loff_t to, size_t len,
 		/* Let the caller know we completed it */
 		*retlen += len;
 
-		if (eccbuf) {
+		if (eccbuf != NULL) {
 			unsigned char x[8];
 			size_t dummy;
 			int ret;

