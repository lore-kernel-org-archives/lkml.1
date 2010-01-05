Return-Path: <linux-kernel-owner+w=401wt.eu-S1754237Ab0AEAyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab0AEAyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:54:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227Ab0AEAez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:34:55 -0500
Received: from kroah.org ([198.145.64.141]:34133 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054Ab0AEAeu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:50 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Zhao Yakui <yakui.zhao@intel.com>,
       Len Brown <len.brown@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/97] ACPI: Use the return result of ACPI lid notifier chain correctly
Date: Mon,  4 Jan 2010 16:32:29 -0800
Message-Id: <1262651630-7354-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhao Yakui <yakui.zhao@intel.com>

commit 13c199c0d0cf78b27592991129fb8cbcfc5164de upstream.

On some laptops it will return NOTIFY_OK(non-zero) when calling the ACPI LID
notifier. Then it is used as the result of ACPI LID resume function, which
will complain the following warning message in course of suspend/resume:

     >PM: Device PNP0C0D:00 failed to resume: error 1

This patch is to eliminate the above warning message.

http://bugzilla.kernel.org/show_bug.cgi?id=14782

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/acpi/button.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index 0c9c6a9..8a95e83 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -282,6 +282,13 @@ static int acpi_lid_send_state(struct acpi_device *device)
 	if (ret == NOTIFY_DONE)
 		ret = blocking_notifier_call_chain(&acpi_lid_notifier, state,
 						   device);
+	if (ret == NOTIFY_DONE || ret == NOTIFY_OK) {
+		/*
+		 * It is also regarded as success if the notifier_chain
+		 * returns NOTIFY_OK or NOTIFY_DONE.
+		 */
+		ret = 0;
+	}
 	return ret;
 }
 
-- 
1.6.6

