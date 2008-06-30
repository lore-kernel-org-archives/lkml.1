Return-Path: <linux-kernel-owner+w=401wt.eu-S1764687AbYF3VnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764687AbYF3VnE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932953AbYF3VfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:35:00 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:48249 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763140AbYF3Ved (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:34:33 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Jan Beulich <jbeulich@novell.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 15/24] vmlinux.lds: move __attribute__((__cold__)) functions back into final .text section
Date: Mon, 30 Jun 2008 23:35:09 +0200
Message-Id: <1214861718-32626-15-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.1.93.gef98
In-Reply-To: <20080630213155.GA32479@uranus.ravnborg.org>
References: <20080630213155.GA32479@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <jbeulich@novell.com>

Due to the addition of __attribute__((__cold__)) to a few symbols
without adjusting the linker scripts, those symbols currently may end
up outside the [_stext,_etext) range, as they get placed in
.text.unlikely by (at least) gcc 4.3.0. This may confuse code not only
outside of the kernel, symbol_put_addr()'s BUG() could also trigger.
Hence we need to add .text.unlikely (and for future uses of
__attribute__((__hot__)) also .text.hot) to the TEXT_TEXT() macro.

Issue observed by Lukas Lipavsky.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Tested-by: Lukas Lipavsky <llipavsky@suse.cz>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 include/asm-generic/vmlinux.lds.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index f054778..5a544bf 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -204,6 +204,7 @@
  * during second ld run in second ld pass when generating System.map */
 #define TEXT_TEXT							\
 		ALIGN_FUNCTION();					\
+		*(.text.hot)						\
 		*(.text)						\
 		*(.ref.text)						\
 		*(.text.init.refok)					\
@@ -213,7 +214,8 @@
 	CPU_KEEP(init.text)						\
 	CPU_KEEP(exit.text)						\
 	MEM_KEEP(init.text)						\
-	MEM_KEEP(exit.text)
+	MEM_KEEP(exit.text)						\
+		*(.text.unlikely)
 
 
 /* sched.text is aling to function alignment to secure we have same
-- 
1.5.6.1.93.gef98

