Return-Path: <linux-kernel-owner+w=401wt.eu-S1761811AbXHTTbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761811AbXHTTbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 15:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760015AbXHTTbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 15:31:09 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:61786 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756307AbXHTTbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 15:31:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=h4BQskyO4TGNWqeYWxdSBbBLXSIV3mz0WQTaNaW6B8ajGypJCaaXY8kORIraxdmINd3LiCfHvmmu4zHpdDPgVHKdFrWgj6nVl59YII7GptER0GQpuJRxzGECv8ZMAOS0DTU64a8oN02vifFekY1GTfpG/GsdT2dUxpk3TZqEUQs=
Date: Mon, 20 Aug 2007 23:31:03 +0400
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org
Subject: Re: Kernel oops during netfilter memory allocation
Message-ID: <20070820193103.GC2488@martell.zuzino.mipt.ru>
References: <200708201808.08880.thomas.jarosch@intra2net.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708201808.08880.thomas.jarosch@intra2net.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2007 at 06:08:08PM +0200, Thomas Jarosch wrote:
> I'm currently debugging a kernel oops with kernel 2.6.21.7 that occurs
> from time to time with our netfilter accounting module ipt_ACCOUNT 
> (http://www.intra2net.com/de/produkte/opensource/ipt_account/).

	kernel BUG at arch/i386/mm/highmem.c:38
 
> static unsigned int ipt_crash_target(struct sk_buff **pskb,
>                                    const struct net_device *in,
>                                    const struct net_device *out,
>                                    unsigned int hooknum,
> #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,17)
>                                    const struct xt_target *target,
> #endif
> #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,19)
>                                    const void *targinfo)
> #else
>                                    const void *targinfo,
>                                    void *userinfo)
> #endif
> {
>     char *data;
> 
>     spin_lock_bh(&ipt_crash_lock);
> 
>     if ((data = (char *)get_zeroed_page(GFP_ATOMIC)) == NULL) {

Try this.

commit b8c1c5da1520977cb55a358f20fc09567d40cad9
tree c762e6ad77297beed0978337ce2f5b0c50add739
parent 01e457cfcd5b6b6f18d0bb8cec0c5d43df56557e
author Andrew Morton <akpm@linux-foundation.org> 1185303760 -0700
committer Linus Torvalds <torvalds@woody.linux-foundation.org> 1185305099 -0700

slab: correctly handle __GFP_ZERO

Use the correct local variable when calling into the page allocator.  Local
`flags' can have __GFP_ZERO set, which causes us to pass __GFP_ZERO into the
page allocator, possibly from illegal contexts.  The page allocator will later
do prep_zero_page()->kmap_atomic(..., KM_USER0) from irq contexts and will
then go BUG.

Cc: Mike Galbraith <efault@gmx.de>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
diff --git a/mm/slab.c b/mm/slab.c
index bde271c..a684778 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2776,7 +2776,7 @@ static int cache_grow(struct kmem_cache *cachep,
 	 * 'nodeid'.
 	 */
 	if (!objp)
-		objp = kmem_getpages(cachep, flags, nodeid);
+		objp = kmem_getpages(cachep, local_flags, nodeid);
 	if (!objp)
 		goto failed;
 
