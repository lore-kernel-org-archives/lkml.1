Return-Path: <linux-kernel-owner+w=401wt.eu-S1767024AbXDSUZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767024AbXDSUZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 16:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767025AbXDSUZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 16:25:31 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:57880 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767024AbXDSUZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 16:25:30 -0400
Subject: Re: [PATCH 13/13] maps#2: Add /proc/kpagemap interface
From: Dave Hansen <hansendc@us.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070419200226.GG11115@waste.org>
References: <14.469046093@selenic.com>
	 <1177009598.12599.152.camel@localhost.localdomain>
	 <20070419200226.GG11115@waste.org>
Content-Type: text/plain
Date: Thu, 19 Apr 2007 13:25:25 -0700
Message-Id: <1177014325.12599.166.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-19 at 15:02 -0500, Matt Mackall wrote:
> On Thu, Apr 19, 2007 at 12:06:38PM -0700, Dave Hansen wrote:
> > On Fri, 2007-04-06 at 17:03 -0500, Matt Mackall wrote:
> > > 
> > > +static ssize_t kpagemap_read(struct file *file, char __user *buf,
> > > +                            size_t count, loff_t *ppos)
> > > +{
> > ...
> > > +               for (; i < 2 * chunk / KPMSIZE; i += 2, pfn++) {
> > > +                       ppage = pfn_to_page(pfn);
> > > +                       if (!ppage) {
> > > +                               page[i] = 0;
> > > +                               page[i + 1] = 0;
> > > +                       } else {
> > > +                               page[i] = ppage->flags;
> > > +                               page[i + 1] = atomic_read(&ppage->_count);
> > > +                       }
> > > +               } 
> > 
> > I think this needs a pfn_valid() check for sparse/discontig systems.  I
> > think we'll oops if we have holes because we don't check pfn_valid()
> > inside of pfn_to_page().
> 
> Are there cases where pfn_valid is true but pfn_to_page doesn't work?
> In other words, do I still only need two cases?

pfn_valid() will at least guarantee that pfn_to_page() will give you
_some_ 'struct page' back.  

However, it isn't an absolute guarantee that there is actual physical
memory backing that struct page.  For your use here, it should be OK,
but it might be a bit confusing if anyone ever ends up with more entries
in that /proc file than they have pages of total memory.

But, this is a pretty low-level debugging mechanism, and I'm not sure
this is very easy to solve in an arch-independent way.

I'd probably just leave it looking something like this:

+               for (; i < 2 * chunk / KPMSIZE; i += 2, pfn++) {
+                       if (!pfn_valid(pfn)) {
+                              page[i] = 0;
+                              page[i + 1] = 0;
+                       } else {
+	                       ppage = pfn_to_page(pfn);
+                              page[i] = ppage->flags;
+                              page[i + 1] = atomic_read(&ppage->_count);
+                       }
+               } 

BTW, page->flags can be quite config-dependent on how stuff is stored in
there, especially with the zone, node, and section information encoded
in there.  Do you, perhaps, want to just spit out the bits that are
actual PageFoo() flags?

-- Dave

