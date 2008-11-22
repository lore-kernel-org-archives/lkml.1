Return-Path: <linux-kernel-owner+w=401wt.eu-S1757029AbYKVWs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029AbYKVWs4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbYKVWss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:48:48 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:23831 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbYKVWsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:48:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=q1iiOdghsQhNJui5v3XLnKKV8dd9MaLx7AxLOPv3Pw1m+0RKjj5k1UVF2R7Mqgeroi
         DUA+NmozQX6d6m2BYhkySuEZ+d2PedBVZNXaKw7PWidXJZJjK3WeOn/p9crByJdMbbb9
         TyFj1xEhT5SQi4ZN2/yaiGteyUTg+WS1k5nCA=
Message-ID: <5b7270f40811221448g33c7889g7684dd876eb4a2ce@mail.gmail.com>
Date: Sat, 22 Nov 2008 23:48:45 +0100
From: "Zoltan Devai" <zdevai@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix PIT lockup on some chipsets when using the PC-Speaker
In-Reply-To: <5b7270f40811021527j26c22d2ana3b5b9c437173989@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5b7270f40811021527j26c22d2ana3b5b9c437173989@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Did not get any attention on the linux-input list, so trying it here.
The ALSA snd-pcsp fix is already merged.

--

There've been reports [1] about the sysem bell causing a hard lockup.
My machine was affected as well: Any speaker output hung the machine
completely, nothing in the logs, no magic sysrq, etc., looked like a
hardware problem.
Had a closer look on the issue, and it turned out that the pcspkr module is
responsible. The cause is the bad setup of Timer 2 in the i8253 controller,
which probably hangs the whole PIT controller.

Intel datasheets [2] state that the timer registers are in an undefined
state after reset and they need to be programmed before enabling the
timer. (And enabling without programming the frequency first doesn't
make sense anyway).

I don't know which chipsets are affected (if not all), it also depends on
the BIOS whether it initializes the timer (e.g. to beep when you start the
machine).

The following patch solved the issue on my ICH6 notebook, couldn't
test it with any others, but should be safe to apply.

I'll also send a patch to the ALSA people for the snd-pcsp version.

Cheers,
Zoltan

[1]
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/146151
https://bugs.launchpad.net/ubuntu/+bug/270790
http://ubuntuforums.org/showthread.php?t=227693
http://bugs.gentoo.org/show_bug.cgi?id=222583
https://bugzilla.redhat.com/show_bug.cgi?id=454225

[2]
http://www.intel.com/assets/pdf/datasheet/252516.pdf
http://www.intel.com/assets/pdf/datasheet/301473.pdf
http://www.intel.com/design/chipsets/datashts/29065503.pdf

------------------

Fix PIT lockup on some chipsets when using the PC-Speaker.

Signed-off-by: Zoltan Devai <zdevai@gmail.com>

--- drivers/input/misc/pcspkr.c
+++ drivers/input/misc/pcspkr.c
@@ -52,13 +52,13 @@
 	spin_lock_irqsave(&i8253_lock, flags);

 	if (count) {
-		/* enable counter 2 */
-		outb_p(inb_p(0x61) | 3, 0x61);
 		/* set command for counter 2, 2 byte write */
 		outb_p(0xB6, 0x43);
 		/* select desired HZ */
 		outb_p(count & 0xff, 0x42);
 		outb((count >> 8) & 0xff, 0x42);
+		/* enable counter 2 */
+		outb_p(inb_p(0x61) | 3, 0x61);
 	} else {
 		/* disable counter 2 */
 		outb(inb_p(0x61) & 0xFC, 0x61);
