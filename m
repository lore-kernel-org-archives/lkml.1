Return-Path: <linux-kernel-owner+w=401wt.eu-S934103AbZHEKTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934103AbZHEKTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 06:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933794AbZHEKTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 06:19:41 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50602 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933046AbZHEKTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 06:19:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 5 Aug 2009 19:17:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       npiggin@suse.de, hugh.dickins@tiscali.co.uk,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
Subject: [PATCH 1/2] ZERO_PAGE config
Message-Id: <20090805191750.a6d10776.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090805191643.2b11ae78.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090805191643.2b11ae78.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

no changes from v4.
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Kconfig for using ZERO_PAGE or not. Using ZERO_PAGE or not is depends on
 - arch has pte_special() or not.
 - arch allows to use ZERO_PAGE or not.

In this patch, generic-config for /mm and arch-specific config for x86
is added. Other archs ?

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 arch/x86/Kconfig |    3 +++
 mm/Kconfig       |   18 ++++++++++++++++++
 2 files changed, 21 insertions(+)

Index: mmotm-2.6.31-Aug4/mm/Kconfig
===================================================================
--- mmotm-2.6.31-Aug4.orig/mm/Kconfig
+++ mmotm-2.6.31-Aug4/mm/Kconfig
@@ -225,6 +225,24 @@ config KSM
 	  saving memory until one or another app needs to modify the content.
 	  Recommended for use with KVM, or with other duplicative applications.
 
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
+	  To developper:
+	  This ZERO_PAGE changes behavior of follow_page(). please check
+	  usage of follow_page() in your arch before supporting this.
+
 config DEFAULT_MMAP_MIN_ADDR
         int "Low address space to protect from user allocation"
         default 4096
Index: mmotm-2.6.31-Aug4/arch/x86/Kconfig
===================================================================
--- mmotm-2.6.31-Aug4.orig/arch/x86/Kconfig
+++ mmotm-2.6.31-Aug4/arch/x86/Kconfig
@@ -158,6 +158,9 @@ config ARCH_HIBERNATION_POSSIBLE
 config ARCH_SUSPEND_POSSIBLE
 	def_bool y
 
+config ARCH_SUPPORT_ANON_ZERO_PAGE
+	def_bool y
+
 config ZONE_DMA32
 	bool
 	default X86_64

