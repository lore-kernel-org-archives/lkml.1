Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758176AbYLQLNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176AbYLQLNf (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 06:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbYLQLNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 06:13:05 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:20468 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbYLQLND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 06:13:03 -0500
Date: Wed, 17 Dec 2008 12:12:14 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: David Howells <dhowells@redhat.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>, linux-arch@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: PROC macro to annotate functions in assembly files
Message-ID: <20081217111213.GA8342@mailshack.com>
References: <1229505475-10219-1-git-send-email-heukelum@fastmail.fm> <1636.1229511233@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1636.1229511233@redhat.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Wed, 17 Dec 2008 12:12:15 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.9.0.45; VDF: 7.1.0.245; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 10:53:53AM +0000, David Howells wrote:
> Alexander van Heukelum <heukelum@fastmail.fm> wrote:
> 
> > The goal is to annotate functions, at least those called
> > from C code, with PROC at the beginning and ENDPROC at the
> > end. This is for the benefit of debugging and tracing.
> 
> What about asm functions that have multiple entry points?
> 
> Take arch/mn10300/mm/cache-flush-mn10300.S for example.  Several functions in
> there share bodies by virtue of falling through one to another.
> 
> David

Yeah, assembly files contain some interesting nesting. In this
particular case I think the solution is simple... Just use PROC
and ENDPROC around the complete functions, and leave the explicit
.global's for the additional entry points.

Have a look at arch/x86/crypto/aes-x86_64-asm_64.S too if you wish ;).

Greetings,
	Alexander

 arch/mn10300/mm/cache-flush-mn10300.S |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/mn10300/mm/cache-flush-mn10300.S b/arch/mn10300/mm/cache-flush-mn10300.S
index c8ed1cb..2c0f26d 100644
--- a/arch/mn10300/mm/cache-flush-mn10300.S
+++ b/arch/mn10300/mm/cache-flush-mn10300.S
@@ -16,12 +16,9 @@
 #include <asm/cache.h>
 
 	.am33_2
-	.globl mn10300_dcache_flush
-	.globl mn10300_dcache_flush_page
+	/* nested entry points */
 	.globl mn10300_dcache_flush_range
 	.globl mn10300_dcache_flush_range2
-	.globl mn10300_dcache_flush_inv
-	.globl mn10300_dcache_flush_inv_page
 	.globl mn10300_dcache_flush_inv_range
 	.globl mn10300_dcache_flush_inv_range2
 
@@ -31,8 +28,8 @@
 # Flush the entire data cache back to RAM
 #
 ###############################################################################
-	ALIGN
-mn10300_dcache_flush:
+
+PROC(mn10300_dcache_flush)
 	movhu	(CHCTR),d0
 	btst	CHCTR_DCEN,d0
 	beq	mn10300_dcache_flush_end
@@ -59,6 +56,7 @@ mn10300_dcache_flush_skip:
 
 mn10300_dcache_flush_end:
 	ret	[],0
+ENDPROC(mn10300_dcache_flush)
 
 ###############################################################################
 #
@@ -68,8 +66,8 @@ mn10300_dcache_flush_end:
 # Flush a range of addresses on a page in the dcache
 #
 ###############################################################################
-	ALIGN
-mn10300_dcache_flush_page:
+
+PROC(mn10300_dcache_flush_page)
 	mov	PAGE_SIZE,d1
 mn10300_dcache_flush_range2:
 	add	d0,d1
@@ -113,6 +111,7 @@ mn10300_dcache_flush_range_loop:
 
 mn10300_dcache_flush_range_end:
 	ret	[d2,d3],8
+ENDPROC(mn10300_dcache_flush_page)
 
 ###############################################################################
 #
@@ -120,8 +119,8 @@ mn10300_dcache_flush_range_end:
 # Flush the entire data cache and invalidate all entries
 #
 ###############################################################################
-	ALIGN
-mn10300_dcache_flush_inv:
+
+PROC(mn10300_dcache_flush_inv)
 	movhu	(CHCTR),d0
 	btst	CHCTR_DCEN,d0
 	beq	mn10300_dcache_flush_inv_end
@@ -139,6 +138,7 @@ mn10300_dcache_flush_inv_loop:
 
 mn10300_dcache_flush_inv_end:
 	ret	[],0
+ENDPROC(mn10300_dcache_flush_inv)
 
 ###############################################################################
 #
@@ -148,8 +148,8 @@ mn10300_dcache_flush_inv_end:
 # Flush and invalidate a range of addresses on a page in the dcache
 #
 ###############################################################################
-	ALIGN
-mn10300_dcache_flush_inv_page:
+
+PROC(mn10300_dcache_flush_inv_page)
 	mov	PAGE_SIZE,d1
 mn10300_dcache_flush_inv_range2:
 	add	d0,d1
@@ -190,3 +190,4 @@ mn10300_dcache_flush_inv_range_loop:
 
 mn10300_dcache_flush_inv_range_end:
 	ret	[d2,d3],8
+ENDPROC(mn10300_dcache_flush_inv_page)

