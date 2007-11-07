Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbXKGNLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbXKGNLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 08:11:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757944AbXKGNLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 08:11:07 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:47225 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757898AbXKGNLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 08:11:05 -0500
Subject: Re: [patch 00/28] cpu alloc v1: Optimize by removing arrays of
	pointers to per cpu objects
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>, heiko.carstens@de.ibm.com
In-Reply-To: <20071106195144.983665861@sgi.com>
References: <20071106195144.983665861@sgi.com>
Content-Type: text/plain
Organization: IBM Corporation
Date: Wed, 07 Nov 2007 14:10:58 +0100
Message-Id: <1194441058.7744.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-06 at 11:51 -0800, Christoph Lameter wrote:
> TODO:
> - Currently only i386, ia64 and x86_64 arch definitions are provided.
>   Other arches fall back to 64k static configurations.
> - Cpu hotplug support. Current we simply allocate for all possible processors.
>   We could reduce this to only online processors if we could allocate the
>   cpu area for the new processor before the callbacks are run and if we could
>   free the cpu areas for a processor going down after all the callbacks for
>   that were run.
> - There are various modifications to exotic configurations that still need
>   some testing (f.e. s/390 iucv--whatever that is--) etc. Tests were
>   done on UP(i386) SMP(i386, x86_64) and NUMA (x86_64, ia64)

IUCV = Inter-User-Communication-Vehicle. Nice name, isn't it?

It is a z/VM hypervisor interface that allows the different guests to
communicate between each other. net/iucv.c is the base code,
net/af_iucv.c implements the socket interface. 

The patch you provided for iucv has a few bugs which are corrected with
the patch below (please merge with patch #25). With it new cpu alloc
code works fine on s390. We likely want to switch to a virtual
configuration as well. For now we can live with the static
configuration.

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.

---

 net/iucv/iucv.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index 0d77dba..7698f6c 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -566,7 +566,6 @@ static int __cpuinit iucv_cpu_notify(struct notifier_block *self,
 				     GFP_KERNEL|GFP_DMA, cpu_to_node(cpu));
 		if (!iucv_param[cpu])
 			return NOTIFY_BAD;
-		}
 		break;
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
@@ -1622,19 +1621,21 @@ static int __init iucv_init(void)
 	}
 
 	for_each_online_cpu(cpu) {
-			/* Note: GFP_DMA used to get memory below 2G */
+		/* Note: GFP_DMA used to get memory below 2G */
 		iucv_irq_data[cpu] = kmalloc_node(sizeof(struct iucv_irq_data),
 				     GFP_KERNEL|GFP_DMA, cpu_to_node(cpu));
 		if (!iucv_irq_data[cpu]) {
 			rc = -ENOMEM;
-			goto out_root;
+			goto out_free;
+		}
 
 		/* Allocate parameter blocks. */
 		iucv_param[cpu] = kmalloc_node(sizeof(union iucv_param),
 				  GFP_KERNEL|GFP_DMA, cpu_to_node(cpu));
 		if (!iucv_param[cpu]) {
 			rc = -ENOMEM;
-			goto out_extint;
+			goto out_free;
+		}
 	}
 	register_hotcpu_notifier(&iucv_cpu_notifier);
 	ASCEBC(iucv_error_no_listener, 16);
@@ -1643,12 +1644,13 @@ static int __init iucv_init(void)
 	iucv_available = 1;
 	return 0;
 
-out_extint:
-	for_each_cpu(cpu) {
+out_free:
+	for_each_possible_cpu(cpu) {
+		kfree(iucv_param[cpu]);
+		iucv_param[cpu] = NULL;
 		kfree(iucv_irq_data[cpu]);
 		iucv_irq_data[cpu] = NULL;
 	}
-out_root:
 	s390_root_dev_unregister(iucv_root);
 out_bus:
 	bus_unregister(&iucv_bus);
@@ -1675,7 +1677,7 @@ static void __exit iucv_exit(void)
 		kfree(p);
 	spin_unlock_irq(&iucv_queue_lock);
 	unregister_hotcpu_notifier(&iucv_cpu_notifier);
-	for_each_cpu(cpu) {
+	for_each_possible_cpu(cpu) {
 		kfree(iucv_param[cpu]);
 		iucv_param[cpu] = NULL;
 		kfree(iucv_irq_data[cpu]);


