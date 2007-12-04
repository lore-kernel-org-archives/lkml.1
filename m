Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbXLDN4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbXLDN4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbXLDNyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:54:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572AbXLDNys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:54:48 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 7/10] change rdpmc interface
Date: Tue,  4 Dec 2007 09:10:01 -0200
Message-Id: <11967666393130-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11967666351395-git-send-email-gcosta@redhat.com>
References: <11967666042130-git-send-email-gcosta@redhat.com> <11967666111489-git-send-email-gcosta@redhat.com> <11967666161585-git-send-email-gcosta@redhat.com> <11967666212496-git-send-email-gcosta@redhat.com> <11967666263502-git-send-email-gcosta@redhat.com> <11967666303321-git-send-email-gcosta@redhat.com> <11967666351395-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the rdpmc instruction gets a counter argument in rcx. However,
the i386 version was ignoring it. To make both x86_64 and i386 versions
the same, as well as to comply with the instruction semantics, this
parameter is added in the i386 version

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/msr.h      |    6 +++---
 include/asm-x86/paravirt.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/asm-x86/msr.h b/include/asm-x86/msr.h
index 0296358..ce2a257 100644
--- a/include/asm-x86/msr.h
+++ b/include/asm-x86/msr.h
@@ -90,10 +90,10 @@ static inline unsigned long long native_read_tsc(void)
 	return val;
 }
 
-static inline unsigned long long native_read_pmc(void)
+static inline unsigned long long native_read_pmc(int counter)
 {
 	unsigned long long val;
-	asm volatile("rdpmc" : "=A" (val));
+	asm volatile("rdpmc" : "=A" (val) : "c" (counter));
 	return val;
 }
 
@@ -150,7 +150,7 @@ static inline int wrmsr_safe(u32 __msr, u32 __low, u32 __high)
 
 #define rdpmc(counter,low,high)					\
 	do {							\
-		u64 _l = native_read_pmc();			\
+		u64 _l = native_read_pmc(counter);		\
 		(low)  = (u32)_l;				\
 		(high) = (u32)(_l >> 32);			\
 	} while(0)
diff --git a/include/asm-x86/paravirt.h b/include/asm-x86/paravirt.h
index f59d370..4a7be97 100644
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -118,7 +118,7 @@ struct pv_cpu_ops {
 	int (*write_msr)(unsigned int msr, u64 val);
 
 	u64 (*read_tsc)(void);
-	u64 (*read_pmc)(void);
+	u64 (*read_pmc)(int counter);
 
 	/* These two are jmp to, not actually called. */
 	void (*irq_enable_sysexit)(void);
-- 
1.4.4.2

