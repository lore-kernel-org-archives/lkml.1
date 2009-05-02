Return-Path: <linux-kernel-owner+w=401wt.eu-S1758871AbZEBSO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbZEBSO0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 14:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758194AbZEBSOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 14:14:10 -0400
Received: from [212.69.161.110] ([212.69.161.110]:55440 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbZEBSOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 14:14:08 -0400
Date: Sat, 2 May 2009 20:13:12 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
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
Message-ID: <20090502181311.GG6466@racke>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-2-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-3-git-send-email-philipp.reisner@linbit.com> <20090501015956.ef663e9b.akpm@linux-foundation.org> <20090502152620.GA6466@racke> <20090502105823.bf27bf22.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090502105823.bf27bf22.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 02, 2009 at 10:58:23AM -0700, Andrew Morton wrote:
> On Sat, 2 May 2009 17:26:20 +0200 Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
> 
> > in memory structure is
> > 
> > struct lru_cache {
> >         struct list_head active;
> >         struct list_head quiet;
> >         struct list_head free;
> >         size_t element_size;          <-- parameter to "lc_alloc"
> >         unsigned int  nr_elements;    <-- parameter to "lc_alloc"
> >         unsigned int  new_number;
> > 
> >         unsigned int used;
> >         unsigned long flags;
> >         unsigned long hits, misses, starving, dirty, changed;
> > 
> >         struct lc_element *changing_element; /* just for paranoia */
> > 
> >         const char *name;
> > 
> >         struct hlist_head slot[0];
> >         /* hash colision chains here, then element storage. */
> > };
> > 
> > so we have fixed size list heads,
> > size of a single such "element", to allow the user
> > to add small payload;
> > number of hash slots and "elements" following this header;
> > some counters;
> > hlist_slot[0];
> > }
> > following:
> > struct hlist_head[nr_elements];
> > array of element_size blobs[nr_elements];
> > 
> > these "blobs" start with the struct lru_element,
> > possibly followed by some user payload.
> > 
> > the "index" you are asking about later is
> > index into that "blob" array,
> > and is used primarily to initialize the state of this thing
> > from an on-disk representation (the "activity log", "AL"),
> > for crash recovery purposes.
> > 
> > the typecasting is necessary to get from the slot[0] to the "elements"
> > skipping the hash slots.
> > using "container of" or something like that would obscure the fact that,
> > as currently implemented, the "lru_element" _must_ be the first member
> > of any payload structure.
> 
> I still don't see why the lru_element must be the first member of the
> user's outer, containing structure.


ok, arguably one could also record the offset_of beneath the element_size,
and add that in when doing the lc_element *e =  blob[index] + offset.
would not make it much more appealing, though.

	Lars
