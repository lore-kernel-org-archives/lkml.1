Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbXHHIKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbXHHIKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 04:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbXHHIKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 04:10:17 -0400
Received: from iona.labri.fr ([147.210.8.143]:54816 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754097AbXHHIKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 04:10:13 -0400
Date: Wed, 8 Aug 2007 10:10:10 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, linuxconsole-dev@lists.sourceforge.net
Cc: akpm@google.com
Subject: [PATCH] unicode diacritics support
Message-ID: <20070808081010.GA3292@implementation.labri.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org,
	linuxconsole-dev@lists.sourceforge.net, akpm@google.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There have been issues with non-latin1 diacritics and unicode.
http://bugzilla.kernel.org/show_bug.cgi?id=7746

Git 759448f459234bfcf34b82471f0dba77a9aca498 `Kernel utf-8 handling'
partly resolved it by adding conversion between diacritics and
unicode. The patch below goes further by just turning diacritics into
unicode, hence providing better future support. The kbd support can be
fetched from
http://bugzilla.kernel.org/attachment.cgi?id=12313

This was tested in all of latin1, latin9, latin2 and unicode with french
and czech dead keys.

--

Turn the kernel accent_table into unicode, and extend ioctls KDGKBDIACR
and KDSKBDIACR into their equivalents KDGKBDIACRUC and KDSKBDIACR.

New function int conv_uni_to_8bit(u32 uni) for converting unicode into 8bit
_input_.  No, we don't want to store the translation, as it is potentially
sparse and large.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

diff --git a/drivers/acorn/char/defkeymap-l7200.c b/drivers/acorn/char/defkeymap-l7200.c
index 9e18ce7..28a5fbc 100644
--- a/drivers/acorn/char/defkeymap-l7200.c
+++ b/drivers/acorn/char/defkeymap-l7200.c
@@ -346,7 +346,7 @@ char *func_table[MAX_NR_FUNC] = {
 	0,
 };
 
-struct kbdiacr accent_table[MAX_DIACR] = {
+struct kbdiacruc accent_table[MAX_DIACR] = {
 	{'`', 'A', '\300'},	{'`', 'a', '\340'},
 	{'\'', 'A', '\301'},	{'\'', 'a', '\341'},
 	{'^', 'A', '\302'},	{'^', 'a', '\342'},
diff --git a/drivers/char/consolemap.c b/drivers/char/consolemap.c
index 4b3916f..689d820 100644
--- a/drivers/char/consolemap.c
+++ b/drivers/char/consolemap.c
@@ -670,19 +670,29 @@ void con_protect_unimap(struct vc_data *vc, int rdonly)
 		p->readonly = rdonly;
 }
 
+/*
+ * Always use USER_MAP. These functions are used by the keyboard,
+ * which shouldn't be affected by G0/G1 switching, etc.
+ * If the user map still contains default values, i.e. the
+ * direct-to-font mapping, then assume user is using Latin1.
+ */
 /* may be called during an interrupt */
 u32 conv_8bit_to_uni(unsigned char c)
 {
-	/*
-	 * Always use USER_MAP. This function is used by the keyboard,
-	 * which shouldn't be affected by G0/G1 switching, etc.
-	 * If the user map still contains default values, i.e. the
-	 * direct-to-font mapping, then assume user is using Latin1.
-	 */
 	unsigned short uni = translations[USER_MAP][c];
 	return uni == (0xf000 | c) ? c : uni;
 }
 
+int conv_uni_to_8bit(u32 uni)
+{
+	int c;
+	for (c = 0; c < 0x100; c++)
+		if (translations[USER_MAP][c] == uni ||
+		   (translations[USER_MAP][c] == (c | 0xf000) && uni == c))
+			return c;
+	return -1;
+}
+
 int
 conv_uni_to_pc(struct vc_data *conp, long ucs) 
 {
diff --git a/drivers/char/defkeymap.c_shipped b/drivers/char/defkeymap.c_shipped
index 453a2f1..0aa419a 100644
--- a/drivers/char/defkeymap.c_shipped
+++ b/drivers/char/defkeymap.c_shipped
@@ -222,7 +222,7 @@ char *func_table[MAX_NR_FUNC] = {
 	NULL,
 };
 
-struct kbdiacr accent_table[MAX_DIACR] = {
+struct kbdiacruc accent_table[MAX_DIACR] = {
 	{'`', 'A', '\300'},	{'`', 'a', '\340'},
 	{'\'', 'A', '\301'},	{'\'', 'a', '\341'},
 	{'^', 'A', '\302'},	{'^', 'a', '\342'},
diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index 2ce0af1..3bec260 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -41,6 +41,7 @@
 #include <linux/sysrq.h>
 #include <linux/input.h>
 #include <linux/reboot.h>
+#include <linux/consolemap.h>
 
 extern void ctrl_alt_del(void);
 
@@ -403,9 +404,12 @@ static unsigned int handle_diacr(struct vc_data *vc, unsigned int ch)
 		return d;
 
 	if (kbd->kbdmode == VC_UNICODE)
-		to_utf8(vc, conv_8bit_to_uni(d));
-	else if (d < 0x100)
-		put_queue(vc, d);
+		to_utf8(vc, d);
+	else {
+		int c = conv_uni_to_8bit(d);
+		if (c != -1)
+			put_queue(vc, c);
+	}
 
 	return ch;
 }
@@ -417,9 +421,12 @@ static void fn_enter(struct vc_data *vc)
 {
 	if (diacr) {
 		if (kbd->kbdmode == VC_UNICODE)
-			to_utf8(vc, conv_8bit_to_uni(diacr));
-		else if (diacr < 0x100)
-			put_queue(vc, diacr);
+			to_utf8(vc, diacr);
+		else {
+			int c = conv_uni_to_8bit(diacr);
+			if (c != -1)
+				put_queue(vc, c);
+		}
 		diacr = 0;
 	}
 	put_queue(vc, 13);
@@ -627,9 +634,12 @@ static void k_unicode(struct vc_data *vc, unsigned int value, char up_flag)
 		return;
 	}
 	if (kbd->kbdmode == VC_UNICODE)
-		to_utf8(vc, conv_8bit_to_uni(value));
-	else if (value < 0x100)
-		put_queue(vc, value);
+		to_utf8(vc, value);
+	else {
+		int c = conv_uni_to_8bit(value);
+		if (c != -1)
+			put_queue(vc, c);
+	}
 }
 
 /*
@@ -646,7 +656,12 @@ static void k_deadunicode(struct vc_data *vc, unsigned int value, char up_flag)
 
 static void k_self(struct vc_data *vc, unsigned char value, char up_flag)
 {
-	k_unicode(vc, value, up_flag);
+	unsigned int uni;
+	if (kbd->kbdmode == VC_UNICODE)
+		uni = value;
+	else
+		uni = conv_8bit_to_uni(value);
+	k_unicode(vc, uni, up_flag);
 }
 
 static void k_dead2(struct vc_data *vc, unsigned char value, char up_flag)
diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index c6f6f42..e4d817b 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -23,6 +23,7 @@
 #include <linux/major.h>
 #include <linux/fs.h>
 #include <linux/console.h>
+#include <linux/consolemap.h>
 #include <linux/signal.h>
 #include <linux/timex.h>
 
@@ -582,10 +583,27 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 	case KDGKBDIACR:
 	{
 		struct kbdiacrs __user *a = up;
+		struct kbdiacr diacr;
+		int i;
 
 		if (put_user(accent_table_size, &a->kb_cnt))
 			return -EFAULT;
-		if (copy_to_user(a->kbdiacr, accent_table, accent_table_size*sizeof(struct kbdiacr)))
+		for (i = 0; i < accent_table_size; i++) {
+			diacr.diacr = conv_uni_to_8bit(accent_table[i].diacr);
+			diacr.base = conv_uni_to_8bit(accent_table[i].base);
+			diacr.result = conv_uni_to_8bit(accent_table[i].result);
+			if (copy_to_user(a->kbdiacr + i, &diacr, sizeof(struct kbdiacr)))
+				return -EFAULT;
+		}
+		return 0;
+	}
+	case KDGKBDIACRUC:
+	{
+		struct kbdiacrsuc __user *a = up;
+
+		if (put_user(accent_table_size, &a->kb_cnt))
+			return -EFAULT;
+		if (copy_to_user(a->kbdiacruc, accent_table, accent_table_size*sizeof(struct kbdiacruc)))
 			return -EFAULT;
 		return 0;
 	}
@@ -593,6 +611,30 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 	case KDSKBDIACR:
 	{
 		struct kbdiacrs __user *a = up;
+		struct kbdiacr diacr;
+		unsigned int ct;
+		int i;
+
+		if (!perm)
+			return -EPERM;
+		if (get_user(ct,&a->kb_cnt))
+			return -EFAULT;
+		if (ct >= MAX_DIACR)
+			return -EINVAL;
+		accent_table_size = ct;
+		for (i = 0; i < ct; i++) {
+			if (copy_from_user(&diacr, a->kbdiacr + i, sizeof(struct kbdiacr)))
+				return -EFAULT;
+			accent_table[i].diacr = conv_8bit_to_uni(diacr.diacr);
+			accent_table[i].base = conv_8bit_to_uni(diacr.base);
+			accent_table[i].result = conv_8bit_to_uni(diacr.result);
+		}
+		return 0;
+	}
+
+	case KDSKBDIACRUC:
+	{
+		struct kbdiacrsuc __user *a = up;
 		unsigned int ct;
 
 		if (!perm)
@@ -602,7 +644,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		if (ct >= MAX_DIACR)
 			return -EINVAL;
 		accent_table_size = ct;
-		if (copy_from_user(accent_table, a->kbdiacr, ct*sizeof(struct kbdiacr)))
+		if (copy_from_user(accent_table, a->kbdiacruc, ct*sizeof(struct kbdiacruc)))
 			return -EFAULT;
 		return 0;
 	}
diff --git a/drivers/s390/char/defkeymap.c b/drivers/s390/char/defkeymap.c
index 564baca..389346c 100644
--- a/drivers/s390/char/defkeymap.c
+++ b/drivers/s390/char/defkeymap.c
@@ -150,7 +150,7 @@ char *func_table[MAX_NR_FUNC] = {
 	NULL,
 };
 
-struct kbdiacr accent_table[MAX_DIACR] = {
+struct kbdiacruc accent_table[MAX_DIACR] = {
 	{'^', 'c', '\003'},	{'^', 'd', '\004'},
 	{'^', 'z', '\032'},	{'^', '\012', '\000'},
 };
diff --git a/drivers/s390/char/keyboard.c b/drivers/s390/char/keyboard.c
index f62f9a4..5ab0d9e 100644
--- a/drivers/s390/char/keyboard.c
+++ b/drivers/s390/char/keyboard.c
@@ -11,6 +11,7 @@
 #include <linux/sched.h>
 #include <linux/sysrq.h>
 
+#include <linux/consolemap.h>
 #include <linux/kbd_kern.h>
 #include <linux/kbd_diacr.h>
 #include <asm/uaccess.h>
@@ -82,11 +83,11 @@ kbd_alloc(void) {
 	if (!kbd->fn_handler)
 		goto out_func;
 	kbd->accent_table =
-		kmalloc(sizeof(struct kbdiacr)*MAX_DIACR, GFP_KERNEL);
+		kmalloc(sizeof(struct kbdiacruc)*MAX_DIACR, GFP_KERNEL);
 	if (!kbd->accent_table)
 		goto out_fn_handler;
 	memcpy(kbd->accent_table, accent_table,
-	       sizeof(struct kbdiacr)*MAX_DIACR);
+	       sizeof(struct kbdiacruc)*MAX_DIACR);
 	kbd->accent_table_size = accent_table_size;
 	return kbd;
 
@@ -183,8 +184,8 @@ kbd_ebcasc(struct kbd_data *kbd, unsigned char *ebcasc)
  * Otherwise, conclude that DIACR was not combining after all,
  * queue it and return CH.
  */
-static unsigned char
-handle_diacr(struct kbd_data *kbd, unsigned char ch)
+static unsigned int
+handle_diacr(struct kbd_data *kbd, unsigned int ch)
 {
 	int i, d;
 
@@ -460,7 +461,6 @@ int
 kbd_ioctl(struct kbd_data *kbd, struct file *file,
 	  unsigned int cmd, unsigned long arg)
 {
-	struct kbdiacrs __user *a;
 	void __user *argp;
 	int ct, perm;
 
@@ -481,17 +481,40 @@ kbd_ioctl(struct kbd_data *kbd, struct file *file,
 	case KDSKBSENT:
 		return do_kdgkb_ioctl(kbd, argp, cmd, perm);
 	case KDGKBDIACR:
-		a = argp;
+	{
+		struct kbdiacrs __user *a = argp;
+		struct kbdiacr diacr;
+		int i;
 
 		if (put_user(kbd->accent_table_size, &a->kb_cnt))
 			return -EFAULT;
+		for (i = 0; i < kbd->accent_table_size; i++) {
+			diacr.diacr = conv_uni_to_8bit(kbd->accent_table[i].diacr);
+			diacr.base = conv_uni_to_8bit(kbd->accent_table[i].base);
+			diacr.result = conv_uni_to_8bit(kbd->accent_table[i].result);
+			if (copy_to_user(a->kbdiacr + i, &diacr, sizeof(struct kbdiacr)))
+			return -EFAULT;
+		}
+		return 0;
+	}
+	case KDGKBDIACRUC:
+	{
+		struct kbdiacrsuc __user *a = argp;
+
 		ct = kbd->accent_table_size;
-		if (copy_to_user(a->kbdiacr, kbd->accent_table,
-				 ct * sizeof(struct kbdiacr)))
+		if (put_user(ct, &a->kb_cnt))
+			return -EFAULT;
+		if (copy_to_user(a->kbdiacruc, kbd->accent_table,
+				 ct * sizeof(struct kbdiacruc)))
 			return -EFAULT;
 		return 0;
+	}
 	case KDSKBDIACR:
-		a = argp;
+	{
+		struct kbdiacrs __user *a = argp;
+		struct kbdiacr diacr;
+		int i;
+
 		if (!perm)
 			return -EPERM;
 		if (get_user(ct, &a->kb_cnt))
@@ -499,10 +522,31 @@ kbd_ioctl(struct kbd_data *kbd, struct file *file,
 		if (ct >= MAX_DIACR)
 			return -EINVAL;
 		kbd->accent_table_size = ct;
-		if (copy_from_user(kbd->accent_table, a->kbdiacr,
-				   ct * sizeof(struct kbdiacr)))
+		for (i = 0; i < ct; i++) {
+			if (copy_from_user(&diacr, a->kbdiacr + i, sizeof(struct kbdiacr)))
+				return -EFAULT;
+			kbd->accent_table[i].diacr = conv_8bit_to_uni(diacr.diacr);
+			kbd->accent_table[i].base = conv_8bit_to_uni(diacr.base);
+			kbd->accent_table[i].result = conv_8bit_to_uni(diacr.result);
+		}
+		return 0;
+	}
+	case KDSKBDIACRUC:
+	{
+		struct kbdiacrsuc __user *a = argp;
+
+		if (!perm)
+			return -EPERM;
+		if (get_user(ct, &a->kb_cnt))
+			return -EFAULT;
+		if (ct >= MAX_DIACR)
+			return -EINVAL;
+		kbd->accent_table_size = ct;
+		if (copy_from_user(kbd->accent_table, a->kbdiacruc,
+				   ct * sizeof(struct kbdiacruc)))
 			return -EFAULT;
 		return 0;
+	}
 	default:
 		return -ENOIOCTLCMD;
 	}
diff --git a/drivers/s390/char/keyboard.h b/drivers/s390/char/keyboard.h
index f7bf45c..5ccfe9c 100644
--- a/drivers/s390/char/keyboard.h
+++ b/drivers/s390/char/keyboard.h
@@ -25,9 +25,9 @@ struct kbd_data {
 	unsigned short **key_maps;
 	char **func_table;
 	fn_handler_fn **fn_handler;
-	struct kbdiacr *accent_table;
+	struct kbdiacruc *accent_table;
 	unsigned int accent_table_size;
-	unsigned char diacr;
+	unsigned int diacr;
 	unsigned short sysrq;
 };
 
diff --git a/drivers/tc/lk201-map.c_shipped b/drivers/tc/lk201-map.c_shipped
index a9df8f5..4d2aba5 100644
--- a/drivers/tc/lk201-map.c_shipped
+++ b/drivers/tc/lk201-map.c_shipped
@@ -225,7 +225,7 @@ char *func_table[MAX_NR_FUNC] = {
 	0,
 };
 
-struct kbdiacr accent_table[MAX_DIACR] = {
+struct kbdiacruc accent_table[MAX_DIACR] = {
 	{'`', 'A', 'À'},	{'`', 'a', 'à'},
 	{'\'', 'A', 'Á'},	{'\'', 'a', 'á'},
 	{'^', 'A', 'Â'},	{'^', 'a', 'â'},
diff --git a/include/linux/consolemap.h b/include/linux/consolemap.h
index 06b2768..e2bf7e5 100644
--- a/include/linux/consolemap.h
+++ b/include/linux/consolemap.h
@@ -16,4 +16,5 @@ extern u16 inverse_translate(struct vc_data *conp, int glyph, int use_unicode);
 extern unsigned short *set_translate(int m, struct vc_data *vc);
 extern int conv_uni_to_pc(struct vc_data *conp, long ucs);
 extern u32 conv_8bit_to_uni(unsigned char c);
+extern int conv_uni_to_8bit(u32 uni);
 void console_map_init(void);
diff --git a/include/linux/kbd_diacr.h b/include/linux/kbd_diacr.h
index 1c1a3ff..7274ec6 100644
--- a/include/linux/kbd_diacr.h
+++ b/include/linux/kbd_diacr.h
@@ -2,7 +2,7 @@
 #define _DIACR_H
 #include <linux/kd.h>
 
-extern struct kbdiacr accent_table[];
+extern struct kbdiacruc accent_table[];
 extern unsigned int accent_table_size;
 
 #endif /* _DIACR_H */
diff --git a/include/linux/kd.h b/include/linux/kd.h
index 28be4fb..c91fc0c 100644
--- a/include/linux/kd.h
+++ b/include/linux/kd.h
@@ -125,6 +125,16 @@ struct kbdiacrs {
 #define KDGKBDIACR      0x4B4A  /* read kernel accent table */
 #define KDSKBDIACR      0x4B4B  /* write kernel accent table */
 
+struct kbdiacruc {
+        __u32 diacr, base, result;
+};
+struct kbdiacrsuc {
+        unsigned int kb_cnt;    /* number of entries in following array */
+	struct kbdiacruc kbdiacruc[256];    /* MAX_DIACR from keyboard.h */
+};
+#define KDGKBDIACRUC    0x4BFA  /* read kernel accent table - UCS */
+#define KDSKBDIACRUC    0x4BFB  /* write kernel accent table - UCS */
+
 struct kbkeycode {
 	unsigned int scancode, keycode;
 };
