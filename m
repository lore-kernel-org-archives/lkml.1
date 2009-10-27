Return-Path: <linux-kernel-owner+w=401wt.eu-S932126AbZJ0IJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbZJ0IJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 04:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932103AbZJ0IJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 04:09:56 -0400
Received: from mx9.orcon.net.nz ([219.88.242.59]:57571 "EHLO mx9.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088AbZJ0IJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 04:09:53 -0400
Message-ID: <4AE6AAD3.3000102@orcon.net.nz>
Date: Tue, 27 Oct 2009 21:09:55 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [alpha] Add minimal support for software performance
 events.
References: <1256545926-6972-1-git-send-email-mcree@orcon.net.nz> <20091026084854.GA26990@elte.hu>
In-Reply-To: <20091026084854.GA26990@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------090208020908000308050607"
X-DSPAM-Check: by mx9.orcon.net.nz on Tue, 27 Oct 2009 21:09:57 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Oct 27 21:09:57 2009
X-DSPAM-Confidence: 0.9945
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090208020908000308050607
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ingo Molnar wrote:
> * Michael Cree <mcree@orcon.net.nz> wrote:
>   
>> In the kernel the patch enables configuration of the perf event 
>> option, adds the perf_event_open syscall, and includes a minimal 
>> architecture specific asm/perf_event.h header file.
>>
>> For the perf tool the patch implements an Alpha specific section
>> in the perf.h header file and adjusts options used in the
>> Makefile to allow compilation on Alpha.  The -Wcast-align gives
>> a "cast increases required alignment of target type" warning for
>> the list_for_each_entry() macro. The -fstack-protector-all
>> option generates a "not supported for this target" warning which
>> with -Werror causes the compiler to abort.
>>
>> Signed-off-by: Michael Cree <mcree@orcon.net.nz>
>> ---
>>  arch/alpha/Kconfig                  |    1 +
>>  arch/alpha/include/asm/perf_event.h |    9 +++++++++
>>  arch/alpha/include/asm/unistd.h     |    3 ++-
>>  arch/alpha/kernel/systbls.S         |    1 +
>>  tools/perf/Makefile                 |    5 ++---
>>  tools/perf/perf.h                   |    6 ++++++
>>  6 files changed, 21 insertions(+), 4 deletions(-)
>>  create mode 100644 arch/alpha/include/asm/perf_event.h
>>     
>
> Nice!
>
> I've picked up the perf.h bit in an independent commit. Is there a tree 
> for Alpha bits?
>   

Not that I know of.  Note also that this patch is on top of the patch 
"alpha: Wire up missing/new syscalls" recently posted by Daniele Calore 
(http://lkml.org/lkml/2009/10/21/99).  Hopefully this and prior patches 
get picked up by the Alpha maintainers.

> This portion:
>   
>> --- a/tools/perf/Makefile
>> +++ b/tools/perf/Makefile
>> @@ -201,7 +200,7 @@ EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wold-style-definition
>>  EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
>>  EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
>>  
>> -CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
>> +CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
>>  LDFLAGS = -lpthread -lrt -lelf -lm
>>  ALL_CFLAGS = $(CFLAGS)
>>  ALL_LDFLAGS = $(LDFLAGS)
>>     
>
> Should be done not by removing the stack-protector build unconditionally 
> - but by auto-testing whether stackprotector is supported by GCC and 
> using it if yes.
>   

Revised patch attached.  It includes a test that the compiler doesn't 
bomb out with -fstack-protector-all and only adds the option to CFLAGS 
if ok.  But I have had to put the test below the definition of the macro 
CC.  This has the side effect of separating the addition of 
-fstack-protector-all from the main definitions of CFLAGS and 
ALL_CFLAGS, and is not ideal in my opinion.  The patch also removes 
-Wcast-align (I forgot to say that in the commit message of the patch).

Michael.



--------------090208020908000308050607
Content-Type: text/x-patch;
 name="0001-Test-fstack-protector-all-compiler-option-for-inclus.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-Test-fstack-protector-all-compiler-option-for-inclus.pa";
 filename*1="tch"

>From 92feeaec19635a10145fa32a2f0077c4ddda5c7d Mon Sep 17 00:00:00 2001
From: Michael Cree <mcree@orcon.net.nz>
Date: Tue, 27 Oct 2009 20:56:27 +1300
Subject: [PATCH] Test -fstack-protector-all compiler option for inclusion in CFLAGS.

Some architectures (e.g. Alpha) do not support the -fstack-protector-all
compiler option and the use of the option with -Werror causes the compiler
to abort.  Test that the compiler supports -fstack-protector-all before
inclusion in CFLAGS.
---
 tools/perf/Makefile |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 742a32e..e7dc01d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -177,8 +177,7 @@ endif
 # Include saner warnings here, which can catch bugs:
 #
 
-EXTRA_WARNINGS := -Wcast-align
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat
+EXTRA_WARNINGS := -Wformat
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-security
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-y2k
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wshadow
@@ -201,7 +200,7 @@ EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wold-style-definition
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wstrict-prototypes
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wdeclaration-after-statement
 
-CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -fstack-protector-all -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
+CFLAGS = $(MBITS) -ggdb3 -Wall -Wextra -std=gnu99 -Werror -O6 -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS)
 LDFLAGS = -lpthread -lrt -lelf -lm
 ALL_CFLAGS = $(CFLAGS)
 ALL_LDFLAGS = $(LDFLAGS)
@@ -253,6 +252,9 @@ PTHREAD_LIBS = -lpthread
 # explicitly what architecture to check for. Fix this up for yours..
 SPARSE_FLAGS = -D__BIG_ENDIAN__ -D__powerpc__
 
+ifeq ($(shell sh -c "echo 'int foo(void) {char X[2]; return 3;}' | $(CC) -x c -c -Werror -fstack-protector-all - -o /dev/null >/dev/null 2>&1 && echo y"), y)
+  CFLAGS := $(CFLAGS) -fstack-protector-all
+endif
 
 
 ### --- END CONFIGURATION SECTION ---
-- 
1.6.3.3


--------------090208020908000308050607--

