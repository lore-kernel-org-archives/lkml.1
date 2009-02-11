Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbZBKEtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbZBKEtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 23:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZBKEs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 23:48:57 -0500
Received: from ozlabs.org ([203.10.76.45]:54413 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbZBKEs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 23:48:56 -0500
To: Linux Memory Management <linux-mm@kvack.org>
CC: <linuxppc-dev@ozlabs.org>, <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 11 Feb 2009 15:48:26 +1100
Subject: [PATCH] vmalloc: Add __get_vm_area_caller()
Message-Id: <20090211044854.969CEDDDA9@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have get_vm_area_caller() and __get_vm_area() but not __get_vm_area_caller()

On powerpc, I use __get_vm_area() to separate the ranges of addresses given
to vmalloc vs. ioremap (various good reasons for that) so in order to be
able to implement the new caller tracking in /proc/vmallocinfo, I need
a "_caller" variant of it.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

I want to put into powerpc-next patches relying into that, so if the
patch is ok with you guys, can I stick it in powerpc.git ?

 include/linux/vmalloc.h |    3 +++
 mm/vmalloc.c            |    8 ++++++++
 2 files changed, 11 insertions(+)

--- linux-work.orig/include/linux/vmalloc.h	2009-02-04 15:33:35.000000000 +1100
+++ linux-work/include/linux/vmalloc.h	2009-02-04 15:33:47.000000000 +1100
@@ -84,6 +84,9 @@ extern struct vm_struct *get_vm_area_cal
 					unsigned long flags, void *caller);
 extern struct vm_struct *__get_vm_area(unsigned long size, unsigned long flags,
 					unsigned long start, unsigned long end);
+extern struct vm_struct *__get_vm_area_caller(unsigned long size, unsigned long flags,
+					      unsigned long start, unsigned long end,
+					      void *caller);
 extern struct vm_struct *get_vm_area_node(unsigned long size,
 					  unsigned long flags, int node,
 					  gfp_t gfp_mask);
Index: linux-work/mm/vmalloc.c
===================================================================
--- linux-work.orig/mm/vmalloc.c	2009-02-04 15:32:47.000000000 +1100
+++ linux-work/mm/vmalloc.c	2009-02-04 15:33:25.000000000 +1100
@@ -1106,6 +1106,14 @@ struct vm_struct *__get_vm_area(unsigned
 }
 EXPORT_SYMBOL_GPL(__get_vm_area);
 
+struct vm_struct *__get_vm_area_caller(unsigned long size, unsigned long flags,
+				       unsigned long start, unsigned long end,
+				       void *caller)
+{
+	return __get_vm_area_node(size, flags, start, end, -1, GFP_KERNEL,
+				  caller);
+}
+
 /**
  *	get_vm_area  -  reserve a contiguous kernel virtual area
  *	@size:		size of the area

