Return-Path: <linux-kernel-owner+w=401wt.eu-S935703AbZDCRxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935703AbZDCRxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935318AbZDCRxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:53:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:49343 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933728AbZDCRxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:53:03 -0400
Date: Fri, 3 Apr 2009 17:51:36 GMT
From: Joseph Cihula <joseph.cihula@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       arjan@linux.intel.com, joseph.cihula@intel.com, chrisw@sous-sol.org,
       tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, arjan@linux.intel.com, tj@kernel.org,
       tglx@linutronix.de, joseph.cihula@intel.com, mingo@elte.hu
In-Reply-To: <49D13385.5060900@intel.com>
References: <49D13385.5060900@intel.com>
Subject: [tip:x86/urgent] x86: disable stack-protector for __restore_processor_state()
Message-ID: <tip-9b7b89efa3bdaceaa2efb93e2d635391835da209@git.kernel.org>
Git-Commit-ID: 9b7b89efa3bdaceaa2efb93e2d635391835da209
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 03 Apr 2009 17:51:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9b7b89efa3bdaceaa2efb93e2d635391835da209
Gitweb:     http://git.kernel.org/tip/9b7b89efa3bdaceaa2efb93e2d635391835da209
Author:     Joseph Cihula <joseph.cihula@intel.com>
AuthorDate: Mon, 30 Mar 2009 14:03:01 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 3 Apr 2009 19:48:41 +0200

x86: disable stack-protector for __restore_processor_state()

The __restore_processor_state() fn restores %gs on resume from S3.  As
such, it cannot be protected by the stack-protector guard since %gs will
not be correct on function entry.

There are only a few other fns in this file and it should not negatively
impact kernel security that they will also have the stack-protector
guard removed (and so it's not worth moving them to another file).

Without this change, S3 resume on a kernel built with
CONFIG_CC_STACKPROTECTOR_ALL=y will fail.

Signed-off-by: Joseph Cihula <joseph.cihula@intel.com>
Tested-by: Chris Wright <chrisw@sous-sol.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Tejun Heo <tj@kernel.org>
LKML-Reference: <49D13385.5060900@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/power/Makefile |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/power/Makefile b/arch/x86/power/Makefile
index 9ff4d5b..58b32db 100644
--- a/arch/x86/power/Makefile
+++ b/arch/x86/power/Makefile
@@ -1,2 +1,7 @@
+# __restore_processor_state() restores %gs after S3 resume and so should not
+# itself be stack-protected
+nostackp := $(call cc-option, -fno-stack-protector)
+CFLAGS_cpu_$(BITS).o	:= $(nostackp)
+
 obj-$(CONFIG_PM_SLEEP)		+= cpu_$(BITS).o
 obj-$(CONFIG_HIBERNATION)	+= hibernate_$(BITS).o hibernate_asm_$(BITS).o
