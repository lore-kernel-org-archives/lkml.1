Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbYDRQ5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbYDRQ5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 12:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYDRQ5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 12:57:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:22317 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbYDRQ53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 12:57:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,678,1199692800"; 
   d="scan'208,223";a="318753492"
Message-ID: <4808D2F2.7030008@linux.intel.com>
Date: Fri, 18 Apr 2008 09:57:22 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: Stack protector build failure (was Re: 2.6.25-mm1: not looking
 good)
References: <20080417160331.b4729f0c.akpm@linux-foundation.org>	<20080417224908.67cec814@laptopd505.fenrus.org>	<20080417231038.72363123.akpm@linux-foundation.org>	<20080418071945.GA18044@elte.hu>	<20080418002858.de236663.akpm@linux-foundation.org> <20080418065806.35c73f96@laptopd505.fenrus.org>
In-Reply-To: <20080418065806.35c73f96@laptopd505.fenrus.org>
Content-Type: multipart/mixed;
 boundary="------------060102040908010107020906"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060102040908010107020906
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Arjan van de Ven wrote:
> On Fri, 18 Apr 2008 00:28:58 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> 
>>> No harm done on a 
>>> perfectly bug-free system - but once a bug happens that SELinux
>>> should have mitigated, the breakage becomes real. Having a
>>> prominent warning is the _minimum_.
>>>
>>> having a build failure would be nice too because this is a build 
>>> environment problem. (not a build warning - warnings can easily be 
>>> missed because on a typical kernel build there's so many false
>>> positives that get emitted by various other warning mechanisms)
>>> Arjan?
>>>
>> Yeah, #error would work too.
> 
> I'm totally fine with that, but I think I need Sam's help on making that happen
> the right way; this is going to need makefile fu L(
> 

ok I found a way that works for me:

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] stackprotector: turn not having the right gcc into an #error

If the user selects the stack-protector config option, but does not have
a gcc that has the right bits enabled (for example because it isn't build
with a glibc that supports TLS, as is common for cross-compilers, but also
because it may be too old), then the runtime test fails right now.

Andrew rightfully points out that this is a condition we can detect at
build time, and we should error out at that point instead.

This patch adds an error message for this scenario. This error accomplishes
two goals
1) the user is informed that the security option he selective isn't available
2) the user has enough info to turn of the CONFIG option that won't work for him,
    and would make the runtime test fail anyway.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
  arch/x86/Makefile |    2 +-
  kernel/panic.c    |    3 +++
  2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 3cff3c8..c3e0eee 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -73,7 +73,7 @@ else

          stackp := $(CONFIG_SHELL) $(srctree)/scripts/gcc-x86_64-has-stack-protector.sh
          stackp-$(CONFIG_CC_STACKPROTECTOR) := $(shell $(stackp) \
-                "$(CC)" -fstack-protector )
+                "$(CC)" "-fstack-protector -DGCC_HAS_SP" )
          stackp-$(CONFIG_CC_STACKPROTECTOR_ALL) += $(shell $(stackp) \
                  "$(CC)" -fstack-protector-all )

diff --git a/kernel/panic.c b/kernel/panic.c
index c92c1e2..7cbcd8e 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -321,6 +321,9 @@ EXPORT_SYMBOL(warn_on_slowpath);

  #ifdef CONFIG_CC_STACKPROTECTOR

+#ifndef GCC_HAS_SP
+#error You have selected the CONFIG_CC_STACKPROTECTOR option, but the gcc used does not support this.
+#endif
  static unsigned long __stack_check_testing;
  /*
   * Self test function for the stack-protector feature.
-- 
1.5.4.5


--------------060102040908010107020906
Content-Type: text/x-patch;
 name="0001-stackprotector-turn-not-having-the-right-gcc-into-a.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-stackprotector-turn-not-having-the-right-gcc-into-a.pat";
 filename*1="ch"

>From 8f6106eceec8d11463164038efb7ffe322054913 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 18 Apr 2008 06:16:45 -0700
Subject: [PATCH] stackprotector: turn not having the right gcc into an #error

If the user selects the stack-protector config option, but does not have
a gcc that has the right bits enabled (for example because it isn't build
with a glibc that supports TLS, as is common for cross-compilers, but also
because it may be too old), then the runtime test fails right now.

Andrew rightfully points out that this is a condition we can detect at
build time, and we should error out at that point instead.

This patch adds an error message for this scenario. This error accomplishes
two goals
1) the user is informed that the security option he selective isn't available
2) the user is suggested to turn of the CONFIG option that won't work for him,
   and would make the runtime test fail anyway.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/Makefile |    2 +-
 kernel/panic.c    |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 3cff3c8..c3e0eee 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -73,7 +73,7 @@ else
 
         stackp := $(CONFIG_SHELL) $(srctree)/scripts/gcc-x86_64-has-stack-protector.sh
         stackp-$(CONFIG_CC_STACKPROTECTOR) := $(shell $(stackp) \
-                "$(CC)" -fstack-protector )
+                "$(CC)" "-fstack-protector -DGCC_HAS_SP" )
         stackp-$(CONFIG_CC_STACKPROTECTOR_ALL) += $(shell $(stackp) \
                 "$(CC)" -fstack-protector-all )
 
diff --git a/kernel/panic.c b/kernel/panic.c
index c92c1e2..7cbcd8e 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -321,6 +321,9 @@ EXPORT_SYMBOL(warn_on_slowpath);
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 
+#ifndef GCC_HAS_SP
+#error You have selected the CONFIG_CC_STACKPROTECTOR option, but the gcc used does not support this.
+#endif
 static unsigned long __stack_check_testing;
 /*
  * Self test function for the stack-protector feature.
-- 
1.5.4.5


--------------060102040908010107020906--
