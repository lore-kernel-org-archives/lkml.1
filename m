Return-Path: <linux-kernel-owner+w=401wt.eu-S1752889AbZJ1Lit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbZJ1Lit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 07:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbZJ1Lir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 07:38:47 -0400
Received: from aa002msb.fastweb.it ([85.18.95.81]:38085 "EHLO
	aa002msb.fastweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbZJ1Liq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 07:38:46 -0400
Message-ID: <4AE82D17.6040900@evidence.eu.com>
Date: Wed, 28 Oct 2009 12:37:59 +0100
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org, rmk+kernel@arm.linux.org.uk,
       linux-arm-kernel@lists.arm.linux.org.uk, akpm@linux-foundation.org
Subject: Re: [PATCH][RE-SUBMIT] Default setting of the ARM_UNWIND option
References: <4AD73DA4.4050006@evidence.eu.com>	 <1255620333.10164.77.camel@pc1117.cambridge.arm.com>	 <4AE55D83.7080608@evidence.eu.com> <1256555452.5282.21.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1256555452.5282.21.camel@pc1117.cambridge.arm.com>
Content-Type: multipart/mixed;
 boundary="------------040300070102060505080405"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040300070102060505080405
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Catalin Marinas ha scritto:
> On Mon, 2009-10-26 at 09:27 +0100, Claudio Scordino wrote:
>   
>> My ARM board hanged at the initial "Calibrating delay loop" message.
>>
>> After some inspection, I found out the problem to be with commit
>> adf8b37bafc1495393201a2ae4235846371870d0. This commit introduces stack
>> unwinding for ARM, and set it enabled by default. However, it seems to
>> not work with buggy or not-EABI compilers.
>>
>> My suggestion is to keep the feature (which is fine) but change the
>> default setting of the option (see the attached patch).
>>     
>
> The option still depends on EXPERIMENTAL, so you get ARM_UNWIND on when
> enabling that.
>
> I'm more in favour of a #warning on #error in the unwind.c file based on
> the compiler version rather than not having it on by default. The reason
> is that people reported performance improvements when compiling the
> kernel without frame pointers.
>   

[Sorry, I sent the wrong patch... This is the new one.]

This solution is fine too (even if I still think that changing the
default setting is better).

Please, consider the patch in attachment: is it like you would have it ?

BTW, do we have any list of buggy or not-EABI versions of the gcc compiler ?

Many thanks,

             Claudio



--------------040300070102060505080405
Content-Type: text/x-patch;
 name="0001-Some-warnings-when-compiling-ARM-unwind-support-with.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Some-warnings-when-compiling-ARM-unwind-support-with.pa";
 filename*1="tch"

From: Claudio Scordino <claudio@evidence.eu.com>
Date: Mon, 26 Oct 2009 17:13:18 +0100
Subject: [PATCH 1/1] Some warnings when compiling ARM unwind support with a buggy or not-EABI compiler.

ARM unwind support is known to build only with EABI and not-buggy compilers.
Now we check the compiler and raise a #warning in case of wrong compiler.

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
---
 arch/arm/kernel/unwind.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
index 39baf11..47345c1 100644
--- a/arch/arm/kernel/unwind.c
+++ b/arch/arm/kernel/unwind.c
@@ -26,6 +26,15 @@
  * http://infocenter.arm.com/help/topic/com.arm.doc.subset.swdev.abi/index.html
  */
 
+#if !defined (__ARM_EABI__)
+#warning Your compiler does not have EABI support.
+#warning    ARM unwind support it is known to compile only on EABI compilers.
+#warning    Change compiler or disable ARM_UNWIND option.
+#elif (__GNUC__ == 4 && __GNUC_MINOR__ == 2)
+#warning Your compiler is too buggy; it is known to not compile ARM unwind support.
+#warning    Change compiler or disable ARM_UNWIND option.
+#endif
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/module.h>
-- 
1.6.0.4


--------------040300070102060505080405--
