Return-Path: <linux-kernel-owner+w=401wt.eu-S935273AbZDHUD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935273AbZDHUD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 16:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935131AbZDHUCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 16:02:49 -0400
Received: from smtp-out.google.com ([216.239.45.13]:4962 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088AbZDHUCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 16:02:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:content-type:
	content-transfer-encoding:x-system-of-record;
	b=lMouQKzEZNw8B0lDOMRAQ39viEOpVsVYuxip4K9SFxq5VBe+Tk1pV8upZxsubhIbD
	lsNjCc7EbQ1VBygDZDANg==
MIME-Version: 1.0
Date: Wed, 8 Apr 2009 13:02:43 -0700
Message-ID: <604427e00904081302g1e3e4923kd61ceac5de72ccb2@mail.gmail.com>
Subject: [PATCH][2/2]page_fault retry with NOPAGE_RETRY
From: Ying Han <yinghan@google.com>
To: linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>, Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>,
       =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86 support:

Signed-off-by: Ying Han <yinghan@google.com>
	       Mike Waychison <mikew@google.com>

arch/x86/mm/fault.c |   20 ++++++++++++++


diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 31e8730..0ec60a1 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -591,6 +591,7 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigne
 #ifdef CONFIG_X86_64
 	unsigned long flags;
 #endif
+	unsigned int retry_flag = FAULT_FLAG_RETRY;

 	tsk = current;
 	mm = tsk->mm;
@@ -689,6 +690,7 @@ again:
 		down_read(&mm->mmap_sem);
 	}

+retry:
 	vma = find_vma(mm, address);
 	if (!vma)
 		goto bad_area;
@@ -715,6 +717,7 @@ again:
 good_area:
 	si_code = SEGV_ACCERR;
 	write = 0;
+	write |= retry_flag;
 	switch (error_code & (PF_PROT|PF_WRITE)) {
 	default:	/* 3: write, present */
 		/* fall through */
@@ -743,6 +746,23 @@ good_area:
 			goto do_sigbus;
 		BUG();
 	}
+
+	/*
+	 * Here we retry fault once and switch to synchronous mode. The
+	 * main reason is to prevent us from the cases of starvation.
+	 * The retry logic open a starvation hole in which case pages might
+	 * be removed or changed after the retry.
+	 */
+	if (fault & VM_FAULT_RETRY) {
+		if (write & FAULT_FLAG_RETRY) {
+			retry_flag &= ~FAULT_FLAG_RETRY;
+			tsk->maj_flt++;
+			tsk->min_flt--;
+			goto retry;
+		}
+		BUG();
+	}
+
 	if (fault & VM_FAULT_MAJOR)
 		tsk->maj_flt++;
 	else
