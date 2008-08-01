Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbYHAUDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbYHAUDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:03:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758676AbYHAUCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:02:41 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54907 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758579AbYHAUCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:02:40 -0400
Subject: [PATCH 2/2] Cell OProfile: SPU mutex lock fix, version 4
From: Carl Love <cel@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
       cel <cel@linux.vnet.ibm.com>, cbe-oss-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 13:01:19 -0700
Message-Id: <1217620879.15667.145.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If an error occurs on opcontrol start, the event and per cpu buffers 
are released.  If later opcontrol shutdown is called then the free
function will be called again to free buffers that no longer 
exist.  This results in a kernel oops.  The following changes
prevent the call to delete buffers that don't exist.

Signed-off-by: Carl Love <carll@us.ibm.com>

Index: Cell_kernel_6_26_2008/drivers/oprofile/cpu_buffer.c
===================================================================
--- Cell_kernel_6_26_2008.orig/drivers/oprofile/cpu_buffer.c
+++ Cell_kernel_6_26_2008/drivers/oprofile/cpu_buffer.c
@@ -38,8 +38,12 @@ void free_cpu_buffers(void)
 {
 	int i;
 
-	for_each_online_cpu(i)
-		vfree(per_cpu(cpu_buffer, i).buffer);
+	for_each_online_cpu(i) {
+		if (per_cpu(cpu_buffer, i).buffer) {
+			vfree(per_cpu(cpu_buffer, i).buffer);
+			per_cpu(cpu_buffer, i).buffer = NULL;
+		}
+	}
 }
 
 unsigned long oprofile_get_cpu_buffer_size(void)
Index: Cell_kernel_6_26_2008/drivers/oprofile/event_buffer.c
===================================================================
--- Cell_kernel_6_26_2008.orig/drivers/oprofile/event_buffer.c
+++ Cell_kernel_6_26_2008/drivers/oprofile/event_buffer.c
@@ -92,7 +92,10 @@ out:
 
 void free_event_buffer(void)
 {
-	vfree(event_buffer);
+	if (event_buffer)
+		vfree(event_buffer);
+
+	event_buffer = NULL;
 }
 
  


