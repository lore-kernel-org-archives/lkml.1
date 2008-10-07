Return-Path: <linux-kernel-owner+w=401wt.eu-S1759135AbYJGBEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135AbYJGBEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 21:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756268AbYJGAq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:46:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:32846 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801AbYJGAq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:46:27 -0400
Date: Mon, 6 Oct 2008 17:40:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Pascal Terjan <pterjan@mandriva.com>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       Moritz Muehlenhoff <jmm@inutil.org>
Subject: [patch 65/71] braille_console: only register notifiers when the
	braille console is used
Message-ID: <20081007004017.GN3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="braille_console-only-register-notifiers-when-the-braille-console-is-used.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Pascal Terjan <pterjan@mandriva.com>

commit c0c9209ddd96bc4f1d70a8b9958710671e076080 upstream

Only register the braille driver VT and keyboard notifiers when the
braille console is used.  Avoids eating insert or backspace keys.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=11242

Signed-off-by: Pascal Terjan <pterjan@mandriva.com>
Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Moritz Muehlenhoff <jmm@inutil.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/accessibility/braille/braille_console.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/drivers/accessibility/braille/braille_console.c
+++ b/drivers/accessibility/braille/braille_console.c
@@ -376,6 +376,8 @@ int braille_register_console(struct cons
 	console->flags |= CON_ENABLED;
 	console->index = index;
 	braille_co = console;
+	register_keyboard_notifier(&keyboard_notifier_block);
+	register_vt_notifier(&vt_notifier_block);
 	return 0;
 }
 
@@ -383,15 +385,8 @@ int braille_unregister_console(struct co
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
