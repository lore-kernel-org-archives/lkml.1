Return-Path: <linux-kernel-owner+w=401wt.eu-S932433AbXB1Xra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbXB1Xra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 18:47:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932280AbXB1Xra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 18:47:30 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50634 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932165AbXB1Xr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 18:47:29 -0500
From: John Keller <jpk@sgi.com>
To: linux-acpi@vger.kernel.org
Cc: ayoung@sgi.com, linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Keller <jpk@sgi.com>
Date: Wed, 28 Feb 2007 17:47:27 -0600
Message-Id: <20070228234727.11369.38394.sendpatchset@attica.americas.sgi.com>
Subject: [PATCH 1/1] - Altix: reinitialize acpi tables
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

To provide compatibilty with SN kernels that do and do not
have ACPI IO support, the SN PROM must build different
versions of some ACPI tables based on which kernel is booting.
As such, the tables may have to change at kernel boot time.
By default, prior to kernel boot, the PROM builds an empty
DSDT (header only) and no SSDTs. If an ACPI capable kernel
boots, the kernel will notify the PROM, at platform setup time,
and the PROM will build full DSDT and SSDT tables.

With the latest changes to acpi_table_init(), the table lengths
are saved, and when our PROM changes them, the changes are not seen,
and the kernel will crash on boot. Because of issues with kexec support,
we are not able to create the tables prior to acpi_table_init().
As a result, we are making a second call to acpi_table_init() to
process the rebuilt DSDT and SSDTs.

Signed-off-by: John Keller <jpk@sgi.com>
---


Index: release/arch/ia64/sn/kernel/setup.c
===================================================================
--- release.orig/arch/ia64/sn/kernel/setup.c	2007-02-28 11:02:34.558139870 -0600
+++ release/arch/ia64/sn/kernel/setup.c	2007-02-28 11:02:39.362737953 -0600
@@ -397,6 +397,8 @@ void __init sn_setup(char **cmdline_p)
 	ia64_sn_set_os_feature(OSF_PCISEGMENT_ENABLE);
 	ia64_sn_set_os_feature(OSF_ACPI_ENABLE);
 
+	/* Load the new DSDT and SSDT tables into the global table list. */
+ 	acpi_table_init();
 
 #if defined(CONFIG_VT) && defined(CONFIG_VGA_CONSOLE)
 	/*
