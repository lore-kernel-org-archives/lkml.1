Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbXEARvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbXEARvt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 13:51:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755163AbXEARvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 13:51:49 -0400
Received: from hoboe2bl1.telenet-ops.be ([195.130.137.73]:44764 "EHLO
	hoboe2bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151AbXEARvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 13:51:48 -0400
Date: Tue, 1 May 2007 19:51:46 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [AF_RXRPC]: Make the in-kernel AFS filesystem use AF_RXRPC.
In-Reply-To: <alpine.LFD.0.98.0705010918550.3808@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705011946430.27246@anakin>
References: <200704271707.l3RH7H5Z032671@hera.kernel.org>
 <Pine.LNX.4.64.0705011734410.27246@anakin>
 <alpine.LFD.0.98.0705010918550.3808@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, Linus Torvalds wrote:
> On Tue, 1 May 2007, Geert Uytterhoeven wrote:
> > This causes a compile failure on m68k:
> > 
> > | linux/fs/afs/fsclient.c: In function 'afs_deliver_fs_fetch_data':
> > | linux/fs/afs/fsclient.c:269: warning: dereferencing 'void *' pointer
> > | linux/fs/afs/fsclient.c:269: error: request for member 'virtual' in something not a structure or union
> > 
> > Probably you wanted to assign call->reply3 to a struct page pointer first, like you do for the call->unmarshall == 2 case.
> 
> Hmm. Wouldn't it be nicer to make "kmap_atomic()" be an inline function 
> instead? That way, if you pass it a "void *", it still just works, and you 
> get a much nicer/more readable error message too when the types actually 
> don't match?

Of course.

> Of course, there may be some reason why <linux/highmem.h> does those with 
> #define's rather than inline functions. Maybe "page_address()" or 
> "pagefault_disabled()" is not declared at that point, and asking it to be 
> declared might cause header file inclusion recursion?

That's what I was afraid of, too...

However, this change seems to build fine (for one of my test configs):

Convert kmap_atomic() in the non-highmem case from a macro to a static
inline function, for better type-checking and the ability to pass void
pointers instead of struct page pointers.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

--- linux-m68k-2.6.21/include/linux/highmem.h
+++ linux-m68k-2.6.21/include/linux/highmem.h
@@ -42,8 +42,14 @@ static inline void *kmap(struct page *pa
 
 #define kunmap(page) do { (void) (page); } while (0)
 
-#define kmap_atomic(page, idx) \
-	({ pagefault_disable(); page_address(page); })
+#include <asm/kmap_types.h>
+
+static inline void *kmap_atomic(struct page *page, enum km_type idx)
+{
+	pagefault_disable();
+	return page_address(page);
+}
+
 #define kunmap_atomic(addr, idx)	do { pagefault_enable(); } while (0)
 #define kmap_atomic_pfn(pfn, idx)	kmap_atomic(pfn_to_page(pfn), (idx))
 #define kmap_atomic_to_page(ptr)	virt_to_page(ptr)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
