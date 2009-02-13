Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbZBMNMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbZBMNMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 08:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbZBMNL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 08:11:57 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:39356 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752710AbZBMNL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 08:11:56 -0500
Message-ID: <49957F98.50708@st.com>
Date: Fri, 13 Feb 2009 15:11:36 +0100
From: Giuseppe CAVALLARO <peppe.cavallaro@st.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       linux-sh@vger.kernel.org, linux-mm@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] slab: fix slab flags for archs use alignment larger 
 64-bit
References: <1234461073-23281-1-git-send-email-peppe.cavallaro@st.com>	 <20090212185640.GA6111@linux-sh.org> <499544AD.3030804@st.com>	 <84144f020902130122y471dd92em4a72de43a0cfc681@mail.gmail.com>	 <49954F9A.5020801@st.com> <84144f020902130205x4dc5886l70fe6a695ef050a4@mail.gmail.com> <4995565D.5010105@st.com>
In-Reply-To: <4995565D.5010105@st.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------030203020209040702050708"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030203020209040702050708
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Giuseppe CAVALLARO wrote:
> Pekka Enberg wrote:
>   
>> Hi Giuseppe,
>>
>> On Fri, Feb 13, 2009 at 12:46 PM, Giuseppe CAVALLARO
>> <peppe.cavallaro@st.com> wrote:
>>   
>>     
>>> 1) LOG with my patch:
>>> root@linux:~# cat /proc/meminfo | grep Slab
>>> Slab:             2612 kB
>>>
>>> 2) LOG without my patch:
>>> root@linux:~# cat /proc/meminfo | grep Slab
>>> Slab:             2504 kB
>>>     
>>>       
>> That's not too bad. I assume it's L1_CACHE_BYTES set to 32 bytes? 
>>     
> you are perfectly right.
>   
>> One big problem with your patch is that on some MIPS configurations
>> ARCH_KMALLOC_MINALIGN is as big as 128.
>>     
> Agree again and problem understood... thanks!
>   
>> So if you're going to do this, you can't use ARCH_KMALLOC_MINALIGN directly but add a some
>> SLAB_MAX_DEBUG_ALIGN which can be overridden by architecture code.
>>   
>>     
> If you like, I can prepare a patch in any case.
> Then we can decide if it actually adds complexity and discard it.
> Otherwise we could maintain it.
>   
>> One obvious question, though, is whether all this is worth the added
>> complexity. I mean, we've managed "just fine" without it for years.
>> Paul, thoughts?
>>
>>                                         Pekka
>>   
>>     
Hi!
as promised, patches attached.
At any rate, (this is just my feeling) although we add more complexity
this kind of 'fixes' can actually help users to debug.
So, complexity is welcome especially in these scenarios (debug on, users
in panic mode :-)).
Let me know.
Cheers,
Peppe

--------------030203020209040702050708
Content-Type: text/plain;
 name="0001-slab-fix-the-debug-information-with-different-align.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-slab-fix-the-debug-information-with-different-align.pat";
 filename*1="ch"

>From 86c7fe861b4a6ee7b533a25ce2c506134a7533a8 Mon Sep 17 00:00:00 2001
From: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Date: Fri, 13 Feb 2009 15:06:22 +0100
Subject: [PATCH] slab: fix the debug information with different alignments.

This patch is to fix the debug information reported in /proc/slab_allocators

for all the architectures by using a new define (ARCH_SLAB_MAX_DEBUG_ALIGN)
rather than the alignment of a 64-bit integer.
Currently, on sh, for example, /proc/slab_allocators has no size-X entries
as side effect.

Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
---
 mm/slab.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 4d00855..587e0f3 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -165,6 +165,10 @@
 #define ARCH_SLAB_MINALIGN 0
 #endif
 
+#ifndef ARCH_SLAB_MAX_DEBUG_ALIGN
+#define ARCH_SLAB_MAX_DEBUG_ALIGN __alignof__(unsigned long long)
+#endif
+
 #ifndef ARCH_KMALLOC_FLAGS
 #define ARCH_KMALLOC_FLAGS SLAB_HWCACHE_ALIGN
 #endif
@@ -2262,7 +2266,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 		ralign = align;
 	}
 	/* disable debug if necessary */
-	if (ralign > __alignof__(unsigned long long))
+	if (ralign > ARCH_SLAB_MAX_DEBUG_ALIGN)
 		flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
 	/*
 	 * 4) Store it.
-- 
1.5.6.6


--------------030203020209040702050708
Content-Type: text/plain;
 name="0002-sh-add-the-default-value-for-ARCH_SLAB_MAX_DEBUG_AL.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0002-sh-add-the-default-value-for-ARCH_SLAB_MAX_DEBUG_AL.pat";
 filename*1="ch"

>From 3b461766df1841f03e740b91efc38132eae74f86 Mon Sep 17 00:00:00 2001
From: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Date: Fri, 13 Feb 2009 15:06:39 +0100
Subject: [PATCH] sh: add the default value for ARCH_SLAB_MAX_DEBUG_ALIGN define.

Add and enforce ARCH_SLAB_MAX_DEBUG_ALIGN to the cache line size.

Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
---
 arch/sh/include/asm/page.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/sh/include/asm/page.h b/arch/sh/include/asm/page.h
index 5871d78..14768c8 100644
--- a/arch/sh/include/asm/page.h
+++ b/arch/sh/include/asm/page.h
@@ -182,4 +182,6 @@ typedef struct page *pgtable_t;
 #define ARCH_SLAB_MINALIGN	8
 #endif
 
+#define ARCH_SLAB_MAX_DEBUG_ALIGN L1_CACHE_BYTES
+
 #endif /* __ASM_SH_PAGE_H */
-- 
1.5.6.6


--------------030203020209040702050708--
