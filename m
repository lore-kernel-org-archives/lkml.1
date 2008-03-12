Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbYCLRdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbYCLRdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 13:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbYCLRc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 13:32:27 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:55359 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbYCLRcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 13:32:22 -0400
Message-Id: <20080312173217.286584635@de.ibm.com>
References: <20080312173155.703966894@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 12 Mar 2008 18:32:00 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 05/10] cpu topology: convert siblings_show macro to accept non-lvalues.
Content-Disposition: inline; filename=105-nodes-siblings.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

The sibling cpu masks on s390 can change because of dynamic cpu
reconfiguration. Therefore accesses to these masks are protected with
a lock so there aren't concurrent read and write accesses at the same
time. cpumask_scnprint in define_siblings_show_func expects an lvalue
for the cpu mask which would make the locking down in the s390 arch
code pointless. To solve this change the topology code to save a
snapshot of the sibling cpu mask and use that for output purposes.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/base/topology.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

Index: quilt-2.6/drivers/base/topology.c
===================================================================
--- quilt-2.6.orig/drivers/base/topology.c
+++ quilt-2.6/drivers/base/topology.c
@@ -40,13 +40,16 @@ static ssize_t show_##name(struct sys_de
 	return sprintf(buf, "%d\n", topology_##name(cpu));	\
 }
 
-#define define_siblings_show_func(name)					\
-static ssize_t show_##name(struct sys_device *dev, char *buf)		\
-{									\
-	ssize_t len = -1;						\
-	unsigned int cpu = dev->id;					\
-	len = cpumask_scnprintf(buf, NR_CPUS+1, topology_##name(cpu));	\
-	return (len + sprintf(buf + len, "\n"));			\
+#define define_siblings_show_func(name)				\
+static ssize_t show_##name(struct sys_device *dev, char *buf)	\
+{								\
+	ssize_t len = -1;					\
+	unsigned int cpu = dev->id;				\
+	cpumask_t mask; 					\
+								\
+	mask = topology_##name(cpu);				\
+	len = cpumask_scnprintf(buf, NR_CPUS + 1, mask);	\
+	return len + sprintf(buf + len, "\n");			\
 }
 
 #ifdef	topology_physical_package_id

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

