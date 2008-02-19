Return-Path: <linux-kernel-owner+w=401wt.eu-S1760185AbYBSOre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbYBSOre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 09:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756984AbYBSOpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 09:45:23 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:31944 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067AbYBSOpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:45:09 -0500
Message-Id: <20080219144504.185987495@de.ibm.com>
References: <20080219144047.587547541@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 19 Feb 2008 15:40:53 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 06/13] find bit corner case.
Content-Disposition: inline; filename=006-bitops.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Fix [ext2_]find_first_[zero_]bit for the corner case of an all clear
or all set bit field by always handling that last word of the bit field
with __ffz_word/__ffs_word.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 include/asm-s390/bitops.h |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

Index: quilt-2.6/include/asm-s390/bitops.h
===================================================================
--- quilt-2.6.orig/include/asm-s390/bitops.h
+++ quilt-2.6/include/asm-s390/bitops.h
@@ -456,16 +456,18 @@ static inline unsigned long __ffz_word_l
 
 	asm volatile(
 #ifndef __s390x__
-		"	ahi	%1,31\n"
-		"	srl	%1,5\n"
+		"	ahi	%1,-1\n"
+		"	sra	%1,5\n"
+		"	jz	1f\n"
 		"0:	c	%2,0(%0,%3)\n"
 		"	jne	1f\n"
 		"	la	%0,4(%0)\n"
 		"	brct	%1,0b\n"
 		"1:\n"
 #else
-		"	aghi	%1,63\n"
-		"	srlg	%1,%1,6\n"
+		"	aghi	%1,-1\n"
+		"	srag	%1,%1,6\n"
+		"	jz	1f\n"
 		"0:	cg	%2,0(%0,%3)\n"
 		"	jne	1f\n"
 		"	la	%0,8(%0)\n"
@@ -491,16 +493,18 @@ static inline unsigned long __ffs_word_l
 
 	asm volatile(
 #ifndef __s390x__
-		"	ahi	%1,31\n"
-		"	srl	%1,5\n"
+		"	ahi	%1,-1\n"
+		"	sra	%1,5\n"
+		"	jz	1f\n"
 		"0:	c	%2,0(%0,%3)\n"
 		"	jne	1f\n"
 		"	la	%0,4(%0)\n"
 		"	brct	%1,0b\n"
 		"1:\n"
 #else
-		"	aghi	%1,63\n"
-		"	srlg	%1,%1,6\n"
+		"	aghi	%1,-1\n"
+		"	srag	%1,%1,6\n"
+		"	jz	1f\n"
 		"0:	cg	%2,0(%0,%3)\n"
 		"	jne	1f\n"
 		"	la	%0,8(%0)\n"

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

