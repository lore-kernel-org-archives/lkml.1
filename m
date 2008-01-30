Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116AbYA3F05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116AbYA3F05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 00:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYA3F0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 00:26:49 -0500
Received: from c60.cesmail.net ([216.154.195.49]:20715 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987AbYA3F0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 00:26:48 -0500
Subject: Re: ndiswrapper and GPL-only symbols redux
From: Pavel Roskin <proski@gnu.org>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
In-Reply-To: <20080130050721.GB22444@dallas.jonmasters.org>
References: <1201641765.18773.35.camel@dv> <20080129224529.4b8016c3@core>
	 <1201651006.23553.8.camel@dv> <p73bq746lml.fsf@bingen.suse.de>
	 <20080130050721.GB22444@dallas.jonmasters.org>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 00:26:45 -0500
Message-Id: <1201670805.4382.4.camel@rd>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-30 at 05:07 +0000, Jon Masters wrote:
> *). Add a new taint?
> *). Move it later?
> 
> It's all trivial, but a policy should be established for the future.

I'd prefer a new taint.  It's less likely to break.  It provides more
information in the stack dumps.  It makes it clear the difference
ndiswrapper and driverloader.

Here's the patch:
---

Introduce a new taint flag for ndiswrapper

Although ndiswrapper loads proprietary code, it's under GPL itself.
Introduce a different taint flag for this case, so that ndiswrapper
retains access to GPL-only symbols.

Add comments to show the difference between driverloader and
ndiswrapper.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 include/linux/kernel.h |    1 +
 kernel/module.c        |    5 ++++-
 kernel/panic.c         |    2 ++
 3 files changed, 7 insertions(+), 1 deletions(-)


diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index a7283c9..861a6ae 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -240,6 +240,7 @@ extern enum system_states {
 #define TAINT_BAD_PAGE			(1<<5)
 #define TAINT_USER			(1<<6)
 #define TAINT_DIE			(1<<7)
+#define TAINT_BLOB_WRAPPER		(1<<8)
 
 extern void dump_stack(void) __cold;
 
diff --git a/kernel/module.c b/kernel/module.c
index f6a4e72..a64380c 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1925,8 +1925,11 @@ static struct module *load_module(void __user *umod,
 	/* Set up license info based on the info section */
 	set_license(mod, get_modinfo(sechdrs, infoindex, "license"));
 
+	/* GPL, but may load proprietary code */
 	if (strcmp(mod->name, "ndiswrapper") == 0)
-		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
+		add_taint_module(mod, TAINT_BLOB_WRAPPER);
+
+	/* Wrongly claims to be under GPL */
 	if (strcmp(mod->name, "driverloader") == 0)
 		add_taint_module(mod, TAINT_PROPRIETARY_MODULE);
 
diff --git a/kernel/panic.c b/kernel/panic.c
index da4d6ba..b040812 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -152,6 +152,7 @@ EXPORT_SYMBOL(panic);
  *  'M' - System experienced a machine check exception.
  *  'B' - System has hit bad_page.
  *  'U' - Userspace-defined naughtiness.
+ *  'W' - Wrapper for untrusted binary blobs has been loaded.
  *
  *	The string is overwritten by the next call to print_taint().
  */
@@ -162,6 +163,7 @@ const char *print_tainted(void)
 	if (tainted) {
 		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c%c",
 			tainted & TAINT_PROPRIETARY_MODULE ? 'P' : 'G',
+			tainted & TAINT_BLOB_WRAPPER ? 'W' : ' ',
 			tainted & TAINT_FORCED_MODULE ? 'F' : ' ',
 			tainted & TAINT_UNSAFE_SMP ? 'S' : ' ',
 			tainted & TAINT_FORCED_RMMOD ? 'R' : ' ',

-- 
Regards,
Pavel Roskin
