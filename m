Return-Path: <linux-kernel-owner+w=401wt.eu-S1756293AbYBJUmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293AbYBJUmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 15:42:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbYBJUlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 15:41:55 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:29412 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755288AbYBJUlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 15:41:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bYRcCIB6xh685dkGBBvzoFfG0q6UT5z5uAEAV7w2kznTBfCz8J319uO1plH5tw958oyMQIqd/qx/T346xlHSkg8nQ8acwybfKI/UgPUBkBPci15rqfPy3yzEUENXPm4zMwSCMlnGxOD1HslaQMn5v4j9QzM8gqmL7UXlVUgNlyc=  ;
X-YMail-OSG: MsjJBGQVM1lDccWhibJ.ddWFLtdYL9YkpfGtfB60SLHR7agii9BLBBHWdny_u_72af4XQyxURA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.24-git] rtc: avoid legacy drivers with generic framework
Date: Sun, 10 Feb 2008 12:08:19 -0800
User-Agent: KMail/1.9.6
Cc: rtc-linux@googlegroups.com, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802101208.20593.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig tweaks to help reduce RTC configuration bugs, by avoiding
legacy RTC drivers when the generic RTC framework is enabled:

 - If rtc-cmos is selected, disable the legacy rtc driver;

 - When using generic RTC on x86, enable rtc-cmos by default;

 - In the old "chardev RTC" section of Kconfig, add a comment
   warning people off these (seven) legacy RTC drivers when
   the generic framework is in use.

People can still use the legacy drivers if they want (or need) to.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
This doesn't fix the broken dependencies for the legacy "CMOS" RTC
driver.  Ideally it would be a full list of platforms where it works,
not a partial list of ones where it won't.  Or better yet, it would
depend on a "HAVE_CMOS_RTC" flag defined by various platforms ...
surely there's a Kconfig style guideline lurking there.

 drivers/char/Kconfig |    6 +++++-
 drivers/rtc/Kconfig  |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

--- g26.orig/drivers/char/Kconfig	2008-02-10 11:16:04.000000000 -0800
+++ g26/drivers/char/Kconfig	2008-02-10 11:30:21.000000000 -0800
@@ -704,9 +704,14 @@ config NVRAM
 	  To compile this driver as a module, choose M here: the
 	  module will be called nvram.
 
+comment "Avoid any legacy RTC drivers you may see here"
+	depends on RTC_LIB
+
 config RTC
 	tristate "Enhanced Real Time Clock Support"
-	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV && !ARM && !SUPERH && !S390
+	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV \
+			&& !ARM && !SUPERH && !S390 \
+			&& RTC_DRV_CMOS=n
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
--- g26.orig/drivers/rtc/Kconfig	2008-02-10 11:16:04.000000000 -0800
+++ g26/drivers/rtc/Kconfig	2008-02-10 11:19:00.000000000 -0800
@@ -294,6 +294,7 @@ comment "Platform RTC drivers"
 config RTC_DRV_CMOS
 	tristate "PC-style 'CMOS'"
 	depends on X86 || ALPHA || ARM || M32R || ATARI || PPC || MIPS
+	default y if X86
 	help
 	  Say "yes" here to get direct support for the real time clock
 	  found in every PC or ACPI-based system, and some other boards.
