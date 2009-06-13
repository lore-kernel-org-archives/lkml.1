Return-Path: <linux-kernel-owner+w=401wt.eu-S1763431AbZFMUxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763431AbZFMUxy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 16:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762851AbZFMUxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 16:53:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55204 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760702AbZFMUxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 16:53:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] asm-generic: uaccess: fix up local access_ok() usage
Date: Sat, 13 Jun 2009 22:53:39 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <1244903447-23579-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1244903447-23579-1-git-send-email-vapier@gentoo.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200906132253.39879.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+NMJBXoB+Z1cfvp8iu6OkfB7Ij5hvliowyKyu
 7Cmr3vJd+m1M0wSmww+9vSuk/U0HyGDzkkrl9ZdgxcMN16m5Je
 ZiUofaIbWET0bivJYJo7Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 June 2009, Mike Frysinger wrote:
> There's no reason that I can see to use the short __access_ok() form
> directly when the access_ok() is clearer in intent and for more people,
> expands to the same C code (i.e. always specify the first field -- access
> type).  Not all no-mmu systems lack memory protection, so the read/write
> could feasibly be checked.

Ah, I didn't consider this. I checked all the architectures and could not
find a case where access_ok actually evaluates the the first argument, so
I chose the slightly terser variant. I also don't let you override
access_ok() at this moment, which means that you don't have a choice
to use the generic uaccess.h and still differentiate between read and
write accesses.

What I really got wrong was the prototype for __access_ok(), as you
showed in your follow-up. I only tested this with the microblaze
patch that overrides __access_ok() with an architecture specific
version that gets this part right.

Would this simpler patch help you as well?

--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -37,14 +37,14 @@ static inline void set_fs(mm_segment_t fs)
 #define VERIFY_READ	0
 #define VERIFY_WRITE	1
 
-#define access_ok(type, addr, size) __access_ok((unsigned long)(addr),(size))
+#define access_ok(type, addr, size) __access_ok((addr), (size))
 
 /*
  * The architecture should really override this if possible, at least
  * doing a check on the get_fs()
  */
 #ifndef __access_ok
-static inline int __access_ok(unsigned long addr, unsigned long size)
+static inline int __access_ok(void __user *ptr, unsigned long size)
 {
 	return 1;
 }

It may not be clearer in intent, but it's what the majority (by a small
margin) of architecture do anyway.

> Also, the strnlen_user() function was missing a access_ok() check on the
> pointer given.  We've had cases on Blackfin systems where test cases
> caused kernel crashes here because userspace passed up a NULL/-1 pointer
> and the kernel gladly attempted to run strlen() on it.

Right, well spotted. I'll take this fix as a separate patch, ok?

	Arnd <><
