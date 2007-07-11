Return-Path: <linux-kernel-owner+w=401wt.eu-S934074AbXGKWNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934074AbXGKWNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761997AbXGKWNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:13:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61249 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761750AbXGKWNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:13:39 -0400
Date: Thu, 12 Jul 2007 00:13:25 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>, 7eggert@gmx.de
Subject: [PATCH] Use BIOS Keyboard variable to set Numlock
Message-ID: <Pine.LNX.4.58.0707112305390.2432@be1.lrz>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463760633-152122169-1184192005=:2432"
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/UD/v2e+luMHHpRHkVYCNQ2JusGTf3CJfJpKz
 WTVN8xaeLtXXpSBWCi7GTSa0h4nAfCVnwzN351hsyZm3HCMVHr
 DAAIFW7fcGXMZcaWBiOeg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

---1463760633-152122169-1184192005=:2432
Content-Type: TEXT/PLAIN; charset=US-ASCII

As discussed in the thread "Linus' laptop and Num lock status", the 
numlock setting may cause some laptop keyboards to turn on the numeric key 
part, so cannot be safely enabled on those systems. Unfortunately we can't 
tell if the current system is one of these laptops nor can we read the 
numlock status from the keyboard, so we can't enable Numlock based on one of
these facts and therefore it was disabled by default on most architectures.

This is very unfortunate, since the MF-II keyboards feature a way better 
set of cursor keys, freeing the numeric keypad for numeric input. Having
to enable this each time you boot is a nuisance, especially if the 
keyboard does not feature LED to remind you.

This patch uses the IBM-PC (1981) BIOS data area to determine the initial 
state of theNumlock key. This data area holds a bitmap for the current 
keyboard status, including the numlock bit. All PC-compatible systems that 
can operate DOS or i386 expansion cards need to support this. This data 
area is not destroyed by booting linux from lilo.

Instead of the byte at 0x497 as suggested in that thread, I'm using the 
byte at 0x417, which reflects the intended LED state. In order to change 
the keyboard LED, DOS programs would change this byte and call INT 5
(which is the keyboard software interrupt).

It is yet unknown if booting from non-classic BIOS will provide this data 
area, therefore I've set it to depend on EXPERIMENTAL. The worst thing 
that should happen is a wrongly set keyboard LED.

This patch adds 48 bytes of init-text on x86_32.


Signed-Off-By: Bodo Eggert <7eggert@gmx.de>


diff -X dontdiff -pruN linux-2.6.22/drivers/char/keyboard.c linux-2.6.22.changed/drivers/char/keyboard.c
--- linux-2.6.22/drivers/char/keyboard.c	2007-07-11 23:26:01.000000000 +0200
+++ linux-2.6.22.changed/drivers/char/keyboard.c	2007-07-11 23:27:39.000000000 +0200
@@ -24,6 +24,7 @@
  * 21-08-02: Converted to input API, major cleanup. (Vojtech Pavlik)
  */
 
+#include <asm/io.h>
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/tty.h>
@@ -56,7 +57,10 @@ extern void ctrl_alt_del(void);
  * to be used for numbers.
  */
 
-#if defined(CONFIG_PARISC) && (defined(CONFIG_KEYBOARD_HIL) || defined(CONFIG_KEYBOARD_HIL_OLD))
+#ifdef CONFIG_KBD_DEFLEDS_PCBIOS
+/* KBD_DEFLEDS is a variable */
+#undef KBD_DEFLEDS
+#elif defined(CONFIG_PARISC) && (defined(CONFIG_KEYBOARD_HIL) || defined(CONFIG_KEYBOARD_HIL_OLD))
 #define KBD_DEFLEDS (1 << VC_NUMLOCK)
 #else
 #define KBD_DEFLEDS 0
@@ -1352,8 +1356,17 @@ int __init kbd_init(void)
 {
 	int i;
 	int error;
+#ifdef CONFIG_KBD_DEFLEDS_PCBIOS
+	int KBD_DEFLEDS = 0;
+	/* address 0x40:0x17 */
+	char * bios_kbd_status=xlate_dev_mem_ptr(0x417);
+
+	/* Numlock status bit set? */
+	if (*bios_kbd_status & 0x20)
+		KBD_DEFLEDS = 1 << VC_NUMLOCK;
+#endif
 
-        for (i = 0; i < MAX_NR_CONSOLES; i++) {
+	for (i = 0; i < MAX_NR_CONSOLES; i++) {
 		kbd_table[i].ledflagstate = KBD_DEFLEDS;
 		kbd_table[i].default_ledflagstate = KBD_DEFLEDS;
 		kbd_table[i].ledmode = LED_SHOW_FLAGS;
diff -X dontdiff -pruN linux-2.6.22/drivers/input/keyboard/Kconfig linux-2.6.22.changed/drivers/input/keyboard/Kconfig
--- linux-2.6.22/drivers/input/keyboard/Kconfig	2007-07-11 23:26:01.000000000 +0200
+++ linux-2.6.22.changed/drivers/input/keyboard/Kconfig	2007-07-11 23:27:39.000000000 +0200
@@ -12,6 +12,17 @@ menuconfig INPUT_KEYBOARD
 
 if INPUT_KEYBOARD
 
+config KBD_DEFLEDS_PCBIOS
+	bool "Enable Num-Lock based on BIOS settings"
+	depends on X86_PC && EXPERIMENTAL
+	help
+	  Turns on Numlock depending on the BIOS settings.
+	  This works by reading the BIOS data area as defined for IBM PCs (1981).
+
+	  If you have an alternative firmware like OpenFirmware or LinuxBIOS,
+	  this flag might not be set correctly, which results in a random state
+	  of the Numlock key.
+
 config KEYBOARD_ATKBD
 	tristate "AT keyboard" if EMBEDDED || !X86_PC
 	default y
---1463760633-152122169-1184192005=:2432
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="patch.7eggert.numlock"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.58.0707112305391.2432@be1.lrz>
Content-Description: 
Content-Disposition: attachment; filename="patch.7eggert.numlock"

ZGlmZiAtWCBkb250ZGlmZiAtcHJ1TiBsaW51eC0yLjYuMjIvZHJpdmVycy9j
aGFyL2tleWJvYXJkLmMgbGludXgtMi42LjIyLmNoYW5nZWQvZHJpdmVycy9j
aGFyL2tleWJvYXJkLmMNCi0tLSBsaW51eC0yLjYuMjIvZHJpdmVycy9jaGFy
L2tleWJvYXJkLmMJMjAwNy0wNy0xMSAyMzoyNjowMS4wMDAwMDAwMDAgKzAy
MDANCisrKyBsaW51eC0yLjYuMjIuY2hhbmdlZC9kcml2ZXJzL2NoYXIva2V5
Ym9hcmQuYwkyMDA3LTA3LTExIDIzOjI3OjM5LjAwMDAwMDAwMCArMDIwMA0K
QEAgLTI0LDYgKzI0LDcgQEANCiAgKiAyMS0wOC0wMjogQ29udmVydGVkIHRv
IGlucHV0IEFQSSwgbWFqb3IgY2xlYW51cC4gKFZvanRlY2ggUGF2bGlrKQ0K
ICAqLw0KIA0KKyNpbmNsdWRlIDxhc20vaW8uaD4NCiAjaW5jbHVkZSA8bGlu
dXgvbW9kdWxlLmg+DQogI2luY2x1ZGUgPGxpbnV4L3NjaGVkLmg+DQogI2lu
Y2x1ZGUgPGxpbnV4L3R0eS5oPg0KQEAgLTU2LDcgKzU3LDEwIEBAIGV4dGVy
biB2b2lkIGN0cmxfYWx0X2RlbCh2b2lkKTsNCiAgKiB0byBiZSB1c2VkIGZv
ciBudW1iZXJzLg0KICAqLw0KIA0KLSNpZiBkZWZpbmVkKENPTkZJR19QQVJJ
U0MpICYmIChkZWZpbmVkKENPTkZJR19LRVlCT0FSRF9ISUwpIHx8IGRlZmlu
ZWQoQ09ORklHX0tFWUJPQVJEX0hJTF9PTEQpKQ0KKyNpZmRlZiBDT05GSUdf
S0JEX0RFRkxFRFNfUENCSU9TDQorLyogS0JEX0RFRkxFRFMgaXMgYSB2YXJp
YWJsZSAqLw0KKyN1bmRlZiBLQkRfREVGTEVEUw0KKyNlbGlmIGRlZmluZWQo
Q09ORklHX1BBUklTQykgJiYgKGRlZmluZWQoQ09ORklHX0tFWUJPQVJEX0hJ
TCkgfHwgZGVmaW5lZChDT05GSUdfS0VZQk9BUkRfSElMX09MRCkpDQogI2Rl
ZmluZSBLQkRfREVGTEVEUyAoMSA8PCBWQ19OVU1MT0NLKQ0KICNlbHNlDQog
I2RlZmluZSBLQkRfREVGTEVEUyAwDQpAQCAtMTM1Miw4ICsxMzU2LDE3IEBA
IGludCBfX2luaXQga2JkX2luaXQodm9pZCkNCiB7DQogCWludCBpOw0KIAlp
bnQgZXJyb3I7DQorI2lmZGVmIENPTkZJR19LQkRfREVGTEVEU19QQ0JJT1MN
CisJaW50IEtCRF9ERUZMRURTID0gMDsNCisJLyogYWRkcmVzcyAweDQwOjB4
MTcgKi8NCisJY2hhciAqIGJpb3Nfa2JkX3N0YXR1cz14bGF0ZV9kZXZfbWVt
X3B0cigweDQxNyk7DQorDQorCS8qIE51bWxvY2sgc3RhdHVzIGJpdCBzZXQ/
ICovDQorCWlmICgqYmlvc19rYmRfc3RhdHVzICYgMHgyMCkNCisJCUtCRF9E
RUZMRURTID0gMSA8PCBWQ19OVU1MT0NLOw0KKyNlbmRpZg0KIA0KLSAgICAg
ICAgZm9yIChpID0gMDsgaSA8IE1BWF9OUl9DT05TT0xFUzsgaSsrKSB7DQor
CWZvciAoaSA9IDA7IGkgPCBNQVhfTlJfQ09OU09MRVM7IGkrKykgew0KIAkJ
a2JkX3RhYmxlW2ldLmxlZGZsYWdzdGF0ZSA9IEtCRF9ERUZMRURTOw0KIAkJ
a2JkX3RhYmxlW2ldLmRlZmF1bHRfbGVkZmxhZ3N0YXRlID0gS0JEX0RFRkxF
RFM7DQogCQlrYmRfdGFibGVbaV0ubGVkbW9kZSA9IExFRF9TSE9XX0ZMQUdT
Ow0KZGlmZiAtWCBkb250ZGlmZiAtcHJ1TiBsaW51eC0yLjYuMjIvZHJpdmVy
cy9pbnB1dC9rZXlib2FyZC9LY29uZmlnIGxpbnV4LTIuNi4yMi5jaGFuZ2Vk
L2RyaXZlcnMvaW5wdXQva2V5Ym9hcmQvS2NvbmZpZw0KLS0tIGxpbnV4LTIu
Ni4yMi9kcml2ZXJzL2lucHV0L2tleWJvYXJkL0tjb25maWcJMjAwNy0wNy0x
MSAyMzoyNjowMS4wMDAwMDAwMDAgKzAyMDANCisrKyBsaW51eC0yLjYuMjIu
Y2hhbmdlZC9kcml2ZXJzL2lucHV0L2tleWJvYXJkL0tjb25maWcJMjAwNy0w
Ny0xMSAyMzoyNzozOS4wMDAwMDAwMDAgKzAyMDANCkBAIC0xMiw2ICsxMiwx
NyBAQCBtZW51Y29uZmlnIElOUFVUX0tFWUJPQVJEDQogDQogaWYgSU5QVVRf
S0VZQk9BUkQNCiANCitjb25maWcgS0JEX0RFRkxFRFNfUENCSU9TDQorCWJv
b2wgIkVuYWJsZSBOdW0tTG9jayBiYXNlZCBvbiBCSU9TIHNldHRpbmdzIg0K
KwlkZXBlbmRzIG9uIFg4Nl9QQyAmJiBFWFBFUklNRU5UQUwNCisJaGVscA0K
KwkgIFR1cm5zIG9uIE51bWxvY2sgZGVwZW5kaW5nIG9uIHRoZSBCSU9TIHNl
dHRpbmdzLg0KKwkgIFRoaXMgd29ya3MgYnkgcmVhZGluZyB0aGUgQklPUyBk
YXRhIGFyZWEgYXMgZGVmaW5lZCBmb3IgSUJNIFBDcyAoMTk4MSkuDQorDQor
CSAgSWYgeW91IGhhdmUgYW4gYWx0ZXJuYXRpdmUgZmlybXdhcmUgbGlrZSBP
cGVuRmlybXdhcmUgb3IgTGludXhCaW9zLA0KKwkgIHRoaXMgZmxhZyBtaWdo
dCBub3QgYmUgc2V0IGNvcnJlY3RseSwgd2hpY2ggcmVzdWx0cyBpbiBhIHJh
bmRvbSBzdGF0ZQ0KKwkgIG9mIHRoZSBOdW1sb2NrIGtleS4NCisNCiBjb25m
aWcgS0VZQk9BUkRfQVRLQkQNCiAJdHJpc3RhdGUgIkFUIGtleWJvYXJkIiBp
ZiBFTUJFRERFRCB8fCAhWDg2X1BDDQogCWRlZmF1bHQgeQ0K

---1463760633-152122169-1184192005=:2432--
