Return-Path: <linux-kernel-owner+w=401wt.eu-S1763981AbYF0S2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763981AbYF0S2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761940AbYF0SZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:25:58 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:11711 "EHLO
	phenom.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759207AbYF0SZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:25:50 -0400
Date: Fri, 27 Jun 2008 12:13:23 -0600
From: dougthompson@xmission.com
To: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 7/13] EDAC core fix workq timer
Message-ID: <48652dc3.lmAi9ickn7g7orhI%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Arthur Jones <ajones@riverbed.com>

Applied to linux-2.6.26-rc5-mm3

When updating the edac_mc_poll_msec module parameter from
the sysfs /sys/module/edac_core/parameters/edac_mc_poll_msec
file, we don't update the workq timers.  So that, if we
move from a big poll time to a small one, the small one
won't take effect until the big one has timed out.
    
Here we provide a new module parameter set method
to call out to the update routine.  This brings
the /sys/module/edac_core/parameters functionality
up to that provided by the /sys/drivers/system/edac/mc
sysfs module parameter files so that we can remove
them or at least link to the /sys/module files...

Signed-off-by:  Arthur Jones <ajones@riverbed.com>
Signed-off-by:  Doug Thompson <dougthompson@xmission.com>
---
 edac_mc_sysfs.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

Index: linux-2.6.26-rc5/drivers/edac/edac_mc_sysfs.c
===================================================================
--- linux-2.6.26-rc5.orig/drivers/edac/edac_mc_sysfs.c
+++ linux-2.6.26-rc5/drivers/edac/edac_mc_sysfs.c
@@ -44,6 +44,25 @@ int edac_mc_get_poll_msec(void)
 	return edac_mc_poll_msec;
 }
 
+static int edac_set_poll_msec(const char *val, struct kernel_param *kp)
+{
+	long l;
+	int ret;
+
+	if (!val)
+		return -EINVAL;
+
+	ret = strict_strtol(val, 0, &l);
+	if (ret == -EINVAL || ((int)l != l))
+		return -EINVAL;
+	*((int *)kp->arg) = l;
+
+	/* notify edac_mc engine to reset the poll period */
+	edac_mc_reset_delay_period(l);
+
+	return 0;
+}
+
 /* Parameter declarations for above */
 module_param(edac_mc_panic_on_ue, int, 0644);
 MODULE_PARM_DESC(edac_mc_panic_on_ue, "Panic on uncorrected error: 0=off 1=on");
@@ -53,7 +72,8 @@ MODULE_PARM_DESC(edac_mc_log_ue,
 module_param(edac_mc_log_ce, int, 0644);
 MODULE_PARM_DESC(edac_mc_log_ce,
 		 "Log correctable error to console: 0=off 1=on");
-module_param(edac_mc_poll_msec, int, 0644);
+module_param_call(edac_mc_poll_msec, edac_set_poll_msec, param_get_int,
+		  &edac_mc_poll_msec, 0644);
 MODULE_PARM_DESC(edac_mc_poll_msec, "Polling period in milliseconds");
 
 /*
