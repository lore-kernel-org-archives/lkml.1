Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbXLBIxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbXLBIxu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 03:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbXLBIxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 03:53:42 -0500
Received: from il.qumranet.com ([82.166.9.18]:34777 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927AbXLBIxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 03:53:41 -0500
Message-ID: <4752734A.70903@qumranet.com>
Date: Sun, 02 Dec 2007 10:56:42 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.24-rc3-mm1 make headers_check fails
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>	<4743EB52.1040205@linux.vnet.ibm.com>	<20071120163240.e54beed6.akpm@linux-foundation.org>	<4743EF47.5000203@linux.vnet.ibm.com>	<4743EFF8.9010307@qumranet.com>	<20071121095821.GB1070@uranus.ravnborg.org>	<474401BB.2020204@qumranet.com>	<474405AA.2070608@qumranet.com> <20071127210211.094e9562.akpm@linux-foundation.org>
In-Reply-To: <20071127210211.094e9562.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------090604040905070009030406"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090604040905070009030406
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> On Wed, 21 Nov 2007 12:17:14 +0200 Avi Kivity <avi@qumranet.com> wrote:
>
>   
>> Avi Kivity wrote:
>>     
>>>>>>>   
>>>>>>>               
>>>>>>>> The make headers_check fails,
>>>>>>>>
>>>>>>>>  CHECK   include/linux/usb/gadgetfs.h
>>>>>>>>  CHECK   include/linux/usb/ch9.h
>>>>>>>>  CHECK   include/linux/usb/cdc.h
>>>>>>>>  CHECK   include/linux/usb/audio.h
>>>>>>>>  CHECK   include/linux/kvm.h
>>>>>>>> /root/kernels/linux-2.6.24-rc3/usr/include/linux/kvm.h requires 
>>>>>>>> asm/kvm.h, which does not exist in exported headers
>>>>>>>>                
>>>>>>>>                 
>>>>>>> hm, works for me, on i386 and x86_64.  What's different over there?
>>>>>>>            
>>>>>>>               
>>>>>> Hi Andrew,
>>>>>>
>>>>>> It fails on the powerpc box, with allyesconfig option.
>>>>>>
>>>>>>  
>>>>>>       
>>>>>>             
>>>>> How do we fix this?  Export linux/kvm.h only on x86?  Seems ugly.
>>>>>     
>>>>>           
>>>> Is kvm x86 specific? Then move the .h file to asm-x86.
>>>> Otherwise no good idea...
>>>>
>>>>   
>>>>         
>>> kvm.h is x86 specific today, but will be s390, ppc, ia64, and x86 
>>> specific tomorrow.
>>>
>>> What about having a asm-generic/kvm.h with a nice #error?    would 
>>> that suit?
>>>
>>>       
>> headers_check continues to complain.  Is the only recourse to add 
>> asm/kvm.h for all archs?
>>
>>     
>
> That would work.
>
> Meanwhile my recourse is to drop the kvm tree ;)
>   

Since you put it this way...

I committed the attached (sorry) patch to kvm.git.   Rather than 
touching 2*($NARCH - 1) file, I changed include/linux/Kbuild to only 
export kvm.h if the arch actually supports it.  Currently that's just x86.


-- 
error compiling committee.c: too many arguments to function


--------------090604040905070009030406
Content-Type: text/x-patch;
 name="0001-KVM-Export-include-linux-kvm.h-only-if-ARCH-actual.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-KVM-Export-include-linux-kvm.h-only-if-ARCH-actual.patc";
 filename*1="h"

>From a393444c97f6d7355a6d7d6d7aeb80f1e72472b1 Mon Sep 17 00:00:00 2001
From: Avi Kivity <avi@qumranet.com>
Date: Sun, 2 Dec 2007 10:50:06 +0200
Subject: [PATCH] KVM: Export include/linux/kvm.h only if $ARCH actually supports KVM

Currently, make headers_check barfs due to <asm/kvm.h>, which <linux/kvm.h>
includes, not existing.  Rather than add a zillion <asm/kvm.h>s, export kvm.h
only if the arch actually supports it.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/Kconfig     |    3 +++
 drivers/kvm/Kconfig  |    4 ++--
 include/linux/Kbuild |    2 +-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 368864d..eded44e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -112,6 +112,9 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default X86_64
 
+config ARCH_SUPPORTS_KVM
+	bool
+	default y
 
 
 
diff --git a/drivers/kvm/Kconfig b/drivers/kvm/Kconfig
index 6569206..4086080 100644
--- a/drivers/kvm/Kconfig
+++ b/drivers/kvm/Kconfig
@@ -3,7 +3,7 @@
 #
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
-	depends on X86
+	depends on ARCH_SUPPORTS_KVM || X86
 	default y
 	---help---
 	  Say Y here to get to see options for using your Linux host to run other
@@ -16,7 +16,7 @@ if VIRTUALIZATION
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
-	depends on X86 && EXPERIMENTAL
+	depends on ARCH_SUPPORTS_KVM && EXPERIMENTAL
 	select PREEMPT_NOTIFIERS
 	select ANON_INODES
 	---help---
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 105c5d6..397197f 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -254,7 +254,7 @@ unifdef-y += kd.h
 unifdef-y += kernelcapi.h
 unifdef-y += kernel.h
 unifdef-y += keyboard.h
-unifdef-y += kvm.h
+unifdef-$(CONFIG_ARCH_SUPPORTS_KVM) += kvm.h
 unifdef-y += llc.h
 unifdef-y += loop.h
 unifdef-y += lp.h
-- 
1.5.3


--------------090604040905070009030406--
