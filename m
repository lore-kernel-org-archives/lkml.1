Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbZDFNke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbZDFNke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 09:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbZDFNkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 09:40:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55239 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbZDFNkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 09:40:25 -0400
From: Jarod Wilson <jarod@redhat.com>
Organization: Red Hat, Inc.
To: carlos@strangeworlds.co.uk
Subject: [PATCH] acer-wmi: don't bother loading on unsupported systems
Date: Mon, 6 Apr 2009 09:40:16 -0400
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-170.2.56.fc10.x86_64; KDE/4.2.1; x86_64; ; )
Cc: aceracpi@googlegroups.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904060940.16889.jarod@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its both a waste of system resources to load this driver on unsupported
systems (which happens often, due to the *Acer* dmi modalias wildcard),
and actually causes problems -- we wind up with a sysfs rfkill entry
that is always disabled, which throws things like NetworkManager for a
loop, causing it to think your wireless card isn't available, even
though the *real* rfkill entry for the card says it is. This is
triggering on multiple Acer Aspire One's here in the office, like so:

NetworkManager: <info> starting...
NetworkManager: <WARN> nm_generic_enable_loopback(): error -17 returned from rtnl_addr_add():#012Sucess#012
NetworkManager: <info> Found radio killswitch /org/freedesktop/Hal/devices/platform_acer_wmi_rfkill_acer_wireless_wlan
NetworkManager: <info> Found radio killswitch /org/freedesktop/Hal/devices/pci_8086_423a_rfkill_5350AGN_wlan
NetworkManager: <info> (eth0): new Ethernet device (driver: 'r8169')
NetworkManager: <info> (eth0): exported as /org/freedesktop/Hal/devices/net_00_1e_68_8a_a1_f8
NetworkManager: <info> (wlan0): driver supports SSID scans (scan_capa 0x01).
NetworkManager: <info> (wlan0): new 802.11 WiFi device (driver: 'iwlagn')
NetworkManager: <info> (wlan0): exported as /org/freedesktop/Hal/devices/net_00_16_eb_04_31_ea
NetworkManager: <info> Trying to start the supplicant...
NetworkManager: <info> Trying to start the system settings daemon...
NetworkManager: <info> Wireless now disabled by radio killswitch
NetworkManager: <info> (wlan0): supplicant manager state: down -> idle

So have acer-wmi just bail on unsupported systems -- includes only my
particular model of the Aspire One atm, but a larger list of unsupported
systems can be found here:

http://code.google.com/p/aceracpi/wiki/SupportedHardware

This might well become unnecessary once the WMI sysfs interface mentioned in
acer-wmi.c exists and the wild-card dmi modalias is gone, but for now... I
prefer to have working wireless, and this isn't exactly an obvious root
cause. I lack the hardware to further extend the blacklist, but doing so is
trivial. Whether or not loading acer-wmi actually negatively impacts
machines other than the AAO is unknown at this time.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---
 drivers/platform/x86/acer-wmi.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index a6a42e8..eda7eea 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -355,6 +355,25 @@ static struct dmi_system_id acer_quirks[] = {
 	{}
 };
 
+static int __init acer_wmi_unsupported_callback(const struct dmi_system_id *id)
+{
+	printk(ACER_INFO "%s not supported by Acer Laptop ACPI-WMI Extras\n",
+	       id->ident);
+	return 1;
+}
+
+static const struct dmi_system_id __initdata acer_wmi_unsupported[] = {
+	{
+		.callback = acer_wmi_unsupported_callback,
+		.ident = "Acer Aspire One",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "AOA110"),
+		},
+	},
+	{}
+};
+
 /* Find which quirks are needed for a particular vendor/ model pair */
 static void find_quirks(void)
 {
@@ -1252,6 +1271,10 @@ static int __init acer_wmi_init(void)
 {
 	int err;
 
+	/* Check for unsupported systems and bail */
+	if (dmi_check_system(acer_wmi_unsupported))
+		return -ENODEV;
+
 	printk(ACER_INFO "Acer Laptop ACPI-WMI Extras\n");
 
 	find_quirks();

-- 
Jarod Wilson
jarod@redhat.com
