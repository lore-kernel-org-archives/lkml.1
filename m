Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbZETHln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbZETHln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756300AbZETHkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:40:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:42091 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249AbZETHkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:40:53 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, x86@kernel.org,
       ink@jurassic.park.msu.ru, rth@twiddle.net, linux@arm.linux.org.uk,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       jesper.nilsson@axis.com, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, takata@linux-m32r.org,
       geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org,
       kyle@mcmartin.ca, benh@kernel.crashing.org, paulus@samba.org,
       schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, lethal@linux-sh.org,
       davem@davemloft.net, jdike@addtoit.com, chris@zankel.net,
       rusty@rustcorp.com.au
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/7] percpu: enforce global uniqueness and disallow in-function statics
Date: Wed, 20 May 2009 16:37:36 +0900
Message-Id: <1242805059-18338-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1242805059-18338-1-git-send-email-tj@kernel.org>
References: <1242805059-18338-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 20 May 2009 07:38:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some archs (alpha and s390) need to add 'weak' attribute to percpu
variable definitions so that the compiler generates external
references for them.  To allow this, all percpu variables should be
unique regardless of scope and in-function static definitions can't be
allowed.

This patch updates DECLARE_PER_CPU_SECTION() and
DEFINE_PER_CPU_SECTION() such that percpu symbol itself is always
defined global so that weak can be added via PER_CPU_ATTRIBUTES.  The
scope and uniqueness rules are enforced using two dummy variables,
both of which are thrown away during linking.  The multiline
definition combined with section specification prevents in-function
static definitions.

This patch is inspired by Ivan Kokshaysky's alpha percpu patch.

[ Impact: stricter rules for percpu variable definitions ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Howells <dhowells@redhat.com>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 include/linux/percpu-defs.h |   34 +++++++++++++++++++++++++---------
 1 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index 8f921d7..6ff4fc1 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -10,21 +10,37 @@
 /*
  * Base implementations of per-CPU variable declarations and definitions, where
  * the section in which the variable is to be placed is provided by the
- * 'section' argument.  This may be used to affect the parameters governing the
+ * 'sec' argument.  This may be used to affect the parameters governing the
  * variable's storage.
  *
+ * Percpu variable declaration and definition decouple scope (static or extern)
+ * specification from the actual percpu variable and use two dummy variables
+ * to ensure DECLARE_PER_CPU_SECTION() is not coupled with static definition
+ * and each percpu symbol is unique regardless of scope.  This is for archs
+ * which need to add 'weak' attribute to per cpu variables to force the
+ * compiler to generate external references for percpu variables (alpha and
+ * s390).  This also means that in-function static percpu variables aren't
+ * allowed.
+ *
  * NOTE!  The sections for the DECLARE and for the DEFINE must match, lest
  * linkage errors occur due the compiler generating the wrong code to access
  * that section.
  */
-#define DECLARE_PER_CPU_SECTION(type, name, section)			\
-	extern								\
-	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
-	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
-
-#define DEFINE_PER_CPU_SECTION(type, name, section)			\
-	__attribute__((__section__(PER_CPU_BASE_SECTION section)))	\
-	PER_CPU_ATTRIBUTES __typeof__(type) per_cpu__##name
+#define __PCPU_ATTRS(sec)						\
+	__attribute__((section(PER_CPU_BASE_SECTION sec)))		\
+	PER_CPU_ATTRIBUTES
+
+#define __PCPU_DUMMY_ATTRS						\
+	__attribute__((section(".discard"), unused))
+
+#define DECLARE_PER_CPU_SECTION(type, name, sec)			\
+	extern __PCPU_DUMMY_ATTRS char __pcpu_scope_##name;		\
+	extern __PCPU_ATTRS(sec) __typeof__(type) per_cpu__##name
+
+#define DEFINE_PER_CPU_SECTION(type, name, sec)				\
+	__PCPU_DUMMY_ATTRS char __pcpu_scope_##name;			\
+	__PCPU_DUMMY_ATTRS char __pcpu_unique_##name;			\
+	__PCPU_ATTRS(sec) __typeof__(type) per_cpu__##name
 
 /*
  * Variant on the per-CPU variable declaration/definition theme used for
-- 
1.6.0.2

