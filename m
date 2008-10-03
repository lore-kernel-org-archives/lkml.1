Return-Path: <linux-kernel-owner+w=401wt.eu-S1754605AbYJCWAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbYJCWAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 18:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbYJCWAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 18:00:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41599 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753097AbYJCWAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 18:00:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI Suspend: Enable ACPI during resume if SCI_EN is not set
Date: Sat, 4 Oct 2008 00:05:05 +0200
User-Agent: KMail/1.9.9
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810040005.06220.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

ACPI Suspend: Enable ACPI during resume if SCI_EN is not set

On some machines, like for example MSI Wind U100, the BIOS doesn't
enable ACPI before returning control to the OS, which sometimes
causes resume to fail.  This is against the ACPI specification,
which clearly states that "When the platform is waking from an S1, S2
or S3 state, OSPM assumes the hardware is already in the ACPI mode
and will not issue an ACPI_ENABLE", but it won't hurt to check the
SCI_EN bit and enable ACPI during resume from S3 if this bit is not
set.

Fortunately, we already have acpi_enable() for that, so use it in the
resume code path, before executing _BFS, in analogy with the
resume-from-hibernation code path.

NOTE: We aren't supposed to set SCI_EN directly, because it's owned
by the hardware.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/sleep/main.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep/main.c
+++ linux-2.6/drivers/acpi/sleep/main.c
@@ -200,6 +200,8 @@ static int acpi_suspend_enter(suspend_st
 		break;
 	}
 
+	/* If ACPI is not enabled by the BIOS, we need to enable it here. */
+	acpi_enable();
 	/* Reprogram control registers and execute _BFS */
 	acpi_leave_sleep_state_prep(acpi_state);
 
