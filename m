Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZG1X6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZG1X6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbZG1XuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:50:01 -0400
Received: from kroah.org ([198.145.64.141]:35774 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754326AbZG1XuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:00 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:56 2009
Message-Id: <20090728234155.923201319@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 31/71] x86: Fix fixmap page order for FIX_TEXT_POKE0,1
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=x86-fix-fixmap-page-order-for-fix_text_poke0-1.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

commit 12b9d7ccb841805e347fec8f733f368f43ddba40 upstream.

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
LKML-Reference: <20090701213722.GH19926@Krystal>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/fixmap.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


