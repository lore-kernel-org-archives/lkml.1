Return-Path: <linux-kernel-owner+w=401wt.eu-S1751869AbZAZOgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbZAZOgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 09:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750862AbZAZOgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 09:36:06 -0500
Received: from cpsmtpo-eml04.KPNXCHANGE.COM ([213.75.38.153]:6596 "EHLO
	cpsmtpo-eml04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbZAZOgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 09:36:05 -0500
From: Frans Pop <elendil@planet.nl>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] hp-wmi: set initial docking state
Date: Mon, 26 Jan 2009 15:36:01 +0100
User-Agent: KMail/1.9.9
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901261536.02809.elendil@planet.nl>
X-OriginalArrivalTime: 26 Jan 2009 14:36:04.0022 (UTC) FILETIME=[6A943D60:01C97FC3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the initial state is not set when the input device is set up, the
first docking event after the module is loaded will be lost.
    
Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
---
Patch is based on what is done for the LID switch in drivers/acpi/button.c 
and has been tested on my HP 2510p.

As this is a (minor) bug fix, it would be nice to have it in 2.6.29.

Cheers,
FJP

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 7c789f0..8aaff0c 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -382,6 +382,11 @@ static int __init hp_wmi_input_setup(void)
 		case KE_SW:
 			set_bit(EV_SW, hp_wmi_input_dev->evbit);
 			set_bit(key->keycode, hp_wmi_input_dev->swbit);
+
+			/* Set initial dock state */
+			input_report_switch(hp_wmi_input_dev, key->keycode,
+					    hp_wmi_dock_state());
+			input_sync(hp_wmi_input_dev);
 			break;
 		}
 	}
