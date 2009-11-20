Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbZKTA3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbZKTA3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 19:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757782AbZKTA3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 19:29:39 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:35854 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757392AbZKTA3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 19:29:39 -0500
Message-ID: <4B05E183.4010301@jeffreymahoney.com>
Date: Thu, 19 Nov 2009 19:23:31 -0500
From: Jeff Mahoney <jeffm@jeffreymahoney.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: James Bottomley <JBottomley@Novell.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] enclosure: fix oops while iterating enclosure_status array
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 enclosure_status is expected to be a NULL terminated array of strings
 but isn't actually NULL terminated. When writing an invalid value to
 /sys/class/enclosure/.../.../status, it goes off the end of the array
 and Oopses.

 This patch uses the array size instead.

Reported-by: Artur Wojcik <artur.wojcik@intel.com>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 drivers/misc/enclosure.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -412,8 +412,9 @@ static ssize_t set_component_status(stru
 	struct enclosure_component *ecomp = to_enclosure_component(cdev);
 	int i;
 
-	for (i = 0; enclosure_status[i]; i++) {
-		if (strncmp(buf, enclosure_status[i],
+	for (i = 0; i < ARRAY_SIZE(enclosure_status); i++) {
+		if (enclosure_status[i] &&
+		    strncmp(buf, enclosure_status[i],
 			    strlen(enclosure_status[i])) == 0 &&
 		    (buf[strlen(enclosure_status[i])] == '\n' ||
 		     buf[strlen(enclosure_status[i])] == '\0'))
-- 
Jeff Mahoney
