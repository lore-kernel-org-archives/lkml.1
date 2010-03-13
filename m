Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935798Ab0CMAfp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:35:45 -0500
Received: from kroah.org ([198.145.64.141]:47062 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935508Ab0CMAcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:32:13 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:14 2010
Message-Id: <20100313002714.651144506@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:27:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [108/145] thinkpad-acpi: document HKEY event 3006
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

commit bf8b29c8f7f8269e99eca8b19048ed5b34b51810 upstream.

Event 0x3006 is used to help power management of the ODD in the
UltraBay.  The EC generates this event when the ODD eject button is
pressed (even if the bay is powered down).

Normally, Linux doesn't need this as we keep the SATA link powered
up (which wastes power).  The EC powers up the bay by itself when the
ODD eject button is pressed, and the SATA PHY reports the hotplug.

However, we could also power that SATA link down (and for that matter,
also power down the Ultrabay) if the ODD is left idle for a while with
no disk inside, and use event 0x3006 to know when we need that SATA link
powered back up.

For now, just stop asking for more information when event 0x3006 is
seen, there is no point in pestering users about it anymore.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/thinkpad_acpi.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -3630,13 +3630,19 @@ static void hotkey_notify(struct ibm_str
 			break;
 		case 3:
 			/* 0x3000-0x3FFF: bay-related wakeups */
-			if (hkey == TP_HKEY_EV_BAYEJ_ACK) {
+			switch (hkey) {
+			case TP_HKEY_EV_BAYEJ_ACK:
 				hotkey_autosleep_ack = 1;
 				printk(TPACPI_INFO
 				       "bay ejected\n");
 				hotkey_wakeup_hotunplug_complete_notify_change();
 				known_ev = true;
-			} else {
+				break;
+			case TP_HKEY_EV_OPTDRV_EJ:
+				/* FIXME: kick libata if SATA link offline */
+				known_ev = true;
+				break;
+			default:
 				known_ev = false;
 			}
 			break;


