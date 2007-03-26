Return-Path: <linux-kernel-owner+w=401wt.eu-S1753131AbXCZUwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbXCZUwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 16:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbXCZUww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 16:52:52 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:62736 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbXCZUwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 16:52:51 -0400
Message-Id: <20070326205248.338724078@de.ibm.com>
References: <20070326205225.438154546@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 26 Mar 2007 22:52:26 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Subject: [patch 1/6] dasd: Work around gcc bug.
Content-Disposition: inline; filename=001-dasd-gcc-bug.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

gcc incorrectly removes initialization of register 0 in dasd diag
inline assembly. Use different register to work around this compiler
bug.

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 drivers/s390/block/dasd_diag.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/s390/block/dasd_diag.c
===================================================================
--- linux-2.6.orig/drivers/s390/block/dasd_diag.c
+++ linux-2.6/drivers/s390/block/dasd_diag.c
@@ -65,7 +65,7 @@ static const u8 DASD_DIAG_CMS1[] = { 0xc
  * resulting condition code and DIAG return code. */
 static inline int dia250(void *iob, int cmd)
 {
-	register unsigned long reg0 asm ("0") = (unsigned long) iob;
+	register unsigned long reg2 asm ("2") = (unsigned long) iob;
 	typedef union {
 		struct dasd_diag_init_io init_io;
 		struct dasd_diag_rw_io rw_io;
@@ -74,15 +74,15 @@ static inline int dia250(void *iob, int 
 
 	rc = 3;
 	asm volatile(
-		"	diag	0,%2,0x250\n"
+		"	diag	2,%2,0x250\n"
 		"0:	ipm	%0\n"
 		"	srl	%0,28\n"
-		"	or	%0,1\n"
+		"	or	%0,3\n"
 		"1:\n"
 		EX_TABLE(0b,1b)
 		: "+d" (rc), "=m" (*(addr_type *) iob)
-		: "d" (cmd), "d" (reg0), "m" (*(addr_type *) iob)
-		: "1", "cc");
+		: "d" (cmd), "d" (reg2), "m" (*(addr_type *) iob)
+		: "3", "cc");
 	return rc;
 }
 

-- 
