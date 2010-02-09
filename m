Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab0BIBhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 20:37:42 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58737 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124Ab0BIBhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 20:37:40 -0500
X-Sasl-enc: /FJd39G1g95iqlQMUb5jMH7S8qHQ27SQnR3cxRY1TRgI 1265679458
Date: Mon, 8 Feb 2010 23:37:36 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-acpi@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] thinkpad-acpi: setup hotkey polling after changing
 hotkey_driver_mask
Message-ID: <20100209013736.GE21680@khazad-dum.debian.net>
References: <1265567528-1180-1-git-send-email-cascardo@holoscopio.com>
 <20100209003706.GC21680@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100209003706.GC21680@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thadeu, thanks for the detailed analysis of the problem.

Please test the commit below, it should fix things cleanly.  I am quite
tired right now, so I might have missed some details, but it survived a fast
testing and compiled without warnings both with and without poll support
compiled in.

Tested in a T43 by crippling the input device open handle to not start the
poller, and by crippling hotkey_mask support to force the driver to think it
needs to default to poll mode.  Both volume and brightness reporting worked
fine in the test.

If it does fixes the issues you observed, I will add the tested-by, and send
it to Len.


commit 8e05920a6cb236b21f31391b4479ec29ce65ccdf
Author: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Date:   Mon Feb 8 22:40:28 2010 -0200

    thinkpad-acpi: make driver events work in NVRAM poll mode
    
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
    Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
    Cc: Andrew Morton <akpm@linux-foundation.org>

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index d12b61b..09c1fe6 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -2086,6 +2086,7 @@ static struct attribute_set *hotkey_dev_attributes;
 
 static void tpacpi_driver_event(const unsigned int hkey_event);
 static void hotkey_driver_event(const unsigned int scancode);
+static void hotkey_poll_setup(const bool may_warn);
 
 /* HKEY.MHKG() return bits */
 #define TP_HOTKEY_TABLET_MASK (1 << 3)
@@ -2268,6 +2269,8 @@ static int tpacpi_hotkey_driver_mask_set(const u32 mask)
 
 	rc = hotkey_mask_set((hotkey_acpi_mask | hotkey_driver_mask) &
 							~hotkey_source_mask);
+	hotkey_poll_setup(true);
+
 	mutex_unlock(&hotkey_mutex);
 
 	return rc;
@@ -2552,7 +2555,7 @@ static void hotkey_poll_stop_sync(void)
 }
 
 /* call with hotkey_mutex held */
-static void hotkey_poll_setup(bool may_warn)
+static void hotkey_poll_setup(const bool may_warn)
 {
 	const u32 poll_driver_mask = hotkey_driver_mask & hotkey_source_mask;
 	const u32 poll_user_mask = hotkey_user_mask & hotkey_source_mask;
@@ -2583,7 +2586,7 @@ static void hotkey_poll_setup(bool may_warn)
 	}
 }
 
-static void hotkey_poll_setup_safe(bool may_warn)
+static void hotkey_poll_setup_safe(const bool may_warn)
 {
 	mutex_lock(&hotkey_mutex);
 	hotkey_poll_setup(may_warn);
@@ -2601,7 +2604,11 @@ static void hotkey_poll_set_freq(unsigned int freq)
 
 #else /* CONFIG_THINKPAD_ACPI_HOTKEY_POLL */
 
-static void hotkey_poll_setup_safe(bool __unused)
+static void hotkey_poll_setup(const bool __unused)
+{
+}
+
+static void hotkey_poll_setup_safe(const bool __unused)
 {
 }
 

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
