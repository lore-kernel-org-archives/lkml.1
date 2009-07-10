Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbZGJOWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbZGJOWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 10:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbZGJOWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 10:22:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:34017 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbZGJOWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 10:22:30 -0400
Date: Fri, 10 Jul 2009 14:21:31 GMT
From: tip-bot for Frans Pop <elendil@planet.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       elendil@planet.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       elendil@planet.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <200907061331.49930.elendil@planet.nl>
References: <200907061331.49930.elendil@planet.nl>
Subject: [tip:core/printk] printk: Restore previous console_loglevel when re-enabling logging
Message-ID: <tip-1aaad49e856ce41adc07d8ae0c8ef35fc4483245@git.kernel.org>
Git-Commit-ID: 1aaad49e856ce41adc07d8ae0c8ef35fc4483245
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Jul 2009 14:21:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1aaad49e856ce41adc07d8ae0c8ef35fc4483245
Gitweb:     http://git.kernel.org/tip/1aaad49e856ce41adc07d8ae0c8ef35fc4483245
Author:     Frans Pop <elendil@planet.nl>
AuthorDate: Mon, 6 Jul 2009 13:31:48 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 16:02:23 +0200

printk: Restore previous console_loglevel when re-enabling logging

When logging to console is disabled from userspace using klogctl()
and later re-enabled, console_loglevel gets set to the default
log level instead to the previous value.

This means that if the kernel was booted with 'quiet', the boot is
suddenly no longer quiet after logging to console gets re-enabled.

Save the current console_loglevel when logging is disabled and
restore to that value. If the log level is set to a specific value
while disabled, this is interpreted as an implicit re-enabling of
the logging.

The problem that prompted this patch is described in:

    http://lkml.org/lkml/2009/6/28/234

There are two variations possible on the patch below:

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
 +			console_loglevel = len;
 +		else
 +			saved_console_loglevel = len;

Yet another option would be to ignore the request.

Signed-off-by: Frans Pop <elendil@planet.nl>
Cc: cryptsetup@packages.debian.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <200907061331.49930.elendil@planet.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/printk.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 668df35..e0daaf5 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -67,6 +67,8 @@ int console_printk[4] = {
 	DEFAULT_CONSOLE_LOGLEVEL,	/* default_console_loglevel */
 };
 
+static int saved_console_loglevel = -1;
+
 /*
  * Low level drivers may need that to know if they can schedule in
  * their unblank() callback or not. So let's export it.
@@ -378,10 +380,15 @@ int do_syslog(int type, char __user *buf, int len)
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
@@ -390,6 +397,8 @@ int do_syslog(int type, char __user *buf, int len)
 		if (len < minimum_console_loglevel)
 			len = minimum_console_loglevel;
 		console_loglevel = len;
+		/* Implicitly re-enable logging to console */
+		saved_console_loglevel = -1;
 		error = 0;
 		break;
 	case 9:		/* Number of chars in the log buffer */
