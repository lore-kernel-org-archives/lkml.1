Return-Path: <linux-kernel-owner+w=401wt.eu-S1764645AbYHHWk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764645AbYHHWk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYHHWkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:40:49 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:41729 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbYHHWks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:40:48 -0400
Subject: Re: [PATCH 2/2] Repost  Cell OProfile: SPU mutex lock fix, version
	4
From: Carl Love <cel@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, cel <cel@linux.vnet.ibm.com>,
       cbe-oss-dev@ozlabs.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200808081526.21405.arnd@arndb.de>
References: <1217620879.15667.145.camel@carll-linux-desktop>
	 <200808081526.21405.arnd@arndb.de>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 15:39:44 -0700
Message-Id: <1218235184.6637.111.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated to address Arnd's comments.

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
@@ -38,8 +38,10 @@ void free_cpu_buffers(void)
 {
 	int i;
 
-	for_each_online_cpu(i)
+	for_each_online_cpu(i) {
 		vfree(per_cpu(cpu_buffer, i).buffer);
+		per_cpu(cpu_buffer, i).buffer = NULL;
+	}
 }
 
 unsigned long oprofile_get_cpu_buffer_size(void)
Index: Cell_kernel_6_26_2008/drivers/oprofile/event_buffer.c
===================================================================
--- Cell_kernel_6_26_2008.orig/drivers/oprofile/event_buffer.c
+++ Cell_kernel_6_26_2008/drivers/oprofile/event_buffer.c
@@ -93,6 +93,8 @@ out:
 void free_event_buffer(void)
 {
 	vfree(event_buffer);
+
+	event_buffer = NULL;
 }
 
  


