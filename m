Return-Path: <linux-kernel-owner+w=401wt.eu-S1752973AbZIZSyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbZIZSyb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 14:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbZIZSy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 14:54:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:36404 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbZIZSyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 14:54:20 -0400
Date: Sat, 26 Sep 2009 20:53:36 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, mingo@elte.hu,
       jmorris@nami.org
Subject: [PATCH 7/9] Simplify bound checks in capabilities for
 copy_from_user
Message-ID: <20090926205336.77bc5b21@infradead.org>
In-Reply-To: <20090926204951.424e567e@infradead.org>
References: <20090926204951.424e567e@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 7/9] Simplify bound checks in capabilities for copy_from_user
CC: James Morris <jmorris@namei.org>

The capabilities syscall has a copy_from_user() call where gcc currently
cannot prove to itself that the copy is always within bounds.

This patch adds a very explicity bound check to prove to gcc that 
this copy_from_user cannot overflow its destination buffer.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

diff --git a/kernel/capability.c b/kernel/capability.c
index 4e17041..204f11f 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -238,7 +241,7 @@ SYSCALL_DEFINE2(capget, cap_user_header_t, header, cap_user_data_t, dataptr)
 SYSCALL_DEFINE2(capset, cap_user_header_t, header, const cap_user_data_t, data)
 {
 	struct __user_cap_data_struct kdata[_KERNEL_CAPABILITY_U32S];
-	unsigned i, tocopy;
+	unsigned i, tocopy, copybytes;
 	kernel_cap_t inheritable, permitted, effective;
 	struct cred *new;
 	int ret;
@@ -255,8 +258,11 @@ SYSCALL_DEFINE2(capset, cap_user_header_t, header, const cap_user_data_t, data)
 	if (pid != 0 && pid != task_pid_vnr(current))
 		return -EPERM;
 
-	if (copy_from_user(&kdata, data,
-			   tocopy * sizeof(struct __user_cap_data_struct)))
+	copybytes = tocopy * sizeof(struct __user_cap_data_struct);
+	if (copybytes > _KERNEL_CAPABILITY_U32S)
+		return -EFAULT;
+
+	if (copy_from_user(&kdata, data, copybytes))
 		return -EFAULT;
 
 	for (i = 0; i < tocopy; i++) {



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
