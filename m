Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbYCHTTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbYCHTTm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 14:19:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbYCHTTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 14:19:34 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:40125 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755275AbYCHTTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 14:19:34 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=J5vUNgWmKKNy0AbdRG35KSR9HQLXwmkWJ4mYy01iKh7aH6S/QJR2pT5hT9SU+LD8/mHLrk16fvcQ8o1k/4kAIiToxVL4qmlWGrGYdjKd/1mWLFMQWopux9nHUYrLclgMvuZHNa9/j1dvajuncw7L0Grciwz03U++3QNQLOB+ZlU=  ;
X-YMail-OSG: XChsg5YVM1mE5ZF4qsFx2dt.qVzg9h3IATsutU.ZHJ7GHNaKdMI4Ru3VAduakK.QU3uu5fof5g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2.6.24-git] rtc: avoid legacy drivers with generic framework
Date: Sat, 8 Mar 2008 11:19:29 -0800
User-Agent: KMail/1.9.6
Cc: rtc-linux@googlegroups.com, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>
References: <200802101208.20593.david-b@pacbell.net>
In-Reply-To: <200802101208.20593.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803081119.31053.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 February 2008, David Brownell wrote:
> Kconfig tweaks to help reduce RTC configuration bugs, by avoiding
> legacy RTC drivers when the generic RTC framework is enabled:
> 
>  - If rtc-cmos is selected, disable the legacy rtc driver;
> 
>  - When using generic RTC on x86, enable rtc-cmos by default;
> 
>  - In the old "chardev RTC" section of Kconfig, add a comment
>    warning people off these (seven) legacy RTC drivers when
>    the generic framework is in use.
> 
> People can still use the legacy drivers if they want (or need) to.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> 	...

Here's an update to that patch, which is in MMOTM with the name

	rtc-avoid-legacy-drivers-with-generic-framework.patch

=======
This is a harsher fix for the problems of trying to make legacy
RTCs coexist with the generic RTC framework:  Just Don't Do It.

The legacy drivers are not geared towards coexistence; they
never had a reason to try.  So rather than accumulating more
and more special cases, and gently nudging users away from the
old code, make it be an either/or choice.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/char/Kconfig |   12 ++++++++----
 drivers/rtc/Kconfig  |    4 ----
 2 files changed, 8 insertions(+), 8 deletions(-)

--- g26.orig/drivers/char/Kconfig	2008-03-07 13:28:53.000000000 -0800
+++ g26/drivers/char/Kconfig	2008-03-07 13:35:07.000000000 -0800
@@ -704,14 +704,16 @@ config NVRAM
 	  To compile this driver as a module, choose M here: the
 	  module will be called nvram.
 
-comment "Avoid any legacy RTC drivers you may see here"
-	depends on RTC_LIB
+#
+# These legacy RTC drivers just cause too many conflicts with the generic
+# RTC framework ... let's not even try to coexist any more.
+#
+if RTC_LIB=n
 
 config RTC
 	tristate "Enhanced Real Time Clock Support"
 	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV \
-			&& !ARM && !SUPERH && !S390 \
-			&& RTC_DRV_CMOS=n
+			&& !ARM && !SUPERH && !S390
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
@@ -817,6 +819,8 @@ config DS1302
 	  will get access to the real time clock (or hardware clock) built
 	  into your computer.
 
+endif # RTC_LIB
+
 config COBALT_LCD
 	bool "Support for Cobalt LCD"
 	depends on MIPS_COBALT
--- g26.orig/drivers/rtc/Kconfig	2008-03-07 13:28:53.000000000 -0800
+++ g26/drivers/rtc/Kconfig	2008-03-07 13:31:28.000000000 -0800
@@ -20,10 +20,6 @@ menuconfig RTC_CLASS
 
 if RTC_CLASS
 
-if GEN_RTC || RTC
-comment "Conflicting RTC option has been selected, check GEN_RTC and RTC"
-endif
-
 config RTC_HCTOSYS
 	bool "Set system time from RTC on startup and resume"
 	depends on RTC_CLASS = y
