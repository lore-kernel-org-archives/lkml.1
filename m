Return-Path: <linux-kernel-owner+w=401wt.eu-S1758309AbZEBSfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309AbZEBSfn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 14:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757667AbZEBSfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 14:35:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757339AbZEBSfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 14:35:24 -0400
Date: Sat, 2 May 2009 11:26:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Kyle Moffett <kyle@moffetthome.net>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 02/16] DRBD: lru_cache
Message-Id: <20090502112609.67637bc6.akpm@linux-foundation.org>
In-Reply-To: <20090502181311.GG6466@racke>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
	<1241090812-13516-2-git-send-email-philipp.reisner@linbit.com>
	<1241090812-13516-3-git-send-email-philipp.reisner@linbit.com>
	<20090501015956.ef663e9b.akpm@linux-foundation.org>
	<20090502152620.GA6466@racke>
	<20090502105823.bf27bf22.akpm@linux-foundation.org>
	<20090502181311.GG6466@racke>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 May 2009 20:13:12 +0200 Lars Ellenberg <lars.ellenberg@linbit.com> wrote:

> On Sat, May 02, 2009 at 10:58:23AM -0700, Andrew Morton wrote:
> > On Sat, 2 May 2009 17:26:20 +0200 Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
> > 
> > > in memory structure is
> > > 
> > > struct lru_cache {
> > >         struct list_head active;
> > >         struct list_head quiet;
> > >         struct list_head free;
> > >         size_t element_size;          <-- parameter to "lc_alloc"
> > >         unsigned int  nr_elements;    <-- parameter to "lc_alloc"
> > >         unsigned int  new_number;
> > > 
> > >         unsigned int used;
> > >         unsigned long flags;
> > >         unsigned long hits, misses, starving, dirty, changed;
> > > 
> > >         struct lc_element *changing_element; /* just for paranoia */
> > > 
> > >         const char *name;
> > > 
> > >         struct hlist_head slot[0];
> > >         /* hash colision chains here, then element storage. */
> > > };
> > > 
> > > so we have fixed size list heads,
> > > size of a single such "element", to allow the user
> > > to add small payload;
> > > number of hash slots and "elements" following this header;
> > > some counters;
> > > hlist_slot[0];
> > > }
> > > following:
> > > struct hlist_head[nr_elements];
> > > array of element_size blobs[nr_elements];
> > > 
> > > these "blobs" start with the struct lru_element,
> > > possibly followed by some user payload.
> > > 
> > > the "index" you are asking about later is
> > > index into that "blob" array,
> > > and is used primarily to initialize the state of this thing
> > > from an on-disk representation (the "activity log", "AL"),
> > > for crash recovery purposes.
> > > 
> > > the typecasting is necessary to get from the slot[0] to the "elements"
> > > skipping the hash slots.
> > > using "container of" or something like that would obscure the fact that,
> > > as currently implemented, the "lru_element" _must_ be the first member
> > > of any payload structure.
> > 
> > I still don't see why the lru_element must be the first member of the
> > user's outer, containing structure.
> 
> 
> ok, arguably one could also record the offset_of beneath the element_size,
> and add that in when doing the lc_element *e =  blob[index] + offset.
> would not make it much more appealing, though.
> 

You appear to believe that I understood the relevance of all the above
text.  I didn't ;)

Let's start again.

Why can't I do

struct foo {
	int x;
	struct lc_element lc;
	..
};

and then use the lru library code to handle my foo objects?
