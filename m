Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbZGAVhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbZGAVhe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 17:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbZGAVhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 17:37:25 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:56595 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914AbZGAVhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 17:37:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqcFAL5xS0pMQWU3/2dsb2JhbACBUc8WhBEF
Date: Wed, 1 Jul 2009 17:37:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>, stable@kernel.org
Subject: [BUGFIX PATCH] x86: Fix fixmap page order for FIX_TEXT_POKE0,1
Message-ID: <20090701213722.GH19926@Krystal>
References: <20090701210246.22089.65697.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090701210246.22089.65697.stgit@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:28:29 up 123 days, 17:54,  3 users,  load average: 0.24, 0.36,
	0.41
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami wrote :

> Since the fixmap pages are assigned higher address to lower, text_poke()
> has to use it with inverted order (FIX_TEXT_POKE1 to FIX_TEXT_POKE0).

I prefer to just invert the order of the fixmap declaration. It's simpler and
more straightforward.

Backward fixmaps seems to be used by both x86 32 and 64.

It's a really nasty bug, because it only hurts when instructions to patch are
crossing a page boundary. If this happens, the fixmap write accesses
will spill on the following fixmap, which may very well crash the
system. And this does not crash the system, it could leave illegal
instructions in place. Thanks Masami for finding this.

It seems to have crept into the 2.6.30-rc series, so this calls for a
-stable inclusion.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
CC: stable@kernel.org
---
 arch/x86/include/asm/fixmap.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-lttng/arch/x86/include/asm/fixmap.h
===================================================================
--- linux-2.6-lttng.orig/arch/x86/include/asm/fixmap.h	2009-07-01 16:52:57.000000000 -0400
+++ linux-2.6-lttng/arch/x86/include/asm/fixmap.h	2009-07-01 16:54:52.000000000 -0400
@@ -111,8 +111,8 @@ enum fixed_addresses {
 #ifdef CONFIG_PARAVIRT
 	FIX_PARAVIRT_BOOTMAP,
 #endif
-	FIX_TEXT_POKE0,	/* reserve 2 pages for text_poke() */
-	FIX_TEXT_POKE1,
+	FIX_TEXT_POKE1,	/* reserve 2 pages for text_poke() */
+	FIX_TEXT_POKE0, /* first page is last, because allocation is backward */
 	__end_of_permanent_fixed_addresses,
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
