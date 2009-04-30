Return-Path: <linux-kernel-owner+w=401wt.eu-S1751750AbZD3Gln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbZD3Gln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 02:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbZD3Glb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 02:41:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:54879 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbZD3Glb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 02:41:31 -0400
Date: Thu, 30 Apr 2009 08:41:27 +0200
From: Nick Piggin <npiggin@suse.de>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linuxppc-dev@ozlabs.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: Next April 28: boot failure on PowerPC with SLQB
Message-ID: <20090430064127.GF23746@wotan.suse.de>
References: <20090428165343.2e357d7a.sfr@canb.auug.org.au> <49F6E421.401@in.ibm.com> <84144f020904280422s6a9a277fjc4619c904f37e5ca@mail.gmail.com> <20090429113604.GE3398@wotan.suse.de> <49F87FAB.9050408@in.ibm.com> <20090430041146.GB23746@wotan.suse.de> <49F938E4.2030703@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49F938E4.2030703@in.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 30, 2009 at 11:06:36AM +0530, Sachin Sant wrote:
> Nick Piggin wrote:
> >Well kmalloc is failing. It should not be though, even if the
> >current node is offline, it should be able to fall back to other
> >nodes. Stephen's trace indicates the same thing.
> >
> >Could you try the following patch please, and capture the output
> >it generates?
> With this patch i don't get any extra information other that what is 
> already reported.
> Have attached the boot log captured using loglevel=8 mminit_loglevel=4 
> options.

Hmm, forget that. Actually my last patch had a silly mistake because I
forgot MAX_ORDER shift is applied to PAGE_SIZE, rather than 1. So
kmalloc(PAGE_SIZE) was failing as too large.

This patch should do the trick I hope.

Thanks,
Nick
---
 include/linux/slqb_def.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/include/linux/slqb_def.h
===================================================================
--- linux-2.6.orig/include/linux/slqb_def.h
+++ linux-2.6/include/linux/slqb_def.h
@@ -172,7 +172,8 @@ struct kmem_cache {
 #endif
 
 #define KMALLOC_SHIFT_LOW ilog2(KMALLOC_MIN_SIZE)
-#define KMALLOC_SHIFT_SLQB_HIGH (PAGE_SHIFT + 9)
+#define KMALLOC_SHIFT_SLQB_HIGH (PAGE_SHIFT + 			\
+				 ((9 <= (MAX_ORDER - 1)) ? 9 : (MAX_ORDER - 1)))
 
 extern struct kmem_cache kmalloc_caches[KMALLOC_SHIFT_SLQB_HIGH + 1];
 extern struct kmem_cache kmalloc_caches_dma[KMALLOC_SHIFT_SLQB_HIGH + 1];
