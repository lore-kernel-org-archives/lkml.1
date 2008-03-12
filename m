Return-Path: <linux-kernel-owner+w=401wt.eu-S1754150AbYCLCyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbYCLCyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 22:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbYCLCxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 22:53:34 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:9291 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbYCLCxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 22:53:33 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080312353.598285931@firstfloor.org>
In-Reply-To: <20080312353.598285931@firstfloor.org>
To: andreas.herrmann3@amd.com, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [5/7] Readd rdmsrl_safe
Message-Id: <20080312025331.B113B1B41D1@basil.firstfloor.org>
Date: Wed, 12 Mar 2008 03:53:31 +0100 (CET)
X-OriginalArrivalTime: 12 Mar 2008 02:46:59.0598 (UTC) FILETIME=[57F052E0:01C883EB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


RDMSR for 64bit values with exception handling.

Makes it easier to deal with 64bit valued MSRs. The old 64bit code
base had that too as checking_rdmsrl(), but it got dropped somehow. 

Needed for followup patch.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86/msr.h      |    3 +++
 include/asm-x86/paravirt.h |    4 ++++
 2 files changed, 7 insertions(+)

Index: linux/include/asm-x86/msr.h
===================================================================
--- linux.orig/include/asm-x86/msr.h
+++ linux/include/asm-x86/msr.h
@@ -150,6 +150,9 @@ static inline int wrmsr_safe(unsigned ms
 		__err;							\
 	})
 
+#define rdmsrl_safe(msr,p) \
+	({ int __err; *(p) = native_read_msr_safe(msr, &__err); __err; })
+
 #define rdtscl(low)						\
 	((low) = (u32)native_read_tsc())
 
Index: linux/include/asm-x86/paravirt.h
===================================================================
--- linux.orig/include/asm-x86/paravirt.h
+++ linux/include/asm-x86/paravirt.h
@@ -687,6 +687,10 @@ static inline int paravirt_write_msr(uns
 	(*b) = _l >> 32;			\
 	_err; })
 
+#define rdmsrl_safe(msr, p) ({			\
+	int _err;				\
+	*(p) = paravirt_read_msr(msr, &_err);	\
+	_err; })
 
 static inline u64 paravirt_read_tsc(void)
 {
