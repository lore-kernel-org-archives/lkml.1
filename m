Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbYCVJ7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbYCVJ7l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 05:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYCVJ7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 05:59:31 -0400
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:45110 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbYCVJ7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 05:59:30 -0400
Date: Sat, 22 Mar 2008 10:59:28 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, andreas.herrmann3@amd.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Readd rdmsrl_safe v2
Message-ID: <20080322095928.GA20759@basil.nowhere.org>
References: <20080312353.598285931@firstfloor.org> <20080312025331.B113B1B41D1@basil.firstfloor.org> <alpine.LFD.1.00.0803211756000.3781@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803211756000.3781@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 22 Mar 2008 09:52:52.0185 (UTC) FILETIME=[7E992C90:01C88C02]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Readd rdmsrl_safe v2

RDMSR for 64bit values with exception handling.

Makes it easier to deal with 64bit valued MSRs. The old 64bit code
base had that too as checking_rdmsrl(), but it got dropped somehow. 

Needed for followup patch.

v2: switch to inline

Signed-off-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andi Kleen <andi@firstfloor.org>

---
 include/asm-x86/msr.h      |    3 +++
 include/asm-x86/paravirt.h |    4 ++++
 2 files changed, 7 insertions(+)

Index: linux/include/asm-x86/msr.h
===================================================================
--- linux.orig/include/asm-x86/msr.h
+++ linux/include/asm-x86/msr.h
@@ -150,6 +150,13 @@ static inline int wrmsr_safe(unsigned ms
 		__err;							\
 	})
 
+static inline int rdmsrl_safe(unsigned msr, unsigned long long *p)
+{
+	int err;
+	*p = native_read_msr_safe(msr, &err);
+	return err;
+}
+
 #define rdtscl(low)						\
 	((low) = (u32)native_read_tsc())
 
Index: linux/include/asm-x86/paravirt.h
===================================================================
--- linux.orig/include/asm-x86/paravirt.h
+++ linux/include/asm-x86/paravirt.h
@@ -687,6 +687,12 @@ static inline int paravirt_write_msr(uns
 	(*b) = _l >> 32;			\
 	_err; })
 
+static inline int rdmsrl_safe(unsigned msr, unsigned long long *p)
+{
+	int err;
+	*p = paravirt_read_msr(msr, &err);
+	return err;
+}
 
 static inline u64 paravirt_read_tsc(void)
 {
