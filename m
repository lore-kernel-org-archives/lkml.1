Return-Path: <linux-kernel-owner+w=401wt.eu-S1760423AbZF3XSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760423AbZF3XSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759653AbZF3XRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:17:21 -0400
Received: from ozlabs.org ([203.10.76.45]:39649 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757890AbZF3XRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:17:19 -0400
Message-Id: <20090630230141.182536873@samba.org>
References: <20090630230043.464194676@samba.org>
User-Agent: quilt/0.46-1
Date: Wed, 01 Jul 2009 09:00:49 +1000
From: Anton Blanchard <anton@samba.org>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [patch 6/8] perf report: Add hypervisor dso
Content-Disposition: inline; filename=pcl_fix_add_hypervisor_dso.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a dso for hypervisor samples. We don't get any symbol information on
the ppc64 hypervisor but this at least gives us a high level summary of the
time spent in there.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6-tip/tools/perf/builtin-report.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/builtin-report.c	2009-07-01 08:21:39.000000000 +1000
+++ linux-2.6-tip/tools/perf/builtin-report.c	2009-07-01 08:21:43.000000000 +1000
@@ -118,6 +118,7 @@
 static LIST_HEAD(dsos);
 static struct dso *kernel_dso;
 static struct dso *vdso;
+static struct dso *hypervisor_dso;
 
 static void dsos__add(struct dso *dso)
 {
@@ -199,6 +200,11 @@
 
 	dsos__add(vdso);
 
+	hypervisor_dso = dso__new("[hypervisor]", 0);
+	if (!hypervisor_dso)
+		return -1;
+	dsos__add(hypervisor_dso);
+
 	return err;
 }
 
@@ -637,7 +643,8 @@
 
 	if (self->sym) {
 		ret += fprintf(fp, "[%c] %s",
-			self->dso == kernel_dso ? 'k' : '.', self->sym->name);
+			self->dso == kernel_dso ? 'k' :
+			self->dso == hypervisor_dso ? 'h' : '.', self->sym->name);
 	} else {
 		ret += fprintf(fp, "%#016llx", (u64)self->ip);
 	}
@@ -960,6 +967,9 @@
 			}
 
 			switch (context) {
+			case PERF_CONTEXT_HV:
+				dso = hypervisor_dso;
+				break;
 			case PERF_CONTEXT_KERNEL:
 				dso = kernel_dso;
 				break;
@@ -1269,6 +1279,9 @@
 	} else {
 		show = SHOW_HV;
 		level = 'H';
+
+		dso = hypervisor_dso;
+
 		dprintf(" ...... dso: [hypervisor]\n");
 	}
 

-- 

