Return-Path: <linux-kernel-owner+w=401wt.eu-S1765529AbZDIV15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765529AbZDIV15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 17:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760133AbZDIV1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 17:27:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:44829 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759016AbZDIV1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 17:27:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=usrLLjYEg9hrVG2i8bomHig4lapsMKJpm+yBOfQuNrEbSux9aNkMnE819VjpW6Hkvs
         u0tyCPqRo6SoNjE/So40M/DVSRbLuEySA0sQvfTE3RpMrr3TkUz2UljOKx132UAh+akN
         BBmnP5YXVGM8Z7prSuop+LsItrHOYBI6IwMmU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 1/2] lockdep: warn about lockdep disabling after kernel taint
Date: Thu,  9 Apr 2009 23:27:39 +0200
Message-Id: <1239312460-13396-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: provide useful missing info for developers

Kernel taint can occur in several situations such as warnings,
load of prorietary or staging modules, bad page, etc...

But when such taint happens, a developer might still be working on
the kernel, expecting that lockdep is still enabled. But a taint
disables lockdep without ever warning about it.
Such a kernel behaviour doesn't really help for kernel development.

This patch adds this missing warning.

Since the taint is done most of the time after the main message that
explain the real source issue, it seems safe to warn about it inside
add_taint() so that it appears at last, without hurting the main
information.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

diff --git a/kernel/panic.c b/kernel/panic.c
index 3fd8c5b..9e7420a 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -213,8 +213,14 @@ unsigned long get_taint(void)
 
 void add_taint(unsigned flag)
 {
-	/* can't trust the integrity of the kernel anymore: */
-	debug_locks = 0;
+	/*
+	 * Can't trust the integrity of the kernel anymore.
+	 * We don't call directly debug_locks_off() because the issue
+	 * is not necessarily serious enough to set oops_in_progress to 1
+	 */
+	if (xchg(&debug_locks, 0))
+		printk(KERN_WARNING "Disabling lockdep due to kernel taint\n");
+
 	set_bit(flag, &tainted_mask);
 }
 EXPORT_SYMBOL(add_taint);
-- 
1.6.1

