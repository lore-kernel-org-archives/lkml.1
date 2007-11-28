Return-Path: <linux-kernel-owner+w=401wt.eu-S1759258AbXK1TGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258AbXK1TGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755989AbXK1TFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:05:39 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:42877 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759444AbXK1TFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:05:37 -0500
Date: Wed, 28 Nov 2007 14:04:40 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 4/4] UML - Work around host tcsetattr bug
Message-ID: <20071128190440.GA8313@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Under the conditions that UML uses it, tcgetattr is guaranteed to
return -EINTR when the console is attached to /dev/ptmx, making
generic_console_write hang because it loops, calling tcgetattr until
it succeeds.  This is a host bug - see
http://marc.info/?l=linux-kernel&m=119618990807182&w=2 for the
details.

This patch works around it by blocking SIGIO while the terminal
attributes are being fiddled.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/drivers/chan_user.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

Index: linux-2.6.22/arch/um/drivers/chan_user.c
===================================================================
--- linux-2.6.22.orig/arch/um/drivers/chan_user.c	2007-11-21 11:43:50.000000000 -0500
+++ linux-2.6.22/arch/um/drivers/chan_user.c	2007-11-27 14:03:10.000000000 -0500
@@ -74,10 +74,16 @@ void generic_free(void *data)
 
 int generic_console_write(int fd, const char *buf, int n)
 {
+	sigset_t old, no_sigio;
 	struct termios save, new;
 	int err;
 
 	if (isatty(fd)) {
+		sigemptyset(&no_sigio);
+		sigaddset(&no_sigio, SIGIO);
+		if (sigprocmask(SIG_BLOCK, &no_sigio, &old))
+			goto error;
+
 		CATCH_EINTR(err = tcgetattr(fd, &save));
 		if (err)
 			goto error;
@@ -97,8 +103,11 @@ int generic_console_write(int fd, const 
 	 * Restore raw mode, in any case; we *must* ignore any error apart
 	 * EINTR, except for debug.
 	 */
-	if (isatty(fd))
+	if (isatty(fd)) {
 		CATCH_EINTR(tcsetattr(fd, TCSAFLUSH, &save));
+		sigprocmask(SIG_SETMASK, &old, NULL);
+	}
+
 	return err;
 error:
 	return -errno;
