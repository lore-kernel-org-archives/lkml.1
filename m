Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbYGLICI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbYGLICI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 04:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYGLIB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 04:01:56 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:21404 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbYGLIBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 04:01:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=NabUUzf+rNS/8i6SvB8Dbs+aQy1xFiJMAGnRJdXTjDMmPhRwntETnuE1Z8S0cUryBB
         jhG2muQTNK2Su2cHRkRzQhCYKAGbFj630zHugDm9PJ/OQ4HiXcHtp2BvQDWLBhfLrc6e
         9QxoFHfkEPBgm52QLCmpgyGh8tKtab7oDPbJQ=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH] x86: make 64bit have get_apic_id
Date: Sat, 12 Jul 2008 01:01:20 -0700
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807111843.11157.yhlu.kernel@gmail.com> <200807111844.17084.yhlu.kernel@gmail.com>
In-Reply-To: <200807111844.17084.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807120101.20554.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


and read_apic_id become macro
GET_APIC_ID(apic_read(APIC_ID))

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/genapic_flat_64.c           |   26 +++++++++++++++++++++++---
 arch/x86/kernel/genx2apic_cluster.c         |   20 +++++++++++++++++++-
 arch/x86/kernel/genx2apic_phys.c            |   20 +++++++++++++++++++-
 arch/x86/kernel/genx2apic_uv_x.c            |   23 ++++++++++++++++++++---
 include/asm-x86/genapic_64.h                |    4 +++-
 include/asm-x86/mach-default/mach_apic.h    |    2 +-
 include/asm-x86/mach-default/mach_apicdef.h |    6 +++---
 7 files changed, 88 insertions(+), 13 deletions(-)

Index: linux-2.6/arch/x86/kernel/genapic_flat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genapic_flat_64.c
+++ linux-2.6/arch/x86/kernel/genapic_flat_64.c
@@ -97,11 +97,27 @@ static void flat_send_IPI_all(int vector
 		__send_IPI_shortcut(APIC_DEST_ALLINC, vector, APIC_DEST_LOGICAL);
 }
 
+static unsigned int get_apic_id(unsigned long x)
+{
+	unsigned int id;
+
+	id = (((x)>>24) & 0xFFu);
+	return id;
+}
+
+static unsigned long set_apic_id(unsigned int id)
+{
+	unsigned long x;
+
+	x = ((id & 0xFFu)<<24);
+	return x;
+}
+
 static unsigned int read_xapic_id(void)
 {
 	unsigned int id;
 
-	id = GET_APIC_ID(apic_read(APIC_ID));
+	id = get_apic_id(apic_read(APIC_ID));
 	return id;
 }
 
@@ -134,7 +150,9 @@ struct genapic apic_flat =  {
 	.send_IPI_self = apic_send_IPI_self,
 	.cpu_mask_to_apicid = flat_cpu_mask_to_apicid,
 	.phys_pkg_id = phys_pkg_id,
-	.read_apic_id = read_xapic_id,
+	.get_apic_id = get_apic_id,
+	.set_apic_id = set_apic_id,
+	.apic_id_mask = (0xFFu<<24),
 };
 
 /*
@@ -200,5 +218,7 @@ struct genapic apic_physflat =  {
 	.send_IPI_self = apic_send_IPI_self,
 	.cpu_mask_to_apicid = physflat_cpu_mask_to_apicid,
 	.phys_pkg_id = phys_pkg_id,
-	.read_apic_id = read_xapic_id,
+	.get_apic_id = get_apic_id,
+	.set_apic_id = set_apic_id,
+	.apic_id_mask = (0xFFu<<24),
 };
Index: linux-2.6/arch/x86/kernel/genx2apic_cluster.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genx2apic_cluster.c
+++ linux-2.6/arch/x86/kernel/genx2apic_cluster.c
@@ -94,6 +94,22 @@ static unsigned int x2apic_cpu_mask_to_a
 		return BAD_APICID;
 }
 
+static unsigned int get_apic_id(unsigned long x)
+{
+	unsigned int id;
+
+	id = x;
+	return id;
+}
+
+static unsigned long set_apic_id(unsigned int id)
+{
+	unsigned long x;
+
+	x = id;
+	return x;
+}
+
 static unsigned int x2apic_read_id(void)
 {
 	return apic_read(APIC_ID);
@@ -131,5 +147,7 @@ struct genapic apic_x2apic_cluster = {
 	.send_IPI_self = x2apic_send_IPI_self,
 	.cpu_mask_to_apicid = x2apic_cpu_mask_to_apicid,
 	.phys_pkg_id = phys_pkg_id,
-	.read_apic_id = x2apic_read_id,
+	.get_apic_id = get_apic_id,
+	.set_apic_id = set_apic_id,
+	.apic_id_mask = (0xFFFFFFFFu),
 };
Index: linux-2.6/arch/x86/kernel/genx2apic_phys.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genx2apic_phys.c
+++ linux-2.6/arch/x86/kernel/genx2apic_phys.c
@@ -84,6 +84,22 @@ static unsigned int x2apic_cpu_mask_to_a
 		return BAD_APICID;
 }
 
+static unsigned int get_apic_id(unsigned long x)
+{
+	unsigned int id;
+
+	id = x;
+	return id;
+}
+
+static unsigned long set_apic_id(unsigned int id)
+{
+	unsigned long x;
+
+	x = id;
+	return x;
+}
+
 static unsigned int x2apic_read_id(void)
 {
 	return apic_read(APIC_ID);
@@ -118,5 +134,7 @@ struct genapic apic_x2apic_phys = {
 	.send_IPI_self = x2apic_send_IPI_self,
 	.cpu_mask_to_apicid = x2apic_cpu_mask_to_apicid,
 	.phys_pkg_id = phys_pkg_id,
-	.read_apic_id = x2apic_read_id,
+	.get_apic_id = get_apic_id,
+	.set_apic_id = set_apic_id,
+	.apic_id_mask = (0xFFFFFFFFu),
 };
Index: linux-2.6/arch/x86/kernel/genx2apic_uv_x.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/genx2apic_uv_x.c
+++ linux-2.6/arch/x86/kernel/genx2apic_uv_x.c
@@ -139,16 +139,31 @@ static unsigned int uv_cpu_mask_to_apici
 		return BAD_APICID;
 }
 
-static unsigned int uv_read_apic_id(void)
+static unsigned int get_apic_id(unsigned long x)
 {
 	unsigned int id;
 
 	WARN_ON(preemptible() && num_online_cpus() > 1);
-	id = apic_read(APIC_ID) | __get_cpu_var(x2apic_extra_bits);
+	id = x | __get_cpu_var(x2apic_extra_bits);
 
 	return id;
 }
 
+static long set_apic_id(unsigned int id)
+{
+	unsigned long x;
+
+	/* maskout x2apic_extra_bits ? */
+	x = id;
+	return x;
+}
+
+static unsigned int uv_read_apic_id(void)
+{
+
+	return get_apic_id(apic_read(APIC_ID));
+}
+
 static unsigned int phys_pkg_id(int index_msb)
 {
 	return uv_read_apic_id() >> index_msb;
@@ -175,7 +190,9 @@ struct genapic apic_x2apic_uv_x = {
 	/* ZZZ.send_IPI_self = uv_send_IPI_self, */
 	.cpu_mask_to_apicid = uv_cpu_mask_to_apicid,
 	.phys_pkg_id = phys_pkg_id,	/* Fixme ZZZ */
-	.read_apic_id = uv_read_apic_id,
+	.get_apic_id = get_apic_id,
+	.set_apic_id = set_apic_id,
+	.apic_id_mask = (0xFFFFFFFFu),
 };
 
 static __cpuinit void set_x2apic_extra_bits(int pnode)
Index: linux-2.6/include/asm-x86/genapic_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/genapic_64.h
+++ linux-2.6/include/asm-x86/genapic_64.h
@@ -28,7 +28,9 @@ struct genapic {
 	/* */
 	unsigned int (*cpu_mask_to_apicid)(cpumask_t cpumask);
 	unsigned int (*phys_pkg_id)(int index_msb);
-	unsigned int (*read_apic_id)(void);
+	unsigned int (*get_apic_id)(unsigned long x);
+	unsigned long (*set_apic_id)(unsigned int id);
+	unsigned long apic_id_mask;
 };
 
 extern struct genapic *genapic;
Index: linux-2.6/include/asm-x86/mach-default/mach_apic.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-default/mach_apic.h
+++ linux-2.6/include/asm-x86/mach-default/mach_apic.h
@@ -30,7 +30,7 @@ static inline cpumask_t target_cpus(void
 #define cpu_mask_to_apicid (genapic->cpu_mask_to_apicid)
 #define phys_pkg_id	(genapic->phys_pkg_id)
 #define vector_allocation_domain    (genapic->vector_allocation_domain)
-#define read_apic_id  (genapic->read_apic_id)
+#define read_apic_id()  (GET_APIC_ID(apic_read(APIC_ID)))
 #define send_IPI_self (genapic->send_IPI_self)
 extern void setup_apic_routing(void);
 #else
Index: linux-2.6/include/asm-x86/mach-default/mach_apicdef.h
===================================================================
--- linux-2.6.orig/include/asm-x86/mach-default/mach_apicdef.h
+++ linux-2.6/include/asm-x86/mach-default/mach_apicdef.h
@@ -4,9 +4,9 @@
 #include <asm/apic.h>
 
 #ifdef CONFIG_X86_64
-#define	APIC_ID_MASK		(0xFFu<<24)
-#define GET_APIC_ID(x)		(((x)>>24) & 0xFFu)
-#define	SET_APIC_ID(x)		(((x)<<24))
+#define	APIC_ID_MASK		(genapic->apic_id_mask)
+#define GET_APIC_ID(x)		(genapic->get_apic_id(x))
+#define	SET_APIC_ID(x)		(genapic->set_apic_id(x))
 #else
 #define		APIC_ID_MASK		(0xF<<24)
 static inline unsigned get_apic_id(unsigned long x) 
