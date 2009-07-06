Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbZGFLb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbZGFLb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 07:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbZGFLbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 07:31:50 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:53001 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751534AbZGFLbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 07:31:49 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH,RFC,resend] printk: restore previous console_loglevel when re-enabling logging
Cc: cryptsetup@packages.debian.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Disposition: inline
From: Frans Pop <elendil@planet.nl>
Date: Mon, 6 Jul 2009 13:31:48 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907061331.49930.elendil@planet.nl>
X-OriginalArrivalTime: 06 Jul 2009 11:31:50.0188 (UTC) FILETIME=[5A7CC6C0:01C9FE2D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When logging to console is disabled from userspace using klogctl()
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

Resend. The problem that prompted this patch is described in
http://lkml.org/lkml/2009/6/28/234

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

Yet another option would be to ignore the request.


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
