Return-Path: <linux-kernel-owner+w=401wt.eu-S1767302AbXDTWxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767302AbXDTWxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 18:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767307AbXDTWxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 18:53:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33491 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767302AbXDTWxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 18:53:51 -0400
Message-ID: <4629447D.5030900@redhat.com>
Date: Fri, 20 Apr 2007 18:53:49 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Andi Kleen <ak@suse.de>
Subject: [RFC PATCH 2/3] x86: new API for modifying CPU feature flags
References: <4629438C.4070209@redhat.com>
In-Reply-To: <4629438C.4070209@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------050605090201010105080605"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050605090201010105080605
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------050605090201010105080605
Content-Type: text/plain;
 name="x86_cpufeature_api.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x86_cpufeature_api.patch"

x86: new API for modifying CPU feature flags

Use an API for setting/clearing CPU features, so the
process can be debugged.

Adds:
set_cpu_feature()
clear_cpu_feature()
clear_all_cpu_features()

Todo:
mask_boot_cpu_features()
set_cpu_feature_word()
more?

(Hardcoded printk for now, should be dprintk.)

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
---
 include/asm-i386/cpufeature.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- 2.6.21-rc7-d390.orig/include/asm-i386/cpufeature.h
+++ 2.6.21-rc7-d390/include/asm-i386/cpufeature.h
@@ -108,6 +108,23 @@
 #define cpu_has(c, bit)		test_bit(bit, (c)->x86_capability)
 #define boot_cpu_has(bit)	test_bit(bit, boot_cpu_data.x86_capability)
 
+#define alter_cpu_feature(fn, feat, c) \
+		do {    typeof(c) __c = (c); \
+			printk("CPU: %s: %s feature %s for CPU %p", \
+				__func__, #fn, #feat, __c); \
+			fn ## _bit(X86_FEATURE_ ## feat, __c->x86_capability); \
+		} while (0)
+
+#define set_cpu_feature(f, c)	alter_cpu_feature(set, f, c)
+#define clear_cpu_feature(f, c)	alter_cpu_feature(clear, f, c)
+
+#define clear_all_cpu_features(c) \
+		do {    typeof(c) __c = (c); \
+			printk("CPU: %s: clearing all capabilities for CPU %p", \
+				__func__, __c); \
+			memset(&__c->x86_capability, 0, sizeof __c->x86_capability); \
+		} while (0)
+
 #define cpu_has_fpu		boot_cpu_has(X86_FEATURE_FPU)
 #define cpu_has_vme		boot_cpu_has(X86_FEATURE_VME)
 #define cpu_has_de		boot_cpu_has(X86_FEATURE_DE)

--------------050605090201010105080605--
