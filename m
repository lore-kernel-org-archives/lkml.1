Return-Path: <linux-kernel-owner+w=401wt.eu-S1757830AbZC1Ayr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757830AbZC1Ayr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 20:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbZC1Ayj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 20:54:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:35262 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbZC1Ayi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 20:54:38 -0400
Subject: Re: [PATCH 1/6] drm/i915: Fix lock order reversal in GTT pwrite
 path.
From: Peter Zijlstra <peterz@infradead.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net
In-Reply-To: <20090326174320.4f16c822@hobbes>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
	 <1238017510-26784-2-git-send-email-eric@anholt.net>
	 <20090326174320.4f16c822@hobbes>
Content-Type: text/plain
Date: Sat, 28 Mar 2009 01:54:32 +0100
Message-Id: <1238201672.4039.396.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-26 at 17:43 -0700, Jesse Barnes wrote:
> On Wed, 25 Mar 2009 14:45:05 -0700
> Eric Anholt <eric@anholt.net> wrote:
> 
> > Since the pagefault path determines that the lock order we use has to
> > be mmap_sem -> struct_mutex, we can't allow page faults to occur
> > while the struct_mutex is held.  To fix this in pwrite, we first try
> > optimistically to see if we can copy from user without faulting.  If
> > it fails, fall back to using get_user_pages to pin the user's memory,
> > and map those pages atomically when copying it to the GPU.
> > 
> > Signed-off-by: Eric Anholt <eric@anholt.net>
> > ---
> > +	/* Pin the user pages containing the data.  We can't fault
> > while
> > +	 * holding the struct mutex, and all of the pwrite
> > implementations
> > +	 * want to hold it while dereferencing the user data.
> > +	 */
> > +	first_data_page = data_ptr / PAGE_SIZE;
> > +	last_data_page = (data_ptr + args->size - 1) / PAGE_SIZE;
> > +	num_pages = last_data_page - first_data_page + 1;
> > +
> > +	user_pages = kcalloc(num_pages, sizeof(struct page *),
> > GFP_KERNEL);
> > +	if (user_pages == NULL)
> > +		return -ENOMEM;
> 
> If kmalloc limits us to a 128k allocation (and maybe less under
> pressure), then we'll be limited to 128k/8 page pointers on 64 bit, or
> 64M per pwrite...  Is that ok?  Or do we need to handle multiple passes
> here?

While officially supported, a 128k kmalloc is _very_ likely to fail, it
would require an order 5 page allocation to back that, and that is well
outside of comfortable.



