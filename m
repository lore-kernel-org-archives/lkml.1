Return-Path: <linux-kernel-owner+w=401wt.eu-S1763623AbYHDUYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763623AbYHDUYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762890AbYHDUYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:24:06 -0400
Received: from ns2.suse.de ([195.135.220.15]:45677 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762273AbYHDUYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:24:04 -0400
Date: Mon, 4 Aug 2008 13:15:07 -0700
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
       alan@lxorguk.ukuu.org.uk, Jiri Kosina <jkosina@suse.cz>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [patch 11/33] Input: i8042 - add Intel D845PESV to nopnp list
Message-ID: <20080804201507.GL1139@suse.de>
References: <20080804200515.110033151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="input-i8042-add-intel-d845pesv-to-nopnp-list.patch"
In-Reply-To: <20080804201321.GA1139@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit c3a34f4390396a4bede3f8b7bcc5153f50b974bb upstream

This patch introduces i8042_dmi_nopnp_table to make it possible to perform
DMI matches for systems that need 'i8042.nopnp' to work correctly, and
introduces such an entry for Intel D845PESV -- this system doesn't
detect PS2 mouse reliably without this option, as reported by Robert
Lewis.

[dtor@mail.ru - make it compile if CONFIG_PNP is off - reported
 by Randy Dunlap]

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/serio/i8042-x86ia64io.h |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -63,7 +63,7 @@ static inline void i8042_write_command(i
 	outb(val, I8042_COMMAND_REG);
 }
 
-#if defined(__i386__) || defined(__x86_64__)
+#ifdef CONFIG_X86
 
 #include <linux/dmi.h>
 
@@ -287,14 +287,19 @@ static struct dmi_system_id __initdata i
 	{ }
 };
 
-
-
+#ifdef CONFIG_PNP
+static struct dmi_system_id __initdata i8042_dmi_nopnp_table[] = {
+	{
+		.ident = "Intel MBO Desktop D845PESV",
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "D845PESV"),
+			DMI_MATCH(DMI_BOARD_VENDOR, "Intel Corporation"),
+		},
+	},
+	{ }
+};
 #endif
 
-#ifdef CONFIG_X86
-
-#include <linux/dmi.h>
-
 /*
  * Some Wistron based laptops need us to explicitly enable the 'Dritek
  * keyboard extension' to make their extra keys start generating scancodes.
@@ -342,7 +347,6 @@ static struct dmi_system_id __initdata i
 
 #endif /* CONFIG_X86 */
 
-
 #ifdef CONFIG_PNP
 #include <linux/pnp.h>
 
@@ -452,6 +456,11 @@ static int __init i8042_pnp_init(void)
 	int pnp_data_busted = 0;
 	int err;
 
+#ifdef CONFIG_X86
+	if (dmi_check_system(i8042_dmi_nopnp_table))
+		i8042_nopnp = 1;
+#endif
+
 	if (i8042_nopnp) {
 		printk(KERN_INFO "i8042: PNP detection disabled\n");
 		return 0;
@@ -577,15 +586,13 @@ static int __init i8042_platform_init(vo
         i8042_reset = 1;
 #endif
 
-#if defined(__i386__) || defined(__x86_64__)
+#ifdef CONFIG_X86
 	if (dmi_check_system(i8042_dmi_noloop_table))
 		i8042_noloop = 1;
 
 	if (dmi_check_system(i8042_dmi_nomux_table))
 		i8042_nomux = 1;
-#endif
 
-#ifdef CONFIG_X86
 	if (dmi_check_system(i8042_dmi_dritek_table))
 		i8042_dritek = 1;
 #endif /* CONFIG_X86 */

-- 
