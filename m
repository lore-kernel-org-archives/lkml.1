Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbYFWCz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbYFWCz5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 22:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYFWCzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 22:55:49 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:30161 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752479AbYFWCzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 22:55:48 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=45xKX61++ZQuZFLI1zF9kpYIgY8sl7DTbBDzRsiEE/P4Of6oHe8I9bTwZWkc4+74XRIXekk2MkZqocnVzcsRx4QXHyiRGqKoQBPvmIpVpZpXcftg5onQ1toVU2AP6q7mfTQRuzJd18gp+0I6+CL6U5rRvBrU2K23NtxSXlpFpd4=  ;
X-YMail-OSG: EW2W8qIVM1lIxkjIiodm4coeL7NRJIYR88c9leu65Qskldfv8_ihzYy9IdD4lOMCVCOo3dGeEeegD1uhydgCgNIfp6UMzqbuBh1TYGkqURqwtPkqS2GOR8lBrXuct6WC4WD7s0mwralHiFetbG60xHdKSIlXeWCqd4IbogkKJz7Yp7WJWic-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.26-rc7] <linux/bcd.h> space reduction
Date: Sun, 22 Jun 2008 19:54:36 -0700
User-Agent: KMail/1.9.9
Cc: rtc-linux@googlegroups.com
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806221954.37088.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This updates <linux/bcd.h> to define the key routines as static
constant functions, which the macros will then call.

In effect this lets each user of these BCD routines shrink their
codespace, when GCC observes that's a win, by using N function calls
and one copy of the routines, instead of N inlined copies of these
constant functions.

These routines aren't used in speed-critical code.  Almost all callers
are from the RTC framework.  Typical per-driver savings top 200 bytes.
On one RTC driver that's almost a 20% reduction in runtime I-space
footprint; for many, closer to 10%; for rtc-cmos it's about 4%.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 include/linux/bcd.h |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/include/linux/bcd.h	2008-06-21 22:26:14.000000000 -0700
+++ b/include/linux/bcd.h	2008-06-21 22:37:48.000000000 -0700
@@ -10,8 +10,20 @@
 #ifndef _BCD_H
 #define _BCD_H
 
-#define BCD2BIN(val)	(((val) & 0x0f) + ((val)>>4)*10)
-#define BIN2BCD(val)	((((val)/10)<<4) + (val)%10)
+static int __bcd2bin(u8 val) __attribute_const__ __maybe_unused;
+static int __bcd2bin(u8 val)
+{
+	return (val & 0x0f) + (val >> 4) * 10;
+}
+
+static u8 __bin2bcd(unsigned val) __attribute_const__ __maybe_unused;
+static u8 __bin2bcd(unsigned val)
+{
+	return ((val/10) << 4) + val % 10;
+}
+
+#define BCD2BIN(val)	__bcd2bin(val)
+#define BIN2BCD(val)	__bin2bcd(val)
 
 /* backwards compat */
 #define BCD_TO_BIN(val) ((val)=BCD2BIN(val))
