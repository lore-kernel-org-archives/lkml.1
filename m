Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab0CIT2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:28:00 -0500
Received: from quartz.orcorp.ca ([139.142.54.143]:58538 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755819Ab0CIT15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:27:57 -0500
Date: Tue, 9 Mar 2010 12:27:56 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] mtd: Extend physmap_of to let the device tree specify the
	parition probe
Message-ID: <20100309192756.GC30462@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to support custom partitioning schemes for embedded PPC. To use
define your own mtd_part_parser and then add something like:
   linux,part-probe = "my_probe", "cmdlinepart";
To the board's dts file.

If linux,part-probe is not specified then this behaves the same as before.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
---
 drivers/mtd/maps/physmap_of.c |   53 +++++++++++++++++++++++++++++++++++++----
 1 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/maps/physmap_of.c b/drivers/mtd/maps/physmap_of.c
index 61e4eb4..fe4438c 100644
--- a/drivers/mtd/maps/physmap_of.c
+++ b/drivers/mtd/maps/physmap_of.c
@@ -172,12 +172,53 @@ static struct mtd_info * __devinit obsolete_probe(struct of_device *dev,
 	}
 }
 
+#ifdef CONFIG_MTD_PARTITIONS
+/* When partitions are set we look for a linux,part-probe property which
+   specifies the list of partition probers to use. If none is given then the
+   default is use. These take precedence over other device tree
+   information. */
+static const char *part_probe_types_def[] = { "cmdlinepart", "RedBoot", NULL };
+static const char ** __devinit of_get_probes(struct device_node *dp)
+{
+	const char *cp;
+	int cplen;
+	unsigned int l;
+	unsigned int count;
+	const char **res;
+
+	cp = of_get_property(dp, "linux,part-probe", &cplen);
+	if (cp == NULL)
+		return part_probe_types_def;
+
+	count = 0;
+	for (l = 0; l != cplen; l++)
+		if (cp[l] == 0)
+			count++;
+
+	res = kzalloc((count + 1)*sizeof(*res), GFP_KERNEL);
+	count = 0;
+	while (cplen > 0) {
+		res[count] = cp;
+		l = strlen(cp) + 1;
+		cp += l;
+		cplen -= l;
+		count++;
+	}
+	return res;
+}
+
+static void __devinit of_free_probes(const char **probes)
+{
+	if (probes != part_probe_types_def)
+		kfree(probes);
+}
+#endif
+
 static int __devinit of_flash_probe(struct of_device *dev,
 				    const struct of_device_id *match)
 {
 #ifdef CONFIG_MTD_PARTITIONS
-	static const char *part_probe_types[]
-		= { "cmdlinepart", "RedBoot", NULL };
+	const char **part_probe_types;
 #endif
 	struct device_node *dp = dev->node;
 	struct resource res;
@@ -306,12 +347,14 @@ static int __devinit of_flash_probe(struct of_device *dev,
 		goto err_out;
 
 #ifdef CONFIG_MTD_PARTITIONS
-	/* First look for RedBoot table or partitions on the command
-	 * line, these take precedence over device tree information */
+	part_probe_types = of_get_probes(dp);
 	err = parse_mtd_partitions(info->cmtd, part_probe_types,
 				   &info->parts, 0);
-	if (err < 0)
+	if (err < 0) {
+		of_free_probes(part_probe_types);
 		return err;
+	}
+	of_free_probes(part_probe_types);
 
 #ifdef CONFIG_MTD_OF_PARTS
 	if (err == 0) {
-- 
1.5.4.2

