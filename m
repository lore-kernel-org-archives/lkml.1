Return-Path: <linux-kernel-owner+w=401wt.eu-S1760435AbYJKHjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760435AbYJKHjZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757050AbYJKHhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 03:37:11 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:48107 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758034AbYJKHhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 03:37:09 -0400
Date: Sat, 11 Oct 2008 02:36:05 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 45/85] ACPI Suspend: Enable ACPI during resume if SCI_EN is not
 set
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Message-id: <73ebf767b33707fcd050e3f37b7dbf4b1370b0c5.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
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
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/sleep/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index c7f0c9c..5419938 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -233,6 +233,8 @@ static int acpi_suspend_enter(suspend_state_t pm_state)
 		break;
 	}
 
+	/* If ACPI is not enabled by the BIOS, we need to enable it here. */
+	acpi_enable();
 	/* Reprogram control registers and execute _BFS */
 	acpi_leave_sleep_state_prep(acpi_state);
 
-- 
1.5.5.1

