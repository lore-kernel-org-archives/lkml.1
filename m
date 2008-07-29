Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbYG2FQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbYG2FQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 01:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYG2FQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 01:16:06 -0400
Received: from 1wt.eu ([62.212.114.60]:1994 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbYG2FQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 01:16:05 -0400
Date: Tue, 29 Jul 2008 07:15:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: David W Studeman <avionicsdv@aim.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Keyboard Jammed error patch 2.4.35-pre4
Message-ID: <20080729051558.GH29189@1wt.eu>
References: <g6jqud$t5e$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <g6jqud$t5e$1@ger.gmane.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

On Sun, Jul 27, 2008 at 11:59:47PM -0700, David W Studeman wrote:
>  Hello! The changes that were made on 04-25-2007 as "[PATCH 
> 2.4.35-pre4] fix 'pc_keyb: controller jammed (0xA7)' error" have broken 
> the ability to compile with no keyboard and no VT support. This mainly 
> affects Cobalt machines which do not have dmi present as these use a 
> flashrom to boot with and not a typical bios so dmi blacklisting would 
> be pointless unless it allowed for no dmi present and then blacklist. I 
> had to create a patch against 2.4.34 to restore the ability to compile 
> with no keyboard and VT support.

Grrr... I see what's happening. I remember having checked that the
kbd_controller_present macro was really not used before merging the
patch, but obviously I had not looked deep enough. It's defined by
ia64, mips and mips64 in include/asm.

Could you please test the patch below (untested here). It should revert
to pre-2.4.35 behaviour on all architectures cited above. If you confirm
that it works, I'll merge it.

BTW, in the mean time, you can boot with the "nokeyb" option. It will
disable the keyboard. This is what I use on some non-blacklisted systems,
and the option was precisely provided by this patch.

Also, if you don't have any PC keyboard on your machines, you can
build without support for any VT/keyboard. I'm already doing this
on some embedded systems, and it works fine. If your platform still
requires that some keyboard is enabled, you may want to try to enable
CONFIG_DUMMY_KEYB which I've been using in the past.

Regards,
Willy

>From e4827f141dc86c540971082877124b213557ece0 Mon Sep 17 00:00:00 2001
From: Willy Tarreau <w@1wt.eu>
Date: Tue, 29 Jul 2008 07:06:00 +0200
Subject: pc_keyb: fix breakage on ia64/mips/mips64

Commit f8db8c9c81afb4b04c146cae0e2a1fd311de1f22 fixed the keyboard
controller jammed issue on keyboard-less PCs, but introduced the
problem for other architectures (ia64/mips/mips64) which already
define their own keyboard probing method.

This patch gives precedence to these archs' probing method and only
defines the setup option if no arch-specific method was defined.

Problem reported by David W Studeman.

Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/char/pc_keyb.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/char/pc_keyb.c b/drivers/char/pc_keyb.c
index d4e1611..b90e659 100644
--- a/drivers/char/pc_keyb.c
+++ b/drivers/char/pc_keyb.c
@@ -61,6 +61,10 @@ unsigned char pckbd_sysrq_xlate[128] =
 	"\r\000/";					/* 0x60 - 0x6f */
 #endif
 
+/* Warning: do not redefine kbd_controller_present on ia64, mips and mips64 */
+#ifndef kbd_controller_present
+#define kbd_controller_present() keyboard_controller_present
+
 int keyboard_controller_present __initdata = 1;
 static int __init removable_keyb(char *str)
 {
@@ -68,6 +72,7 @@ static int __init removable_keyb(char *str)
         return 0;
 }
 __setup("nokeyb", removable_keyb);
+#endif
 
 static void kbd_write_command_w(int data);
 static void kbd_write_output_w(int data);
@@ -77,8 +82,6 @@ static void __aux_write_ack(int val);
 static int aux_reconnect = 0;
 #endif
 
-#define kbd_controller_present() keyboard_controller_present
-
 static spinlock_t kbd_controller_lock = SPIN_LOCK_UNLOCKED;
 static unsigned char handle_kbd_event(void);
 
@@ -905,7 +908,7 @@ static char * __init initialize_kbd(void)
 
 void __init pckbd_init_hw(void)
 {
-	if (!keyboard_controller_present) {
+	if (!kbd_controller_present()) {
 		kbd_exists = 0;
 		return;
 	}
-- 
1.5.3.8

