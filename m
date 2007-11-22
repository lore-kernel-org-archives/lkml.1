Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbXKVUE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbXKVUE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 15:04:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbXKVUEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 15:04:20 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:35502 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbXKVUET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 15:04:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=VQZ3QLr0ZUe/oxOtmaKzeWOymww5h5WAnC+KphF/0/6jCJADx6QyWq2JKOoh4wfYbUbmOkVuxJwWfiMS3bZ2hFp3sewbwJM6F0DmK7rvLGRV9uqANeaewsh8lcR/aihjinM5fKM++ltfVkV+L8hG87lZl0wN5xKHnExDHn2XjQg=
Date: Thu, 22 Nov 2007 22:54:23 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: PPCML <linuxppc-dev@ozlabs.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Olof Johansson <olof@lixom.net>, Kumar Gala <galak@kernel.crashing.org>
Subject: [PATCH] PPC: CHRP - fix possible NULL pointer dereference
Message-ID: <20071122195423.GA9877@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch does fix possible NULL pointer dereference
inside of strncmp() if of_get_property() failed.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

 arch/powerpc/platforms/chrp/setup.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/platforms/chrp/setup.c b/arch/powerpc/platforms/chrp/setup.c
index 5930626..e3f276d 100644
--- a/arch/powerpc/platforms/chrp/setup.c
+++ b/arch/powerpc/platforms/chrp/setup.c
@@ -115,7 +115,7 @@ void chrp_show_cpuinfo(struct seq_file *m)
 	seq_printf(m, "machine\t\t: CHRP %s\n", model);
 
 	/* longtrail (goldengate) stuff */
-	if (!strncmp(model, "IBM,LongTrail", 13)) {
+	if (model && !strncmp(model, "IBM,LongTrail", 13)) {
 		/* VLSI VAS96011/12 `Golden Gate 2' */
 		/* Memory banks */
 		sdramen = (in_le32(gg2_pci_config_base + GG2_PCI_DRAM_CTRL)
@@ -203,16 +203,19 @@ static void __init sio_fixup_irq(const char *name, u8 device, u8 level,
 static void __init sio_init(void)
 {
 	struct device_node *root;
+	const char *model = NULL;
 
-	if ((root = of_find_node_by_path("/")) &&
-	    !strncmp(of_get_property(root, "model", NULL),
-			"IBM,LongTrail", 13)) {
-		/* logical device 0 (KBC/Keyboard) */
-		sio_fixup_irq("keyboard", 0, 1, 2);
-		/* select logical device 1 (KBC/Mouse) */
-		sio_fixup_irq("mouse", 1, 12, 2);
-	}
-	of_node_put(root);
+	root = of_find_node_by_path("/");
+	if (root) {
+		model = of_get_property(root, "model", NULL);
+		if (model && !strncmp(model,"IBM,LongTrail", 13)) {
+			/* logical device 0 (KBC/Keyboard) */
+			sio_fixup_irq("keyboard", 0, 1, 2);
+			/* select logical device 1 (KBC/Mouse) */
+			sio_fixup_irq("mouse", 1, 12, 2);
+		}
+		of_node_put(root);
+ 	}
 }
 
 
