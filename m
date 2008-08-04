Return-Path: <linux-kernel-owner+w=401wt.eu-S1764054AbYHDU1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764054AbYHDU1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763431AbYHDU1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:27:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45890 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763998AbYHDU1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:27:19 -0400
Date: Mon, 4 Aug 2008 13:15:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Holger Macht <hmacht@suse.de>,
       Len Brown <len.brown@intel.com>
Subject: [patch 19/33] bay: exit if notify handler cannot be installed
Message-ID: <20080804201556.GT1139@suse.de>
References: <20080804200515.110033151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="bay-exit-if-notify-handler-cannot-be-installed.patch"
In-Reply-To: <20080804201321.GA1139@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Holger Macht <hmacht@suse.de>

commit 7efd52a407bed6a2b02015b8ebbff7beba155392 upstream

If acpi_install_notify_handler() for a bay device fails, the bay driver is
superfluous.  Most likely, another driver (like libata) is already caring
about this device anyway.  Furthermore,
register_hotplug_dock_device(acpi_handle) from the dock driver must not be
called twice with the same handler.  This would result in an endless loop
consuming 100% of CPU.  So clean up and exit.

Signed-off-by: Holger Macht <hmacht@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/bay.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/acpi/bay.c
+++ b/drivers/acpi/bay.c
@@ -299,16 +299,20 @@ static int bay_add(acpi_handle handle, i
 	 */
 	pdev->dev.uevent_suppress = 0;
 
-	if (acpi_bay_add_fs(new_bay)) {
-		platform_device_unregister(new_bay->pdev);
-		goto bay_add_err;
-	}
-
 	/* register for events on this device */
 	status = acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 			bay_notify, new_bay);
 	if (ACPI_FAILURE(status)) {
-		printk(KERN_ERR PREFIX "Error installing bay notify handler\n");
+		printk(KERN_INFO PREFIX "Error installing bay notify handler\n");
+		platform_device_unregister(new_bay->pdev);
+		goto bay_add_err;
+	}
+
+	if (acpi_bay_add_fs(new_bay)) {
+		acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+					   bay_notify);
+		platform_device_unregister(new_bay->pdev);
+		goto bay_add_err;
 	}
 
 	/* if we are on a dock station, we should register for dock

-- 
