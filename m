Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbXLUE7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbXLUE7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 23:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760207AbXLUE7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 23:59:01 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58021 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753325AbXLUE66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 23:58:58 -0500
Date: Thu, 20 Dec 2007 20:58:42 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kyle McMartin <kyle@mcmartin.ca>, Junio C Hamano <gitster@pobox.com>,
       Git Mailing List <git@vger.kernel.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.24-rc6
In-Reply-To: <alpine.LFD.0.9999.0712202009290.21557@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.9999.0712202054350.21557@woody.linux-foundation.org>
References: <alpine.LFD.0.9999.0712201731010.21557@woody.linux-foundation.org> <20071221024805.GB8535@fattire.cabal.ca> <20071221030152.GC8535@fattire.cabal.ca> <alpine.LFD.0.9999.0712201937470.21557@woody.linux-foundation.org>
 <alpine.LFD.0.9999.0712202009290.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 Dec 2007, Linus Torvalds wrote:
>
> And here's the git patch to avoid this optimization when there is 
> context.

Actually, the code to finding one '\n' is still needed to avoid the 
(pathological) case of getting a "\No newline", so scrap that one which 
was too aggressive, and use this (simpler) one instead.

Not that it matters in real life, since nobody uses -U0, and "git blame" 
won't care. But let's get it right anyway ;)

This whole function has had more bugs than it has lines.

		Linus

---
 xdiff-interface.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/xdiff-interface.c b/xdiff-interface.c
index 9ee877c..711029e 100644
--- a/xdiff-interface.c
+++ b/xdiff-interface.c
@@ -115,15 +115,18 @@ static void trim_common_tail(mmfile_t *a, mmfile_t *b, long ctx)
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
+	while (recovered < trimmed)
 		if (ap[recovered++] == '\n')
-			ctx--;
+			break;
 	a->size -= (trimmed - recovered);
 	b->size -= (trimmed - recovered);
 }
