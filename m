Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbZBBRWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbZBBRWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 12:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755893AbZBBRWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 12:22:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:50400 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbZBBRWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 12:22:14 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Luca Tettamanti <kronos.it@gmail.com>
Subject: [PATCH 1/2] RFC: ACPI: Interface for ACPI drivers to place quirk code which gets executed early
Date: Mon, 2 Feb 2009 18:22:10 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.13-HEAD_20090130075504_71baee03-default; KDE/4.1.3; x86_64; ; )
Cc: Jean Delvare <khali@linux-fr.org>, Hans de Goede <hdegoede@redhat.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>
References: <20090125210520.GA12963@dreamland.darkstar.lan> <20090202101103.1208c035@hyperion.delvare> <68676e00902020338o7326ff7dx4efadf94ed534acf@mail.gmail.com>
In-Reply-To: <68676e00902020338o7326ff7dx4efadf94ed534acf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200902021822.11906.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n12HNfwM000745

Hi,
On Monday 02 February 2009 12:38:24 Luca Tettamanti wrote:> On Mon, Feb 2, 2009 at 10:11 AM, Jean Delvare <khali@linux-fr.org> wrote:> > On Sun, 1 Feb 2009 22:22:43 +0100, Luca Tettamanti wrote:> >> --- a/drivers/acpi/osl.c> >> +++ b/drivers/acpi/osl.c> >> @@ -1063,7 +1063,10 @@ __setup("acpi_wake_gpes_always_on",> >> acpi_wake_gpes_always_on_setup); * in arbitrary AML code and can> >> interfere with legacy drivers. * acpi_enforce_resources= can be set to:> >>   *> >> - *   - strict           (2)> >> + *   - auto             (2)> >> + *     -> detect possible conflicts with ACPI drivers and switch to> >> + *     strict if needed, otherwise act like lax> >> + *   - strict           (3)> >>   *     -> further driver trying to access the resources will not load> >>   *   - lax (default)    (1)> >>   *     -> further driver trying to access the resources will load, but> >> you @@ -1073,11 +1076,12 @@ __setup("acpi_wake_gpes_always_on",> >> acpi_wake_gpes_always_on_setup); *     -> ACPI Operation Region> >> resources will not be registered *> >>   */> >> -#define ENFORCE_RESOURCES_STRICT 2> >> +#define ENFORCE_RESOURCES_STRICT 3> >> +#define ENFORCE_RESOURCES_AUTO   2> >>  #define ENFORCE_RESOURCES_LAX    1> >>  #define ENFORCE_RESOURCES_NO     0> >> > I don't see any reason to change ENFORCE_RESOURCES_STRICT from 2 to 3.> > Just add ENFORCE_RESOURCES_AUTO as 3 and that's it, makes your patch> > smaller.>> There's an unspoken reason ;-) The options are ordered by> "strictness", I was experimenting with an API to export the parameter,> in order to move the code to a separate quirk file. Since it's not> relevant in this patch I'll back out the change.
I am still running an fsck as I filled up the fs I worked on to 100%, whichtakes hours for the 300G partition. I hope I didn't mess up something, dueto the full fs, but I do not want to wait until tomorrow, you already mightwant to have a look at this.
These two patches are tested on a ASUS machine and worked as expected,but probably may still need some cleanup.
There is the problem that the quirks are not executed for deviceswhich are not present. But this is due to the poor ACPI hotplug design,which hopefully will be reworked at some time.
Both are against Len's latest ACPI git test branch.
Len, if you like these, tell me and I am going to make themcheck_patch clean and I will send them again.
Thanks,
    Thomas
---
ACPI: Interface for ACPI drivers to place quirk code which gets executed early
Some ACPI drivers need ACPI namespace info before the driver is actuallyloaded.Best examples are legacy vs ACPI driver competitors like ATK0110 vs hwmondrivers and the generic ACPI video driver vs laptop drivers.There may also pop up other examples in the future where this interface willbecome convenient.
Signed-off-by: Thomas Renninger <trenn@suse.de>
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefileindex 65d90c7..498cc6f 100644--- a/drivers/acpi/Makefile+++ b/drivers/acpi/Makefile@@ -59,3 +59,4 @@ obj-$(CONFIG_ACPI_HOTPLUG_MEMORY)	+= acpi_memhotplug.o obj-$(CONFIG_ACPI_PROCFS_POWER)	+= cm_sbs.o obj-$(CONFIG_ACPI_SBS)		+= sbshc.o obj-$(CONFIG_ACPI_SBS)		+= sbs.o+obj-y                           += quirks.o\ No newline at end of filediff --git a/drivers/acpi/acpi.h b/drivers/acpi/acpi.hnew file mode 100644index 0000000..95e29ca--- /dev/null+++ b/drivers/acpi/acpi.h@@ -0,0 +1,8 @@+#ifndef _LINUX_LOCAL_ACPI_H+#define _LINUX_LOCAL_ACPI_H++#include <linux/init.h>++void __init acpi_device_quirks(void);++#endif /* _LINUX_LOCAL_ACPI_H */diff --git a/drivers/acpi/quirks.c b/drivers/acpi/quirks.cnew file mode 100644index 0000000..844480e--- /dev/null+++ b/drivers/acpi/quirks.c@@ -0,0 +1,73 @@+/*+ *  Copyright (c) 2008 Thomas Renninger <trenn@suse.de>+ *+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+ *+ *  This program is free software; you can redistribute it and/or modify+ *  it under the terms of the GNU General Public License as published by+ *  the Free Software Foundation; either version 2 of the License, or+ *  (at your option) any later version.+ *+ *  This program is distributed in the hope that it will be useful,+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the+ *  GNU General Public License for more details.+ *+ *  You should have received a copy of the GNU General Public License+ *  along with this program; if not, write to the Free Software+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA+ *+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+ */++#include <linux/mod_devicetable.h>+#include <acpi/acpi_bus.h>+#include "acpi.h"++struct acpi_device_fixup {+	const char *hid;+	int (*fixup_cb)(struct acpi_device*);+};++/*+ * Add a callback here if your module needs to process code after the ACPI+ * core has parsed the DSDT and initialized all devices, but the code must+ * be processed before module load time.+ * Good candiates are ACPI vs legacy driver decisions which must be made+ * before the driver is loaded.+ */+const struct acpi_device_fixup __initdata fixup_table[] = {+};++static acpi_status __init+acpi_device_quirks_callback(acpi_handle handle,+			    u32 level, void *ctxt, void **retv)+{+	acpi_status status;+	struct acpi_device *dev;+	struct acpi_device_id dev_id;+	int x, ret;++	status = acpi_bus_get_device(handle, &dev);+	if (ACPI_FAILURE(status))+		return AE_OK;++	for (x = 0; x < ARRAY_SIZE(fixup_table); x++) {+		memcpy(&dev_id.id, fixup_table[x].hid, ACPI_ID_LEN);+		if (!acpi_match_device_ids(dev, &dev_id)) {+			ret = fixup_table[x].fixup_cb(dev);+			if (ret)+				printk (KERN_ERR "Fixup failed for device: "+					"%s\n", fixup_table[x].hid);+		}+	}+	return AE_OK;+}++void __init acpi_device_quirks(void) {++	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,+			    ACPI_UINT32_MAX,+			    acpi_device_quirks_callback,+			    NULL, NULL);+}diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.cindex c54d7b6..1c25747 100644--- a/drivers/acpi/scan.c+++ b/drivers/acpi/scan.c@@ -10,6 +10,7 @@ #include <linux/kthread.h>  #include <acpi/acpi_drivers.h>+#include "acpi.h"  #define _COMPONENT		ACPI_BUS_COMPONENT ACPI_MODULE_NAME("scan");@@ -1562,6 +1563,8 @@ static int __init acpi_scan_init(void)  	if (result) 		acpi_device_unregister(acpi_root, ACPI_BUS_REMOVAL_NORMAL);+	else+		acpi_device_quirks();        Done: 	return result; ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
