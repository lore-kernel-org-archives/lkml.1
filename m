Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbYGXUtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbYGXUtd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbYGXUtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:49:05 -0400
Received: from gw.goop.org ([64.81.55.164]:49804 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbYGXUtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:49:03 -0400
Message-ID: <4888EABA.1030608@goop.org>
Date: Thu, 24 Jul 2008 13:48:58 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen: suppress known wrmsrs
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In general, Xen doesn't support wrmsr from an unprivileged domain; it
just ends up ignoring the instruction and printing a message on the
console.

Given that there are sets of MSRs we know the kernel will try to write
to, but we don't care, just eat them in xen_write_msr to cut down on
console noise.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

===================================================================
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -803,6 +803,19 @@
 			ret = -EFAULT;
 		break;
 #endif
+
+	case MSR_STAR:
+	case MSR_CSTAR:
+	case MSR_LSTAR:
+	case MSR_SYSCALL_MASK:
+	case MSR_IA32_SYSENTER_CS:
+	case MSR_IA32_SYSENTER_ESP:
+	case MSR_IA32_SYSENTER_EIP:
+		/* Fast syscall setup is all done in hypercalls, so
+		   these are all ignored.  Stub them out here to stop
+		   Xen console noise. */
+		break;
+
 	default:
 		ret = native_write_msr_safe(msr, low, high);
 	}


