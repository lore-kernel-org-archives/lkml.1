Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbZJLHLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbZJLHLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 03:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbZJLHLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 03:11:16 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:30165 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbZJLHLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 03:11:15 -0400
X-Greylist: delayed 453 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Oct 2009 03:11:15 EDT
Subject: [PATCH 3/5] PCI: maintain backwards compatibility with aer-inject
	user-land tool
To: ying.huang@intel.com
From: Andrew Patterson <andrew.patterson@hp.com>
Cc: prarit@redhat.com, andi@firstfloor.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, pci-linux@vger.kernel.org
Date: Mon, 12 Oct 2009 01:03:04 -0600
Message-ID: <20091012070304.27029.14815.stgit@bob.kio>
In-Reply-To: <20091012070248.27029.78378.stgit@bob.kio>
References: <20091012070248.27029.78378.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI: maintain backwards compatibility with aer-inject user-land tool

Maintain backwards compatibility with the 0.1 version  of the aer-inject
user-land tool.

Signed-off-by: Andrew Patterson<andrew.patterson@hp.com>
---

diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
index 5fc5b3e..ac0b5e7 100644
--- a/drivers/pci/pcie/aer/aer_inject.c
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -23,10 +23,10 @@
 #include <linux/pci.h>
 #include <linux/fs.h>
 #include <linux/uaccess.h>
+#include <linux/stddef.h>
 #include "aerdrv.h"
 
 struct aer_error_inj {
-	u16 domain;
 	u8 bus;
 	u8 dev;
 	u8 fn;
@@ -36,6 +36,7 @@ struct aer_error_inj {
 	u32 header_log1;
 	u32 header_log2;
 	u32 header_log3;
+	u16 domain;
 };
 
 struct aer_error {
@@ -431,10 +432,11 @@ static ssize_t aer_inject_write(struct file *filp, const char __user *ubuf,
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-
-	if (usize != sizeof(struct aer_error_inj))
+	if (usize < offsetof(struct aer_error_inj, domain) ||
+	    usize > sizeof(einj))
 		return -EINVAL;
 
+	memset(&einj, 0, sizeof(einj));
 	if (copy_from_user(&einj, ubuf, usize))
 		return -EFAULT;
 

