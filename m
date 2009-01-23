Return-Path: <linux-kernel-owner+w=401wt.eu-S1763293AbZAWLDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763293AbZAWLDv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 06:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762682AbZAWLBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 06:01:45 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:5663 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761767AbZAWLBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 06:01:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=kIcyJPPkbwtYB2icNwNYenmwWh3SSLv6SMN/igQp6gXr35+gt1gq9of+RNghOEIHwT
         5SEgIALbSbC7ElZAL/3seBsy/owK8HbSwX9sVCtEQE0zRut9r/ziabGUYVeF1AtEdVLn
         VFJLcKshgU5jhEk9U0bDVmnTL67WmXHM6a6rI=
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com, gregkh@suse.de,
       roel.kluin@gmail.com, lethal@linux-sh.org, tglx@linutronix.de,
       mingo@redhat.com, Magnus Damm <magnus.damm@gmail.com>
Date: Fri, 23 Jan 2009 19:59:36 +0900
Message-Id: <20090123105936.18779.9202.sendpatchset@rx1.opensource.se>
In-Reply-To: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
References: <20090123105721.18779.80514.sendpatchset@rx1.opensource.se>
Subject: [PATCH 011/011] sh_cmt: add early platform support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@igel.co.jp>

This adds early platform support to the sh_cmt timer driver.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 drivers/clocksource/sh_cmt.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- 0016/drivers/clocksource/sh_cmt.c
+++ work/drivers/clocksource/sh_cmt.c	2009-01-22 17:30:35.000000000 +0900
@@ -567,9 +567,19 @@ static int sh_cmt_setup(struct sh_cmt_pr
 static int __devinit sh_cmt_probe(struct platform_device *pdev)
 {
 	struct sh_cmt_priv *p = platform_get_drvdata(pdev);
+	struct sh_cmt_config *cfg = pdev->dev.platform_data;
 	int ret;
 
-	p = kmalloc(sizeof(*p), GFP_KERNEL);
+	if (p) {
+		pr_info("sh_cmt: %s kept as earlytimer\n", cfg->name);
+		return 0;
+	}
+
+	if (is_early_platform_device(pdev))
+		p = alloc_bootmem(sizeof(*p));
+	else
+		p = kmalloc(sizeof(*p), GFP_KERNEL);
+
 	if (p == NULL) {
 		dev_err(&pdev->dev, "failed to allocate driver data\n");
 		return -ENOMEM;
@@ -577,7 +587,10 @@ static int __devinit sh_cmt_probe(struct
 
 	ret = sh_cmt_setup(p, pdev);
 	if (ret) {
-		kfree(p);
+		if (is_early_platform_device(pdev))
+			free_bootmem(__pa(p), sizeof(*p));
+		else
+			kfree(p);
 
 		platform_set_drvdata(pdev, NULL);
 	}
@@ -607,6 +620,7 @@ static void __exit sh_cmt_exit(void)
 	platform_driver_unregister(&sh_cmt_device_driver);
 }
 
+early_platform_init("earlytimer", &sh_cmt_device_driver);
 module_init(sh_cmt_init);
 module_exit(sh_cmt_exit);
 
