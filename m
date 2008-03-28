Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbYC1Jt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbYC1Jt4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 05:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbYC1Jtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 05:49:46 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:46111 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751661AbYC1Jto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 05:49:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TOdnlz9os/q61IeOWfiyxETCo6zpC7XIZfwhP8+uNuvHfDTCqmpmGeY7mLzWcvPEMzb/kdbJ0eta3IY8Hd0JrwD5JZ9U8yJ/ZSXToIJiVhMBm8VmY3YNl4NCBYpzjZHkHuKMxj8KOo7ENMP1OCvyVPaG1pJzQXL3K6Mwbej7mWs=  ;
X-YMail-OSG: ybrd0TsVM1lYmgbu0_okWr2czLL0N1bfB0NOsTCo1qvhqGVu_Ayh1OQEcvf9j7tv3wNLuNSt5g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc7: Ugh.
Date: Fri, 28 Mar 2008 02:49:41 -0700
User-Agent: KMail/1.9.6
Cc: Mark Lord <lkml@rtr.ca>, David Miller <davem@davemloft.net>,
       jkosina@suse.cz, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, pavel@suse.cz, akpm@linux-foundation.org,
       rtc-linux@googlegroups.com
References: <20080327160700.GB828@suse.de> <200803272358.20081.david-b@pacbell.net> <20080328091645.GI21413@elte.hu>
In-Reply-To: <20080328091645.GI21413@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803280249.42193.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 March 2008, Ingo Molnar wrote:
> > > Could somebody please fix the RTC mess in kconfig now ?
> > 
> > My version has been sitting in MM for a while now.
> 
> could you please provide an URL or the patch itself so that others who 
> hit this issue and read this thread can apply the fix?

I merged the two patches (gentle, then harsh) so the result is
smaller.  Here you go.

- dave


========== CUT HERE
Prevent the most significant RTC configuration problems:

 - If the new RTC framework is enabled, don't allow any of the
   legacy drivers to be configured.

 - When using generic RTC on x86, enable rtc-cmos by default.

It seems too many people are used to enabling a legacy RTC despite 
the Kconfig help/comments; the gentle approach hasn't worked.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/char/Kconfig |    8 ++++++++
 drivers/rtc/Kconfig  |    5 +----
 2 files changed, 9 insertions(+), 4 deletions(-)

--- linux-2.6.orig/drivers/char/Kconfig	2008-03-28 02:35:58.000000000 -0700
+++ linux-2.6/drivers/char/Kconfig	2008-03-28 02:39:17.000000000 -0700
@@ -704,6 +704,12 @@ config NVRAM
 	  To compile this driver as a module, choose M here: the
 	  module will be called nvram.
 
+#
+# These legacy RTC drivers just cause too many conflicts with the generic
+# RTC framework ... let's not even try to coexist any more.
+#
+if RTC_LIB=n
+
 config RTC
 	tristate "Enhanced Real Time Clock Support"
 	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV && !ARM && !SUPERH && !S390
@@ -812,6 +818,8 @@ config DS1302
 	  will get access to the real time clock (or hardware clock) built
 	  into your computer.
 
+endif # RTC_LIB
+
 config COBALT_LCD
 	bool "Support for Cobalt LCD"
 	depends on MIPS_COBALT
--- linux-2.6.orig/drivers/rtc/Kconfig	2008-03-28 02:35:58.000000000 -0700
+++ linux-2.6/drivers/rtc/Kconfig	2008-03-28 02:39:12.000000000 -0700
@@ -20,10 +20,6 @@ menuconfig RTC_CLASS
 
 if RTC_CLASS
 
-if GEN_RTC || RTC
-comment "Conflicting RTC option has been selected, check GEN_RTC and RTC"
-endif
-
 config RTC_HCTOSYS
 	bool "Set system time from RTC on startup and resume"
 	depends on RTC_CLASS = y
@@ -303,6 +299,7 @@ comment "Platform RTC drivers"
 config RTC_DRV_CMOS
 	tristate "PC-style 'CMOS'"
 	depends on X86 || ALPHA || ARM || M32R || ATARI || PPC || MIPS
+	default y if X86
 	help
 	  Say "yes" here to get direct support for the real time clock
 	  found in every PC or ACPI-based system, and some other boards.
