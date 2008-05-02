Return-Path: <linux-kernel-owner+w=401wt.eu-S1760615AbYEBCsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760615AbYEBCsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 22:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbYEBCsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 22:48:05 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:40446 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbYEBCsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 22:48:04 -0400
Date: Thu, 1 May 2008 23:46:36 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: kernel/time.c: integer constant is too large for long type
Message-ID: <20080502024636.GA31465@beyonder.ift.unesp.br>
Mail-Followup-To: hpa@zytor.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

I would like to report a gcc warning which caught my attention today:

kernel/time.c: In function msecs_to_jiffies:
kernel/time.c:479: warning: integer constant is too large for long type
kernel/time.c: In function usecs_to_jiffies:
kernel/time.c:494: warning: integer constant is too large for long type

and ask you if this is something I should worry about (and propose
a patch if this warning is harmless).

I ask this because this warning was introduced via commit 
bdc807871d58285737d50dc6163d0feb72cb0dc2 ("avoid overflows in kernel/time.c")
and (naively) for me it looks like the above gcc warning is some kind of 
overflow.

I looked in the code for the first warning:

return ((u64)MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
		>> MSEC_TO_HZ_SHR32;

and noticed that the warning is due to

#define MSEC_TO_HZ_ADJ32        0x1cccccccc

in kernel/timeconst.h

Just for fun I converted it to binary 
111001100110011001100110011001100
and noticed that there are 33 bits in it.

I also noticed that if I cast it to (u64)MSEC_TO_HZ_ADJ32 the warning
is gone, but it appears to be an ugly thing to do. I can understand
the first cast to u64 in the return written above because of the 
multiplication by 'm'. But it looks strange to do that to MSEC_TO_HZ_ADJ32 
alone.

Shouldn't MSEC_TO_HZ_ADJ32 have at most 32 bits?

Well, just in case there is no problem about it being 33 bits despite
its name, please consider the patch below, which silences these
warnings.


>From b9781ceb0a635384423ceeee9030135cccddaad8 Mon Sep 17 00:00:00 2001
From: Carlos R. Mafra <crmafra@ift.unesp.br>
Date: Thu, 1 May 2008 23:30:49 -0300
Subject: [PATCH] kernel/time.c: Silence gcc warning 'integer constant to large for long type'

This patch remove the gcc warnings:

kernel/time.c: In function msecs_to_jiffies:
kernel/time.c:479: warning: integer constant is too large for long type
kernel/time.c: In function usecs_to_jiffies:
kernel/time.c:494: warning: integer constant is too large for long type

by casting MSEC_TO_HZ_ADJ32 and USEC_TO_HZ_ADJ32 to u64.

Signed-off-by: Carlos R. Mafra <crmafra@ift.unesp.br>
---
 kernel/time.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time.c b/kernel/time.c
index cbe0d5a..76dcc0f 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -476,7 +476,7 @@ unsigned long msecs_to_jiffies(const unsigned int m)
 	if (HZ > MSEC_PER_SEC && m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
 		return MAX_JIFFY_OFFSET;
 
-	return ((u64)MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
+	return ((u64)MSEC_TO_HZ_MUL32 * m + (u64)MSEC_TO_HZ_ADJ32)
 		>> MSEC_TO_HZ_SHR32;
 #endif
 }
@@ -491,7 +491,7 @@ unsigned long usecs_to_jiffies(const unsigned int u)
 #elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
 	return u * (HZ / USEC_PER_SEC);
 #else
-	return ((u64)USEC_TO_HZ_MUL32 * u + USEC_TO_HZ_ADJ32)
+	return ((u64)USEC_TO_HZ_MUL32 * u + (u64)USEC_TO_HZ_ADJ32)
 		>> USEC_TO_HZ_SHR32;
 #endif
 }
-- 
1.5.4.3









