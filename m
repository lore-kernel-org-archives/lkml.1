Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbZFAOQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbZFAOQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 10:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbZFAOQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 10:16:11 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48151 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbZFAOQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 10:16:07 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Mario Limonciello <mario_limonciello@dell.com>,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/3] dell-wmi: Mask off upper bytes of event response
Date: Mon,  1 Jun 2009 15:14:35 +0100
Message-Id: <1243865677-25425-1-git-send-email-mjg@redhat.com>
X-Mailer: git-send-email 1.6.2.2
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 78.86.230.144
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mario Limonciello <mario_limonciello@dell.com>

From: Mario Limonciello <mario_limonciello@dell.com>

In debugging with some future machines that actually contain BIOS level
support for dell-wmi, I've determined that the upper half of the data
that comes back from wmi_get_event_data may sometimes contain extra
information that isn't currently relevant when pulling scan codes out of
the data.  This causes dell-wmi to improperly respond to these events.

Signed-off-by: Mario Limonciello <mario_limonciello@dell.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/platform/x86/dell-wmi.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index 2fab941..8a0d39e 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -122,7 +122,12 @@ static void dell_wmi_notify(u32 value, void *context)
 
 	if (obj && obj->type == ACPI_TYPE_BUFFER) {
 		int *buffer = (int *)obj->buffer.pointer;
-		key = dell_wmi_get_entry_by_scancode(buffer[1]);
+		/*
+		 *  The upper bytes of the event may contain
+		 *  additional information, so mask them off for the
+		 *  scancode lookup
+		 */
+		key = dell_wmi_get_entry_by_scancode(buffer[1] & 0xFFFF);
 		if (key) {
 			input_report_key(dell_wmi_input_dev, key->keycode, 1);
 			input_sync(dell_wmi_input_dev);
-- 
1.6.2.2

