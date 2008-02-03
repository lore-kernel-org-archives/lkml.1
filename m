Return-Path: <linux-kernel-owner+w=401wt.eu-S935956AbYBCHSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935956AbYBCHSU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 02:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756747AbYBCHSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 02:18:08 -0500
Received: from smtp104.sbc.mail.mud.yahoo.com ([68.142.198.203]:21645 "HELO
	smtp104.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754913AbYBCHSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 02:18:07 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MW+UCnlkTDWfpxSYktackrz6DWZYCRmzLtxr9+vc7Ddv3br7CaB79wbIJzYDzGYIytIuaA/UQ31zWD6uPkSqi7yOCNGB8L35vpKWN5wXHpGZCI7R6jwRQI+Z2U9o6AoOlK0LBRakJGyvP2MMg4Et5NaBrZkemdeecljWc4f+Wik=  ;
X-YMail-OSG: MOQgo9AVM1kGZ2.0cJp2.072ARjkZQamUsA28TUbq21h3GKCjT0c21Tg40jjhH3sAO_Sr0DV2A--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] sleepy linux self-test
Date: Sat, 2 Feb 2008 23:18:02 -0800
User-Agent: KMail/1.9.6
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>
References: <20080130131748.GA3796@elf.ucw.cz> <20080203050537.GA18942@elte.hu> <20080203051425.GA20740@elte.hu>
In-Reply-To: <20080203051425.GA20740@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802022318.03597.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 February 2008, Ingo Molnar wrote:
> > [   23.509562] Calling initcall 0xc0c49e00: be_sleepy+0x0/0x170()
> > [   23.515837] PM: no wakelarm-capable RTC
> > [   23.517562] initcall 0xc0c49e00: be_sleepy+0x0/0x170() returned 0.

Because CONFIG_RTC_DRV_CMOS was not configured, though
you had several other RTC drivers ready.

> # CONFIG_RTC_DRV_CMOS is not set

Then later you had that enabled, but you also had the
legacy driver enabled:

> CONFIG_RTC=y

So that was the driver which succesfully bound to the RTC
(since it's probed first) and prevented the more generic
code from kicking in.


Nobody has yet submitted a patch to help arbitrate between the
legacy and "newfangled" RTC drivers.  The general "how to Kconfig"
policy has been to expect a lot (too much?) from users, but this
type of annoyance is too common.

Maybe we need something to more actively avoid the "two drivers"
on PC hardware ... like the appended.  (The "comment" is there as
a reminder to folk who still look to that menu for RTC stuff.)

- Dave


--- g26.orig/drivers/char/Kconfig
+++ g26/drivers/char/Kconfig
@@ -715,9 +715,12 @@ config NVRAM
 	  To compile this driver as a module, choose M here: the
 	  module will be called nvram.
 
+comment "You are using the RTC framework, not the legacy CMOS RTC driver"
+	depends on RTC_DRV_CMOS
+
 config RTC
 	tristate "Enhanced Real Time Clock Support"
-	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV && !ARM && !SUPERH && !S390
+	depends on !PPC && !PARISC && !IA64 && !M68K && !SPARC && !FRV && !ARM && !SUPERH && !S390 && !RTC_DRV_CMOS
 	---help---
 	  If you say Y here and create a character special file /dev/rtc with
 	  major number 10 and minor number 135 using mknod ("man mknod"), you
--- g26.orig/drivers/rtc/Kconfig
+++ g26/drivers/rtc/Kconfig
@@ -281,6 +281,7 @@ comment "Platform RTC drivers"
 config RTC_DRV_CMOS
 	tristate "PC-style 'CMOS'"
 	depends on X86 || ALPHA || ARM || M32R || ATARI || PPC || MIPS
+	default y if X86
 	help
 	  Say "yes" here to get direct support for the real time clock
 	  found in every PC or ACPI-based system, and some other boards.
 
