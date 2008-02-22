Return-Path: <linux-kernel-owner+w=401wt.eu-S936747AbYBVWsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936747AbYBVWsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936568AbYBVWqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:46:52 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:41362 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936501AbYBVWqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:46:50 -0500
Date: Fri, 22 Feb 2008 15:46:45 -0700
From: dann frazier <dannf@hp.com>
To: Willy TARREAU <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH] 2.4: [POWERPC] CHRP: Fix possible NULL pointer dereference
Message-ID: <20080222224645.GD6392@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a 2.4 backport of a linux-2.6 change by Cyrill Gorcunov.
(commit 9ac71d00398674aaec664f30559f0a21d963862f)

CVE-2007-6694 was assigned for this issue.
This backport has been compile-tested only.

Commit log from 2.6 follows.

    This fixes a possible NULL pointer dereference inside of strncmp() if
    of_get_property() fails.

Signed-off-by: dann frazier <dannf@hp.com>

diff --git a/arch/ppc/platforms/chrp_setup.c b/arch/ppc/platforms/chrp_setup.c
index 0ffbbd2..28747db 100644
--- a/arch/ppc/platforms/chrp_setup.c
+++ b/arch/ppc/platforms/chrp_setup.c
@@ -121,7 +121,7 @@ chrp_show_cpuinfo(struct seq_file *m)
 	seq_printf(m, "machine\t\t: CHRP %s\n", model);
 
 	/* longtrail (goldengate) stuff */
-	if (!strncmp(model, "IBM,LongTrail", 13)) {
+	if (model && !strncmp(model, "IBM,LongTrail", 13)) {
 		/* VLSI VAS96011/12 `Golden Gate 2' */
 		/* Memory banks */
 		sdramen = (in_le32((unsigned *)(gg2_pci_config_base+
@@ -210,14 +210,20 @@ static void __init sio_fixup_irq(const char *name, u8 device, u8 level,
 static void __init sio_init(void)
 {
 	struct device_node *root;
+	const char *model;
 
-	if ((root = find_path_device("/")) &&
-	    !strncmp(get_property(root, "model", NULL), "IBM,LongTrail", 13)) {
+	root = find_path_device("/");
+	if (!root)
+		return;
+
+	model = get_property(root, "model", NULL);
+	if (model && !strncmp(model, "IBM,LongTrail", 13)) {
 		/* logical device 0 (KBC/Keyboard) */
 		sio_fixup_irq("keyboard", 0, 1, 2);
 		/* select logical device 1 (KBC/Mouse) */
 		sio_fixup_irq("mouse", 1, 12, 2);
 	}
+
 }
 
 
-- 
1.5.4

