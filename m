Return-Path: <linux-kernel-owner+w=401wt.eu-S1761839AbYBGUEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761839AbYBGUEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761139AbYBGUDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:03:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:41969 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759706AbYBGUDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:03:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=pw6x4AzbNHZlgppTA1FsuusNlN+ZV0nBonyb9rwgrAK0BcnMcpeRlW4RufpMEhKw5s/YSMlESJ2ClrAiaBzQOzlRegPzKZPvm7gsfKCB4tHq/BXL40X98ZPBDi+sfOcAAEepXHgGnMqN7LjLXqrXqrgMQoN4jfV0h6rrmXX0mSs=
Message-ID: <6101e8c40802071203i132e678s8e7f30484f5854c5@mail.gmail.com>
Date: Thu, 7 Feb 2008 21:03:16 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {03/14} - Handle bogus %cs selector in single-step instruction decoding - on top of 2.6.22.17
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aka: handle-bogus-%cs-selector-in-single-step-instruction-decoding.patch

From: Roland McGrath <roland@redhat.com>
Date: Mon, 16 Jul 2007 08:03:16 +0000 (-0700)
Subject: Handle bogus %cs selector in single-step instruction decoding
Patch-mainline: 2.6.23-rc1
References: 326270, CVE-2007-3731

Handle bogus %cs selector in single-step instruction decoding

mainline: 29eb51101c02df517ca64ec472d7501127ad1da8

The code for LDT segment selectors was not robust in the face of a bogus
selector set in %cs via ptrace before the single-step was done.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Jeff Mahoney <jeffm@suse.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>
---

 arch/i386/kernel/ptrace.c   |   22 +++++++++++++++-------
 arch/x86_64/kernel/ptrace.c |   23 ++++++++++++++++-------
 2 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/arch/i386/kernel/ptrace.c b/arch/i386/kernel/ptrace.c
index 1c075f5..0c8f00e 100644
--- a/arch/i386/kernel/ptrace.c
+++ b/arch/i386/kernel/ptrace.c
@@ -164,14 +164,22 @@ static unsigned long
convert_eip_to_linear(struct task_struct *child, struct pt_
 		u32 *desc;
 		unsigned long base;

-		down(&child->mm->context.sem);
-		desc = child->mm->context.ldt + (seg & ~7);
-		base = (desc[0] >> 16) | ((desc[1] & 0xff) << 16) | (desc[1] & 0xff000000);
+		seg &= ~7UL;

-		/* 16-bit code segment? */
-		if (!((desc[1] >> 22) & 1))
-			addr &= 0xffff;
-		addr += base;
+		down(&child->mm->context.sem);
+		if (unlikely((seg >> 3) >= child->mm->context.size))
+			addr = -1L; /* bogus selector, access would fault */
+		else {
+			desc = child->mm->context.ldt + seg;
+			base = ((desc[0] >> 16) |
+				((desc[1] & 0xff) << 16) |
+				(desc[1] & 0xff000000));
+
+			/* 16-bit code segment? */
+			if (!((desc[1] >> 22) & 1))
+				addr &= 0xffff;
+			addr += base;
+		}
 		up(&child->mm->context.sem);
 	}
 	return addr;
diff --git a/arch/x86_64/kernel/ptrace.c b/arch/x86_64/kernel/ptrace.c
index fa6775e..e83cc67 100644
--- a/arch/x86_64/kernel/ptrace.c
+++ b/arch/x86_64/kernel/ptrace.c
@@ -102,16 +102,25 @@ unsigned long convert_rip_to_linear(struct
task_struct *child, struct pt_regs *r
 		u32 *desc;
 		unsigned long base;

-		down(&child->mm->context.sem);
-		desc = child->mm->context.ldt + (seg & ~7);
-		base = (desc[0] >> 16) | ((desc[1] & 0xff) << 16) | (desc[1] & 0xff000000);
+		seg &= ~7UL;

-		/* 16-bit code segment? */
-		if (!((desc[1] >> 22) & 1))
-			addr &= 0xffff;
-		addr += base;
+		down(&child->mm->context.sem);
+		if (unlikely((seg >> 3) >= child->mm->context.size))
+			addr = -1L; /* bogus selector, access would fault */
+		else {
+			desc = child->mm->context.ldt + seg;
+			base = ((desc[0] >> 16) |
+				((desc[1] & 0xff) << 16) |
+				(desc[1] & 0xff000000));
+
+			/* 16-bit code segment? */
+			if (!((desc[1] >> 22) & 1))
+				addr &= 0xffff;
+			addr += base;
+		}
 		up(&child->mm->context.sem);
 	}
+
 	return addr;
 }



-- 
Thanks,
Oliver
