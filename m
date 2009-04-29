Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbZD2GSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbZD2GSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 02:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbZD2GRh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 02:17:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:58001 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851AbZD2GRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 02:17:35 -0400
Date: Wed, 29 Apr 2009 06:16:26 GMT
From: tip-bot for Chris Wright <chrisw@sous-sol.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, chrisw@sous-sol.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, rostedt@goodmis.org, tglx@linutronix.de
In-Reply-To: <20090423172138.GR3036@sequoia.sous-sol.org>
References: <20090423172138.GR3036@sequoia.sous-sol.org>
Subject: [tip:tracing/core] x86: use native register access for native tlb flushing
Message-ID: <tip-d7285c6b5c54397fdf112c2fb98ee43193173aa9@git.kernel.org>
Git-Commit-ID: d7285c6b5c54397fdf112c2fb98ee43193173aa9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 06:16:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7285c6b5c54397fdf112c2fb98ee43193173aa9
Gitweb:     http://git.kernel.org/tip/d7285c6b5c54397fdf112c2fb98ee43193173aa9
Author:     Chris Wright <chrisw@sous-sol.org>
AuthorDate: Thu, 23 Apr 2009 10:21:38 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 23 Apr 2009 23:05:03 -0400

x86: use native register access for native tlb flushing

currently these are paravirtulaized, doesn't appear any callers rely on
this (no pv_ops backends are using native_tlb and overriding cr3/4
access).

[ Impact: fix lockdep warning with paravirt and function tracer ]

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
LKML-Reference: <20090423172138.GR3036@sequoia.sous-sol.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


---
 arch/x86/include/asm/tlbflush.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index d3539f9..e2927c5 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -17,7 +17,7 @@
 
 static inline void __native_flush_tlb(void)
 {
-	write_cr3(read_cr3());
+	native_write_cr3(native_read_cr3());
 }
 
 static inline void __native_flush_tlb_global(void)
@@ -32,11 +32,11 @@ static inline void __native_flush_tlb_global(void)
 	 */
 	raw_local_irq_save(flags);
 
-	cr4 = read_cr4();
+	cr4 = native_read_cr4();
 	/* clear PGE */
-	write_cr4(cr4 & ~X86_CR4_PGE);
+	native_write_cr4(cr4 & ~X86_CR4_PGE);
 	/* write old PGE again and flush TLBs */
-	write_cr4(cr4);
+	native_write_cr4(cr4);
 
 	raw_local_irq_restore(flags);
 }
