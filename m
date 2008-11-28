Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbYK1Qfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbYK1Qfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 11:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYK1QfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 11:35:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:38956 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbYK1QfI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 11:35:08 -0500
Date: Fri, 28 Nov 2008 08:36:09 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>, akpm@linux-foundation.org,
       mingo@elte.hu
Subject: [PATCH 2/2] warn: print the DMI board info name in a WARN/WARN_ON
Message-ID: <20081128083609.2a254c06@linux.intel.com>
In-Reply-To: <20081128083525.092e9859@linux.intel.com>
References: <20081128083525.092e9859@linux.intel.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From acdc8771dfaf6e8236b9122364301f65f46d4b59 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 28 Nov 2008 08:32:44 -0800
Subject: [PATCH] warn: print the DMI board info name in a WARN/WARN_ON

it's very useful for many low level WARN_ON's to find out which
motherboard has the broken BIOS etc... this patch adds a printk
to the WARN_ON code for this.
On architectures without DMI, gcc should optimize the code out.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/panic.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 2b913aa..9c1b7e0 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -21,6 +21,7 @@
 #include <linux/debug_locks.h>
 #include <linux/random.h>
 #include <linux/kallsyms.h>
+#include <linux/dmi.h>
 
 int panic_on_oops;
 static unsigned long tainted_mask;
@@ -328,12 +329,16 @@ void warn_slowpath(const char *file, int line, const char *fmt, ...)
 {
 	va_list args;
 	char function[KSYM_SYMBOL_LEN];
+	const char *board;
 	unsigned long caller = (unsigned long)__builtin_return_address(0);
 	sprint_symbol(function, caller);
 
 	printk(KERN_WARNING "------------[ cut here ]------------\n");
 	printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
 		line, function);
+	board = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (board)
+		printk(KERN_WARNING "Hardware name: %s\n", board);
 
 	if (fmt) {
 		va_start(args, fmt);
-- 
1.6.0.4




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
