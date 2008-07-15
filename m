Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbYGOIKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbYGOIKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 04:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754138AbYGOIKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 04:10:35 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:43763 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbYGOIKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 04:10:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=OqboXy0TCc3BaXC8gfBwI98JZ7Oix/ugdtIX6a/qTK3aAAiiVwt0TKnpjKm1vc5sOq
         YRREfjQejkJ7EskUMMcdvFO3qlMDArWD7NIF5kht/lpv8sNjT5Zn3jFtoDITSWOgoQCI
         smOk7GucqJ5abbY2ouqSBwBKtqwKnskN5/zHc=
Date: Tue, 15 Jul 2008 17:10:25 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       Ursula Braun <ubraun@linux.vnet.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org
Subject: [PATCH] iucv: fix memory leak in cpu hotplug error path.
Message-ID: <20080715081025.GB22068@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix memory leak in error path in CPU_UP_PREPARE notifier.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: Ursula Braun <ubraun@linux.vnet.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
---
 net/iucv/iucv.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: 2.6-mmotm/net/iucv/iucv.c
===================================================================
--- 2.6-mmotm.orig/net/iucv/iucv.c
+++ 2.6-mmotm/net/iucv/iucv.c
@@ -567,8 +567,11 @@ static int __cpuinit iucv_cpu_notify(str
 			return NOTIFY_BAD;
 		iucv_param[cpu] = kmalloc_node(sizeof(union iucv_param),
 				     GFP_KERNEL|GFP_DMA, cpu_to_node(cpu));
-		if (!iucv_param[cpu])
+		if (!iucv_param[cpu]) {
+			kfree(iucv_irq_data[cpu]);
+			iucv_irq_data[cpu] = NULL;
 			return NOTIFY_BAD;
+		}
 		break;
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
