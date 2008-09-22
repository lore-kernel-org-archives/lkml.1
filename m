Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYIVWCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYIVWCa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 18:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbYIVWCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 18:02:22 -0400
Received: from toccata.ens-lyon.org ([140.77.166.68]:41456 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbYIVWCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 18:02:21 -0400
X-Greylist: delayed 1305 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Sep 2008 18:02:21 EDT
Date: Mon, 22 Sep 2008 23:40:31 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, stable@kernel.org
Subject: [PATCH] Only register notifiers when the braille console is used.
Message-ID: <20080922214031.GJ5930@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	stable@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only register the braille driver VT and keyboard notifiers when the
braille console is used.  Avoids eating insert or backspace keys.

http://bugzilla.kernel.org/show_bug.cgi?id=11242

Signed-off-by: Pascal Terjan <pterjan@mandriva.com>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
---
 drivers/accessibility/braille/braille_console.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/accessibility/braille/braille_console.c b/drivers/accessibility/braille/braille_console.c
index 0a5f6b2..d672cfe 100644
--- a/drivers/accessibility/braille/braille_console.c
+++ b/drivers/accessibility/braille/braille_console.c
@@ -376,6 +376,8 @@ int braille_register_console(struct console *console, int index,
 	console->flags |= CON_ENABLED;
 	console->index = index;
 	braille_co = console;
+	register_keyboard_notifier(&keyboard_notifier_block);
+	register_vt_notifier(&vt_notifier_block);
 	return 0;
 }
 
@@ -383,15 +385,8 @@ int braille_unregister_console(struct console *console)
 {
 	if (braille_co != console)
 		return -EINVAL;
+	unregister_keyboard_notifier(&keyboard_notifier_block);
+	unregister_vt_notifier(&vt_notifier_block);
 	braille_co = NULL;
 	return 0;
 }
-
-static int __init braille_init(void)
-{
-	register_keyboard_notifier(&keyboard_notifier_block);
-	register_vt_notifier(&vt_notifier_block);
-	return 0;
-}
-
-console_initcall(braille_init);
-- 
1.6.0.2

