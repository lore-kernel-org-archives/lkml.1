Return-Path: <linux-kernel-owner+w=401wt.eu-S1753647AbYFYUMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbYFYUMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 16:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbYFYUMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 16:12:40 -0400
Received: from gw.goop.org ([64.81.55.164]:51099 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbYFYUMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 16:12:39 -0400
Message-ID: <4862A6A9.1030109@goop.org>
Date: Wed, 25 Jun 2008 13:12:25 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Nick Piggin <npiggin@suse.de>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 00 of 36] x86/paravirt: groundwork for 64-bit Xen	support
References: <patchbomb.1214367536@localhost> <20080625084253.GA11524@elte.hu> <20080625152212.GA3442@elte.hu>
In-Reply-To: <20080625152212.GA3442@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> Anyway, that's all theory - i'll try out your patchset in -tip to see 
>> what breaks in practice ;-)
>>     
>
> i've put the commits (and a good number of dependent commits) into the 
> new tip/x86/xen-64bit topic branch.
>
> It quickly broke the build in testing:
>
>  include/asm/pgalloc.h: In function ‘paravirt_pgd_free':
>  include/asm/pgalloc.h:14: error: parameter name omitted
>  arch/x86/kernel/entry_64.S: In file included from 
>  arch/x86/kernel/traps_64.c:51:include/asm/pgalloc.h: In function ‘paravirt_pgd_free':
>  include/asm/pgalloc.h:14: error: parameter name omitted
>   

No, looks like my fault.  The non-PARAVIRT version of 
paravirt_pgd_free() is:

static inline void paravirt_pgd_free(struct mm_struct *mm, pgd_t *) {}

but C doesn't like missing parameter names, even if unused.

This should fix it:

diff -r 19b73cc5fdf4 include/asm-x86/pgalloc.h
--- a/include/asm-x86/pgalloc.h	Wed Jun 25 11:24:41 2008 -0400
+++ b/include/asm-x86/pgalloc.h	Wed Jun 25 13:11:56 2008 -0700
@@ -11,7 +11,7 @@
 #include <asm/paravirt.h>
 #else
 #define paravirt_pgd_alloc(mm)	__paravirt_pgd_alloc(mm)
-static inline void paravirt_pgd_free(struct mm_struct *mm, pgd_t *) {}
+static inline void paravirt_pgd_free(struct mm_struct *mm, pgd_t *pgd) {}
 static inline void paravirt_alloc_pte(struct mm_struct *mm, unsigned long pfn)	{}
 static inline void paravirt_alloc_pmd(struct mm_struct *mm, unsigned long pfn)	{}
 static inline void paravirt_alloc_pmd_clone(unsigned long pfn, unsigned long clonepfn,



