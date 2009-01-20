Return-Path: <linux-kernel-owner+w=401wt.eu-S1760891AbZATXZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760891AbZATXZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 18:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757605AbZATXY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 18:24:59 -0500
Received: from smtp-out.google.com ([216.239.45.13]:16717 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757596AbZATXY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 18:24:57 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:content-type:
	content-transfer-encoding:x-gmailtapped-by:x-gmailtapped;
	b=E1eP5ONyuDYt0XatxCOZHNsOmSbkaofSrV9Cy9YGEpXG4Io5bxj8L3aAHpqJbkUGi
	iIyUaZMkstWCbYG2XKQcw==
MIME-Version: 1.0
Date: Tue, 20 Jan 2009 15:24:50 -0800
Message-ID: <ee007d8e0901201524s3be5e8e2m7d1d4026c078a87@mail.gmail.com>
Subject: tty_tiocmset() masks out TIOCM_RI and TIOCM_CD, which breaks rfcomm
From: Adam Bliss <abliss@google.com>
To: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Russell King <rmk@flint.arm.linux.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-GMailtapped-By: 172.28.16.76
X-GMailtapped: abliss
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello. This is my first email to lkml so please be gentle.

In drivers/char/tty_io.c:2477, the tty_tiocmset() function masks out
all bits except these:

   TIOCM_DTR|TIOCM_RTS|TIOCM_OUT1|TIOCM_OUT2|TIOCM_LOOP

[1] I do not understand the purpose of this masking; it seems to have
existed as long as tty_tiocmset() [2], though TIOCM_LOOP was added to
the whitelist later [3].  I wonder if it would be appropriate to add
TIOCM_CD and TIOCM_RI to the list?  Like this:

--- old/drivers/char/tty_io.c       2009-01-20 14:35:58.000000000 -0800
+++ new/drivers/char/tty_io.c       2009-01-20 14:39:43.000000000 -0800
@@ -2474,8 +2474,8 @@
                clear = ~val;
                break;
        }
-       set &= TIOCM_DTR|TIOCM_RTS|TIOCM_OUT1|TIOCM_OUT2|TIOCM_LOOP;
-       clear &= TIOCM_DTR|TIOCM_RTS|TIOCM_OUT1|TIOCM_OUT2|TIOCM_LOOP;
+       set &= TIOCM_DTR|TIOCM_RTS|TIOCM_CD|TIOCM_RI|TIOCM_OUT1|TIOCM_OUT2|TIOCM_LOOP;
+       clear &=
TIOCM_DTR|TIOCM_RTS|TIOCM_CD|TIOCM_RI|TIOCM_OUT1|TIOCM_OUT2|TIOCM_LOOP;
        return tty->ops->tiocmset(tty, file, set, clear);
 }


Traditionally, RI (Ring Indicator) and CD (Carrier Detect) were
typically used for DCE -> DTE communication, so perhaps this is why
they were left off initially.  However, when Bluetooth is used to
create a rfcomm serial connection, there is no real distinction
between DTE and DCE, and these signals can be used in either
direction.  The rfcomm driver correctly handles these signals in its
tiocmset function (see net/blutooth/rfcomm/tty.c lines 1033-1036 [4]),
but it can never receive these bits from the tty subsystem because of
the mask above.

My use case is for a linux desktop to communicate with an NXP BGB203
Bluetooth serial chip.  The chip provides outputs for the RI and CD
signals, but I cannot find any way to send these signals through the
stock rfcomm tty driver.

It might be appropriate to include other signals as well, such as CTS
and DSR.  However, these do not seem necessary for rfcomm, since the
rfcomm driver will interpret a DTR as a DSR and an RTS as a CTS.  My
main concern is for RI and CD, for which there does not seem to be a
workaround.

(Before asking this question I have consulted ESR's "How To Ask
Questions".  Google searches for TIOCM_RI have not turned up any
information on this issue, in the lkml archives or elsewhere.  The
initial commit of tiocmset does not explain the reasoning behind the
mask [2], so I can't determine if it's inappropriate to include RI and
CD.  I initially posted this question to the linux-bluetooth mailing
list [5] but Marcel Holtmann advised me to ask again here, for which I
thank him.  He suggested I include Alan Cox, and I am including
Russell King because he seems to have written the mask in the first
place [2].)

Thanks in advance,
--Adam Bliss

References:
1: <http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=drivers/char/tty_io.c;hb=fc6f6238226e6d1248e1967eae2bf556eaf3ac17>
or http://a.gd/c4c55a
2: <http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=commitdiff;h=3bbb0896d422a2c5d5c6f8eb584e9bda3d3277a5>
or http://a.gd/283b12
3: <http://git.kernel.org/?p=linux/kernel/git/tglx/history.git;a=blobdiff;f=drivers/char/tty_io.c;h=357c331adc8d61477092f002e6e3ed23838e1d5a;hp=b82dd71948b8b3fff0f8996b78ae09fb162de82b;hb=276fccf5526400db75752ed7ce8cbf8bb68591ca;hpb=2c0bec026ccb24b6a8f31138471b79f5efcb0168>
or http://a.gd/da5064
4: <http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=net/bluetooth/rfcomm/tty.c;hb=09c7d8293a2d1317d16ef4ddb9f6dd2553d0694e>
or http://a.gd/ec3a81
5: <http://article.gmane.org/gmane.linux.bluez.kernel/1229> or
http://a.gd/2e7a0a
