Return-Path: <linux-kernel-owner+w=401wt.eu-S1759716AbZC0RHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759716AbZC0RHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 13:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbZC0RHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 13:07:25 -0400
Received: from outbound-mail-153.bluehost.com ([67.222.39.33]:54819 "HELO
	outbound-mail-153.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752178AbZC0RHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 13:07:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=XWhUs/5UJcSMrP6Sqa8nsghtfSrN/ZK9hGmgC578IqWqSbWb/gYDdow9wC9twTgAf3qlTYI7bc0HsNRJbibVScousRWl87W4HiWw8ZdMSF35udTqWUP1QsL7yV6rUMYB;
Date: Fri, 27 Mar 2009 10:07:18 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Eric Anholt <eric@anholt.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/6] drm/i915: Fix lock order reversal in GTT pwrite
 path.
Message-ID: <20090327100718.29a79397@hobbes>
In-Reply-To: <1238172963.8275.2492.camel@gaiman>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
	<1238017510-26784-2-git-send-email-eric@anholt.net>
	<20090326174320.4f16c822@hobbes>
	<1238172963.8275.2492.camel@gaiman>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 09:56:03 -0700
Eric Anholt <eric@anholt.net> wrote:

> On Thu, 2009-03-26 at 17:43 -0700, Jesse Barnes wrote:
> > On Wed, 25 Mar 2009 14:45:05 -0700
> > Eric Anholt <eric@anholt.net> wrote:
> > 
> > > Since the pagefault path determines that the lock order we use
> > > has to be mmap_sem -> struct_mutex, we can't allow page faults to
> > > occur while the struct_mutex is held.  To fix this in pwrite, we
> > > first try optimistically to see if we can copy from user without
> > > faulting.  If it fails, fall back to using get_user_pages to pin
> > > the user's memory, and map those pages atomically when copying it
> > > to the GPU.
> > > 
> > > Signed-off-by: Eric Anholt <eric@anholt.net>
> > > ---
> > > +	/* Pin the user pages containing the data.  We can't
> > > fault while
> > > +	 * holding the struct mutex, and all of the pwrite
> > > implementations
> > > +	 * want to hold it while dereferencing the user data.
> > > +	 */
> > > +	first_data_page = data_ptr / PAGE_SIZE;
> > > +	last_data_page = (data_ptr + args->size - 1) / PAGE_SIZE;
> > > +	num_pages = last_data_page - first_data_page + 1;
> > > +
> > > +	user_pages = kcalloc(num_pages, sizeof(struct page *),
> > > GFP_KERNEL);
> > > +	if (user_pages == NULL)
> > > +		return -ENOMEM;
> > 
> > If kmalloc limits us to a 128k allocation (and maybe less under
> > pressure), then we'll be limited to 128k/8 page pointers on 64 bit,
> > or 64M per pwrite...  Is that ok?  Or do we need to handle multiple
> > passes here?
> 
> That's a really good point.  This hurts.  However, we're already in
> pain:
> 	obj_priv->page_list = drm_calloc(page_count, sizeof(struct
> page *), DRM_MEM_DRIVER);
> 
> drm_calloc is kcalloc, so we already fall on our faces with big
> objects, before this code.  Thinking about potential regressions for
> big objects from the change in question:
> 
> pixmaps: Can't render with them already.  X only limits you to 4GB
> pixmaps.  Doesn't use pread/pwrite.
> 
> textures: Can't render with them already.  Largest texture size is
> 2048*2048*4*6*1.5 or so for a mipmapped cube map, or around 150MB.
> This would fail on 32-bit as well. Doesn't use pread/write.
> 
> FBOs: Can't render with them.  Same size as textures.  Software
> fallbacks use pread/pwrite, but it's always done a page at a time.
> 
> VBOs (965): Can't render with them.  No size limitations I know of.
> 
> VBOs (915): Not used for rendering, just intermediate storage (this
> is a bug).  No size limitations I know of.  So here we would regress
> huge VBOs on 915 when uploaded using BufferData instead of MapBuffer
> (unlikely).  Of course, it's already a bug that we make real VBOs on
> 915 before it's strictly necessary.
> 
> PBOs: Can't render with them.  Normal usage wouldn't be big enough to
> trigger the bug, though.  Does use pread/pwrite when accessed using
> {Get,}Buffer{Sub,}Data.
> 
> My summary here would be: Huge objects are already pretty thoroughly
> broken, since any acceleration using them fails at the kcalloc of the
> page list when binding to the GTT.  Doing one more kalloc of a page
> list isn't significantly changing the situation.
> 
> I propose going forward with these patches, and I'll go off and build
> some small testcases for our various interfaces with big objects so we
> can fix them and make sure we stay correct.

Great, thanks for looking into it.  I figured there was probably
similar breakage elsewhere, so there's no reason to block this
patchset.  I agree large stuff should be fixed up in a separate set.

-- 
Jesse Barnes, Intel Open Source Technology Center
