Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbZAMFjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbZAMFjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 00:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbZAMFjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 00:39:35 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:47929 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbZAMFje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 00:39:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=rkEkmaPSsWApRSPe29zD4pvUvT0QQpM0sCWfljR4b59wBw+bNJIx1f4etOLAVO7avH
         PYfByjSYvAN4Cm1TkDtBWGXQ5qo60lwKHvYGca7mhjE/eWNzD5qIQzkyf3BSoIS1W0Y5
         LRRzD22dOuFXZupdBfSUU7PqxBPm1sI3LVmrM=
Message-ID: <b9df5fa10901122139h4bfb727i64f864ec185c731d@mail.gmail.com>
Date: Tue, 13 Jan 2009 11:39:33 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm: Fix section mismatch in memcontrol.c
Cc: mingo@elte.hu, "Andrew Morton" <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Fix section mismatch warning.

The annotation for __init in enable_swap_cgroup() and __initdata for
really_do_swap_account produces the following warning. Which is not
right, since this function is called from non-init section. This patch
fixes it. If anything else please notice.

  LD      mm/built-in.o
WARNING: mm/built-in.o(.text+0x277d9): Section mismatch in reference
from the function mem_cgroup_create() to the function
.init.text:enable_swap_cgroup()
The function mem_cgroup_create() references
the function __init enable_swap_cgroup().
This is often because mem_cgroup_create lacks a __init
annotation or the annotation of enable_swap_cgroup is wrong.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

--- linux-2.6-orig/mm/memcontrol.c	2009-01-12 09:53:10.000000000 +0600
+++ linux-2.6/mm/memcontrol.c	2009-01-12 19:40:06.134648480 +0600
@@ -46,7 +46,7 @@ struct cgroup_subsys mem_cgroup_subsys _
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 /* Turned on only when memory cgroup is enabled &&
really_do_swap_account = 0 */
 int do_swap_account __read_mostly;
-static int really_do_swap_account __initdata = 1; /* for remember boot option*/
+static int really_do_swap_account = 1; /* for remember boot option*/
 #else
 #define do_swap_account		(0)
 #endif
@@ -2170,13 +2170,13 @@ static void mem_cgroup_put(struct mem_cg


 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
-static void __init enable_swap_cgroup(void)
+static void enable_swap_cgroup(void)
 {
 	if (!mem_cgroup_disabled() && really_do_swap_account)
 		do_swap_account = 1;
 }
 #else
-static void __init enable_swap_cgroup(void)
+static void enable_swap_cgroup(void)
 {
 }
 #endif
