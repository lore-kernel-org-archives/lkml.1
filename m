Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbZGCI6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbZGCI6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbZGCI60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:58:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:38823 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbZGCI6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:58:25 -0400
Date: Fri, 3 Jul 2009 08:57:43 GMT
From: tip-bot for Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
       mingo@redhat.com, stable@kernel.org, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, stable@kernel.org, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20090701213722.GH19926@Krystal>
References: <20090701213722.GH19926@Krystal>
Subject: [tip:x86/urgent] x86: Fix fixmap page order for FIX_TEXT_POKE0,1
Message-ID: <tip-23202d8f10c901836fb272b5bf1f07a3dd3efb9a@git.kernel.org>
Git-Commit-ID: 23202d8f10c901836fb272b5bf1f07a3dd3efb9a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Jul 2009 08:57:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23202d8f10c901836fb272b5bf1f07a3dd3efb9a
Gitweb:     http://git.kernel.org/tip/23202d8f10c901836fb272b5bf1f07a3dd3efb9a
Author:     Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
AuthorDate: Wed, 1 Jul 2009 17:37:22 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Jul 2009 09:08:34 +0200

x86: Fix fixmap page order for FIX_TEXT_POKE0,1

Masami reported:

> Since the fixmap pages are assigned higher address to lower,
> text_poke() has to use it with inverted order (FIX_TEXT_POKE1
> to FIX_TEXT_POKE0).

I prefer to just invert the order of the fixmap declaration.
It's simpler and more straightforward.

Backward fixmaps seems to be used by both x86 32 and 64.

It's really rare but a nasty bug, because it only hurts when
instructions to patch are crossing a page boundary. If this
happens, the fixmap write accesses will spill on the following
fixmap, which may very well crash the system. And this does not
crash the system, it could leave illegal instructions in place.
Thanks Masami for finding this.

It seems to have crept into the 2.6.30-rc series, so this calls
for a -stable inclusion.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: <stable@kernel.org>
LKML-Reference: <20090701213722.GH19926@Krystal>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/fixmap.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 3eb0f79..7b2d71d 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -111,8 +111,8 @@ enum fixed_addresses {
 #ifdef CONFIG_PARAVIRT
 	FIX_PARAVIRT_BOOTMAP,
 #endif
-	FIX_TEXT_POKE0,	/* reserve 2 pages for text_poke() */
-	FIX_TEXT_POKE1,
+	FIX_TEXT_POKE1,	/* reserve 2 pages for text_poke() */
+	FIX_TEXT_POKE0, /* first page is last, because allocation is backward */
 	__end_of_permanent_fixed_addresses,
 	/*
 	 * 256 temporary boot-time mappings, used by early_ioremap(),
