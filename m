Return-Path: <linux-kernel-owner+w=401wt.eu-S936584AbXHNXae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936584AbXHNXae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 19:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934755AbXHNXaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 19:30:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57467 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbXHNX37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 19:29:59 -0400
Date: Wed, 15 Aug 2007 05:12:41 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Arjan van de Ven <arjan@infradead.org>
cc: Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: kfree(0) - ok?
In-Reply-To: <1187132149.2618.2.camel@laptopd505.fenrus.org>
Message-ID: <alpine.LFD.0.999.0708150454480.6482@enigma.security.iitk.ac.in>
References: <46C233CB.9000602@am.sony.com>
 <1187132149.2618.2.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 14 Aug 2007, Arjan van de Ven wrote:

> 
> On Tue, 2007-08-14 at 15:59 -0700, Tim Bird wrote:
> > Hi all,
> > 
> > I have a quick question.
> > 
> > I'm trying to resurrect a patch from the Linux-tiny patch suite,
> > to do accounting of kmalloc memory allocations.  In testing it
> > with Linux 2.6.22, I've found a large number of kfrees of
> > NULL pointers.
> > 
> > Is this considered OK?  Or should I examine the offenders
> > to see if something is coded badly?
> 
> kfree(NULL) is explicitly ok and it saves code size to not check
> anywhere

But that doesn't come free of cost, does it, seeing we've now pushed
the conditional inside kfree() itself. kfree() isn't inlined so we do
save on space but lose out on the extra time overhead for the common
case. Speaking of which ...

[PATCH] {slub, slob}: use unlikely() for kfree(ZERO_OR_NULL_PTR) check

Considering kfree(NULL) would normally occur only in error paths and
kfree(ZERO_SIZE_PTR) is uncommon as well, so let's use unlikely() for
the condition check in SLUB's and SLOB's kfree() to optimize for the
common case. SLAB has this already.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 mm/slob.c |    2 +-
 mm/slub.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slob.c b/mm/slob.c
index ec33fcd..37a8b9a 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -466,7 +466,7 @@ void kfree(const void *block)
 {
 	struct slob_page *sp;
 
-	if (ZERO_OR_NULL_PTR(block))
+	if (unlikely(ZERO_OR_NULL_PTR(block)))
 		return;
 
 	sp = (struct slob_page *)virt_to_page(block);
diff --git a/mm/slub.c b/mm/slub.c
index 69d02e3..3788537 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2467,7 +2467,7 @@ void kfree(const void *x)
 	 * this comparison would be true for all "negative" pointers
 	 * (which would cover the whole upper half of the address space).
 	 */
-	if (ZERO_OR_NULL_PTR(x))
+	if (unlikely(ZERO_OR_NULL_PTR(x)))
 		return;
 
 	page = virt_to_head_page(x);
