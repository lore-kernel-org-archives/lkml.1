Return-Path: <linux-kernel-owner+w=401wt.eu-S1759818AbZIQDIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759818AbZIQDIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 23:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759439AbZIQDIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 23:08:19 -0400
Received: from mail.windriver.com ([147.11.1.11]:54806 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600AbZIQDIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 23:08:17 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/3] usb console: fix mutex lock regression
Date: Wed, 16 Sep 2009 22:08:05 -0500
Message-Id: <1253156887-31597-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1253156887-31597-1-git-send-email-jason.wessel@windriver.com>
References: <1253156887-31597-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 17 Sep 2009 03:08:15.0416 (UTC) FILETIME=[193C3380:01CA3744]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the 2.6.32 development the use of serial->disc_mutex was
introduced.  In usb_console_setup() the call to
usb_serial_get_by_index() will obtain this mutex. The
usb_console_setup() must release the mutex before it completes else
later calls to the usb serial core will hang.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg KH <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>

---
 drivers/usb/serial/console.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
index be086e4..166ba4e 100644
--- a/drivers/usb/serial/console.c
+++ b/drivers/usb/serial/console.c
@@ -176,6 +176,7 @@ static int usb_console_setup(struct console *co, char *options)
 	 * indicate this port is now acting as a system console. */
 	port->console = 1;
 	retval = 0;
+	mutex_unlock(&serial->disc_mutex);
 
 out:
 	return retval;
-- 
1.6.4.rc1

