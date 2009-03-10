Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbZCJV6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbZCJV6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbZCJV6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:58:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:40939 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556AbZCJV6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:58:19 -0400
Date: Tue, 10 Mar 2009 21:57:46 GMT
From: Masami Hiramatsu <mhiramat@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <49B54688.8090403@redhat.com>
References: <49B54688.8090403@redhat.com>
Subject: [tip:tracing/core] x86: expand irq-off region in text_poke()
Message-ID: <tip-7cf49427042400d40bdc80b5c3399b6b5945afa8@git.kernel.org>
Git-Commit-ID: 7cf49427042400d40bdc80b5c3399b6b5945afa8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 10 Mar 2009 21:57:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7cf49427042400d40bdc80b5c3399b6b5945afa8
Gitweb:     http://git.kernel.org/tip/7cf49427042400d40bdc80b5c3399b6b5945afa8
Author:     "Masami Hiramatsu" <mhiramat@redhat.com>
AuthorDate: Mon, 9 Mar 2009 12:40:40 -0400
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 Mar 2009 16:24:23 +0100

x86: expand irq-off region in text_poke()

Expand irq-off region to cover fixmap using code and cache synchronizing.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
LKML-Reference: <49B54688.8090403@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/alternative.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 2d903b7..f576587 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -526,13 +526,12 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 		pages[1] = virt_to_page(addr + PAGE_SIZE);
 	}
 	BUG_ON(!pages[0]);
+	local_irq_save(flags);
 	set_fixmap(FIX_TEXT_POKE0, page_to_phys(pages[0]));
 	if (pages[1])
 		set_fixmap(FIX_TEXT_POKE1, page_to_phys(pages[1]));
 	vaddr = (char *)fix_to_virt(FIX_TEXT_POKE0);
-	local_irq_save(flags);
 	memcpy(&vaddr[(unsigned long)addr & ~PAGE_MASK], opcode, len);
-	local_irq_restore(flags);
 	clear_fixmap(FIX_TEXT_POKE0);
 	if (pages[1])
 		clear_fixmap(FIX_TEXT_POKE1);
@@ -542,5 +541,6 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 	   that causes hangs on some VIA CPUs. */
 	for (i = 0; i < len; i++)
 		BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);
+	local_irq_restore(flags);
 	return addr;
 }
