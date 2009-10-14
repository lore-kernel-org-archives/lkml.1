Return-Path: <linux-kernel-owner+w=401wt.eu-S1761631AbZJNDFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761631AbZJNDFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 23:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759814AbZJNDFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 23:05:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38762 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759697AbZJNDFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 23:05:19 -0400
Message-Id: <20091014030321.118688585@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 13 Oct 2009 23:02:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sachin Sant <sachinp@in.ibm.com>
Subject: [PATCH 2/2] [PATCH 2/2] powerpc64/ftrace: use PACA to retrieve TOC in mod_return_to_handler
References: <20091014030225.271734317@goodmis.org>
Content-Disposition: inline; filename=0002-powerpc64-ftrace-use-PACA-to-retrieve-TOC-in-mod_ret.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The mod_return_to_handler needs to switch to the kernel TOC before
jumping to a the kernel code. It currently does this by looking
at the kernel function data and retrieves the TOC that way.

Not only is this inefficient, it also breaks with a relocatable kernel.
The PACA contains the kernel TOC and we can easily retrieve it that
way.

Reported-by: Sachin Sant <sachinp@in.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/kernel/entry_64.S |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/entry_64.S b/arch/powerpc/kernel/entry_64.S
index 900e0ee..f9fd54b 100644
--- a/arch/powerpc/kernel/entry_64.S
+++ b/arch/powerpc/kernel/entry_64.S
@@ -1038,8 +1038,7 @@ _GLOBAL(mod_return_to_handler)
 	 * We are in a module using the module's TOC.
 	 * Switch to our TOC to run inside the core kernel.
 	 */
-	LOAD_REG_IMMEDIATE(r4,ftrace_return_to_handler)
-	ld	r2, 8(r4)
+	ld	r2, PACATOC(r13)
 
 	bl	.ftrace_return_to_handler
 	nop
-- 
1.6.3.3


