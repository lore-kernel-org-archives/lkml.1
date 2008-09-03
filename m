Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbYICKtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbYICKtY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 06:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbYICKtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 06:49:04 -0400
Received: from smtp1.hosting90.cz ([81.0.225.81]:59549 "EHLO
	smtp1.hosting90.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbYICKtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 06:49:02 -0400
X-Greylist: delayed 3212 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Sep 2008 06:49:01 EDT
Message-ID: <48BE5F06.9060406@prepere.com>
Date: Wed, 03 Sep 2008 11:55:18 +0200
From: Miloslav Semler <majkls@prepere.com>
User-Agent: IceDove 1.5.0.14eol (X11/20080724)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>, bunk@stusta.de
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] CHRP: Fix possible NULL pointer dereference
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-Scan-Signature: 1e5737363935d8c2ecf9455101152375
X-authenticated-id: miloslav.semler@hosting90.cz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 This fixes a possible NULL pointer dereference inside of strncmp() if
of_get_property() fails.

This is backport of:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9ac71d00398674aaec664f30559f0a21d963862f

Signed-off-by: Miloslav Semler
---
diff -uprN linux-2.6.16.62/arch/powerpc/platforms/chrp/setup.c
linux-2.6.16.62-new/arch/powerpc/platforms/chrp/setup.c
--- linux-2.6.16.62/arch/powerpc/platforms/chrp/setup.c 2008-07-21
21:48:10.000000000 +0200
+++ linux-2.6.16.62-new/arch/powerpc/platforms/chrp/setup.c    
2008-09-03 11:33:54.000000000 +0200
@@ -103,7 +103,7 @@ void chrp_show_cpuinfo(struct seq_file *
        seq_printf(m, "machine\t\t: CHRP %s\n", model);

        /* longtrail (goldengate) stuff */
-       if (!strncmp(model, "IBM,LongTrail", 13)) {
+       if (model && !strncmp(model, "IBM,LongTrail", 13)) {
                /* VLSI VAS96011/12 `Golden Gate 2' */
                /* Memory banks */
                sdramen = (in_le32(gg2_pci_config_base + GG2_PCI_DRAM_CTRL)
@@ -190,9 +190,14 @@ static void __init sio_fixup_irq(const c
 static void __init sio_init(void)
 {
        struct device_node *root;
+       const char *model;

-       if ((root = find_path_device("/")) &&
-           !strncmp(get_property(root, "model", NULL), "IBM,LongTrail",
13)) {
+       root = find_path_device("/");
+       if(!root)
+               return;
+
+       model = get_property(root, "model", NULL);
+       if(model && !strncmp(model, "IBM,LongTrail", 13)) {
                /* logical device 0 (KBC/Keyboard) */
                sio_fixup_irq("keyboard", 0, 1, 2);
                /* select logical device 1 (KBC/Mouse) */



