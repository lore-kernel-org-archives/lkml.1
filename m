Return-Path: <linux-kernel-owner+w=401wt.eu-S1758519AbXLQRas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519AbXLQRas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 12:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbXLQRak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 12:30:40 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35935 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753676AbXLQRaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 12:30:39 -0500
Date: Mon, 17 Dec 2007 09:28:57 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: John Reiser <jreiser@BitWagon.com>,
       Andrew Morton <akpm@linux-foundation.org>, security@kernel.org,
       tytso@mit.edu, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mpm@selenic.com, linux-sparse@vger.kernel.org
Subject: Signed divides vs shifts (Re: [Security] /dev/urandom uses uninit
 bytes, leaks user data)
In-Reply-To: <E1J3RD5-0006yU-00@gondolin.me.apana.org.au>
Message-ID: <alpine.LFD.0.9999.0712170856050.21557@woody.linux-foundation.org>
References: <E1J3RD5-0006yU-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 15 Dec 2007, Herbert Xu wrote:
> 
> There ought to be a warning about this sort of thing.

We could add it to sparse. The appended (untested) patch seems to say 
there's a lot of those signed divides-by-power-of-twos.

However, the problem with such warnings is that it encourages people to do 
the simple fix that may be *wrong*. For example, you fixed it with patches 
like

> -		int rsvd = r->limit ? 0 : random_read_wakeup_thresh/4;
> +		int rsvd = r->limit ? 0 : random_read_wakeup_thresh / 4u;

which is really quite dangerous for several reasons:

 - it depends intimately on the type of the thing being divided (try it: 
   it will do nothing at all if the thing you divide is larger than 
   "unsigned int", since then the "4u" will be turned into a _signed_ 
   larger type by the C type expansion).

   So in general, the above doesn't even do what it's supposed to do on a 
   64-bit architecture if the thing to be divided is 64-bit!

 - it changes behaviour. If that thing really is signed and can be 
   negative, that "trivial" patch just changed the divide to be 
   fundamentally something totally different.

so I think this patch is horribly wrong.

The *correct* way to fix signed divisions is by doing one of two things:

 - really make the data we divide be unsigned. With all the thinking that 
   involves!

   This is the good change, but it does involve making sure that there are 
   no tests against zero and that the value really cannot go negative. 
   Usually the unsigned types are (a) faster and (b) more robust, but if 
   somebody is depending on signs, unsigned types are obviously not 
   appropriate.

 - change a divide-by-power-of-2 into a signed shift instead.

   Yes, this also changes the end result for negative values, but it 
   changes it in a sane and generally good way (ie it will still be a 
   "valid" divide, it will just be a divide that rounds differently, and 
   is more likely than turning it into an unsigned divide to generally 
   result in working code).

Hmm?

			Linus
---
 simplify.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/simplify.c b/simplify.c
index 94e14d2..91f1120 100644
--- a/simplify.c
+++ b/simplify.c
@@ -286,6 +286,36 @@ static int simplify_constant_rightside(struct instruction *insn)
 		if (!value)
 			return replace_with_pseudo(insn, insn->src2);
 		return 0;
+
+	case OP_DIVU: case OP_DIVS:
+		if (!value)
+			break;
+		if (value == 1)
+			return replace_with_pseudo(insn, insn->src1);
+		/* Power-of-two? */
+		if (!(value & (value-1))) {
+			int log2 = -1;
+			do {
+				log2++;
+				value >>= 1;
+			} while (value);
+
+			/* Turn unsigned divides into shifts */
+			if (insn->opcode == OP_DIVU) {
+				insn->src2->value = log2;
+				insn->opcode = OP_LSR;
+				return 1;
+			}
+
+			/*
+			 * This is incorrect, but we care more about
+			 * the warning than the code generation
+			 */
+			warning(insn->pos, "expensive signed divide");
+			insn->src2->value = log2;
+			insn->opcode = OP_ASR;
+			return 1;
+		}
 	}
 	return 0;
 }
