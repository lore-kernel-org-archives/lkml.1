Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbZIIVDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbZIIVDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 17:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbZIIVDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 17:03:16 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:62433 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbZIIVDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 17:03:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=GOL0b7mrnz68aq062UKLFG1K5pSZKSOf5zXnxu27BjXfBzKjlemPLz62EXh1dzhapN
         2hQjibctOszgTBW5vXnPMdmdPO2JrN7gcTHG0iT00FYXJ4Cl/5YkpR1owQO5i55Gcvzg
         ROdCJNHrGyPhC7erpzSsbio7MRq/9sD2jBU7Y=
Message-ID: <4AA81811.8020500@skyrush.com>
Date: Wed, 09 Sep 2009 15:03:13 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090907)
MIME-Version: 1.0
To: greg@kroah.com
CC: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org
Subject: [PATCH 1/2 (resubmission)] n_tty: honor opost flag for echoes
Content-Type: multipart/mixed;
 boundary="------------060603040407070100010604"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060603040407070100010604
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This (and the forthcoming part 2, which is the same patch with corrected
offsets) are resubmissions to avoid the conflict with "n_tty: do O_ONLCR
translation as a single write" and to move the O_OPOST test to the caller.

						-Joe


--------------060603040407070100010604
Content-Type: text/plain;
 name="n_tty-honor-opost-flag-for-echoes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="n_tty-honor-opost-flag-for-echoes.patch"

Fixes the following bug:

      http://bugs.linuxbase.org/show_bug.cgi?id=2692

Causes processing of echoed characters (output from the echo buffer) to
honor the O_OPOST flag, which is consistent with the old behavior.

Note that this and the next patch ("n_tty: move echoctl check and
clean up logic") were verified together by the bug reporters, and
the test now passes.

Signed-off-by: Joe Peterson <joe@skyrush.com>
---

diff -Nurp a/drivers/char/n_tty.c b/drivers/char/n_tty.c
--- a/drivers/char/n_tty.c	2009-09-07 16:54:03.540366388 -0600
+++ b/drivers/char/n_tty.c	2009-09-07 16:53:53.880294497 -0600
@@ -272,7 +272,8 @@ static inline int is_continuation(unsign
  *
  *	This is a helper function that handles one output character
  *	(including special characters like TAB, CR, LF, etc.),
- *	putting the results in the tty driver's write buffer.
+ *	doing OPOST processing and putting the results in the
+ *	tty driver's write buffer.
  *
  *	Note that Linux currently ignores TABDLY, CRDLY, VTDLY, FFDLY
  *	and NLDLY.  They simply aren't relevant in the world today.
@@ -351,8 +352,9 @@ static int do_output_char(unsigned char 
  *	@c: character (or partial unicode symbol)
  *	@tty: terminal device
  *
- *	Perform OPOST processing.  Returns -1 when the output device is
- *	full and the character must be retried.
+ *	Output one character with OPOST processing.
+ *	Returns -1 when the output device is full and the character
+ *	must be retried.
  *
  *	Locking: output_lock to protect column state and space left
  *		 (also, this is called from n_tty_write under the
@@ -378,8 +380,11 @@ static int process_output(unsigned char 
 /**
  *	process_output_block		-	block post processor
  *	@tty: terminal device
- *	@inbuf: user buffer
- *	@nr: number of bytes
+ *	@buf: character buffer
+ *	@nr: number of bytes to output
+ *
+ *	Output a block of characters with OPOST processing.
+ *	Returns the number of characters output.
  *
  *	This path is used to speed up block console writes, among other
  *	things when processing blocks of output data. It handles only
@@ -606,12 +611,18 @@ static void process_echoes(struct tty_st
 			if (no_space_left)
 				break;
 		} else {
-			int retval;
-
-			retval = do_output_char(c, tty, space);
-			if (retval < 0)
-				break;
-			space -= retval;
+			if (O_OPOST(tty) &&
+			    !(test_bit(TTY_HW_COOK_OUT, &tty->flags))) {
+				int retval = do_output_char(c, tty, space);
+				if (retval < 0)
+					break;
+				space -= retval;
+			} else {
+				if (!space)
+					break;
+				tty_put_char(tty, c);
+				space -= 1;
+			}
 			cp += 1;
 			nr -= 1;
 		}


--------------060603040407070100010604--
