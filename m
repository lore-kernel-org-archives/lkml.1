Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672AbXJHHnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbXJHHnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 03:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbXJHHnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 03:43:12 -0400
Received: from ananke.telenet-ops.be ([195.130.137.78]:53234 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbXJHHnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 03:43:10 -0400
X-Greylist: delayed 77279 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Oct 2007 03:43:10 EDT
Date: Mon, 8 Oct 2007 09:43:02 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Marcelo Tosatti <marcelo@kvack.org>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] libertas link error due to gcc `smartness'
Message-ID: <Pine.LNX.4.64.0710080940110.8127@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some versions of gcc replace strstr() calls with a single-character `needle'
parameter by strchr() behind our back. This causes a link error if strchr() is
defined as an inline function in <asm/string.h> (e.g. on m68k):

| drivers/built-in.o: In function `libertas_parse_chan':
| linux/drivers/net/wireless/libertas/debugfs.c:209: undefined reference to `strchr'
| drivers/built-in.o: In function `libertas_parse_ssid':
| linux/drivers/net/wireless/libertas/debugfs.c:260: undefined reference to `strchr'

Avoid this by explicitly calling strchr() instead.

Also include <linux/string.h>, because this file calls lots of str*() routines.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Due to the lack of hardware, I could not test the functionality of this change.
I was just trying to compile a kernel with a much enabled as possible.

 drivers/net/wireless/libertas/debugfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/libertas/debugfs.c
+++ b/drivers/net/wireless/libertas/debugfs.c
@@ -3,6 +3,7 @@
 #include <linux/debugfs.h>
 #include <linux/delay.h>
 #include <linux/mm.h>
+#include <linux/string.h>
 #include <net/iw_handler.h>
 
 #include "dev.h"
@@ -205,7 +206,7 @@ static int libertas_parse_chan(char *buf
 	if (!start)
 		return -EINVAL;
 	start += 5;
-	end = strstr(start, " ");
+	end = strchr(start, ' ');
 	if (!end)
 		end = buf + count;
 	hold = kzalloc((end - start)+1, GFP_KERNEL);
@@ -256,7 +257,7 @@ static void libertas_parse_ssid(char *bu
 	if (!hold)
 		return;
 	hold += 5;
-	end = strstr(hold, " ");
+	end = strchr(hold, ' ');
 	if (!end)
 		end = buf + count - 1;
 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
