Return-Path: <linux-kernel-owner+w=401wt.eu-S1751751AbZIOJE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbZIOJE0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbZIOJEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:04:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:45958 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZIOJEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:04:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,388,1249282800"; 
   d="scan'208";a="187729908"
Date: Tue, 15 Sep 2009 17:03:54 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Greg KH <greg@kroah.com>, Andi Kleen <andi@firstfloor.org>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Tejun Heo <tj@kernel.org>, Nick Piggin <npiggin@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] devmem: handle partial kmem write/read
Message-ID: <20090915090354.GA8292@localhost>
References: <20090915021851.168285585@intel.com> <20090915022328.460943370@intel.com> <20090915113811.6b44877c.kamezawa.hiroyu@jp.fujitsu.com> <20090915090130.GA4970@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915090130.GA4970@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 05:01:30PM +0800, Wu Fengguang wrote:
> On Tue, Sep 15, 2009 at 10:38:11AM +0800, KAMEZAWA Hiroyuki wrote:
> > On Tue, 15 Sep 2009 10:18:53 +0800
> > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > > Return early on partial read/write, which may happen in future.
> > > (eg. hit hwpoison pages)
> > > 
> > Hmm, please modify vread() as you did in vwrite() and
> > 
> > ==
> >                kbuf = (char *)__get_free_page(GFP_KERNEL);
> >                 if (!kbuf)
> >                         return -ENOMEM;
> > ==
> > Add __GFP_ZERO to kbuf allocation, and just ignore vread()'s return value.
> > Then, this will be much simpler.
> 
> Thanks, here is the updated patch, which
> - updates vread/vwrite prototype to return 0 (or error code in future).
> - do zero fill in the callers
> Comment updates are ignored for now.

This patch also makes it trivial to add your
is_vmalloc_or_module_addr() fixes, like this :)

---
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/char/mem.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- linux-mm.orig/drivers/char/mem.c	2009-09-15 16:58:06.000000000 +0800
+++ linux-mm/drivers/char/mem.c	2009-09-15 16:58:12.000000000 +0800
@@ -446,6 +446,10 @@ static ssize_t read_kmem(struct file *fi
 			return -ENOMEM;
 		while (count > 0) {
 			sz = size_inside_page(p, count);
+			if (!is_vmalloc_or_module_addr((void*)p)) {
+				ret = -EFAULT;
+				break;
+			}
 			ret = vread(kbuf, (char *)p, sz);
 			if (ret)
 				break;
@@ -546,6 +550,10 @@ static ssize_t write_kmem(struct file * 
 			unsigned long sz = size_inside_page(p, count);
 			unsigned long n;
 
+			if (!is_vmalloc_or_module_addr((void*)p)) {
+				ret = -EFAULT;
+				break;
+			}
 			n = copy_from_user(kbuf, buf, sz);
 			if (n) {
 				if (wrote + virtr)
