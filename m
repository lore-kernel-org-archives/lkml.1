Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbXHTCIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbXHTCIK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 22:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbXHTCH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 22:07:57 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:47945 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426AbXHTCH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 22:07:56 -0400
Date: Sun, 19 Aug 2007 19:07:32 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] [5/12] x86_64: Make patching more robust, fix paravirt
	issue
Message-ID: <20070820020732.GA3672@sequoia.sous-sol.org>
References: <20070809241.425881000@suse.de> <20070809124132.C794A14F3B@wotan.suse.de> <46C637B7.30200@goop.org> <1187574628.19435.29.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187574628.19435.29.camel@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> Then back out 19d36ccdc34f5ed444f8a6af0cbfdb6790eb1177 too, which broke
> lguest booting, and this tried to fix.

That did get backed out (at least the part that broke paravirt patching)
in 602033ed5907a59ce86f709082a35be047743a86.  Linus' tree should be
working fine right now with d34fda4a84c18402640a1a2342d6e6d9829e6db7
committed, and can be further refined with the patch below that's just
waiting on some further testing.

thanks,
-chris
--

Subject: [PATCH] x86: skip paravirt patching when appropriate
From: Chris Wright <chrisw@sous-sol.org>

commit d34fda4a84c18402640a1a2342d6e6d9829e6db7 was a little overkill
in the case where a paravirt patcher chooses to leave patch site
unpatched.  Instead of copying original instructions to temp buffer
then back to patch site, simply skip patching those sites altogether.

Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Zach Amsden <zach@vmware.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/i386/kernel/alternative.c |    4 ++--
 arch/i386/kernel/paravirt.c    |   10 +++++-----
 arch/i386/kernel/vmi.c         |    4 ++--
 include/asm-i386/paravirt.h    |    3 +++
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/i386/kernel/alternative.c b/arch/i386/kernel/alternative.c
index 9f4ac8b..b81d87e 100644
--- a/arch/i386/kernel/alternative.c
+++ b/arch/i386/kernel/alternative.c
@@ -366,10 +366,10 @@ void apply_paravirt(struct paravirt_patch_site *start,
 		unsigned int used;
 
 		BUG_ON(p->len > MAX_PATCH_LEN);
-		/* prep the buffer with the original instructions */
-		memcpy(insnbuf, p->instr, p->len);
 		used = paravirt_ops.patch(p->instrtype, p->clobbers, insnbuf,
 					  (unsigned long)p->instr, p->len);
+		if (used == PV_NO_PATCH)
+			continue;
 
 		BUG_ON(used > p->len);
 
diff --git a/arch/i386/kernel/paravirt.c b/arch/i386/kernel/paravirt.c
index 739cfb2..a36ce34 100644
--- a/arch/i386/kernel/paravirt.c
+++ b/arch/i386/kernel/paravirt.c
@@ -122,7 +122,7 @@ unsigned paravirt_patch_nop(void)
 
 unsigned paravirt_patch_ignore(unsigned len)
 {
-	return len;
+	return PV_NO_PATCH;
 }
 
 struct branch {
@@ -139,9 +139,9 @@ unsigned paravirt_patch_call(void *insnbuf,
 	unsigned long delta = (unsigned long)target - (addr+5);
 
 	if (tgt_clobbers & ~site_clobbers)
-		return len;	/* target would clobber too much for this site */
+		return PV_NO_PATCH;	/* target would clobber too much for this site */
 	if (len < 5)
-		return len;	/* call too long for patch site */
+		return PV_NO_PATCH;	/* call too long for patch site */
 
 	b->opcode = 0xe8; /* call */
 	b->delta = delta;
@@ -157,7 +157,7 @@ unsigned paravirt_patch_jmp(const void *target, void *insnbuf,
 	unsigned long delta = (unsigned long)target - (addr+5);
 
 	if (len < 5)
-		return len;	/* call too long for patch site */
+		return PV_NO_PATCH;	/* call too long for patch site */
 
 	b->opcode = 0xe9;	/* jmp */
 	b->delta = delta;
@@ -196,7 +196,7 @@ unsigned paravirt_patch_insns(void *insnbuf, unsigned len,
 	unsigned insn_len = end - start;
 
 	if (insn_len > len || start == NULL)
-		insn_len = len;
+		insn_len = PV_NO_PATCH;
 	else
 		memcpy(insnbuf, start, insn_len);
 
diff --git a/arch/i386/kernel/vmi.c b/arch/i386/kernel/vmi.c
index 18673e0..27ae004 100644
--- a/arch/i386/kernel/vmi.c
+++ b/arch/i386/kernel/vmi.c
@@ -118,7 +118,7 @@ static unsigned patch_internal(int call, unsigned len, void *insnbuf,
 
 		case VMI_RELOCATION_NONE:
 			/* leave native code in place */
-			break;
+			return PV_NO_PATCH;
 
 		default:
 			BUG();
@@ -153,7 +153,7 @@ static unsigned vmi_patch(u8 type, u16 clobbers, void *insns,
 		default:
 			break;
 	}
-	return len;
+	return PV_NO_PATCH;
 }
 
 /* CPUID has non-C semantics, and paravirt-ops API doesn't match hardware ISA */
diff --git a/include/asm-i386/paravirt.h b/include/asm-i386/paravirt.h
index 9fa3fa9..b26794f 100644
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -252,6 +252,9 @@ extern struct paravirt_ops paravirt_ops;
 #define paravirt_alt(insn_string)					\
 	_paravirt_alt(insn_string, "%c[paravirt_typenum]", "%c[paravirt_clobber]")
 
+enum {
+	PV_NO_PATCH = -1
+};
 unsigned paravirt_patch_nop(void);
 unsigned paravirt_patch_ignore(unsigned len);
 unsigned paravirt_patch_call(void *insnbuf,
