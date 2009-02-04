Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbZBDSmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbZBDSmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758528AbZBDShS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:37:18 -0500
Received: from kroah.org ([198.145.64.141]:51044 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758490AbZBDShM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:37:12 -0500
Date: Wed, 4 Feb 2009 10:34:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 15/33] Fix memory corruption in console selection
Message-ID: <20090204183446.GP13936@kroah.com>
References: <20090204182823.831027530@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-memory-corruption-in-console-selection.patch"
In-Reply-To: <20090204183403.GA13936@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 878b8619f711280fd05845e21956434b5e588cc4 upstream.

Fix an off-by-two memory error in console selection.

The loop below goes from sel_start to sel_end (inclusive), so it writes
one more character.  This one more character was added to the allocated
size (+1), but it was not multiplied by an UTF-8 multiplier.

This patch fixes a memory corruption when UTF-8 console is used and the
user selects a few characters, all of them 3-byte in UTF-8 (for example
a frame line).

When memory redzones are enabled, a redzone corruption is reported.
When they are not enabled, trashing of random memory occurs.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/selection.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/selection.c
+++ b/drivers/char/selection.c
@@ -268,7 +268,7 @@ int set_selection(const struct tiocl_sel
 
 	/* Allocate a new buffer before freeing the old one ... */
 	multiplier = use_unicode ? 3 : 1;  /* chars can take up to 3 bytes */
-	bp = kmalloc((sel_end-sel_start)/2*multiplier+1, GFP_KERNEL);
+	bp = kmalloc(((sel_end-sel_start)/2+1)*multiplier, GFP_KERNEL);
 	if (!bp) {
 		printk(KERN_WARNING "selection: kmalloc() failed\n");
 		clear_selection();

