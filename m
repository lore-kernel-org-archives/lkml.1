Return-Path: <linux-kernel-owner+w=401wt.eu-S1760707AbYDAPco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760707AbYDAPco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 11:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762652AbYDAPbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 11:31:45 -0400
Received: from 124-193-dsl.kielnet.net ([89.27.193.124]:42722 "EHLO
	einstein.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762643AbYDAPbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 11:31:44 -0400
X-Greylist: delayed 1518 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Apr 2008 11:31:43 EDT
Message-ID: <47F24F6D.6000603@inbox.com>
Date: Tue, 01 Apr 2008 17:06:21 +0200
From: Oliver Schuster <oliver.s@inbox.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20080213)
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: Oliver Schuster <olivers137@aol.com>, Andrew Paprocki <andrew@ishiboo.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH][WATCHDOG] v2.6.25-rc7: it8712f_wdt.c contains an error -
 was Re: [WATCHDOG] v2.5.25-rc patches
References: <20080310201419.GA7623@infomag.infomag.iguana.be> <47D6CC23.5020202@aol.com> <20080311210232.GE7505@infomag.infomag.iguana.be>
In-Reply-To: <20080311210232.GE7505@infomag.infomag.iguana.be>
Content-Type: multipart/mixed;
 boundary="------------020908090007000609090308"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020908090007000609090308
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

i've mailed before to lkml and Andrew Paprocki (2008-03-12) directly.
But the original patch wasn't changed. Here's a patch to correct the
error.

Description of the error:
By introducing the support of 16 Bit timer values for later it8712 an
error was made. The value is stored through superio_outw() which cause,
that the upper Byte is in the Register called "Watch Dog Timer Time-Out
Value (LSB) Register" and the lower in "Watch Dog Timer Time-Out Value
(MSB) Register".

A common value is 60: stored this way the watchdog timer runs out
in 4h 16mins. In case of a deadlocked server this is a long time to
wait, before the service comes back!

Regards,
Oliver

Wim Van Sebroeck schrieb:
> Hi Oliver,
> 
>> this patch can cause serious problems in the case, that someone use it 
>> with an it8712 rev. 8 and above.
> ...
>> Your patch changes it8712f_wdt.c in function t8712f_wdt_update_margin():
>>
>>> -	superio_outb((margin > 255) ? (margin / 60) : margin, WDT_TIMEOUT);
>>> +	if (revision >= 0x08)
>>> +		superio_outw(units, WDT_TIMEOUT);
>>> +	else
>>> +		superio_outb(units, WDT_TIMEOUT);
>> but here you can't use superio_outw, because the bytes are swapped 
>> --historical reason.
>>
>> I suggest to substitute
>> 	superio_outw(units, WDT_TIMEOUT);
>> with
>> 	superio_outb(units >> 8, WDT_TIMEOUT + 1);
>> 	superio_outb(units, WDT_TIMEOUT);
>>
> 
> Can you keep "Andrew Paprocki" <andrew@ishiboo.com> in the loop?
> Can you also create a patch and test it together with Andrew?
> We need to make sure that we fix this before 2.6.25 is there.
> 
> Thanks,
> Wim



--------------020908090007000609090308
Content-Type: text/x-patch;
 name="2.6.25-rc7-it8712f_wdt.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.6.25-rc7-it8712f_wdt.patch"

This patch corrects an error in the driver it8712f_wdt

Signed-off-by: Oliver Schuster <olivers137@aol.com>

===

diff -urP linux-2.6.25-rc7/drivers/watchdog/it8712f_wdt.c linux-2.6.25-rc7-aaa/drivers/watchdog/it8712f_wdt.c
--- linux-2.6.25-rc7/drivers/watchdog/it8712f_wdt.c	2008-03-26 02:38:14.000000000 +0100
+++ linux-2.6.25-rc7-aaa/drivers/watchdog/it8712f_wdt.c	2008-04-01 16:45:22.396931807 +0200
@@ -111,15 +111,6 @@
 	return val;
 }
 
-static void
-superio_outw(int val, int reg)
-{
-	outb(reg++, REG);
-	outb((val >> 8) & 0xff, VAL);
-	outb(reg, REG);
-	outb(val & 0xff, VAL);
-}
-
 static inline void
 superio_select(int ldn)
 {
@@ -170,9 +161,8 @@
 	superio_outb(config, WDT_CONFIG);
 
 	if (revision >= 0x08)
-		superio_outw(units, WDT_TIMEOUT);
-	else
-		superio_outb(units, WDT_TIMEOUT);
+		superio_outb(units >> 8, WDT_TIMEOUT + 1);
+	superio_outb(units, WDT_TIMEOUT);
 }
 
 static int

--------------020908090007000609090308--
