Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbYBWNTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbYBWNTh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 08:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757444AbYBWNTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 08:19:23 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:1623 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777AbYBWNTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 08:19:22 -0500
X-SBRS: 2.8
X-MesageID: 43201649
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.25,394,1199682000"; 
   d="scan'208";a="43201649"
Date: Sat, 23 Feb 2008 14:15:55 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dtor@mail.ru>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] Braille screen reader fixes
Message-ID: <20080223131555.GD4244@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>,
	Jiri Kosina <jkosina@suse.cz>
References: <20080204031842.GE4439@implementation> <20080205220054.GD4394@implementation> <20080205165853.561d5f3d.akpm@linux-foundation.org> <20080206020423.GG4394@implementation> <20080222002822.GB32480@implementation> <20080223000410.674ce674.akpm@linux-foundation.org> <20080223131028.GC4244@implementation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223131028.GC4244@implementation>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Braille screen reader fixes:
- console_cmdline's brl_options field is only required when braille
console support is enabled.
- Use strlcpy to copy the console name.
- braille console support depends on VT support.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

--- linux-2.6.24.1-orig/kernel/printk.c	2008-02-21 12:09:06.000000000 +0100
+++ linux-2.6.24.1-perso/kernel/printk.c	2008-02-23 12:57:42.000000000 +0100
@@ -105,7 +105,9 @@ struct console_cmdline
 	char	name[8];			/* Name of the driver	    */
 	int	index;				/* Minor dev. to use	    */
 	char	*options;			/* Options for the driver   */
+#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
 	char	*brl_options;			/* Options for braille driver */
+#endif
 };
 
 #define MAX_CMDLINECONSOLES 8
@@ -789,10 +791,11 @@ static int __add_preferred_console
 	if (!brl_options)
 		selected_console = i;
 	c = &console_cmdline[i];
-	memcpy(c->name, name, sizeof(c->name));
-	c->name[sizeof(c->name) - 1] = 0;
+	strlcpy(c->name, name, sizeof(c->name));
 	c->options = options;
+#ifdef CONFIG_A11Y_BRAILLE_CONSOLE
 	c->brl_options = brl_options;
+#endif
 	c->index = idx;
 	return 0;
 }
--- linux-2.6.24.1-orig/drivers/accessibility/Kconfig	2008-02-23 13:32:38.000000000 +0100
+++ linux-2.6.24.1-perso/drivers/accessibility/Kconfig	2008-02-23 13:23:21.000000000 +0100
@@ -8,6 +8,7 @@ menuconfig ACCESSIBILITY
 if ACCESSIBILITY
 config A11Y_BRAILLE_CONSOLE
 	bool "Console on braille device"
+	depends on VT
 	depends on SERIAL_CORE_CONSOLE
 	---help---
 	  Enables console output on a braille device connected to a 8250
