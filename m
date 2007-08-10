Return-Path: <linux-kernel-owner+w=401wt.eu-S941899AbXHJVAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941899AbXHJVAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765867AbXHJVAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:00:37 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52129 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759936AbXHJVAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:00:35 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
       coreteam@netfilter.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/7] sysctl: Remove broken cdrom binary sysctls
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	<46BC8F71.3070006@googlemail.com> <46BC944F.9020801@googlemail.com>
	<m1fy2rxpje.fsf@ebiederm.dsl.xmission.com>
	<20070810124156.2de9710e.akpm@linux-foundation.org>
Date: Fri, 10 Aug 2007 15:00:05 -0600
In-Reply-To: <20070810124156.2de9710e.akpm@linux-foundation.org> (Andrew
	Morton's message of "Fri, 10 Aug 2007 12:41:56 -0700")
Message-ID: <m1ps1vw1ey.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The binary interface for the cdrom sysctls can't possilby work.
So remove the binary sysctls and reduce cdrom_sysctl_handler
to it's essentials (to kill the uses of ctl_name).

Since the last time this patch was posted I radically
simplified cdrom_sysctl_helper to meet address Alan's objections.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---

 drivers/cdrom/cdrom.c |   46 ++++++----------------------------------------
 1 files changed, 6 insertions(+), 40 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 67ee3d4..679c7c0 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -3454,47 +3454,19 @@ static void cdrom_update_settings(void)
 static int cdrom_sysctl_handler(ctl_table *ctl, int write, struct file * filp,
 				void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	int *valp = ctl->data;
-	int val = *valp;
 	int ret;
 	
 	ret = proc_dointvec(ctl, write, filp, buffer, lenp, ppos);
 
-	if (write && *valp != val) {
+	if (write) {
 	
 		/* we only care for 1 or 0. */
-		if (*valp)
-			*valp = 1;
-		else
-			*valp = 0;
+		autoclose        = !!cdrom_sysctl_settings.autoclose;
+		autoeject        = !!cdrom_sysctl_settings.autoeject;
+		debug	         = !!cdrom_sysctl_settings.debug;
+		lockdoor         = !!cdrom_sysctl_settings.lock;
+		check_media_type = !!cdrom_sysctl_settings.check;
 
-		switch (ctl->ctl_name) {
-		case DEV_CDROM_AUTOCLOSE: {
-			if (valp == &cdrom_sysctl_settings.autoclose)
-				autoclose = cdrom_sysctl_settings.autoclose;
-			break;
-			}
-		case DEV_CDROM_AUTOEJECT: {
-			if (valp == &cdrom_sysctl_settings.autoeject)
-				autoeject = cdrom_sysctl_settings.autoeject;
-			break;
-			}
-		case DEV_CDROM_DEBUG: {
-			if (valp == &cdrom_sysctl_settings.debug)
-				debug = cdrom_sysctl_settings.debug;
-			break;
-			}
-		case DEV_CDROM_LOCK: {
-			if (valp == &cdrom_sysctl_settings.lock)
-				lockdoor = cdrom_sysctl_settings.lock;
-			break;
-			}
-		case DEV_CDROM_CHECK_MEDIA: {
-			if (valp == &cdrom_sysctl_settings.check)
-				check_media_type = cdrom_sysctl_settings.check;
-			break;
-			}
-		}
 		/* update the option flags according to the changes. we
 		   don't have per device options through sysctl yet,
 		   but we will have and then this will disappear. */
@@ -3507,7 +3479,6 @@ static int cdrom_sysctl_handler(ctl_table *ctl, int write, struct file * filp,
 /* Place files in /proc/sys/dev/cdrom */
 static ctl_table cdrom_table[] = {
 	{
-		.ctl_name	= DEV_CDROM_INFO,
 		.procname	= "info",
 		.data		= &cdrom_sysctl_settings.info, 
 		.maxlen		= CDROM_STR_SIZE,
@@ -3515,7 +3486,6 @@ static ctl_table cdrom_table[] = {
 		.proc_handler	= &cdrom_sysctl_info,
 	},
 	{
-		.ctl_name	= DEV_CDROM_AUTOCLOSE,
 		.procname	= "autoclose",
 		.data		= &cdrom_sysctl_settings.autoclose,
 		.maxlen		= sizeof(int),
@@ -3523,7 +3493,6 @@ static ctl_table cdrom_table[] = {
 		.proc_handler	= &cdrom_sysctl_handler,
 	},
 	{
-		.ctl_name	= DEV_CDROM_AUTOEJECT,
 		.procname	= "autoeject",
 		.data		= &cdrom_sysctl_settings.autoeject,
 		.maxlen		= sizeof(int),
@@ -3531,7 +3500,6 @@ static ctl_table cdrom_table[] = {
 		.proc_handler	= &cdrom_sysctl_handler,
 	},
 	{
-		.ctl_name	= DEV_CDROM_DEBUG,
 		.procname	= "debug",
 		.data		= &cdrom_sysctl_settings.debug,
 		.maxlen		= sizeof(int),
@@ -3539,7 +3507,6 @@ static ctl_table cdrom_table[] = {
 		.proc_handler	= &cdrom_sysctl_handler,
 	},
 	{
-		.ctl_name	= DEV_CDROM_LOCK,
 		.procname	= "lock",
 		.data		= &cdrom_sysctl_settings.lock,
 		.maxlen		= sizeof(int),
@@ -3547,7 +3514,6 @@ static ctl_table cdrom_table[] = {
 		.proc_handler	= &cdrom_sysctl_handler,
 	},
 	{
-		.ctl_name	= DEV_CDROM_CHECK_MEDIA,
 		.procname	= "check_media",
 		.data		= &cdrom_sysctl_settings.check,
 		.maxlen		= sizeof(int),
-- 
1.5.1.1.181.g2de0

