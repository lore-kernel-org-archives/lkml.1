Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbZD2Ph1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbZD2Ph1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 11:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbZD2PhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 11:37:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53284 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbZD2PhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 11:37:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: [PATCH 20/30] microblaze_mmu_v1: uaccess MMU update
Date: Wed, 29 Apr 2009 17:35:28 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       john.williams@petalogix.com
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu> <200904291258.40667.arnd@arndb.de> <49F87009.1000905@monstr.eu>
In-Reply-To: <49F87009.1000905@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904291735.28964.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/tt29dO7wvh+VX1HhepS3lZLfsywufMojrqQD
 bW64dM7468QkBKIRRo+MI9JgfgMN4GtQiPGVLYErXs1AE13UJd
 CQa1nT43oCU1Iy8jGnI/Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 April 2009, Michal Simek wrote:
> > The above is just the nommu variant. For mmu, you need to
> > have exception handling in __clear_user to take care of the
> > case where the address is part of the user mapping (access_ok)
> > but not currently mapped.
> 
> Is it possible to do it for noMMU kernel too? I mean current MMU
> implementation of __clear_user in asm is faster than call memset
> for noMMU. I think I can use MMU implementation for noMMU too.
> Add two words to __ex_table just extend size of one section but
> not too much and won't be used for noMMU. 

Well, you can probably do something like this:

#ifdef CONFIG_MMU
#define __FIXUP_SECTION		".section .fixup,\"ax\"\n"
#define __EX_TABLE_SECTION	".section __ex_table,\"a\"\n"
#else
#define __FIXUP_SECTION		".section .discard,\"ax\"\n"
#define __EX_TABLE_SECTION	".section .discard,\"a\"\n"
#endif

+#define __get_user_asm(insn, __gu_ptr, __gu_val, __gu_err)             \
+({                                                                     \
+       __asm__ __volatile__ (                                          \
+                       "1:"    insn    " %1, %2, r0; \n"               \
+                       "       addk    %0, r0, r0;   \n"               \
+                       "2:                           \n"               \
+                        __FIXUP_SECTION				\
+                       "3:      brid    2b	      \n"               \
+                       "        addik   %0, r0, %3   \n"               \
+                       ".previous		      \n"               \
+                        __EX_TABLE_SECTION	                        \
+                       ".word   1b,3b		      \n"               \
+                       ".previous		      \n"               \
+               : "=r"(__gu_err), "=r"(__gu_val)                        \
+               : "r"(__gu_ptr), "i"(-EFAULT)                           \
+       );                                                              \
+})

This should simply throw away all the fixups if you list the .discard
section in vmlinux.lds.S under '/DISCARD/:', so you have no
overhead at all.

	Arnd <><
