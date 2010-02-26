Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965087Ab0BZPTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 10:19:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965050Ab0BZPTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 10:19:14 -0500
From: Matthew Garrett <mjg@redhat.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
       Mario Limonciello <Mario_Limonciello@Dell.com>
Subject: [PATCH 07/14] dell-laptop: Block software state changes when rfkill hard blocked
Date: Fri, 26 Feb 2010 10:18:40 -0500
Message-Id: <1267197527-18062-8-git-send-email-mjg@redhat.com>
In-Reply-To: <1267197527-18062-1-git-send-email-mjg@redhat.com>
References: <1267197527-18062-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 66.187.234.200
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mario Limonciello <Mario_Limonciello@Dell.com>

The "hardware" switch is tied directly to a BIOS interface that will
connect and disconnect the hardware from the bus.

If you use the software interface to request the BIOS to make these
changes, the HW switch will be in an inconsistent state and LEDs may not
reflect the state of the HW.

Signed-off-by: Mario Limonciello <Mario_Limonciello@Dell.com>
---
 drivers/platform/x86/dell-laptop.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index b13eb6a..81213e8 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -190,6 +190,10 @@ static int dell_rfkill_set(void *data, bool blocked)
 	unsigned long radio = (unsigned long)data;
 
 	memset(&buffer, 0, sizeof(struct calling_interface_buffer));
+	dell_send_request(&buffer, 17, 11);
+	if (!(buffer.output[1] & BIT(16)))
+		return -EINVAL;
+
 	buffer.input[0] = (1 | (radio<<8) | (disable << 16));
 	dell_send_request(&buffer, 17, 11);
 
-- 
1.6.6.1

