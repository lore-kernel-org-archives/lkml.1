Return-Path: <linux-kernel-owner+w=401wt.eu-S1758170AbZGID3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170AbZGID3E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 23:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756651AbZGID2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 23:28:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33855 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbZGID2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 23:28:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 9 Jul 2009 12:27:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       npiggin@suse.de,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       avi@redhat.com, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, aarcange@redhat.com
Subject: [PATCH 1/2] ZERO PAGE config
Message-Id: <20090709122702.0a8c432b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090709122428.8c2d4232.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090709122428.8c2d4232.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only x86 config is inculded because I can test only x86...
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Kconfig for using ZERO_PAGE. Using ZERO_PAGE or not is depends on
 - arch has pte_special() or not.
 - arch allows to use ZERO_PAGE or not.

In this patch, generic-config for /mm and arch-specific config for x86
is added. Other archs ? AFAIK, powerpc and s390 has pte_special().

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 arch/x86/Kconfig |    3 +++
 mm/Kconfig       |   15 +++++++++++++++
 2 files changed, 18 insertions(+)

Index: zeropage-trialv3/mm/Kconfig
===================================================================
--- zeropage-trialv3.orig/mm/Kconfig
+++ zeropage-trialv3/mm/Kconfig
@@ -214,6 +214,21 @@ config HAVE_MLOCKED_PAGE_BIT
 config MMU_NOTIFIER
 	bool
 
+config SUPPORT_ANON_ZERO_PAGE
+	bool "use anon zero page"
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
Index: zeropage-trialv3/arch/x86/Kconfig
===================================================================
--- zeropage-trialv3.orig/arch/x86/Kconfig
+++ zeropage-trialv3/arch/x86/Kconfig
@@ -161,6 +161,9 @@ config ARCH_HIBERNATION_POSSIBLE
 config ARCH_SUSPEND_POSSIBLE
 	def_bool y
 
+config ARCH_SUPPORT_ANON_ZERO_PAGE
+	def_bool y
+
 config ZONE_DMA32
 	bool
 	default X86_64

