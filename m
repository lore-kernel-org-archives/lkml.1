Return-Path: <linux-kernel-owner+w=401wt.eu-S1765925AbXJSCtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765925AbXJSCtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 22:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762888AbXJSCtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 22:49:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:50319 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1762329AbXJSCtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 22:49:05 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+jG+MSq+Kj26CzXoS/uNoEVKCs++rSJ6I+aPBCAJ
	pWpurX+4bWWByO
Subject: Re: [bisected][mismerge?] Re: [microcode] 2.6.23.git pulled this
	morning oopses loading P4 microcode
From: Mike Galbraith <efault@gmx.de>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071018223333.GD4153@implementation>
References: <1192681533.7147.5.camel@Homer.simpson.net>
	 <1192730198.7182.18.camel@Homer.simpson.net>
	 <20071018223333.GD4153@implementation>
Content-Type: text/plain; charset=ISO-8859-1
Date: Fri, 19 Oct 2007 04:48:58 +0200
Message-Id: <1192762138.6838.13.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-18 at 23:33 +0100, Samuel Thibault wrote:
> Hi,
> 
> Mike Galbraith, le Thu 18 Oct 2007 19:56:38 +0200, a écrit :
> > The winner of a very long git bisect session:
> > 
> >     unicode diacritics support
> 
> Uh, I fail to see how that could have an impact, I've again checked the
> boundaries, it looks fine, please people have a look.

I too was reluctant to believe the bisect result.  But...

> Could you try something odd?  On your tree that has the change reverted,
> please try the attached patch, which makes the array the same size at it
> would be with the change, possibly triggering bugs in completely other
> parts of the kernel.

That didn't break my box.  However, removing your test patch and
re-applying the revert I generated between git tree and working tree
brought it right back.  With the below applied, diff says there is no
difference between working tree and git tree (except for
vsyscall_32.lds, which is a generated file kbuild leaves lying around).
Per gitk, the git repository is at
d85714d81cc0408daddb68c10f7fd69eafe7c213

diff -uprNX /root/dontdiff git/linux-2.6/drivers/acorn/char/defkeymap-l7200.c linux-2.6.23.git/drivers/acorn/char/defkeymap-l7200.c
--- git/linux-2.6/drivers/acorn/char/defkeymap-l7200.c	2007-10-18 18:55:53.000000000 +0200
+++ linux-2.6.23.git/drivers/acorn/char/defkeymap-l7200.c	2007-10-18 19:02:12.000000000 +0200
@@ -346,7 +346,7 @@ char *func_table[MAX_NR_FUNC] = {
 	0,
 };
 
-struct kbdiacruc accent_table[MAX_DIACR] = {
+struct kbdiacr accent_table[MAX_DIACR] = {
 	{'`', 'A', '\300'},	{'`', 'a', '\340'},
 	{'\'', 'A', '\301'},	{'\'', 'a', '\341'},
 	{'^', 'A', '\302'},	{'^', 'a', '\342'},
diff -uprNX /root/dontdiff git/linux-2.6/drivers/char/consolemap.c linux-2.6.23.git/drivers/char/consolemap.c
--- git/linux-2.6/drivers/char/consolemap.c	2007-10-18 18:55:53.000000000 +0200
+++ linux-2.6.23.git/drivers/char/consolemap.c	2007-10-18 19:02:12.000000000 +0200
@@ -669,29 +669,19 @@ void con_protect_unimap(struct vc_data *
 		p->readonly = rdonly;
 }
 
-/*
- * Always use USER_MAP. These functions are used by the keyboard,
- * which shouldn't be affected by G0/G1 switching, etc.
- * If the user map still contains default values, i.e. the
- * direct-to-font mapping, then assume user is using Latin1.
- */
 /* may be called during an interrupt */
 u32 conv_8bit_to_uni(unsigned char c)
 {
+	/*
+	 * Always use USER_MAP. This function is used by the keyboard,
+	 * which shouldn't be affected by G0/G1 switching, etc.
+	 * If the user map still contains default values, i.e. the
+	 * direct-to-font mapping, then assume user is using Latin1.
+	 */
 	unsigned short uni = translations[USER_MAP][c];
 	return uni == (0xf000 | c) ? c : uni;
 }
 
-int conv_uni_to_8bit(u32 uni)
-{
-	int c;
-	for (c = 0; c < 0x100; c++)
-		if (translations[USER_MAP][c] == uni ||
-		   (translations[USER_MAP][c] == (c | 0xf000) && uni == c))
-			return c;
-	return -1;
-}
-
 int
 conv_uni_to_pc(struct vc_data *conp, long ucs) 
 {
diff -uprNX /root/dontdiff git/linux-2.6/drivers/char/keyboard.c linux-2.6.23.git/drivers/char/keyboard.c
--- git/linux-2.6/drivers/char/keyboard.c	2007-10-18 18:55:53.000000000 +0200
+++ linux-2.6.23.git/drivers/char/keyboard.c	2007-10-18 19:02:19.000000000 +0200
@@ -38,7 +38,6 @@
 #include <linux/kbd_kern.h>
 #include <linux/kbd_diacr.h>
 #include <linux/vt_kern.h>
-#include <linux/consolemap.h>
 #include <linux/sysrq.h>
 #include <linux/input.h>
 #include <linux/reboot.h>
@@ -404,12 +403,9 @@ static unsigned int handle_diacr(struct 
 		return d;
 
 	if (kbd->kbdmode == VC_UNICODE)
-		to_utf8(vc, d);
-	else {
-		int c = conv_uni_to_8bit(d);
-		if (c != -1)
-			put_queue(vc, c);
-	}
+		to_utf8(vc, conv_8bit_to_uni(d));
+	else if (d < 0x100)
+		put_queue(vc, d);
 
 	return ch;
 }
@@ -421,12 +417,9 @@ static void fn_enter(struct vc_data *vc)
 {
 	if (diacr) {
 		if (kbd->kbdmode == VC_UNICODE)
-			to_utf8(vc, diacr);
-		else {
-			int c = conv_uni_to_8bit(diacr);
-			if (c != -1)
-				put_queue(vc, c);
-		}
+			to_utf8(vc, conv_8bit_to_uni(diacr));
+		else if (diacr < 0x100)
+			put_queue(vc, diacr);
 		diacr = 0;
 	}
 	put_queue(vc, 13);
@@ -634,12 +627,9 @@ static void k_unicode(struct vc_data *vc
 		return;
 	}
 	if (kbd->kbdmode == VC_UNICODE)
-		to_utf8(vc, value);
-	else {
-		int c = conv_uni_to_8bit(value);
-		if (c != -1)
-			put_queue(vc, c);
-	}
+		to_utf8(vc, conv_8bit_to_uni(value));
+	else if (value < 0x100)
+		put_queue(vc, value);
 }
 
 /*
@@ -656,12 +646,7 @@ static void k_deadunicode(struct vc_data
 
 static void k_self(struct vc_data *vc, unsigned char value, char up_flag)
 {
-	unsigned int uni;
-	if (kbd->kbdmode == VC_UNICODE)
-		uni = value;
-	else
-		uni = conv_8bit_to_uni(value);
-	k_unicode(vc, uni, up_flag);
+	k_unicode(vc, value, up_flag);
 }
 
 static void k_dead2(struct vc_data *vc, unsigned char value, char up_flag)
diff -uprNX /root/dontdiff git/linux-2.6/drivers/char/vt_ioctl.c linux-2.6.23.git/drivers/char/vt_ioctl.c
--- git/linux-2.6/drivers/char/vt_ioctl.c	2007-10-18 18:55:53.000000000 +0200
+++ linux-2.6.23.git/drivers/char/vt_ioctl.c	2007-10-18 19:02:19.000000000 +0200
@@ -23,7 +23,6 @@
 #include <linux/major.h>
 #include <linux/fs.h>
 #include <linux/console.h>
-#include <linux/consolemap.h>
 #include <linux/signal.h>
 #include <linux/timex.h>
 
@@ -583,27 +582,10 @@ int vt_ioctl(struct tty_struct *tty, str
 	case KDGKBDIACR:
 	{
 		struct kbdiacrs __user *a = up;
-		struct kbdiacr diacr;
-		int i;
 
 		if (put_user(accent_table_size, &a->kb_cnt))
 			return -EFAULT;
-		for (i = 0; i < accent_table_size; i++) {
-			diacr.diacr = conv_uni_to_8bit(accent_table[i].diacr);
-			diacr.base = conv_uni_to_8bit(accent_table[i].base);
-			diacr.result = conv_uni_to_8bit(accent_table[i].result);
-			if (copy_to_user(a->kbdiacr + i, &diacr, sizeof(struct kbdiacr)))
-				return -EFAULT;
-		}
-		return 0;
-	}
-	case KDGKBDIACRUC:
-	{
-		struct kbdiacrsuc __user *a = up;
-
-		if (put_user(accent_table_size, &a->kb_cnt))
-			return -EFAULT;
-		if (copy_to_user(a->kbdiacruc, accent_table, accent_table_size*sizeof(struct kbdiacruc)))
+		if (copy_to_user(a->kbdiacr, accent_table, accent_table_size*sizeof(struct kbdiacr)))
 			return -EFAULT;
 		return 0;
 	}
@@ -611,30 +593,6 @@ int vt_ioctl(struct tty_struct *tty, str
 	case KDSKBDIACR:
 	{
 		struct kbdiacrs __user *a = up;
-		struct kbdiacr diacr;
-		unsigned int ct;
-		int i;
-
-		if (!perm)
-			return -EPERM;
-		if (get_user(ct,&a->kb_cnt))
-			return -EFAULT;
-		if (ct >= MAX_DIACR)
-			return -EINVAL;
-		accent_table_size = ct;
-		for (i = 0; i < ct; i++) {
-			if (copy_from_user(&diacr, a->kbdiacr + i, sizeof(struct kbdiacr)))
-				return -EFAULT;
-			accent_table[i].diacr = conv_8bit_to_uni(diacr.diacr);
-			accent_table[i].base = conv_8bit_to_uni(diacr.base);
-			accent_table[i].result = conv_8bit_to_uni(diacr.result);
-		}
-		return 0;
-	}
-
-	case KDSKBDIACRUC:
-	{
-		struct kbdiacrsuc __user *a = up;
 		unsigned int ct;
 
 		if (!perm)
@@ -644,7 +602,7 @@ int vt_ioctl(struct tty_struct *tty, str
 		if (ct >= MAX_DIACR)
 			return -EINVAL;
 		accent_table_size = ct;
-		if (copy_from_user(accent_table, a->kbdiacruc, ct*sizeof(struct kbdiacruc)))
+		if (copy_from_user(accent_table, a->kbdiacr, ct*sizeof(struct kbdiacr)))
 			return -EFAULT;
 		return 0;
 	}
diff -uprNX /root/dontdiff git/linux-2.6/drivers/s390/char/keyboard.c linux-2.6.23.git/drivers/s390/char/keyboard.c
--- git/linux-2.6/drivers/s390/char/keyboard.c	2007-10-18 18:55:53.000000000 +0200
+++ linux-2.6.23.git/drivers/s390/char/keyboard.c	2007-10-18 19:02:21.000000000 +0200
@@ -11,7 +11,6 @@
 #include <linux/sched.h>
 #include <linux/sysrq.h>
 
-#include <linux/consolemap.h>
 #include <linux/kbd_kern.h>
 #include <linux/kbd_diacr.h>
 #include <asm/uaccess.h>
@@ -83,11 +82,11 @@ kbd_alloc(void) {
 	if (!kbd->fn_handler)
 		goto out_func;
 	kbd->accent_table =
-		kmalloc(sizeof(struct kbdiacruc)*MAX_DIACR, GFP_KERNEL);
+		kmalloc(sizeof(struct kbdiacr)*MAX_DIACR, GFP_KERNEL);
 	if (!kbd->accent_table)
 		goto out_fn_handler;
 	memcpy(kbd->accent_table, accent_table,
-	       sizeof(struct kbdiacruc)*MAX_DIACR);
+	       sizeof(struct kbdiacr)*MAX_DIACR);
 	kbd->accent_table_size = accent_table_size;
 	return kbd;
 
@@ -184,8 +183,8 @@ kbd_ebcasc(struct kbd_data *kbd, unsigne
  * Otherwise, conclude that DIACR was not combining after all,
  * queue it and return CH.
  */
-static unsigned int
-handle_diacr(struct kbd_data *kbd, unsigned int ch)
+static unsigned char
+handle_diacr(struct kbd_data *kbd, unsigned char ch)
 {
 	int i, d;
 
@@ -461,6 +460,7 @@ int
 kbd_ioctl(struct kbd_data *kbd, struct file *file,
 	  unsigned int cmd, unsigned long arg)
 {
+	struct kbdiacrs __user *a;
 	void __user *argp;
 	int ct, perm;
 
@@ -481,40 +481,17 @@ kbd_ioctl(struct kbd_data *kbd, struct f
 	case KDSKBSENT:
 		return do_kdgkb_ioctl(kbd, argp, cmd, perm);
 	case KDGKBDIACR:
-	{
-		struct kbdiacrs __user *a = argp;
-		struct kbdiacr diacr;
-		int i;
+		a = argp;
 
 		if (put_user(kbd->accent_table_size, &a->kb_cnt))
 			return -EFAULT;
-		for (i = 0; i < kbd->accent_table_size; i++) {
-			diacr.diacr = kbd->accent_table[i].diacr;
-			diacr.base = kbd->accent_table[i].base;
-			diacr.result = kbd->accent_table[i].result;
-			if (copy_to_user(a->kbdiacr + i, &diacr, sizeof(struct kbdiacr)))
-			return -EFAULT;
-		}
-		return 0;
-	}
-	case KDGKBDIACRUC:
-	{
-		struct kbdiacrsuc __user *a = argp;
-
 		ct = kbd->accent_table_size;
-		if (put_user(ct, &a->kb_cnt))
-			return -EFAULT;
-		if (copy_to_user(a->kbdiacruc, kbd->accent_table,
-				 ct * sizeof(struct kbdiacruc)))
+		if (copy_to_user(a->kbdiacr, kbd->accent_table,
+				 ct * sizeof(struct kbdiacr)))
 			return -EFAULT;
 		return 0;
-	}
 	case KDSKBDIACR:
-	{
-		struct kbdiacrs __user *a = argp;
-		struct kbdiacr diacr;
-		int i;
-
+		a = argp;
 		if (!perm)
 			return -EPERM;
 		if (get_user(ct, &a->kb_cnt))
@@ -522,31 +499,10 @@ kbd_ioctl(struct kbd_data *kbd, struct f
 		if (ct >= MAX_DIACR)
 			return -EINVAL;
 		kbd->accent_table_size = ct;
-		for (i = 0; i < ct; i++) {
-			if (copy_from_user(&diacr, a->kbdiacr + i, sizeof(struct kbdiacr)))
-				return -EFAULT;
-			kbd->accent_table[i].diacr = diacr.diacr;
-			kbd->accent_table[i].base = diacr.base;
-			kbd->accent_table[i].result = diacr.result;
-		}
-		return 0;
-	}
-	case KDSKBDIACRUC:
-	{
-		struct kbdiacrsuc __user *a = argp;
-
-		if (!perm)
-			return -EPERM;
-		if (get_user(ct, &a->kb_cnt))
-			return -EFAULT;
-		if (ct >= MAX_DIACR)
-			return -EINVAL;
-		kbd->accent_table_size = ct;
-		if (copy_from_user(kbd->accent_table, a->kbdiacruc,
-				   ct * sizeof(struct kbdiacruc)))
+		if (copy_from_user(kbd->accent_table, a->kbdiacr,
+				   ct * sizeof(struct kbdiacr)))
 			return -EFAULT;
 		return 0;
-	}
 	default:
 		return -ENOIOCTLCMD;
 	}
diff -uprNX /root/dontdiff git/linux-2.6/drivers/s390/char/keyboard.h linux-2.6.23.git/drivers/s390/char/keyboard.h
--- git/linux-2.6/drivers/s390/char/keyboard.h	2007-10-18 18:55:53.000000000 +0200
+++ linux-2.6.23.git/drivers/s390/char/keyboard.h	2007-10-18 19:02:21.000000000 +0200
@@ -25,9 +25,9 @@ struct kbd_data {
 	unsigned short **key_maps;
 	char **func_table;
 	fn_handler_fn **fn_handler;
-	struct kbdiacruc *accent_table;
+	struct kbdiacr *accent_table;
 	unsigned int accent_table_size;
-	unsigned int diacr;
+	unsigned char diacr;
 	unsigned short sysrq;
 };
 
diff -uprNX /root/dontdiff git/linux-2.6/include/linux/consolemap.h linux-2.6.23.git/include/linux/consolemap.h
--- git/linux-2.6/include/linux/consolemap.h	2007-10-18 18:55:53.000000000 +0200
+++ linux-2.6.23.git/include/linux/consolemap.h	2007-10-18 19:02:34.000000000 +0200
@@ -16,5 +16,4 @@ extern u16 inverse_translate(struct vc_d
 extern unsigned short *set_translate(int m, struct vc_data *vc);
 extern int conv_uni_to_pc(struct vc_data *conp, long ucs);
 extern u32 conv_8bit_to_uni(unsigned char c);
-extern int conv_uni_to_8bit(u32 uni);
 void console_map_init(void);
diff -uprNX /root/dontdiff git/linux-2.6/include/linux/kbd_diacr.h linux-2.6.23.git/include/linux/kbd_diacr.h
--- git/linux-2.6/include/linux/kbd_diacr.h	2007-10-18 18:55:53.000000000 +0200
+++ linux-2.6.23.git/include/linux/kbd_diacr.h	2007-10-18 19:02:34.000000000 +0200
@@ -2,7 +2,7 @@
 #define _DIACR_H
 #include <linux/kd.h>
 
-extern struct kbdiacruc accent_table[];
+extern struct kbdiacr accent_table[];
 extern unsigned int accent_table_size;
 
 #endif /* _DIACR_H */
diff -uprNX /root/dontdiff git/linux-2.6/include/linux/kd.h linux-2.6.23.git/include/linux/kd.h
--- git/linux-2.6/include/linux/kd.h	2007-10-18 18:55:53.000000000 +0200
+++ linux-2.6.23.git/include/linux/kd.h	2007-10-18 19:02:34.000000000 +0200
@@ -125,16 +125,6 @@ struct kbdiacrs {
 #define KDGKBDIACR      0x4B4A  /* read kernel accent table */
 #define KDSKBDIACR      0x4B4B  /* write kernel accent table */
 
-struct kbdiacruc {
-        __u32 diacr, base, result;
-};
-struct kbdiacrsuc {
-        unsigned int kb_cnt;    /* number of entries in following array */
-	struct kbdiacruc kbdiacruc[256];    /* MAX_DIACR from keyboard.h */
-};
-#define KDGKBDIACRUC    0x4BFA  /* read kernel accent table - UCS */
-#define KDSKBDIACRUC    0x4BFB  /* write kernel accent table - UCS */
-
 struct kbkeycode {
 	unsigned int scancode, keycode;
 };


