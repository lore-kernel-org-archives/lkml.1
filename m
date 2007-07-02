Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbXGBNvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbXGBNvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 09:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbXGBNvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 09:51:17 -0400
Received: from mail.windriver.com ([147.11.1.11]:33808 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbXGBNvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 09:51:16 -0400
Message-ID: <4689025C.8000001@windriver.com>
Date: Mon, 02 Jul 2007 08:49:16 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: kgdb-bugreport@lists.sourceforge.net,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Andrew Morton <akpm@linux-foundation.org>, paulus@samba.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <200706291432.10128.m.kozlowski@tuxland.pl> <4685010C.4000108@ru.mvista.com>
In-Reply-To: <4685010C.4000108@ru.mvista.com>
Content-Type: multipart/mixed;
 boundary="------------070207060901030309020002"
X-OriginalArrivalTime: 02 Jul 2007 13:49:17.0494 (UTC) FILETIME=[C8A58D60:01C7BCAF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070207060901030309020002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Sergei Shtylyov wrote:
> Hello.
>
> Mariusz Kozlowski wrote:
>
>   
>> 	allmodconfig on powerpc (iMac g3) fails due to
>> git-kgdb.patch. allmodconfig defaults should be changed?
>>     
>
>   
>>   CC      arch/powerpc/kernel/kgdb.o
>> arch/powerpc/kernel/kgdb.c:485:2: error: #error Both XMON and KGDB selected 
>> in .config. Unselect one of them.
>> make[1]: *** [arch/powerpc/kernel/kgdb.o] Blad 1
>> make: *** [arch/powerpc/kernel] Blad 2
>>     
>
>     I'm not sure if this will work out but maybe it's worth to disable XMON if 
> KGDB is selected, like this?
>
> config XMON
> 	bool "Include xmon kernel debugger"
> 	depends on DEBUGGER && !KGDB
>
>   

It did not seem that you can make a radio button / multi-select kernel 
config option unless the options are in the same Kconfig file.  Given 
that xmon and kgdb are mutually exclusive at the moment.

What Sergei mentioned is the fix that needs to be used for the time being. 

Attached is the patch I put in the for_mm branch in the linux-2.6-kgdb 
git tree.

Jason.



--------------070207060901030309020002
Content-Type: text/plain;
 name="xmon_or_kgdb.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xmon_or_kgdb.patch"

xmon_or_kgdb.patch

From: Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH] Turn off xmon if kgdb is active on ppc and powerpc

Xmon and kgdb are mutuall exclusive at the moment so xmon should be
turned off in the kernel config options if kgdb selected.  The case with "make allmodconfig" was failing and this patch addresses the problem.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 arch/powerpc/Kconfig.debug |    2 +-
 arch/ppc/Kconfig.debug     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-kgdb/arch/powerpc/Kconfig.debug
===================================================================
--- linux-2.6-kgdb.orig/arch/powerpc/Kconfig.debug
+++ linux-2.6-kgdb/arch/powerpc/Kconfig.debug
@@ -43,7 +43,7 @@ config HCALL_STATS
 
 config XMON
 	bool "Include xmon kernel debugger"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL && !KGDB
 	help
 	  Include in-kernel hooks for the xmon kernel monitor/debugger.
 	  Unless you are intending to debug the kernel, say N here.
Index: linux-2.6-kgdb/arch/ppc/Kconfig.debug
===================================================================
--- linux-2.6-kgdb.orig/arch/ppc/Kconfig.debug
+++ linux-2.6-kgdb/arch/ppc/Kconfig.debug
@@ -4,7 +4,7 @@ source "lib/Kconfig.debug"
 
 config XMON
 	bool "Include xmon kernel debugger"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL && !KGDB
 	help
 	  Include in-kernel hooks for the xmon kernel monitor/debugger.
 	  Unless you are intending to debug the kernel, say N here.

--------------070207060901030309020002--
