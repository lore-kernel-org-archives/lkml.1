Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbZANWEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbZANWEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbZANWE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:04:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33161 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbZANWEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:04:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] resume: wait for device probing to finish
Date: Wed, 14 Jan 2009 23:03:45 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-rjw; KDE/4.1.3; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901142303.46166.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>

the resume code does not currently wait for device probing to finish.
Even without async function calls this is dicey and not correct,
but with async function calls during the boot sequence this is going
to get hit more...

This patch adds the synchronization using the newly introduced helper.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/power/disk.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/kernel/power/disk.c b/kernel/power/disk.c
index 45e8541..d2d24b7 100644
--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -585,6 +585,12 @@ static int software_resume(void)
 	unsigned int flags;
 
 	/*
+	 * If the user said "noresume".. bail out early.
+	 */
+	if (noresume)
+		return 0;
+
+	/*
 	 * name_to_dev_t() below takes a sysfs buffer mutex when sysfs
 	 * is configured into the kernel. Since the regular hibernate
 	 * trigger path is via sysfs which takes a buffer mutex before
@@ -600,6 +606,11 @@ static int software_resume(void)
 			mutex_unlock(&pm_mutex);
 			return -ENOENT;
 		}
+		/*
+		 * Some device discovery might still be in progress; we need
+		 * to wait for this to finish.
+		 */
+		wait_for_device_probe();
 		swsusp_resume_device = name_to_dev_t(resume_file);
 		pr_debug("PM: Resume from partition %s\n", resume_file);
 	} else {
-- 
