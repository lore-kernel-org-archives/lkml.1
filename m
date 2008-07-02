Return-Path: <linux-kernel-owner+w=401wt.eu-S1761631AbYGBCCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761631AbYGBCCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 22:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757990AbYGBCC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 22:02:26 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:32406 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756337AbYGBCCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 22:02:25 -0400
Date: Tue, 1 Jul 2008 20:02:23 -0600
From: Alex Chiang <achiang@hp.com>
To: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com
Cc: garyhade@us.ibm.com, linux-pci@vger.kernel-org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] PCI Hotplug: acpiphp: cleanup notify handler on all root
	bridges
Message-ID: <20080702020223.GA32046@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
	kristen.c.accardi@intel.com, garyhade@us.ibm.com,
	linux-pci@vger.kernel-org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse, Kristen,

During the development of the physical PCI slot patch series,
Gary Hade kept on reporting strange oopses due to interactions
between pci_slot and acpiphp.

	http://lkml.org/lkml/2007/11/28/319

He got busy and went away for a while, and that's when I was able
to sneak my patchset into Jesse's linux-next branch. ;)

Recently, Gary got some time to test again on his x3950 M2
system, and together, we finally figured out the oops.

This bug has always been present in acpiphp so it's not a
regression. So if you want to hold off until the next merge
window, I'm ok with that.

Otherwise, I feel it's pretty low-risk and could go into the next
-rc. Totally your call, I have no strong feelings either way.

Incidentally, figuring out this oops makes me feel a lot more
confident about the pci_slot changes, as this has been in the
back of my mind for a while. (famous last words?)

Thanks,

/ac

From: Alex Chiang <achiang@hp.com>

find_root_bridges() unconditionally installs handle_hotplug_event_bridge()
as an ACPI_SYSTEM_NOTIFY handler for all root bridges.

However, during module cleanup, remove_bridge() will only remove the
notify handler iff the root bridge had a hot-pluggable slot directly
underneath. That is:

	root bridge -> hotplug slot

But, if the topology looks like either of the following:

	root bridge -> non-hotplug slot
	root bridge -> p2p bridge -> hotplug slot

Then we currently do not remove the notify handler from that root bridge.

This can cause a kernel oops if we modprobe acpiphp later and it gets
loaded somewhere else in memory. If the root bridge then receives a
hotplug event, it will then attempt to call a stale, non-existent notify 
handler and we blow up.

Much thanks goes to Gary Hade for his persistent debugging efforts.

Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Gary Hade <garyhade@us.ibm.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 9342c84..a3e4705 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -705,9 +705,10 @@ cleanup_p2p_bridge(acpi_handle handle, u32 lvl, void *context, void **rv)
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
 				cleanup_p2p_bridge, NULL, NULL);
 
-	if (!(bridge = acpiphp_handle_to_bridge(handle)))
-		return AE_OK;
-	cleanup_bridge(bridge);
+	bridge = acpiphp_handle_to_bridge(handle);
+	if (bridge)
+		cleanup_bridge(bridge);
+
 	return AE_OK;
 }
 
@@ -720,9 +721,19 @@ static void remove_bridge(acpi_handle handle)
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
 				(u32)1, cleanup_p2p_bridge, NULL, NULL);
 
+	/*
+	 * On root bridges with hotplug slots directly underneath (ie,
+	 * no p2p bridge inbetween), we call cleanup_bridge(). 
+	 *
+	 * The else clause cleans up root bridges that either had no
+	 * hotplug slots at all, or had a p2p bridge underneath.
+	 */
 	bridge = acpiphp_handle_to_bridge(handle);
 	if (bridge)
 		cleanup_bridge(bridge);
+	else
+		acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+					   handle_hotplug_event_bridge);
 }
 
 static struct pci_dev * get_apic_pci_info(acpi_handle handle)
-- 
1.5.3.1.1.g1e61

