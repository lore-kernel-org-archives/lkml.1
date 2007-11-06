Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbXKFSs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbXKFSs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754178AbXKFSsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:48:19 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:45808 "EHLO
	outbound1-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753707AbXKFSsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:48:18 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Message-ID: <20071106183646.338940000@amd.com>
References: <20071106183645.951275000@amd.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 19:36:49 +0100
From: "Robert Richter" <robert.richter@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
cc: "Robert Richter" <robert.richter@amd.com>
Subject: [patch 4/6] x86: apicdef unification: CONFIG_X86_32 checks
 added
X-OriginalArrivalTime: 06 Nov 2007 18:47:57.0964 (UTC)
 FILETIME=[8C8A84C0:01C820A5]
MIME-Version: 1.0
X-WSS-ID: 6B2E696824S1590819-01-01
Content-Disposition: inline;
 filename="apicdef/0004-apicdef-CONFIG_X86_32-checks-added.patch"
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 include/asm-x86/apicdef_32.h |   28 ++++++++++++++++++++++++++++
 include/asm-x86/apicdef_64.h |   11 +++++++++++
 2 files changed, 39 insertions(+), 0 deletions(-)

Index: linux-perfmon/include/asm-x86/apicdef_32.h
===================================================================
--- linux-perfmon.orig/include/asm-x86/apicdef_32.h
+++ linux-perfmon/include/asm-x86/apicdef_32.h
@@ -11,12 +11,19 @@
 #define		APIC_DEFAULT_PHYS_BASE	0xfee00000
  
 #define		APIC_ID		0x20
+#ifndef CONFIG_X86_32
+#define			APIC_ID_MASK		(0xFFu<<24)
+#define			GET_APIC_ID(x)		(((x)>>24)&0xFFu)
+#define			SET_APIC_ID(x)		(((x)<<24))
+#endif
 #define		APIC_LVR	0x30
 #define			APIC_LVR_MASK		0xFF00FF
 #define			GET_APIC_VERSION(x)	((x)&0xFFu)
 #define			GET_APIC_MAXLVT(x)	(((x)>>16)&0xFFu)
 #define			APIC_INTEGRATED(x)	((x)&0xF0u)
+#ifdef CONFIG_X86_32
 #define			APIC_XAPIC(x)		((x) >= 0x14)
+#endif
 #define		APIC_TASKPRI	0x80
 #define			APIC_TPRI_MASK		0xFFu
 #define		APIC_ARBPRI	0x90
@@ -60,6 +67,9 @@
 #define			APIC_INT_ASSERT		0x04000
 #define			APIC_ICR_BUSY		0x01000
 #define			APIC_DEST_LOGICAL	0x00800
+#ifndef CONFIG_X86_32
+#define			APIC_DEST_PHYSICAL	0x00000
+#endif
 #define			APIC_DM_FIXED		0x00000
 #define			APIC_DM_LOWEST		0x00100
 #define			APIC_DM_SMI		0x00200
@@ -111,7 +121,25 @@
 
 #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
 
+#ifdef CONFIG_X86_32
 #define MAX_IO_APICS 64
+#else
+#define MAX_IO_APICS 128
+#define MAX_LOCAL_APIC 256
+#define BAD_APICID 0xFFu
+
+/*
+ * All x86-64 systems are xAPIC compatible.
+ * In the following, "apicid" is a physical APIC ID.
+ */
+#define XAPIC_DEST_CPUS_SHIFT	4
+#define XAPIC_DEST_CPUS_MASK	((1u << XAPIC_DEST_CPUS_SHIFT) - 1)
+#define XAPIC_DEST_CLUSTER_MASK	(XAPIC_DEST_CPUS_MASK << XAPIC_DEST_CPUS_SHIFT)
+#define APIC_CLUSTER(apicid)	((apicid) & XAPIC_DEST_CLUSTER_MASK)
+#define APIC_CLUSTERID(apicid)	(APIC_CLUSTER(apicid) >> XAPIC_DEST_CPUS_SHIFT)
+#define APIC_CPUID(apicid)	((apicid) & XAPIC_DEST_CPUS_MASK)
+#define NUM_APIC_CLUSTERS	((BAD_APICID + 1) >> XAPIC_DEST_CPUS_SHIFT)
+#endif
 
 /*
  * the local APIC register structure, memory mapped. Not terribly well
Index: linux-perfmon/include/asm-x86/apicdef_64.h
===================================================================
--- linux-perfmon.orig/include/asm-x86/apicdef_64.h
+++ linux-perfmon/include/asm-x86/apicdef_64.h
@@ -11,14 +11,19 @@
 #define		APIC_DEFAULT_PHYS_BASE	0xfee00000
  
 #define		APIC_ID		0x20
+#ifndef CONFIG_X86_32
 #define			APIC_ID_MASK		(0xFFu<<24)
 #define			GET_APIC_ID(x)		(((x)>>24)&0xFFu)
 #define			SET_APIC_ID(x)		(((x)<<24))
+#endif
 #define		APIC_LVR	0x30
 #define			APIC_LVR_MASK		0xFF00FF
 #define			GET_APIC_VERSION(x)	((x)&0xFFu)
 #define			GET_APIC_MAXLVT(x)	(((x)>>16)&0xFFu)
 #define			APIC_INTEGRATED(x)	((x)&0xF0u)
+#ifdef CONFIG_X86_32
+#define			APIC_XAPIC(x)		((x) >= 0x14)
+#endif
 #define		APIC_TASKPRI	0x80
 #define			APIC_TPRI_MASK		0xFFu
 #define		APIC_ARBPRI	0x90
@@ -62,7 +67,9 @@
 #define			APIC_INT_ASSERT		0x04000
 #define			APIC_ICR_BUSY		0x01000
 #define			APIC_DEST_LOGICAL	0x00800
+#ifndef CONFIG_X86_32
 #define			APIC_DEST_PHYSICAL	0x00000
+#endif
 #define			APIC_DM_FIXED		0x00000
 #define			APIC_DM_LOWEST		0x00100
 #define			APIC_DM_SMI		0x00200
@@ -114,6 +121,9 @@
 
 #define APIC_BASE (fix_to_virt(FIX_APIC_BASE))
 
+#ifdef CONFIG_X86_32
+#define MAX_IO_APICS 64
+#else
 #define MAX_IO_APICS 128
 #define MAX_LOCAL_APIC 256
 #define BAD_APICID 0xFFu
@@ -129,6 +139,7 @@
 #define APIC_CLUSTERID(apicid)	(APIC_CLUSTER(apicid) >> XAPIC_DEST_CPUS_SHIFT)
 #define APIC_CPUID(apicid)	((apicid) & XAPIC_DEST_CPUS_MASK)
 #define NUM_APIC_CLUSTERS	((BAD_APICID + 1) >> XAPIC_DEST_CPUS_SHIFT)
+#endif
 
 /*
  * the local APIC register structure, memory mapped. Not terribly well

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com



