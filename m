Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbZC3VD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbZC3VD0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755147AbZC3VDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:03:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:27119 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755307AbZC3VDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:03:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,448,1233561600"; 
   d="scan'208";a="502060048"
Message-ID: <49D13385.5060900@intel.com>
Date: Mon, 30 Mar 2009 14:03:01 -0700
From: Joseph Cihula <joseph.cihula@intel.com>
Reply-To: joseph.cihula@intel.com
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, arjan@linux.intel.com, mingo@elte.hu
Subject: [PATCH] x86: disable stack-protector for __restore_processor_state()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __restore_processor_state() fn restores %gs on resume from S3.  As
such, it cannot be protected by the stack-protector guard since %gs will
not be correct on function entry.

There are only a few other fns in this file and it should not negatively
impact kernel security that they will also have the stack-protector
guard removed (and so it's not worth moving them to another file).

Without this change, S3 resume on a kernel built with
CONFIG_CC_STACKPROTECTOR_ALL=y will fail.

Signed-off-by:  Joseph Cihula <joseph.cihula@intel.com>

--- ../linux.trees.git/arch/x86/power/Makefile	2009-03-29 
12:12:13.000000000 -0700
+++ arch/x86/power/Makefile	2009-03-30 12:21:19.000000000 -0700
@@ -1,2 +1,7 @@
+# __restore_processor_state() restores %gs after S3 resume and so 
should not
+# itself be stack-protected
+nostackp := $(call cc-option, -fno-stack-protector)
+CFLAGS_cpu_$(BITS).o	:= $(nostackp)
+
obj-$(CONFIG_PM_SLEEP)		+= cpu_$(BITS).o
obj-$(CONFIG_HIBERNATION)	+= hibernate_$(BITS).o hibernate_asm_$(BITS).o



