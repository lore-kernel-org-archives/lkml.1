Return-Path: <linux-kernel-owner+w=401wt.eu-S1752462AbZHMRyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbZHMRyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 13:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbZHMRya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 13:54:30 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:37039 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZHMRy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 13:54:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEABbwg0qrR7MV/2dsb2JhbAC7S4grkRAFhBk
X-IronPort-AV: E=Sophos;i="4.43,375,1246838400"; 
   d="scan'208";a="366829311"
Date: Thu, 13 Aug 2009 10:54:30 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linux-usb@vger.kernel.org
Subject: [PATCH] Combine two one-character CR-LF writes into one
	two-character write for O_ONLCR
Message-ID: <20090813175430.GA8769@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-1; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When handling output of a newline character in O_ONLCR mode, the n_tty.c
do_output_char() function uses the struct tty_operations function write_room()
to determine whether it is possible to write two characters. It uses
tty_put_char() for each character which, for the USB generic serial driver,
translates into a write() for each character. For the USB generic serial
driver the value returned by write_room() only applies to the next write().
A second write() done in quick succession will fail because the write URB
buffer is still busy from the first write(). In this case, it results in the
printing of a carriage return without the following line feed.

This patch combines the two write() calls into a single, two-character, write().

Signed-off-by: David VomLehn
---
 drivers/char/n_tty.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index 973be2f..bf06c61 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -297,12 +297,12 @@ static int do_output_char(unsigned char c, struct tty_struct *tty, int space)
 		if (O_ONLRET(tty))
 			tty->column = 0;
 		if (O_ONLCR(tty)) {
-			if (space < 2)
+			static const char crlf[] = {'\r', '\n'};
+			if (space < ARRAY_SIZE(crlf))
 				return -1;
 			tty->canon_column = tty->column = 0;
-			tty_put_char(tty, '\r');
-			tty_put_char(tty, c);
-			return 2;
+			tty->ops->write(tty, crlf, ARRAY_SIZE(crlf));
+			return ARRAY_SIZE(crlf);
 		}
 		tty->canon_column = tty->column;
 		break;
