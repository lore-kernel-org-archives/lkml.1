Return-Path: <linux-kernel-owner+w=401wt.eu-S1760578AbXLLTYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760578AbXLLTYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbXLLTYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:24:05 -0500
Received: from mail.queued.net ([207.210.101.209]:1051 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756670AbXLLTYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:24:03 -0500
Date: Wed, 12 Dec 2007 14:12:59 -0500
From: Andres Salomon <dilinger@queued.net>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>, akpm@linux-foundation.org,
       cbou@mail.ru
Subject: [PATCH 2/2] power: fix incorrect unregistration in
 power_supply_create_attrs error path
Message-ID: <20071212141259.67b4e1d9@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In power_supply_create_attrs(), we create static attributes as referenced
by power_supply_static_attrs[i].  After that, if we fail, we unregister
via power_supply_static_attrs[psy->properties[i]].  This is incorrect, as
psy->properties has absolutely no bearing on static attribs.  This patch
fixes it to unregister the correct attrib.

Another line which was unnecessarily line wrapped is also unwrapped.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/power/power_supply_sysfs.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 0331e82..8efedba 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -153,8 +153,7 @@ dynamics_failed:
 			   &power_supply_attrs[psy->properties[j]]);
 statics_failed:
 	while (i--)
-		device_remove_file(psy->dev,
-			   &power_supply_static_attrs[psy->properties[i]]);
+		device_remove_file(psy->dev, &power_supply_static_attrs[i]);
 succeed:
 	return rc;
 }
@@ -164,8 +163,7 @@ void power_supply_remove_attrs(struct power_supply *psy)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(power_supply_static_attrs); i++)
-		device_remove_file(psy->dev,
-			    &power_supply_static_attrs[i]);
+		device_remove_file(psy->dev, &power_supply_static_attrs[i]);
 
 	for (i = 0; i < psy->num_properties; i++)
 		device_remove_file(psy->dev,
-- 
1.5.3.5

