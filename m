Return-Path: <linux-kernel-owner+w=401wt.eu-S1766944AbXDSTMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766944AbXDSTMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 15:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766947AbXDSTMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 15:12:13 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58502 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766944AbXDSTML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 15:12:11 -0400
Date: Thu, 19 Apr 2007 12:12:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Badari Pulavarty <pbadari@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>, Andi Kleen <ak@suse.de>
Subject: Re: [RFC 0/8] Variable Order Page Cache
In-Reply-To: <1177009768.19676.0.camel@dyn9047017100.beaverton.ibm.com>
Message-ID: <Pine.LNX.4.64.0704191211400.12936@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
 <1177009768.19676.0.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007, Badari Pulavarty wrote:

> On Thu, 2007-04-19 at 09:35 -0700, Christoph Lameter wrote:
> > Variable Order Page Cache Patchset
> > 
> 
> ..
> mm/built-in.o: In function `__generic_file_aio_write_nolock':
> filemap.c:(.text+0x295c): undefined reference to `page_cache_shift'
> filemap.c:(.text+0x296c): undefined reference to `page_cache_shift'
> fs/built-in.o: In function `simple_commit_write':
> (.text+0x20866): undefined reference to `page_cache_shift'
> fs/built-in.o: In function `simple_prepare_write':
> (.text+0x2097b): undefined reference to `page_cache_size'
> fs/built-in.o: In function `simple_prepare_write':
> (.text+0x209cd): undefined reference to `page_cache_size'

Sigh. You need this patch that I did not include

Variable Order Page Cache: Add functions to establish sizes

We use the macros PAGE_CACHE_SIZE PAGE_CACHE_SHIFT PAGE_CACHE_MASK
and PAGE_CACHE_ALIGN in various places in the kernel. These are now
the base page size but we do not have a means to calculating these
values for higher order pages.

Provide these functions. An address_space pointer must be passed
to them.

New function			Related base page constant
---------------------------------------------------
page_cache_shift(a)		PAGE_CACHE_SHIFT
page_cache_size(a)		PAGE_CACHE_SIZE
page_cache_mask(a)		PAGE_CACHE_MASK
page_cache_align(addr,a)	PAGE_CACHE_ALIGN(addr)

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/pagemap.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

Index: linux-2.6.21-rc7/include/linux/pagemap.h
===================================================================
--- linux-2.6.21-rc7.orig/include/linux/pagemap.h	2007-04-18 23:01:09.000000000 -0700
+++ linux-2.6.21-rc7/include/linux/pagemap.h	2007-04-18 23:03:32.000000000 -0700
@@ -49,6 +49,27 @@ static inline void mapping_set_gfp_mask(
 #define PAGE_CACHE_MASK		PAGE_MASK
 #define PAGE_CACHE_ALIGN(addr)	(((addr)+PAGE_CACHE_SIZE-1)&PAGE_CACHE_MASK)
 
+static inline int page_cache_shift(struct address_space *a)
+{
+	return a->order + PAGE_CACHE_SHIFT;
+}
+
+static inline unsigned long page_cache_size(struct address_space *a)
+{
+	return PAGE_CACHE_SIZE << a->order;
+}
+
+static inline unsigned long page_cache_mask(struct address_space *a)
+{
+	return PAGE_CACHE_MASK << a->order;
+}
+
+static inline unsigned long page_cache_align(unsigned long addr,
+		struct address_space *a)
+{
+	return (((addr) + page_cache_size(a) - 1) & page_cache_mask(a));
+}
+
 #define page_cache_get(page)		get_page(page)
 #define page_cache_release(page)	put_page(page)
 void release_pages(struct page **pages, int nr, int cold);
