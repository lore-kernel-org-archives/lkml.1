Return-Path: <linux-kernel-owner+w=401wt.eu-S1756553AbZF1SSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553AbZF1SSS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 14:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752990AbZF1SSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 14:18:08 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:59425 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752220AbZF1SSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 14:18:07 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH,RFC] printk: Restore to previous console_loglevel when re-enabling logging
Date: Sun, 28 Jun 2009 20:18:07 +0200
User-Agent: KMail/1.9.9
Cc: cryptsetup@packages.debian.org
References: <200906282005.12020.elendil@planet.nl>
In-Reply-To: <200906282005.12020.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906282018.08538.elendil@planet.nl>
X-OriginalArrivalTime: 28 Jun 2009 18:18:09.0332 (UTC) FILETIME=[CA48EF40:01C9F81C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When logging to console is disabled from userspace using klogctl
and later re-enabled, console_loglevel gets set to the default
log level instead to the previous value.
This means that if the kernel was booted with 'quiet', the boot is
suddenly no longer quiet after logging to console gets re-enabled.

Save the current console_loglevel when logging is disabled and
restore to that value. If the log level is set to a specific value
while disabled, this is interpreted as an implicit re-enabling of
the logging.

Signed-off-by: Frans Pop <elendil@planet.nl>
---

There are two variations possible on the patch below.

1) If klogctl(7) is called while logging is not disabled, then set level
   to default (partially preserving current functionality):
 	case 7:		/* Enable logging to console */
-		console_loglevel = default_console_loglevel;
+		if (saved_console_loglevel == -1)
+			console_loglevel = default_console_loglevel;
+		else {
+			console_loglevel = saved_console_loglevel;
+			saved_console_loglevel = -1;
+		}

2) If klogctl(8) is called while logging is disabled, then don't enable
   logging, but remember the requested value for when logging does get
   enabled again:
 	case 8:		/* Set level of messages printed to console */
[...]
- 		console_loglevel = len;
+		if (saved_console_loglevel == -1)
+	 		console_loglevel = len;
+		else
+			saved_console_loglevel = len;

Yet either option would be to ignore the request.


diff --git a/kernel/printk.c b/kernel/printk.c
index b4d97b5..acbf050 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -271,6 +271,7 @@ int do_syslog(int type, char __user *buf, int len)
 	int do_clear = 0;
 	char c;
 	int error = 0;
+	static int saved_console_loglevel = -1;
 
 	error = security_syslog(type);
 	if (error)
@@ -372,10 +373,15 @@ int do_syslog(int type, char __user *buf, int len)
 		logged_chars = 0;
 		break;
 	case 6:		/* Disable logging to console */
+		if (saved_console_loglevel == -1)
+			saved_console_loglevel = console_loglevel;
 		console_loglevel = minimum_console_loglevel;
 		break;
 	case 7:		/* Enable logging to console */
-		console_loglevel = default_console_loglevel;
+		if (saved_console_loglevel != -1) {
+			console_loglevel = saved_console_loglevel;
+			saved_console_loglevel = -1;
+		}
 		break;
 	case 8:		/* Set level of messages printed to console */
 		error = -EINVAL;
@@ -384,6 +390,8 @@ int do_syslog(int type, char __user *buf, int len)
 		if (len < minimum_console_loglevel)
 			len = minimum_console_loglevel;
 		console_loglevel = len;
+		/* Implicitly re-enable logging to console */
+		saved_console_loglevel = -1;
 		error = 0;
 		break;
 	case 9:		/* Number of chars in the log buffer */
