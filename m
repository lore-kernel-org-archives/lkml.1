Return-Path: <linux-kernel-owner+w=401wt.eu-S1766942AbXDSTKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766942AbXDSTKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 15:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766944AbXDSTKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 15:10:37 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58309 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766942AbXDSTKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 15:10:36 -0400
Date: Thu, 19 Apr 2007 12:10:34 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Adam Litke <aglitke@gmail.com>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 4/8] Enhance fallback functions in libs to support higher
 order pages
In-Reply-To: <a0a62dfc0704191148v15434469kc3130821cb251072@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0704191208340.12936@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
  <20070419163525.11948.3482.sendpatchset@schroedinger.engr.sgi.com>
 <a0a62dfc0704191148v15434469kc3130821cb251072@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007, Adam Litke wrote:

> On 4/19/07, Christoph Lameter <clameter@sgi.com> wrote:
> > @@ -331,11 +331,15 @@ int simple_prepare_write(struct file *fi
> >                         unsigned from, unsigned to)
> >  {
> >         if (!PageUptodate(page)) {
> > -               if (to - from != PAGE_CACHE_SIZE) {
> > +               if (to - from != page_cache_size(file->f_mapping)) {
> 
> Where do you introduce page_cache_size()?  Is this added by a
> different set of patches I should have applied first?

Yuck. Missed that one in the control file. Insert this patch before this 
one.



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
