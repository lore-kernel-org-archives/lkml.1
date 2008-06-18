Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbYFRLfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbYFRLfx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 07:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYFRLfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 07:35:46 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:26162 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbYFRLfp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 07:35:45 -0400
Message-Id: <48590F41.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Wed, 18 Jun 2008 12:36:01 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <sam@ravnborg.org>
Cc: <stable@kernel.org>, <llipavsky@suse.cz>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] move __attribute__((__cold__)) functions back into
	final .text section
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to the addition of __attribute__((__cold__)) to a few symbols
without adjusting the linker scripts, those symbols currently may end
up outside the [_stext,_etext) range, as they get placed in
.text.unlikely by (at least) gcc 4.3.0. This may confuse code not only
outside of the kernel, symbol_put_addr()'s BUG() could also trigger.
Hence we need to add .text.unlikely (and for future uses of
__attribute__((__hot__)) also .text.hot) to the TEXT_TEXT() macro.

Issue observed by Lukas Lipavsky.

Cc: Lukas Lipavsky <llipavsky@suse.cz>
Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 include/asm-generic/vmlinux.lds.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.26-rc6/include/asm-generic/vmlinux.lds.h	2008-04-17 04:49:44.000000000 +0200
+++ 2.6.26-rc6-hot-cold-text/include/asm-generic/vmlinux.lds.h	2008-06-18 12:19:22.000000000 +0200
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



