Return-Path: <linux-kernel-owner+w=401wt.eu-S1764675AbZLQMXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764675AbZLQMXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 07:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764629AbZLQMXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 07:23:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44987 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764606AbZLQMXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 07:23:46 -0500
Date: Thu, 17 Dec 2009 13:23:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: -tip: origin tree build failure
Message-ID: <20091217122316.GB14088@elte.hu>
References: <20091217094041.GA24708@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217094041.GA24708@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

>  config MEMORY_FAILURE
>  	depends on MMU
>  	depends on ARCH_SUPPORTS_MEMORY_FAILURE
> +	select PROC_PAGE_MONITOR
>  	bool "Enable recovery from hardware memory errors"

It also needs to depend on PROC_FS in that case - as per the updated patch 
below.

	Ingo

----------------->
>From 896358c0554c56398d40191dda24da8c4b8029c4 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Thu, 17 Dec 2009 10:40:41 +0100
Subject: [PATCH] hwpoison: fix build failure

Today's -tip fails to build due to upstream commit
1a9b5b7fe0c5dad8a635288882d36785dea742f9 ("mm: export stable
page flags")  (authored and merged yesterday) causing the
following build failure on x86  when CONFIG_PROC_PAGE_MONITOR is
disabled:

 mm/built-in.o: In function `hwpoison_filter':
  (.text+0x39fbf): undefined reference to `stable_page_flags'

The bug is that the stable_page_flags() API is only available
under  CONFIG_PROC_PAGE_MONITOR, but utilized in
mm/memory-failure.c unconditionally.

I've applied the patch below to -tip for now, which expresses
this dependency  in the Kconfig. (Eventually a cleaner solution
would be to factor such ABI  details out of procfs, they dont
belong there.)

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Fr??d??ric Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <20091217094041.GA24708@elte.hu>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 mm/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 43ea8c3..021bc12 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -243,6 +243,8 @@ config ARCH_SUPPORTS_MEMORY_FAILURE
 config MEMORY_FAILURE
 	depends on MMU
 	depends on ARCH_SUPPORTS_MEMORY_FAILURE
+	depends on PROC_FS
+	select PROC_PAGE_MONITOR
 	bool "Enable recovery from hardware memory errors"
 	help
 	  Enables code to recover from some memory failures on systems
