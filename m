Return-Path: <linux-kernel-owner+w=401wt.eu-S1758510AbYFQVHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758510AbYFQVHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 17:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbYFQVHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 17:07:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755980AbYFQVHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 17:07:09 -0400
Date: Tue, 17 Jun 2008 14:06:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bron Gondwana <brong@fastmail.fm>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386,
 bisected, reproducable)
In-Reply-To: <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0806171356320.2908@woody.linux-foundation.org>
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org> <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org> <alpine.LFD.1.10.0806171331460.2908@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jun 2008, Linus Torvalds wrote:
> 
> I don't think that code is reasonably salvageable. Damn. 

Hmm. Something like this *may* salvage it.

Untested, so far (I'll reboot and test soon enough), but even if it fixes 
things, it's not really very good. 

Why?

Because of the unrolling, we may be doing 32 bytes worth of reads from 
user space before doing a *single* write, so if we have a user copy from 
the end of a page (say, 16 bytes from the end), we'd take the fault on the 
third 8-byte load, and not copy anything at all.

So instead of copying 16 bytes and then returning "I copied 16 bytes", it 
will copy _zero_ bytes, and now return "I copied 0 bytes" (it used to 
incorrectly return that it copied 16 bytes because it could _read_ 16 
bytes even though it never wrote them! Totally buggy!).

But I think the mm/filemap.c routines handle this case correctly (because 
of how it probes at least the first iovec), so at least copied will 
generally not be zero. But as mentioned, this isn't tested yet.

It would be better to not do the unrolling, or at least do the faulting 
behaviour correctly so that we fall back on a byte-for-byte copy when it 
faults. But not even the "rep movs" version has ever been _that_ careful, 
so I guess that's ok.

Somebody should _really_ double-check this, and it would be wonderful if 
somebody can come up with something better than this patch.

		Linus
---
 arch/x86/lib/copy_user_64.S         |   25 +++++++++++--------------
 arch/x86/lib/copy_user_nocache_64.S |   25 +++++++++++--------------
 2 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index 70bebd3..ee1c3f6 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -217,19 +217,19 @@ ENTRY(copy_user_generic_unrolled)
 	/* table sorted by exception address */
 	.section __ex_table,"a"
 	.align 8
-	.quad .Ls1,.Ls1e
-	.quad .Ls2,.Ls2e
-	.quad .Ls3,.Ls3e
-	.quad .Ls4,.Ls4e
-	.quad .Ld1,.Ls1e
+	.quad .Ls1,.Ls1e	/* Ls1-Ls4 have copied zero bytes */
+	.quad .Ls2,.Ls1e
+	.quad .Ls3,.Ls1e
+	.quad .Ls4,.Ls1e
+	.quad .Ld1,.Ls1e	/* Ld1-Ld4 have copied 0-24 bytes */
 	.quad .Ld2,.Ls2e
 	.quad .Ld3,.Ls3e
 	.quad .Ld4,.Ls4e
-	.quad .Ls5,.Ls5e
-	.quad .Ls6,.Ls6e
-	.quad .Ls7,.Ls7e
-	.quad .Ls8,.Ls8e
-	.quad .Ld5,.Ls5e
+	.quad .Ls5,.Ls5e	/* Ls5-Ls8 have copied 32 bytes */
+	.quad .Ls6,.Ls5e
+	.quad .Ls7,.Ls5e
+	.quad .Ls8,.Ls5e
+	.quad .Ld5,.Ls5e	/* Ld5-Ld8 have copied 32-56 bytes */
 	.quad .Ld6,.Ls6e
 	.quad .Ld7,.Ls7e
 	.quad .Ld8,.Ls8e
@@ -244,11 +244,8 @@ ENTRY(copy_user_generic_unrolled)
 	.quad .Le5,.Le_zero
 	.previous
 
-	/* compute 64-offset for main loop. 8 bytes accuracy with error on the
-	   pessimistic side. this is gross. it would be better to fix the
-	   interface. */
 	/* eax: zero, ebx: 64 */
-.Ls1e: 	addl $8,%eax
+.Ls1e: 	addl $8,%eax		/* eax is bytes left uncopied within the loop (Ls1e: 64 .. Ls8e: 8) */
 .Ls2e: 	addl $8,%eax
 .Ls3e: 	addl $8,%eax
 .Ls4e: 	addl $8,%eax
diff --git a/arch/x86/lib/copy_user_nocache_64.S b/arch/x86/lib/copy_user_nocache_64.S
index 5196762..9d3d1ab 100644
--- a/arch/x86/lib/copy_user_nocache_64.S
+++ b/arch/x86/lib/copy_user_nocache_64.S
@@ -145,19 +145,19 @@ ENTRY(__copy_user_nocache)
 	/* table sorted by exception address */
 	.section __ex_table,"a"
 	.align 8
-	.quad .Ls1,.Ls1e
-	.quad .Ls2,.Ls2e
-	.quad .Ls3,.Ls3e
-	.quad .Ls4,.Ls4e
-	.quad .Ld1,.Ls1e
+	.quad .Ls1,.Ls1e	/* .Ls[1-4] - 0 bytes copied */
+	.quad .Ls2,.Ls1e
+	.quad .Ls3,.Ls1e
+	.quad .Ls4,.Ls1e
+	.quad .Ld1,.Ls1e	/* .Ld[1-4] - 0..24 bytes coped */
 	.quad .Ld2,.Ls2e
 	.quad .Ld3,.Ls3e
 	.quad .Ld4,.Ls4e
-	.quad .Ls5,.Ls5e
-	.quad .Ls6,.Ls6e
-	.quad .Ls7,.Ls7e
-	.quad .Ls8,.Ls8e
-	.quad .Ld5,.Ls5e
+	.quad .Ls5,.Ls5e	/* .Ls[5-8] - 32 bytes copied */
+	.quad .Ls6,.Ls5e
+	.quad .Ls7,.Ls5e
+	.quad .Ls8,.Ls5e
+	.quad .Ld5,.Ls5e	/* .Ld[5-8] - 32..56 bytes copied */
 	.quad .Ld6,.Ls6e
 	.quad .Ld7,.Ls7e
 	.quad .Ld8,.Ls8e
@@ -172,11 +172,8 @@ ENTRY(__copy_user_nocache)
 	.quad .Le5,.Le_zero
 	.previous
 
-	/* compute 64-offset for main loop. 8 bytes accuracy with error on the
-	   pessimistic side. this is gross. it would be better to fix the
-	   interface. */
 	/* eax: zero, ebx: 64 */
-.Ls1e: 	addl $8,%eax
+.Ls1e: 	addl $8,%eax	/* eax: bytes left uncopied: Ls1e: 64 .. Ls8e: 8 */
 .Ls2e: 	addl $8,%eax
 .Ls3e: 	addl $8,%eax
 .Ls4e: 	addl $8,%eax




