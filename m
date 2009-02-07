Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbZBGLWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbZBGLWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 06:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbZBGLWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 06:22:11 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:13661 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbZBGLWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 06:22:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=rxpjUmpqkND5FWp3GwAclCAuYJJ03PH3WZrzprooem2vAfSzAcE3vV4t3LZuOJrEva
         eyvZQ9qfcOt+nspSAapuqjB2AJHhzfvpWJKalKOjHwQzzFGr34oQl4lQX8pgptk+WiV4
         VDbsh/xzU0IdT/ndvvMrC3i8/Kdsko/dq9OgI=
Subject: Re: [git pull] ACPI patches for 2.6.29-rc3
From: Richard Hughes <hughsient@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0902070148440.26256@localhost.localdomain>
References: <alpine.LFD.2.00.0902070148440.26256@localhost.localdomain>
Content-Type: multipart/mixed; boundary="=-YC5ITcezw+vmippHJnuN"
Date: Sat, 07 Feb 2009 11:21:23 +0000
Message-Id: <1234005683.10134.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 (2.25.90-1.fc11) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YC5ITcezw+vmippHJnuN
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, 2009-02-07 at 01:59 -0500, Len Brown wrote:
> Nothing too Earth-shaking.
> This will update the files shown below.

No sign of my battery patch (attached, again) to fix the confirmed
userspace breakage of the acpi battery on some hardware (T61 and other
Lenovo models).

I've filed http://bugzilla.kernel.org/show_bug.cgi?id=12632 and it's in
status "RESOLVED CODE_FIX" but it seems nobody has done anything with
the patch.

Please, tell me what I need to do to get this merged. If it's not merged
soon, I'll just switch HAL back to using /proc/acpi by default as it's
affecting real users right now.

Thanks,

Richard.


--=-YC5ITcezw+vmippHJnuN
Content-Disposition: attachment; filename="0001-battery-don-t-assume-we-are-fully-charged-when-not.patch"
Content-Type: text/x-patch; name="0001-battery-don-t-assume-we-are-fully-charged-when-not.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 3b0fb1239e5bc064766ffa3d7a45265e722fb9eb Mon Sep 17 00:00:00 2001
From: Richard Hughes <hughsient@gmail.com>
Date: Sun, 25 Jan 2009 15:05:50 +0000
Subject: [PATCH] battery: don't assume we are fully charged when not charging or discharging

On hardware like the T61 it can take a couple of seconds for the battery
to start charging after the power is connected, and we incorrectly tell
userspace that we are fully charged, and then go back to charging.

Only mark a battery as fully charged when the preset charge matches either
the last full charge, or the design charge.

Signed-off-by: Richard Hughes <hughsient@gmail.com>
---
 drivers/acpi/battery.c |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 65132f9..69cbc57 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -138,6 +138,29 @@ static int acpi_battery_technology(struct acpi_battery *battery)
 
 static int acpi_battery_get_state(struct acpi_battery *battery);
 
+static int acpi_battery_is_charged(struct acpi_battery *battery)
+{
+	/* either charging or discharging */
+	if (battery->state != 0)
+		return 0;
+
+	/* battery not reporting charge */
+	if (battery->capacity_now == ACPI_BATTERY_VALUE_UNKNOWN ||
+	    battery->capacity_now == 0)
+		return 0;
+
+	/* good batteries update full_charge as the batteries degrade */
+	if (battery->full_charge_capacity == battery->capacity_now)
+		return 1;
+
+	/* fallback to using design values for broken batteries */
+	if (battery->design_capacity == battery->capacity_now)
+		return 1;
+
+	/* we don't do any sort of metric based on percentages */
+	return 0;
+}
+
 static int acpi_battery_get_property(struct power_supply *psy,
 				     enum power_supply_property psp,
 				     union power_supply_propval *val)
@@ -155,7 +178,7 @@ static int acpi_battery_get_property(struct power_supply *psy,
 			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
 		else if (battery->state & 0x02)
 			val->intval = POWER_SUPPLY_STATUS_CHARGING;
-		else if (battery->state == 0)
+		else if (acpi_battery_is_charged(battery))
 			val->intval = POWER_SUPPLY_STATUS_FULL;
 		else
 			val->intval = POWER_SUPPLY_STATUS_UNKNOWN;
-- 
1.6.0.6


--=-YC5ITcezw+vmippHJnuN--

