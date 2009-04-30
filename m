Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbZD3KhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbZD3KhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 06:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZD3Kg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 06:36:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:60282 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbZD3Kg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 06:36:56 -0400
Date: Thu, 30 Apr 2009 12:36:54 +0200
From: Nick Piggin <npiggin@suse.de>
To: Valdis.Kletnieks@vt.edu, Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-04-24-18-14 uploaded - NVidia indigestion
Message-ID: <20090430103654.GB6900@wotan.suse.de>
References: <200904250133.n3P1XBJn006790@imap1.linux-foundation.org> <5622.1240628800@turing-police.cc.vt.edu> <20090425052434.GE10088@wotan.suse.de> <57773.1240857915@turing-police.cc.vt.edu> <20090428061557.GA29299@wotan.suse.de> <20954.1240934481@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20954.1240934481@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 12:01:21PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 28 Apr 2009 08:15:57 +0200, Nick Piggin said:
> 
> Here's the code (pretty much *all* the code):
> 
> > #include <linux/version.h>
> > #include <linux/utsname.h>
> > int main() {
> > 	if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)) {
> > 		return 0;
> > 	} else {
> > 		return 1;
> > 	}
> > }
> 
> > Hmm, yes if you build without -O, then it appears like the compiler
> > trips over this. I wouldn't be unhappy with just removing the BUILD_BUG_ON,
> > but shouldn't the module be using -O[s2]?
> 
> It's a little autoconfig chunk from vendor code that determines if we're
> building on a sane/recent kernel.  Not the sort of thing you'd expect to
> need to invoke the frikking optimizer for program *correctness* :)
> 
> 

Pekka, can you apply this please?

Thanks,
Nick

--
SLQB: fix compile without optmisations

SLQB fails to build without -O, which causes some external code to trip
over. This BUILD_BUG_ON isn't so useful anyway because it is trivial to
follow that size will be constant, looking at the callers.

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/include/linux/slqb_def.h
===================================================================
--- linux-2.6.orig/include/linux/slqb_def.h	2009-04-29 20:35:45.000000000 +1000
+++ linux-2.6/include/linux/slqb_def.h	2009-04-29 21:25:40.000000000 +1000
@@ -237,8 +238,6 @@ static __always_inline struct kmem_cache
 {
 	int index;
 
-	BUILD_BUG_ON(!__builtin_constant_p(size));
-
 	index = kmalloc_index(size);
 	if (unlikely(index == 0))
 		return ZERO_SIZE_PTR;
