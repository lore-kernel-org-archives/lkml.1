Return-Path: <linux-kernel-owner+w=401wt.eu-S1754584Ab0AECRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab0AECRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 21:17:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475Ab0AECRC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:17:02 -0500
Received: from mga14.intel.com ([143.182.124.37]:6139 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605Ab0AECQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:16:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="229195214"
Date: Tue, 5 Jan 2010 10:16:53 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Quentin Barnes <qbarnes+nfs@yahoo-inc.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>, Steven Whitehouse <swhiteho@redhat.com>,
       David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH v3] readahead: introduce O_RANDOM for
	POSIX_FADV_RANDOM
Message-ID: <20100105021652.GA29428@localhost>
References: <20091225000717.GA26949@yahoo-inc.com> <87aax18xms.fsf@basil.nowhere.org> <20091230051540.GA16308@localhost> <20091230052402.GB26364@localhost> <873a2s8hmp.fsf@basil.nowhere.org> <20100104045020.GA21021@localhost> <28c262361001032120v284e92b5ub1211f3d1fca6140@mail.gmail.com> <20100104121642.GA12266@localhost> <28c262361001041746j1270e2d2i79a932efca861dc5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <28c262361001041746j1270e2d2i79a932efca861dc5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 05, 2010 at 09:46:09AM +0800, Minchan Kim wrote:
> On Mon, Jan 4, 2010 at 9:16 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > Hi Minchan,
> >
> > On Mon, Jan 04, 2010 at 01:20:49PM +0800, Minchan Kim wrote:
> >> > --- linux.orig/mm/readahead.c   2010-01-04 12:39:29.000000000 +0800
> >> > +++ linux/mm/readahead.c        2010-01-04 12:39:30.000000000 +0800
> >> > @@ -501,6 +501,12 @@ void page_cache_sync_readahead(struct ad
> >> >        if (!ra->ra_pages)
> >> >                return;
> >> >
> >> > +       /* be dumb */
> >> > +       if (filp->f_flags & O_RANDOM) {
> >> > +               force_page_cache_readahead(mapping, filp, offset, req_size);
> >> > +               return;
> >> > +       }
> >> > +
> >>
> >> Let me have a dumb question. :)
> >>
> >> How about testing O_RANDOM in front of ra_pages testing?
> >>
> >> My intention is that although we turn off ra, it would be better to read
> >> contiguous block all at once than readpage() callback doing I/O
> >> one page at a time.
> >>
> >> Is it break some semantics or happen some problem in ondemand readahead?
> >
> > Yes it will have some problem with shrink_readahead_size_eio(), which
> > want to disable readahead and use ->readpage() when ra_pages==0.
> >
> > Do you have specific use case in mind? The file systems that set
> > ra_pages=0 seems to don't need readahead, too.
> 
> Never mind. It's just out of curiosity. :)
> 
> I thought although user disable readahead, we could enhance file I/O
> with one readpages not multiple readpage if we know the user want to
> read big contiguous blocks.

Yes, not-break-large-read-into-pages would be good for HD/SSD drives
when readahead is disabled.

Currently, ->ra_pages is somehow overloaded in its ==0 case. As you
said, it's in fact possible to disable readahead while still limiting
read IO size to a non-zero ->ra_pages.

> But I though it break current readahead off semantics. right?

It can be done by applying the ->ra_pages limit to O_RANDOM. This also
makes O_RANDOM safer to use:

@@ -497,6 +497,13 @@ void page_cache_sync_readahead(struct ad
                               struct file_ra_state *ra, struct file *filp,
                               pgoff_t offset, unsigned long req_size)
 {
+       /* be dumb */
+       if (filp->f_flags & O_RANDOM) {
+               req_size = clamp_t(unsigned long, req_size, 1, ra->ra_pages);
+               force_page_cache_readahead(mapping, filp, offset, req_size);
+               return;
+       }
+      
        /* no read-ahead */
        if (!ra->ra_pages)
                return;

To make real change, we need an interface for the user to disable
whole-partition readahead by setting O_RANDOM instead of ra_pages=0.
That would be a hard sell..

> Thanks for reply about my dumb question, Wu. :)

You are welcome :)

Thanks,
Fengguang
