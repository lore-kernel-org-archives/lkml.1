Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbYJFXVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbYJFXVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbYJFXUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:20:52 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:20411 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752106AbYJFXUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:20:51 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Oct 2008 19:20:51 EDT
Date: Mon, 06 Oct 2008 17:12:59 -0600
From: dougthompson@xmission.com
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       aris@redhat.com
Subject: [PATCH 2/2] edac i5000 fix thermal issues
Message-ID: <48ea9b7b.zj4tXpfkwuPASGYB%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aristeu Rozanski <aris@redhat.com>

This patch makes the Thermal messages (temperature got past Tmid) to be
displayed only once because:
1) it's the BIOS job to configure and handle the memory throttling
2) if the BIOS is broken or is aware about the condition, flooding the
   system logs won't help anything.
3) According to the specification update for Intel 5000 MCHs, all the
   revisions of this MCH have problems on the thermal sensors, making
   not automatic (a.k.a. intelligent thermal throttling) impossible.

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/edac/i5000_edac.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

Index: linux-2.6.27-rc8/drivers/edac/i5000_edac.c
===================================================================
--- linux-2.6.27-rc8.orig/drivers/edac/i5000_edac.c
+++ linux-2.6.27-rc8/drivers/edac/i5000_edac.c
@@ -511,8 +511,23 @@ static void i5000_process_fatal_error_in
 				"retry";
 		break;
 	case FERR_FAT_M3ERR:
+		{
+		static int done;
+
+		/*
+		 * This error is generated to inform that the intelligent
+		 * throttling is disabled and the temperature passed the
+		 * specified middle point. Since this is something the BIOS
+		 * should take care of, we'll warn only once to avoid
+		 * worthlessly flooding the log.
+		 */
+		if (done)
+			return;
+		done++;
+
 		specific = ">Tmid Thermal event with intelligent "
-				"throttling disabled";
+			   "throttling disabled";
+		}
 		break;
 	}
 
