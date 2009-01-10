Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbZAJFNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbZAJFNG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 00:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750718AbZAJFMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 00:12:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:44957 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbZAJFMx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 00:12:53 -0500
Date: Fri, 9 Jan 2009 21:14:57 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: rjw@sisk.pl
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       greg@kroah.com
Subject: [PATCH 2/2] resume: wait for device probing to finish
Message-ID: <20090109211457.6b1d37ed@infradead.org>
In-Reply-To: <20090109211346.3ccc36e3@infradead.org>
References: <20090109211346.3ccc36e3@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(this patch needs testing on a few different machines; compile tested only)


>From 10b3e25671c817933e232498a56640fd48964345 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 9 Jan 2009 21:11:23 -0800
Subject: [PATCH] resume: wait for device probing to finish

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
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
