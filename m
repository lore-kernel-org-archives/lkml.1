Return-Path: <linux-kernel-owner+w=401wt.eu-S933262AbYCUXSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbYCUXSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762095AbYCUXHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:07:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:50954 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764293AbYCUXHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:07:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=XVXuheAxo4QX3zy/Zwcgao0V3doGtvQ9978FGaWULdt+l/JTb3ljgL7twu6/HbQdqcPw+d/d3Dm9Qt9HdKyeI1S+TsC5TKkMobWgTGEeDee+Vz09IzzTzyx7opCe4kXCUZMrRZFRQZfDZMb28YLFVwKS6xclFX2InDFQ4NRuStk=
Date: Sat, 22 Mar 2008 00:07:13 +0100 (CET)
To: Greg Kroah-Hartman <greg@kroah.com>
cc: Jyoti Shah <jshah@us.ibm.com>, Irene Zubarev <zubarev@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH] Fix leaks in IBM Hot Plug Controller Driver -
 ibmphp_init_devno()
Message-ID: <alpine.LNX.1.00.0803220003050.10052@dragon.funnycrock.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In drivers/pci/hotplug/ibmphp_core.c::ibmphp_init_devno() we allocate 
space dynamically for a PCI irq routing table by calling 
pcibios_get_irq_routing_table(), but we never free the allocated space.

This patch frees the allocated space at the function exit points.

Spotted by the Coverity checker. Compile tested only.

Please consider applying.


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
--- 

 ibmphp_core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
index 87b6b8b..81d0092 100644
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -148,8 +148,10 @@ int ibmphp_init_devno(struct slot **cur_slot)
 	len = (rtable->size - sizeof(struct irq_routing_table)) /
 			sizeof(struct irq_info);
 
-	if (!len)
+	if (!len) {
+		kfree(rtable);
 		return -1;
+	}
 	for (loop = 0; loop < len; loop++) {
 		if ((*cur_slot)->number == rtable->slots[loop].slot) {
 		if ((*cur_slot)->bus == rtable->slots[loop].bus) {
@@ -187,11 +189,13 @@ int ibmphp_init_devno(struct slot **cur_slot)
 				debug("rtable->slots[loop].irq[3].link = %x\n",
 					rtable->slots[loop].irq[3].link);
 				debug("end of init_devno\n");
+				kfree(rtable);
 				return 0;
 			}
 		}
 	}
 
+	kfree(rtable);
 	return -1;
 }
 



