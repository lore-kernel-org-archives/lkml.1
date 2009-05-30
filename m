Return-Path: <linux-kernel-owner+w=401wt.eu-S1763592AbZE3TbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763592AbZE3TbB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 15:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757337AbZE3Tax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 15:30:53 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:54090 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167AbZE3Taw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 15:30:52 -0400
Date: Sat, 30 May 2009 12:28:29 -0700
From: "Larry H." <research@subreption.com>
To: linux-mm@kvack.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>
Subject: [PATCH] Change ZERO_SIZE_PTR to point at unmapped space
Message-ID: <20090530192829.GK6535@oblivion.subreption.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] Change ZERO_SIZE_PTR to point at unmapped space

This patch changes the ZERO_SIZE_PTR address to point at top memory
unmapped space, instead of the original location which could be
mapped from userland to abuse a NULL (or offset-from-null) pointer
dereference scenario.

The ZERO_OR_NULL_PTR macro is changed accordingly. This patch does
not modify its behavior nor has any performance nor functionality
impact.

The original change was written first by the PaX team for their
patch.

Signed-off-by: Larry Highsmith <larry@subreption.com>

Index: linux-2.6/include/linux/slab.h
===================================================================
--- linux-2.6.orig/include/linux/slab.h
+++ linux-2.6/include/linux/slab.h
@@ -73,10 +73,9 @@
  * ZERO_SIZE_PTR can be passed to kfree though in the same way that NULL can.
  * Both make kfree a no-op.
  */
-#define ZERO_SIZE_PTR ((void *)16)
+#define ZERO_SIZE_PTR ((void *)-1024L)
 
-#define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) <= \
-				(unsigned long)ZERO_SIZE_PTR)
+#define ZERO_OR_NULL_PTR(x) (!(x) || (x) == ZERO_SIZE_PTR)
 
 /*
  * struct kmem_cache related prototypes
