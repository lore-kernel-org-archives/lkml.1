Return-Path: <linux-kernel-owner+w=401wt.eu-S1760624AbYBFXMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760624AbYBFXMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:12:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763033AbYBFXHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:07:16 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:33939 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760670AbYBFXHH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:07:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nxFFmOmO3+k4yUgzSAPaNf4LIv6Y5Wln1CzfUk0cGvMSojSyiR1ciASSmym8m+GDZKCTTHW3nfqhIEtttAIM9ckAwMZt7a1m8DT+CU2jOabwlHLctY+85mxP+RdmUpmTIidPWCgA3SlUiL5iGzSHzLVkoEx5dMVpuaX+yBxrTC8=
Message-ID: <6101e8c40802061507x14ec503ubc7a9cd78304cfd0@mail.gmail.com>
Date: Thu, 7 Feb 2008 00:07:04 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: Re: [2.6.22.y] {06/17} - handle-bogus-%cs-selector-in-single-step-instruction-decoding - series for stable kernel #2
In-Reply-To: <6101e8c40802011733r40492c4fxa5ffd765504004fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6101e8c40802011733r40492c4fxa5ffd765504004fd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland McGrath <roland@redhat.com>
Date: Mon, 16 Jul 2007 08:03:16 +0000 (-0700)
Subject: Handle bogus %cs selector in single-step instruction decoding
Patch-mainline: 2.6.23-rc1
References: 326270, CVE-2007-3731

Handle bogus %cs selector in single-step instruction decoding

The code for LDT segment selectors was not robust in the face of a bogus
selector set in %cs via ptrace before the single-step was done.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Jeff Mahoney <jeffm@suse.com>
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



On 2/2/08, Oliver Pinter (Pintér Olivér) <oliver.pntr@gmail.com> wrote:
> mainline: 29eb51101c02df517ca64ec472d7501127ad1da8
>
>
> --
> Thanks,
> Oliver
>


-- 
Thanks,
Oliver
