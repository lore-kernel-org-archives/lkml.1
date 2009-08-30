Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbZH3Uzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbZH3Uzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 16:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbZH3Uzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 16:55:53 -0400
Received: from ns.unixsol.org ([193.110.159.2]:57164 "EHLO ns.unixsol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024AbZH3Uzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 16:55:52 -0400
Message-ID: <4A9AE758.2060106@unixsol.org>
Date: Sun, 30 Aug 2009 23:55:52 +0300
From: Georgi Chorbadzhiyski <gf@unixsol.org>
Organization: Unix Solutions Ltd. (http://unixsol.org)
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@mail.ru>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Henk Vergonet <henk.vergonet@gmail.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, usbb2k-api-dev@nongnu.org
Subject: input: Phone buttons in USB handsets/phones
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys, I'm patching yealink.c to support p4k phone and
I'm wondering what to do about the extra buttons that are
found the phone [1] but are not defined as KEY_xxxxxx in
input.h?

For example the phone that I'm working with have these
buttons that do not have matching definitions in input.h:

  FLASH
  REDIAL
  SPEAKER

for testing purposes I mapped them to f, r and s
but that's probably not what should be done.

So what to do about them?

[1]: http://www.von-phone.com/prodimages/P4K-functions.jpg

Right now mapping looks like this:

+
+/*
+ * USB-P4K button layout:
+ *
+ *        IN   up    OUT
+ *      VOL+           DEL
+ *       VOL- down   DIAL
+ *
+ *       1      2      3
+ *       4      5      6
+ *       7      8      9
+ *       *      0      #
+ *
+ *    HELP     (S)    SEND
+ *      FLASH       REDIAL
+ *
+ * The "up" and "down" keys, are one big key
+ * The (S) is one big green key with speaker picture on it
+ */
+static int map_p4k_to_key(int scancode)
+{
+	switch(scancode) {			/* phone key:	*/
+	case 0x34: return KEY_LEFT;		/*   IN		*/
+	case 0x32: return KEY_UP;		/*   up		*/
+	case 0x10: return KEY_RIGHT;		/*   OUT	*/
+	case 0x30: return KEY_DOWN;		/*   down	*/
+	case 0x31: return KEY_VOLUMEUP;		/*   VOL+	*/
+	case 0x40: return KEY_VOLUMEDOWN;	/*   VOL-	*/
+	case 0x33: return KEY_BACKSPACE;	/*   DEL	*/
+	case 0x00: return KEY_ENTER;		/*   DIAL	*/
+	case 0x21: return KEY_1;		/*   1		*/
+	case 0x11: return KEY_2;		/*   2 		*/
+	case 0x01: return KEY_3;		/*   3		*/
+	case 0x22: return KEY_4;		/*   4		*/
+	case 0x12: return KEY_5;		/*   5		*/
+	case 0x02: return KEY_6;		/*   6		*/
+	case 0x23: return KEY_7;		/*   7		*/
+	case 0x13: return KEY_8;		/*   8		*/
+	case 0x03: return KEY_9;		/*   9		*/
+	case 0x24: return KEY_KPASTERISK; 	/*   *		*/
+	case 0x14: return KEY_0;		/*   0		*/
+	case 0x04: return KEY_LEFTSHIFT |
+			  KEY_3 << 8;		/*   #		*/
+	case 0x05: return KEY_HELP; 		/*   HELP	*/
+	case 0x15: return KEY_F;   		/*   FLASH	*/
+	case 0x20: return KEY_S;  		/*   SPEAKER	*/
+	case 0x25: return KEY_SEND; 		/*   SEND	*/
+	case 0x44: return KEY_R;    		/*   REDIAL	*/
+	}
+	return -EINVAL;
+}

A related question - cm109 driver uses KEY_NUMERIC_xxx constants
but since yealink is an older driver (merged in 2.6.14-rc1) it
returns KEY_0..KEY_9, KPASTERISK and a hack to return #.

Is it a good idea to make yealink return KEY_NUMERIC_xxxx codes
since they are specially designed for numeric keypads (phones).

On one hand this will unify somehow codes returned by cm109
(supports at least 5 different usb phone models) and yealink
(lots of nice usb phones) but on the other hand support for
KEY_NUMERIC_xxx should be added to every application that
right now is working fine with yealink driver (but not cm109).
Right now returning normal 1,2,3,etc makes testing the driver
a lot easier. Just plug the phone and enter some numbers.
In this case KEY_NUMERIC_xxxx codes are PITA.

So I'm a bit stuck at what to do, should I patch yealink
to return NUMERIC_xxx codes or switch cm109 to returning
KEY_1..KEY_9, KEY_ASTERISK, etc?

-- 
Georgi Chorbadzhiyski
http://georgi.unixsol.org/
