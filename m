Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab0BARfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:35:23 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:8842 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab0BARfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:35:20 -0500
Date: Mon, 1 Feb 2010 10:35:18 -0700
From: Alex Chiang <achiang@hp.com>
To: lenb@kernel.org, Chris Mason <chris.mason@oracle.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: stable@kernel.org
Subject: Re: [PATCH] set dock_station->flags to zero during dock_add
Message-ID: <20100201173518.GA28002@ldl.fc.hp.com>
References: <20100201163043.GA3240@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201163043.GA3240@think>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Thanks for catching this. Seems better to just memset the stack
variable before we kmemdup it in platform_deivce_register_data().

How about this instead?

---
From: Alex Chiang <achiang@hp.com>

ACPI: dock: properly initialize local struct dock_station in dock_add()

Commit fe06fba2 (ACPI: dock: add struct dock_station * directly
to platform device data) changed dock_add() to use the
platform_device_register_data() API.

We passed that interface a stack variable, which is kmemdup'ed
and assigned to the device's platform_data pointer.

Unfortunately, whatever random garbage is in the stack variable
gets coped during the kmemdup, and that leads to broken behavior.

Explicitly zero out the structure before passing it to the API.

Cc: stable@kernel.org
Reported-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---
Commit fe06fba2 was introduced in 2.6.32-rc5, so we need this fix
for the .32 stable series only.

---
diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index bbc2c13..b2586f5 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -935,6 +935,7 @@ static int dock_add(acpi_handle handle)
 	struct platform_device *dd;
 
 	id = dock_station_count;
+	memset(&ds, 0, sizeof(ds));
 	dd = platform_device_register_data(NULL, "dock", id, &ds, sizeof(ds));
 	if (IS_ERR(dd))
 		return PTR_ERR(dd);
