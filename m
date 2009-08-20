Return-Path: <linux-kernel-owner+w=401wt.eu-S932153AbZHTUnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153AbZHTUnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 16:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932138AbZHTUnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 16:43:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:51409 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119AbZHTUnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 16:43:00 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>,
       Alan Stern <stern@rowland.harvard.edu>, dbrownell@users.sourceforge.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 11/11] ehci-dbgp,ehci: Allow dbpg to work with suspend/resume
Date: Thu, 20 Aug 2009 15:39:58 -0500
Message-Id: <1250800798-31559-12-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1250800798-31559-11-git-send-email-jason.wessel@windriver.com>
References: <1250800798-31559-1-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-2-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-3-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-4-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-5-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-6-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-7-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-8-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-9-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-10-git-send-email-jason.wessel@windriver.com>
 <1250800798-31559-11-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 20 Aug 2009 20:41:28.0055 (UTC) FILETIME=[976AB070:01CA21D6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order for the dbgp driver to survive suspend/resume, on every ehci
resume operation the debug controller must get re-initialized.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: dbrownell@users.sourceforge.net
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
---
 drivers/usb/host/ehci-hub.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 452380e..84b972a 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -204,6 +204,13 @@ static int ehci_bus_resume (struct usb_hcd *hcd)
 		return -ESHUTDOWN;
 	}
 
+	if (unlikely(ehci->debug)) {
+		if (ehci->debug && !dbgp_reset_prep())
+			ehci->debug = NULL;
+		else
+			dbgp_external_startup();
+	}
+
 	/* Ideally and we've got a real resume here, and no port's power
 	 * was lost.  (For PCI, that means Vaux was maintained.)  But we
 	 * could instead be restoring a swsusp snapshot -- so that BIOS was
-- 
1.6.3.1.9.g95405b

