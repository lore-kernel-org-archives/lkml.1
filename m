Return-Path: <linux-kernel-owner+w=401wt.eu-S1754816AbZILPgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbZILPgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 11:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbZILPgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 11:36:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:40587 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745AbZILPgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 11:36:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,376,1249282800"; 
   d="scan'208";a="186920222"
Date: Sat, 12 Sep 2009 23:36:09 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>,
       Avi Kivity <avi@qumranet.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] devmem: remove redundant parameter from
	do_write_kmem()
Message-ID: <20090912153609.GA12510@localhost>
References: <20090912152039.479536123@intel.com> <20090912152259.384529634@intel.com> <1252769454.28368.66.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252769454.28368.66.camel@desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12, 2009 at 11:30:54PM +0800, Daniel Walker wrote:
> On Sat, 2009-09-12 at 23:20 +0800, Wu Fengguang wrote:
> >  static inline ssize_t
> > -do_write_kmem(void *p, unsigned long realp, const char __user * buf,
> > +do_write_kmem(unsigned long p, const char __user * buf,
> >               size_t count, loff_t *ppos)
> >  {
> 
> There's one style issue in the block above. Could you run your patches
> through checkpatch and fix whatever errors it reports?

Thanks for catching it!  Here is the updated patch.
(I ran checkpatch against the first two bugs but forgot this last one..)

--
devmem: remove redundant parameter from do_write_kmem()

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Daniel Walker <dwalker@fifo99.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/char/mem.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- linux-mm.orig/drivers/char/mem.c	2009-09-12 23:17:12.000000000 +0800
+++ linux-mm/drivers/char/mem.c	2009-09-12 23:35:18.000000000 +0800
@@ -465,7 +465,7 @@ static ssize_t read_kmem(struct file *fi
 
 
 static inline ssize_t
-do_write_kmem(void *p, unsigned long realp, const char __user * buf,
+do_write_kmem(unsigned long p, const char __user *buf,
 	      size_t count, loff_t *ppos)
 {
 	ssize_t written, sz;
@@ -474,12 +474,11 @@ do_write_kmem(void *p, unsigned long rea
 	written = 0;
 #ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
 	/* we don't have page 0 mapped on sparc and m68k.. */
-	if (realp < PAGE_SIZE) {
-		sz = size_inside_page(realp, count);
+	if (p < PAGE_SIZE) {
+		sz = size_inside_page(p, count);
 		/* Hmm. Do something? */
 		buf += sz;
 		p += sz;
-		realp += sz;
 		count -= sz;
 		written += sz;
 	}
@@ -488,14 +487,14 @@ do_write_kmem(void *p, unsigned long rea
 	while (count > 0) {
 		char *ptr;
 
-		sz = size_inside_page(realp, count);
+		sz = size_inside_page(p, count);
 
 		/*
 		 * On ia64 if a page has been mapped somewhere as
 		 * uncached, then it must also be accessed uncached
 		 * by the kernel or data corruption may occur
 		 */
-		ptr = xlate_dev_kmem_ptr(p);
+		ptr = xlate_dev_kmem_ptr((char *)p);
 
 		copied = copy_from_user(ptr, buf, sz);
 		if (copied) {
@@ -506,7 +505,6 @@ do_write_kmem(void *p, unsigned long rea
 		}
 		buf += sz;
 		p += sz;
-		realp += sz;
 		count -= sz;
 		written += sz;
 	}
@@ -530,7 +528,7 @@ static ssize_t write_kmem(struct file * 
 	if (p < (unsigned long) high_memory) {
 		unsigned long to_write = min_t(unsigned long, count,
 					       (unsigned long)high_memory - p);
-		wrote = do_write_kmem((void *)p, p, buf, to_write, ppos);
+		wrote = do_write_kmem(p, buf, to_write, ppos);
 		if (wrote != to_write)
 			return wrote;
 		p += wrote;
