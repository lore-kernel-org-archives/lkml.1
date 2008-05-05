Return-Path: <linux-kernel-owner+w=401wt.eu-S1761059AbYEEUXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761059AbYEEUXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757873AbYEEUXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:23:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978AbYEEUW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:22:59 -0400
Date: Mon, 5 May 2008 22:25:08 +0200
From: Holger Macht <hmacht@suse.de>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com
Subject: [PATCH] bay: Exit if notify handler cannot be installed
Message-ID: <20080505202508.GA3690@homac>
Mail-Followup-To: linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If acpi_install_notify_handler() for a bay device fails, the bay driver is
superfluous. Most likely, another driver (like libata) is already caring
about this device anyway. Furthermore,
register_hotplug_dock_device(acpi_handle) from the dock driver must not be
called twice with the same handler. So clean up and exit.

Signed-off-by: Holger Macht <hmacht@suse.de>
---

diff --git a/drivers/acpi/bay.c b/drivers/acpi/bay.c
index d2fc941..ce9038f 100644
--- a/drivers/acpi/bay.c
+++ b/drivers/acpi/bay.c
@@ -311,6 +311,7 @@ static int bay_add(acpi_handle handle, int id)
 			bay_notify, new_bay);
 	if (ACPI_FAILURE(status)) {
 		printk(KERN_ERR PREFIX "Error installing bay notify handler\n");
+		goto bay_add_err;
 	}
 
 	/* if we are on a dock station, we should register for dock

