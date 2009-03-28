Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbZC1FWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbZC1FWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 01:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbZC1FWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 01:22:05 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:5531 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbZC1FWC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 01:22:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qWKLIkCgxUQxExGvEQy1htVA7KZAMZjB/Ox74dOOc/nq4UDg1Tk5UtMv119qgRhK+r
         1tENHJ6jJWk+OCVEom7eCAb7k5rjks1iDCDvaa7+ph8GOxq8iw/++jDJE51ht3PdkPFY
         kpHBBRUHdOIezSC1c0g/70aDjzUyKZioBpyNY=
MIME-Version: 1.0
In-Reply-To: <20090327193542.28ffcc10@hobbes>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
	 <1238017510-26784-2-git-send-email-eric@anholt.net>
	 <20090326174320.4f16c822@hobbes> <1238201672.4039.396.camel@laptop>
	 <20090327193542.28ffcc10@hobbes>
Date: Sat, 28 Mar 2009 15:22:00 +1000
Message-ID: <21d7e9970903272222g3c553056u2c1832dc2cd97625@mail.gmail.com>
Subject: Re: [PATCH 1/6] drm/i915: Fix lock order reversal in GTT pwrite path.
From: Dave Airlie <airlied@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 12:35 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Sat, 28 Mar 2009 01:54:32 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
>
>> On Thu, 2009-03-26 at 17:43 -0700, Jesse Barnes wrote:
>> > On Wed, 25 Mar 2009 14:45:05 -0700
>> > Eric Anholt <eric@anholt.net> wrote:
>> >
>> > > Since the pagefault path determines that the lock order we use
>> > > has to be mmap_sem -> struct_mutex, we can't allow page faults to
>> > > occur while the struct_mutex is held.  To fix this in pwrite, we
>> > > first try optimistically to see if we can copy from user without
>> > > faulting.  If it fails, fall back to using get_user_pages to pin
>> > > the user's memory, and map those pages atomically when copying it
>> > > to the GPU.
>> > >
>> > > Signed-off-by: Eric Anholt <eric@anholt.net>
>> > > ---
>> > > + /* Pin the user pages containing the data.  We can't
>> > > fault while
>> > > +  * holding the struct mutex, and all of the pwrite
>> > > implementations
>> > > +  * want to hold it while dereferencing the user data.
>> > > +  */
>> > > + first_data_page = data_ptr / PAGE_SIZE;
>> > > + last_data_page = (data_ptr + args->size - 1) / PAGE_SIZE;
>> > > + num_pages = last_data_page - first_data_page + 1;
>> > > +
>> > > + user_pages = kcalloc(num_pages, sizeof(struct page *),
>> > > GFP_KERNEL);
>> > > + if (user_pages == NULL)
>> > > +         return -ENOMEM;
>> >
>> > If kmalloc limits us to a 128k allocation (and maybe less under
>> > pressure), then we'll be limited to 128k/8 page pointers on 64 bit,
>> > or 64M per pwrite...  Is that ok?  Or do we need to handle multiple
>> > passes here?
>>
>> While officially supported, a 128k kmalloc is _very_ likely to fail,
>> it would require an order 5 page allocation to back that, and that is
>> well outside of comfortable.
>
> Yeah, my "and maybe less" could have been worded a tad more strongly. ;)
> Do we have stats on which kmalloc buckets have available allocations
> anywhere for machines under various workloads?  I know under heavy
> pressure even 8k allocations can fail, but since this is a GFP_KERNEL
> things should be a *little* better.

You might want to check what TTM did, it had a vmalloc fallback.

Another issue that might need checking in GEM was whether we can from unpriv
userspace cause the kernel to do unbounded small kmallocs and keep
them alive either via object references or anything like that.

Dave.
>
> --
> Jesse Barnes, Intel Open Source Technology Center
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
