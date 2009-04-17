Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbZDQKCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbZDQKCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 06:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757101AbZDQKCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 06:02:31 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:24403
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756246AbZDQKCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 06:02:30 -0400
X-BigFish: VPS-13(zz936eQ4015Mzz1202hzzz32i6bh14bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KI8P7U-01-GGV-01
Date: Fri, 17 Apr 2009 12:01:55 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: jbarnes@virtuousgeek.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH]  pci: derive nearby CPUs from device's instead of bus'
	NUMA information
Message-ID: <20090417100155.GE16198@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 17 Apr 2009 10:02:02.0798 (UTC) FILETIME=[8E4E4CE0:01C9BF43]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of AMD CPU northbridge functions this NUMA information might
differ.

Here is an example from a 4-socket system.

Currently Linux shows

  root@hagen:/sys/devices/pci0000:00/0000:00:1a.4# cat numa_node
  0
  root@hagen:/sys/devices/pci0000:00/0000:00:1a.4# cat local_cpu*
  0-3
  00000000,0000000f

which is not correct for northbridge functions as the local CPUs
are those of the same socket.

With this patch and a quirk for AMD CPU NB functions Linux can
do better and correctly show

  root@hagen:/sys/devices/pci0000:00/0000:00:1a.4# cat numa_node
  2
  root@hagen:/sys/devices/pci0000:00/0000:00:1a.4# cat local_cpu*
  8-11
  00000000,00000f00

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 drivers/pci/pci-sysfs.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

The quirk for AMD CPU NB functions is contained in another patch
that I'll send to x86-maintainers for inclusion into tip tree.

Please apply.

Thanks,
Andreas

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index a7eb1b4..9360f3d 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -74,7 +74,11 @@ static ssize_t local_cpus_show(struct device *dev,
 	const struct cpumask *mask;
 	int len;
 
+#ifdef CONFIG_NUMA
+	mask = cpumask_of_node(dev_to_node(dev));
+#else
 	mask = cpumask_of_pcibus(to_pci_dev(dev)->bus);
+#endif
 	len = cpumask_scnprintf(buf, PAGE_SIZE-2, mask);
 	buf[len++] = '\n';
 	buf[len] = '\0';
@@ -88,7 +92,11 @@ static ssize_t local_cpulist_show(struct device *dev,
 	const struct cpumask *mask;
 	int len;
 
+#ifdef CONFIG_NUMA
+	mask = cpumask_of_node(dev_to_node(dev));
+#else
 	mask = cpumask_of_pcibus(to_pci_dev(dev)->bus);
+#endif
 	len = cpulist_scnprintf(buf, PAGE_SIZE-2, mask);
 	buf[len++] = '\n';
 	buf[len] = '\0';
-- 
1.6.2



