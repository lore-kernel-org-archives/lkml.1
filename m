Return-Path: <linux-kernel-owner+w=401wt.eu-S1761102AbXEWRtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761102AbXEWRtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756906AbXEWRtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:49:10 -0400
Received: from waste.org ([66.93.16.53]:42702 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756342AbXEWRtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:49:09 -0400
Date: Wed, 23 May 2007 12:48:36 -0500
From: Matt Mackall <mpm@selenic.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: 2.6.21-mm2: ACPI exception on resume
Message-ID: <20070523174836.GB11115@waste.org>
References: <20070519165738.GK11115@waste.org> <20070523001943.GA3743@khazad-dum.debian.net> <20070523014825.GX11115@waste.org> <200705231057.48320.rjw@sisk.pl> <20070523171330.GB9987@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523171330.GB9987@khazad-dum.debian.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 02:13:30PM -0300, Henrique de Moraes Holschuh wrote:
> On Wed, 23 May 2007, Rafael J. Wysocki wrote:
> > While I agree with that, it would really be helpful if you tested the latest -rc
> > kernel and saw if the bug was present in there.
> > 
> > If the bug is not present in the latest -rc, it'll be possible to identify the
> > patch that causes it to appear in -mm and find the reason of the breakage.
> 
> And, once we know the reason, we will be able to find out how to best fix the
> problem.
> 
> So, do please test latest -rc, or bissect to the last known-good kernel. As
> I said, we need further data points to do anything.

This isn't conclusive as this bug is fairly hard to trigger, but it
looks like the culprit may have been this patch and not anything in
-mm or mainline. So the below patch doesn't help the problem it was
intended for (lid switch no longer wakes up S2R after a S2D cycle) and
appears to be implicated in making my EC unhappy.

-----------------

Can you please check if the appended debug patch helps?

Rafael

---
 kernel/power/disk.c |    4 ++--
 kernel/power/user.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6.21-rc7/kernel/power/disk.c
===================================================================
--- linux-2.6.21-rc7.orig/kernel/power/disk.c
+++ linux-2.6.21-rc7/kernel/power/disk.c
@@ -170,9 +170,9 @@ int pm_suspend_disk(void)
 
 	if (in_suspend) {
 		enable_nonboot_cpus();
-		platform_finish();
 		device_resume();
 		resume_console();
+		platform_finish();
 		pr_debug("PM: writing image.\n");
 		error = swsusp_write();
 		if (!error)
@@ -189,9 +189,9 @@ int pm_suspend_disk(void)
  Enable_cpus:
 	enable_nonboot_cpus();
  Resume_devices:
-	platform_finish();
 	device_resume();
 	resume_console();
+	platform_finish();
  Thaw:
 	unprepare_processes();
  Finish:
Index: linux-2.6.21-rc7/kernel/power/user.c
===================================================================
--- linux-2.6.21-rc7.orig/kernel/power/user.c
+++ linux-2.6.21-rc7/kernel/power/user.c
@@ -170,11 +170,11 @@ static inline int snapshot_suspend(int p
 	}
 	enable_nonboot_cpus();
  Resume_devices:
+	device_resume();
+	resume_console();
 	if (platform_suspend)
 		platform_finish();
 
-	device_resume();
-	resume_console();
  Finish:
 	mutex_unlock(&pm_mutex);
 	return error;
@@ -202,11 +202,11 @@ static inline int snapshot_restore(int p
 
 	enable_nonboot_cpus();
  Resume_devices:
+	device_resume();
+	resume_console();
 	if (platform_suspend)
 		platform_finish();
 
-	device_resume();
-	resume_console();
  Finish:
 	pm_restore_console();
 	mutex_unlock(&pm_mutex);


-- 
Mathematics is the supreme nostalgia of our time.
