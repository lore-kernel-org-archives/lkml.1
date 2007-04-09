Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbXDIPWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbXDIPWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 11:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbXDIPWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 11:22:07 -0400
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.208]:29633 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753436AbXDIPWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 11:22:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JcF00C8N7DOpVTKRzUcoY572B4f/nWZemjeMhNmRHqCoG2mn0h10SjxK2fVCOHb7SqBAQqjCS54B4pXXo+yjUviW/MNh/D11ndnGgrczPiGEnU56epAqwmzMNMrwaqCVtQIjp2fTaJMF72NN9u8ahMwnU4i2HtqbBR94SmjeFnY=  ;
X-YMail-OSG: tLSQGt0VM1m9AnRW6lwPKDXgAJltMW3VMQ6hYOq97uwpHBeXf5pKIT3GoqJg2bFlUoodmJPZlQ--
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.21-rc6] doc: gpio.txt describes open-drain emulation
Date: Mon, 9 Apr 2007 07:09:56 -0700
User-Agent: KMail/1.7.1
Cc: Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704090709.56750.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update the GPIO docs to describe the idiom whereby open drain signals are
emulated by toggling the GPIO direction.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>

--- g26.orig/Documentation/gpio.txt	2007-04-05 20:24:41.000000000 -0700
+++ g26/Documentation/gpio.txt	2007-04-09 07:07:44.000000000 -0700
@@ -27,7 +27,7 @@ The exact capabilities of GPIOs vary bet
   - Output values are writable (high=1, low=0).  Some chips also have
     options about how that value is driven, so that for example only one
     value might be driven ... supporting "wire-OR" and similar schemes
-    for the other value.
+    for the other value (notably, "open drain" signaling).
 
   - Input values are likewise readable (1, 0).  Some chips support readback
     of pins configured as "output", which is very useful in such "wire-OR"
@@ -247,6 +247,35 @@ with gpio_get_value(), for example to in
 when the IRQ is edge-triggered.
 
 
+Emulating Open Drain Signals
+----------------------------
+Sometimes shared signals need to use "open drain" signaling, where only the
+low signal level is actually driven.  (That term applies to CMOS transistors;
+"open collector" is used for TTL.)  A pullup resistor causes the high signal
+level.  This is sometimes called a "wire-AND"; or more practically, from the
+negative logic (low=true) perspective this is a "wire-OR".
+
+One common example of an open drain signal is a shared active-low IRQ line.
+Also, bidirectional data bus signals sometimes use open drain signals.
+
+Some GPIO controllers directly support open drain outputs; many don't.  When
+you need open drain signaling but your hardware doesn't directly support it,
+there's a common idiom you can use to emulate it with any GPIO pin that can
+be used as either an input or an output:
+
+ LOW:	gpio_direction_output(gpio, 0) ... this drives the signal
+	and overrides the pullup.
+
+ HIGH:	gpio_direction_input(gpio) ... this turns off the output,
+	so the pullup (or some other device) controls the signal.
+
+If you are "driving" the signal high but gpio_get_value(gpio) reports a low
+value (after the appropriate rise time passes), you know some other component
+is driving the shared signal low.  That's not necessarily an error.  As one
+common example, that's how I2C clocks are stretched:  a slave that needs a
+slower clock delays the rising edge of SCK, and the I2C master adjusts its
+signaling rate accordingly.
+
 
 What do these conventions omit?
 ===============================
