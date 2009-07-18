Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbZGRQzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbZGRQzb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 12:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbZGRQz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 12:55:29 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:58300 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbZGRQz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 12:55:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=xMv4v6S0MJL3i8GkID5Pl/u79/cXfwF0WmUYqSJPTWU7OG3G8hcb+e3QeSbLRdveL9
         EIvF5z9ovbYIJpGRQA9gkDuZ2J392seB88q8HD2yhQCj4cjt5PKjcQFAINIdzKtZ0gTA
         yBfsShfgRcCN7k1kRCzOe6X7nEHQg35+9vVcg=
Message-ID: <4A61FE7D.9080409@tuffmail.co.uk>
Date: Sat, 18 Jul 2009 17:55:25 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Frans Pop <elendil@planet.nl>, Larry Finger <Larry.Finger@lwfinger.net>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       linux acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RFT] hp-wmi: improved rfkill support for wifi
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I borrowed a HP G7000 last week.  The hp-wmi driver seemed a bit
confused about hard v.s. soft blocks on the wifi, so I fixed it based on
acpidump output [1].  I hope this will work on other HP model numbers,
but it would benefit from testing.  Any volunteers?

The wireless is toggled by a hardware button.  If your laptop is the
same, you should see a "2" in the output of "cat
/sys/class/rfkill/rfkill*/state" when the wireless is disabled.  "1"
means enabled, and "0" means "disabled by software".  Without this
patch, the driver would wrongly show "0" when the wireless was disabled
by the hardware button.

There are some other side-effects which the patch should fix.  I think
it should improve behaviour when you disable the wireless and reboot
into Windows, or vice versa.  Without the patch, it seemed that hp-wmi
would leave a "soft block" without being asked to.  After disabling the
wireless and rebooting into Windows, pressing the wireless button failed
to re-enable it.  Instead, the HP Wireless Assistant popup toggled
between "wireless disabled" and "wireless off".

[1] HP G7000 acpidump.out
<http://bugzilla.kernel.org/show_bug.cgi?id=13745#c1>

Thanks
Alan

----->
>From 9446bad909bf4c6b3d6d57d2f364ac18616f9baa Mon Sep 17 00:00:00 2001
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date: Sat, 18 Jul 2009 16:48:37 +0100
Subject: [PATCH] [PATCH] hp-wmi: improve wlan rfkill support

1) The platform appears to support both hardware and software block
   states.  The current code only reads the overall state, and reports
   it as the software state.  Fix it.

2) Since the software state appears to be persistent, mark it as such.

3) Check rfkill in the resume handler resume.  Both the hard and soft
   blocked states could change over hibernation.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
 drivers/platform/x86/hp-wmi.c |   27 +++++++++++++++++++++++----
 1 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index ca50856..517ac47 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -180,11 +180,21 @@ static const struct rfkill_ops hp_wmi_rfkill_ops = {
 	.set_block = hp_wmi_set_block,
 };
 
-static bool hp_wmi_wifi_state(void)
+static bool hp_wmi_wifi_sw_state(void)
 {
 	int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
 
-	if (wireless & 0x100)
+	if (wireless & 0x200)
+		return false;
+	else
+		return true;
+}
+
+static bool hp_wmi_wifi_hw_state(void)
+{
+	int wireless = hp_wmi_perform_query(HPWMI_WIRELESS_QUERY, 0, 0);
+
+	if (wireless & 0x800)
 		return false;
 	else
 		return true;
@@ -359,8 +369,9 @@ static void hp_wmi_notify(u32 value, void *context)
 			input_sync(hp_wmi_input_dev);
 		} else if (eventcode == 0x5) {
 			if (wifi_rfkill)
-				rfkill_set_sw_state(wifi_rfkill,
-						    hp_wmi_wifi_state());
+				rfkill_set_states(wifi_rfkill,
+						  hp_wmi_wifi_sw_state(),
+						  hp_wmi_wifi_hw_state());
 			if (bluetooth_rfkill)
 				rfkill_set_sw_state(bluetooth_rfkill,
 						    hp_wmi_bluetooth_state());
@@ -451,6 +462,10 @@ static int __init hp_wmi_bios_setup(struct platform_device *device)
 					   RFKILL_TYPE_WLAN,
 					   &hp_wmi_rfkill_ops,
 					   (void *) 0);
+		rfkill_init_sw_state(wifi_rfkill,
+				     hp_wmi_wifi_sw_state());
+		rfkill_set_hw_state(wifi_rfkill,
+				    hp_wmi_wifi_hw_state());
 		err = rfkill_register(wifi_rfkill);
 		if (err)
 			goto register_wifi_error;
@@ -526,6 +541,10 @@ static int hp_wmi_resume_handler(struct platform_device *device)
 			    hp_wmi_tablet_state());
 	input_sync(hp_wmi_input_dev);
 
+	rfkill_set_states(wifi_rfkill,
+			  hp_wmi_wifi_sw_state(),
+			  hp_wmi_wifi_hw_state());
+
 	return 0;
 }
 
-- 
1.6.3.2



