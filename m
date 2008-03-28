Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbYC1BJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbYC1BJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 21:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbYC1BJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 21:09:30 -0400
Received: from zrnetservice.com ([209.133.52.163]:58080 "EHLO
	www.zrnetservice.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754750AbYC1BJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 21:09:29 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 4 of 4] paravirt_ops: don't steal memory resources in
	paravirt_disable_iospace
X-Mercurial-Node: 9befcae155388f3f0e71f2c75a0039b5de332bee
Message-Id: <9befcae155388f3f0e71.1206664120@localhost>
In-Reply-To: <patchbomb.1206664116@localhost>
Date: Thu, 27 Mar 2008 17:28:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memory resource is also used for main memory, and we need it to
allocate physical addresses for memory hotplug.  Knobbling io space is
enough to get the job done anyway.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/paravirt.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -206,13 +206,6 @@
 	.flags = IORESOURCE_IO | IORESOURCE_BUSY,
 };
 
-static struct resource reserve_iomem = {
-	.start = 0,
-	.end = -1,
-	.name = "paravirt-iomem",
-	.flags = IORESOURCE_MEM | IORESOURCE_BUSY,
-};
-
 /*
  * Reserve the whole legacy IO space to prevent any legacy drivers
  * from wasting time probing for their hardware.  This is a fairly
@@ -222,16 +215,7 @@
  */
 int paravirt_disable_iospace(void)
 {
-	int ret;
-
-	ret = request_resource(&ioport_resource, &reserve_ioports);
-	if (ret == 0) {
-		ret = request_resource(&iomem_resource, &reserve_iomem);
-		if (ret)
-			release_resource(&reserve_ioports);
-	}
-
-	return ret;
+	return request_resource(&ioport_resource, &reserve_ioports);
 }
 
 static DEFINE_PER_CPU(enum paravirt_lazy_mode, paravirt_lazy_mode) = PARAVIRT_LAZY_NONE;


