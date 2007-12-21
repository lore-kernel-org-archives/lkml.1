Return-Path: <linux-kernel-owner+w=401wt.eu-S1759209AbXLUEXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209AbXLUEXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 23:23:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbXLUEWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 23:22:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34272 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752921AbXLUEWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 23:22:52 -0500
Date: Thu, 20 Dec 2007 20:22:46 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kyle McMartin <kyle@mcmartin.ca>, Junio C Hamano <gitster@pobox.com>,
       Git Mailing List <git@vger.kernel.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc6
In-Reply-To: <alpine.LFD.0.9999.0712201937470.21557@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.9999.0712202009290.21557@woody.linux-foundation.org>
References: <alpine.LFD.0.9999.0712201731010.21557@woody.linux-foundation.org> <20071221024805.GB8535@fattire.cabal.ca> <20071221030152.GC8535@fattire.cabal.ca> <alpine.LFD.0.9999.0712201937470.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 Dec 2007, Linus Torvalds wrote:
> 
> The tar-ball and the git archive itself is fine, but yes, the diff from 
> 2.6.23 to 2.6.24-rc6 is bad. It's the "trim_common_tail()" optimization 
> that has caused way too much pain.

Very interesting breakage. The patch was actually "correct" in a (rather 
limited) technical sense, but the context at the end was missing because 
while the trim_common_tail() code made sure to keep enough common context 
to allow a valid diff to be generated, the diff machinery itself could 
decide that it could generate the diff differently than the "obvious" 
solution.

It only happened for a few files that had lots of repeated lines - so that 
the diff could literally be done multiple different ways - and in fact, 
the file that caused the problems really had a bogus commit that 
duplicated *way* too much data, and caused lots of #define's to exist 
twice.

But the sad fact appears that the git optimization (which is very 
important for "git blame", which needs no context), is only really valid 
for that one case where we really don't need any context.

I uploaded a fixed patch. And here's the git patch to avoid this 
optimization when there is context.

		Linus

---
 xdiff-interface.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/xdiff-interface.c b/xdiff-interface.c
index 9ee877c..0b7e057 100644
--- a/xdiff-interface.c
+++ b/xdiff-interface.c
@@ -110,22 +110,22 @@ int xdiff_outf(void *priv_, mmbuffer_t *mb, int nbuf)
 static void trim_common_tail(mmfile_t *a, mmfile_t *b, long ctx)
 {
 	const int blk = 1024;
-	long trimmed = 0, recovered = 0;
+	long trimmed = 0;
 	char *ap = a->ptr + a->size;
 	char *bp = b->ptr + b->size;
 	long smaller = (a->size < b->size) ? a->size : b->size;
 
+	if (ctx)
+		return;
+
 	while (blk + trimmed <= smaller && !memcmp(ap - blk, bp - blk, blk)) {
 		trimmed += blk;
 		ap -= blk;
 		bp -= blk;
 	}
 
-	while (recovered < trimmed && 0 <= ctx)
-		if (ap[recovered++] == '\n')
-			ctx--;
-	a->size -= (trimmed - recovered);
-	b->size -= (trimmed - recovered);
+	a->size -= trimmed;
+	b->size -= trimmed;
 }
 
 int xdi_diff(mmfile_t *mf1, mmfile_t *mf2, xpparam_t const *xpp, xdemitconf_t const *xecfg, xdemitcb_t *xecb)
