Return-Path: <linux-kernel-owner+w=401wt.eu-S1764854AbZBNBWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764854AbZBNBWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762936AbZBNBIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:08:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40917 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762633AbZBNBIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:08:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 2/9] PM/resume: wait for device probing to finish
Date: Sat, 14 Feb 2009 02:00:19 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>
References: <200902140157.40869.rjw@sisk.pl>
In-Reply-To: <200902140157.40869.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902140200.21022.rjw@sisk.pl>
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
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/disk.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -595,6 +595,12 @@ static int software_resume(void)
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
@@ -610,6 +616,11 @@ static int software_resume(void)
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
