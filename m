Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbZJGWIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbZJGWIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755082AbZJGWIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:08:21 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:1160 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbZJGWIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:08:19 -0400
Subject: [PATCH 3/6] ACPI: dock: clean up one more error path in dock_add()
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 07 Oct 2009 16:07:42 -0600
Message-ID: <20091007220742.15597.91712.stgit@bob.kio>
In-Reply-To: <20091007220509.15597.65501.stgit@bob.kio>
References: <20091007220509.15597.65501.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove one final redundant error handling path and reduce repetitiveness.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/dock.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 390adee..1d693a1 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -968,11 +968,10 @@ static int dock_add(acpi_handle handle)
 		platform_device_register_simple(dock_device_name,
 			dock_station_count, NULL, 0);
 	dock_device = ds->dock_device;
-	if (IS_ERR(dock_device)) {
-		kfree(ds);
-		ds = NULL;
-		return PTR_ERR(dock_device);
-	}
+	ret = IS_ERR(dock_device) ? PTR_ERR(dock_device) : 0;
+	if (ret)
+		goto err_free;
+
 	platform_device_add_data(dock_device, &ds,
 		sizeof(struct dock_station *));
 
@@ -1036,6 +1035,7 @@ err_unregister1:
 err_unregister:
 	printk(KERN_ERR "%s encountered error %d\n", __func__, ret);
 	platform_device_unregister(dock_device);
+err_free:
 	kfree(ds);
 	ds = NULL;
 	return ret;

