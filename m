Return-Path: <linux-kernel-owner+w=401wt.eu-S1754370AbZGPJEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbZGPJEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 05:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbZGPJEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 05:04:53 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58490 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115AbZGPJEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 05:04:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 16 Jul 2009 18:03:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       npiggin@suse.de,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       avi@redhat.com, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, aarcange@redhat.com
Subject: [PATCH 1/2] ZERO PAGE again v4.
Message-Id: <20090716180303.bc9c887d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090716180134.3393acde.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090709122428.8c2d4232.kamezawa.hiroyu@jp.fujitsu.com>
	<20090716180134.3393acde.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no changes since v3


From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Kconfig for using ZERO_PAGE or not. Using ZERO_PAGE or not is depends on
 - arch has pte_special() or not.
 - arch allows to use ZERO_PAGE or not.

In this patch, generic-config for /mm and arch-specific config for x86
is added. 

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
Index: mmotm-2.6.31-Jul15/mm/Kconfig
===================================================================
--- mmotm-2.6.31-Jul15.orig/mm/Kconfig
+++ mmotm-2.6.31-Jul15/mm/Kconfig
@@ -214,6 +214,21 @@ config HAVE_MLOCKED_PAGE_BIT
 config MMU_NOTIFIER
 	bool
 
+config SUPPORT_ANON_ZERO_PAGE
+	bool "Use anon zero page"
+	default y if ARCH_SUPPORT_ANON_ZERO_PAGE
+	help
+	  In anonymous private mapping (MAP_ANONYMOUS and /dev/zero), a read
+	  page fault will allocate a new zero-cleared page. If the first page
+	  fault is write, allocating a new page is necessary. But if it is
+	  read, we can use ZERO_PAGE until a write comes. If you set this to y,
+	  the kernel use ZERO_PAGE and delays allocating new memory in private
+	  anon mapping until the first write. If applications use large mmap
+	  and most of accesses are read, this reduces memory usage and cache
+	  usage to some extent. To support this, your architecture should have
+	  _PAGE_SPECIAL bit in pte. And this will be no help to cpu cache if
+	  the arch's cache is virtually tagged.
+
 config DEFAULT_MMAP_MIN_ADDR
         int "Low address space to protect from user allocation"
         default 4096
Index: mmotm-2.6.31-Jul15/arch/x86/Kconfig
===================================================================
--- mmotm-2.6.31-Jul15.orig/arch/x86/Kconfig
+++ mmotm-2.6.31-Jul15/arch/x86/Kconfig
@@ -158,6 +158,9 @@ config ARCH_HIBERNATION_POSSIBLE
 config ARCH_SUSPEND_POSSIBLE
 	def_bool y
 
+config ARCH_SUPPORT_ANON_ZERO_PAGE
+	def_bool y
+
 config ZONE_DMA32
 	bool
 	default X86_64

