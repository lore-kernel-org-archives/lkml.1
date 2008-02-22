Return-Path: <linux-kernel-owner+w=401wt.eu-S934746AbYBVVrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934746AbYBVVrQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:47:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933452AbYBVVnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:43:24 -0500
Received: from mx1.suse.de ([195.135.220.2]:46467 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757933AbYBVVnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:43:21 -0500
Date: Fri, 22 Feb 2008 13:40:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roland McGrath <roland@redhat.com>, Jeff Mahoney <jeffm@suse.com>,
       Oliver Pinter <oliver.pntr@gmail.com>
Subject: [patch 08/23] Handle bogus %cs selector in single-step instruction
	decoding (CVE-2007-3731)
Message-ID: <20080222214024.GI8686@suse.de>
References: <20080222213114.583282464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="handle-bogus-cs-selector-in-single-step-instruction-decoding.patch"
In-Reply-To: <20080222213927.GA8686@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Roland McGrath <roland@redhat.com>

Handle bogus %cs selector in single-step instruction decoding

mainline: 29eb51101c02df517ca64ec472d7501127ad1da8

The code for LDT segment selectors was not robust in the face of a bogus
selector set in %cs via ptrace before the single-step was done.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Jeff Mahoney <jeffm@suse.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/i386/kernel/ptrace.c   |   22 +++++++++++++++-------
 arch/x86_64/kernel/ptrace.c |   23 ++++++++++++++++-------
 2 files changed, 31 insertions(+), 14 deletions(-)

--- a/arch/i386/kernel/ptrace.c
+++ b/arch/i386/kernel/ptrace.c
@@ -164,14 +164,22 @@ static unsigned long convert_eip_to_line
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
--- a/arch/x86_64/kernel/ptrace.c
+++ b/arch/x86_64/kernel/ptrace.c
@@ -102,16 +102,25 @@ unsigned long convert_rip_to_linear(stru
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
