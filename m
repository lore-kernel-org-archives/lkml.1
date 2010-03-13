Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935771Ab0CMAsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:48:16 -0500
Received: from kroah.org ([198.145.64.141]:47110 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935509Ab0CMAcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:32:14 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:14 2010
Message-Id: <20100313002714.734756416@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:27:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [109/145] thinkpad-acpi: make driver events work in NVRAM poll mode
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

commit 7f0cf712a74fcc3ad21f0bde95bd32c2f2cc3888 upstream.

Thadeu Lima de Souza Cascardo reports this:

Brightness notification does not work until the user writes to
hotkey_mask attribute.  That's because the polling thread will only run
if hotkey_user_mask is set and someone is reading the input device or
if hotkey_driver_mask is set.  In this second case, this condition is
not tested after the mask is changed, because the brightness and
volume drivers are started after the hotkey drivers.

Fix tpacpi_hotkey_driver_mask_set() to call hotkey_poll_setup(), so
that the poller kthread will be started when needed.

Reported-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Tested-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/thinkpad_acpi.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -2073,6 +2073,7 @@ static struct attribute_set *hotkey_dev_
 
 static void tpacpi_driver_event(const unsigned int hkey_event);
 static void hotkey_driver_event(const unsigned int scancode);
+static void hotkey_poll_setup(const bool may_warn);
 
 /* HKEY.MHKG() return bits */
 #define TP_HOTKEY_TABLET_MASK (1 << 3)
@@ -2254,6 +2255,8 @@ static int tpacpi_hotkey_driver_mask_set
 
 	rc = hotkey_mask_set((hotkey_acpi_mask | hotkey_driver_mask) &
 							~hotkey_source_mask);
+	hotkey_poll_setup(true);
+
 	mutex_unlock(&hotkey_mutex);
 
 	return rc;
@@ -2538,7 +2541,7 @@ static void hotkey_poll_stop_sync(void)
 }
 
 /* call with hotkey_mutex held */
-static void hotkey_poll_setup(bool may_warn)
+static void hotkey_poll_setup(const bool may_warn)
 {
 	const u32 poll_driver_mask = hotkey_driver_mask & hotkey_source_mask;
 	const u32 poll_user_mask = hotkey_user_mask & hotkey_source_mask;
@@ -2569,7 +2572,7 @@ static void hotkey_poll_setup(bool may_w
 	}
 }
 
-static void hotkey_poll_setup_safe(bool may_warn)
+static void hotkey_poll_setup_safe(const bool may_warn)
 {
 	mutex_lock(&hotkey_mutex);
 	hotkey_poll_setup(may_warn);
@@ -2587,7 +2590,11 @@ static void hotkey_poll_set_freq(unsigne
 
 #else /* CONFIG_THINKPAD_ACPI_HOTKEY_POLL */
 
-static void hotkey_poll_setup_safe(bool __unused)
+static void hotkey_poll_setup(const bool __unused)
+{
+}
+
+static void hotkey_poll_setup_safe(const bool __unused)
 {
 }
 


