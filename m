Return-Path: <linux-kernel-owner+w=401wt.eu-S1755553AbZKIRJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbZKIRJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 12:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755169AbZKIRJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 12:09:05 -0500
Received: from relay3.sgi.com ([192.48.152.1]:36190 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755050AbZKIRJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 12:09:01 -0500
From: Robin Holt <holt@sgi.com>
Message-Id: <20091109170905.861066000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 09 Nov 2009 11:08:56 -0600
To: Ingo Molnar <mingo@elte.hu>
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [patch 2/6] x86: UV - XPC needs to provide an abstraction for uv_gpa.
References: <20091109170854.161447000@alcatraz.americas.sgi.com>
Content-Disposition: inline; filename=xpc_introduce_xp_socket_pa
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Provide an SGI SN2/UV agnositic method for converting a global physical
address into a socket physical address.

To: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>

---

 drivers/misc/sgi-xp/xp.h      |    1 +
 drivers/misc/sgi-xp/xp_main.c |    3 +++
 drivers/misc/sgi-xp/xp_sn2.c  |   10 ++++++++++
 drivers/misc/sgi-xp/xp_uv.c   |   10 ++++++++++
 4 files changed, 24 insertions(+)
Index: linux-2.6.27/drivers/misc/sgi-xp/xp.h
===================================================================
--- linux-2.6.27.orig/drivers/misc/sgi-xp/xp.h	2009-10-29 10:15:58.000000000 -0500
+++ linux-2.6.27/drivers/misc/sgi-xp/xp.h	2009-10-29 16:19:25.000000000 -0500
@@ -339,6 +339,7 @@ extern short xp_partition_id;
 extern u8 xp_region_size;
 
 extern unsigned long (*xp_pa) (void *);
+extern unsigned long (*xp_socket_pa) (unsigned long);
 extern enum xp_retval (*xp_remote_memcpy) (unsigned long, const unsigned long,
 		       size_t);
 extern int (*xp_cpu_to_nasid) (int);
Index: linux-2.6.27/drivers/misc/sgi-xp/xp_main.c
===================================================================
--- linux-2.6.27.orig/drivers/misc/sgi-xp/xp_main.c	2009-10-29 09:16:19.000000000 -0500
+++ linux-2.6.27/drivers/misc/sgi-xp/xp_main.c	2009-10-29 16:20:01.000000000 -0500
@@ -44,6 +44,9 @@ EXPORT_SYMBOL_GPL(xp_region_size);
 unsigned long (*xp_pa) (void *addr);
 EXPORT_SYMBOL_GPL(xp_pa);
 
+unsigned long (*xp_socket_pa) (unsigned long gpa);
+EXPORT_SYMBOL_GPL(xp_socket_pa);
+
 enum xp_retval (*xp_remote_memcpy) (unsigned long dst_gpa,
 				    const unsigned long src_gpa, size_t len);
 EXPORT_SYMBOL_GPL(xp_remote_memcpy);
Index: linux-2.6.27/drivers/misc/sgi-xp/xp_sn2.c
===================================================================
--- linux-2.6.27.orig/drivers/misc/sgi-xp/xp_sn2.c	2009-10-29 09:16:11.000000000 -0500
+++ linux-2.6.27/drivers/misc/sgi-xp/xp_sn2.c	2009-10-29 16:21:18.000000000 -0500
@@ -84,6 +84,15 @@ xp_pa_sn2(void *addr)
 }
 
 /*
+ * Convert a global physical to a socket physical address.
+ */
+static unsigned long
+xp_socket_pa_sn2(unsigned long gpa)
+{
+	return gpa;
+}
+
+/*
  * Wrapper for bte_copy().
  *
  *	dst_pa - physical address of the destination of the transfer.
@@ -162,6 +171,7 @@ xp_init_sn2(void)
 	xp_region_size = sn_region_size;
 
 	xp_pa = xp_pa_sn2;
+	xp_socket_pa = xp_socket_pa_sn2;
 	xp_remote_memcpy = xp_remote_memcpy_sn2;
 	xp_cpu_to_nasid = xp_cpu_to_nasid_sn2;
 	xp_expand_memprotect = xp_expand_memprotect_sn2;
Index: linux-2.6.27/drivers/misc/sgi-xp/xp_uv.c
===================================================================
--- linux-2.6.27.orig/drivers/misc/sgi-xp/xp_uv.c	2009-10-29 16:15:05.000000000 -0500
+++ linux-2.6.27/drivers/misc/sgi-xp/xp_uv.c	2009-10-29 16:24:56.000000000 -0500
@@ -32,6 +32,15 @@ xp_pa_uv(void *addr)
 	return uv_gpa(addr);
 }
 
+/*
+ * Convert a global physical to socket physical address.
+ */
+static unsigned long
+xp_socket_pa_uv(unsigned long gpa)
+{
+	return uv_gpa_to_soc_phys_ram(gpa);
+}
+
 static enum xp_retval
 xp_remote_memcpy_uv(unsigned long dst_gpa, const unsigned long src_gpa,
 		    size_t len)
@@ -123,6 +132,7 @@ xp_init_uv(void)
 	xp_region_size = sn_region_size;
 
 	xp_pa = xp_pa_uv;
+	xp_socket_pa = xp_socket_pa_uv;
 	xp_remote_memcpy = xp_remote_memcpy_uv;
 	xp_cpu_to_nasid = xp_cpu_to_nasid_uv;
 	xp_expand_memprotect = xp_expand_memprotect_uv;

