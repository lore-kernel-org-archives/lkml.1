Return-Path: <linux-kernel-owner+w=401wt.eu-S1767767AbXEDJkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767767AbXEDJkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 05:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767766AbXEDJkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 05:40:10 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:61297 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767778AbXEDJkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 05:40:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hBNOuzftbAOharpea8Baf8sP66ywuxOrb4LUNoz7skVVH8yFx7x+QPbhwDzzVl/7DEJ+nnOJPZUGabZsCVDB44XeKieyRGJYc89O2TONSeCQs0oS3aHc/76vvJWyEcIKib9dq2bMIkJj9+CNgNzNpZXh36CXEu32q6hTeNz7TiY=
Message-ID: <4240b9160705040240q2a325845tf81686ae17912ff2@mail.gmail.com>
Date: Fri, 4 May 2007 11:40:03 +0200
From: "Jerome Glisse" <j.glisse@gmail.com>
To: "=?ISO-8859-1?Q?Thomas_Hellstr=F6m?=" <thomas@tungstengraphics.com>
Subject: Re: [RFC] [PATCH] DRM TTM Memory Manager patch
Cc: "Keith Packard" <keithp@keithp.com>, dri-devel@lists.sourceforge.net,
       "Dave Airlie" <airlied@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
In-Reply-To: <4240b9160705040149v3c97413fg54f1486f55ffbc11@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <21d7e9970704252355m4765b65fyb547b9ba2763b103@mail.gmail.com>
	 <1178137279.53297.114.camel@vonnegut>
	 <46391860.3070409@tungstengraphics.com>
	 <1178251621.27028.9.camel@neko.keithp.com>
	 <463AE9AE.7070806@tungstengraphics.com>
	 <4240b9160705040149v3c97413fg54f1486f55ffbc11@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/4/07, Jerome Glisse <j.glisse@gmail.com> wrote:
> On 5/4/07, Thomas Hellström <thomas@tungstengraphics.com> wrote:
> > Keith Packard wrote:
> > > On Thu, 2007-05-03 at 01:01 +0200, Thomas Hellström wrote:
> > >
> > >
> > >> It might be possible to find schemes that work around this. One way
> > >> could possibly be to have a buffer mapping -and validate order for
> > >> shared buffers.
> > >>
> > >
> > > If mapping never blocks on anything other than the fence, then there
> > > isn't any dead lock possibility. What this says is that ordering of
> > > rendering between clients is *not DRMs problem*. I think that's a good
> > > solution though; I want to let multiple apps work on DRM-able memory
> > > with their own CPU without contention.
> > >
> > > I don't recall if Eric layed out the proposed rules, but:
> > >
> > >  1) Map never blocks on map. Clients interested in dealing with this
> > >     are on their own.
> > >
> > >  2) Submit blocks on map. You must unmap all buffers before submitting
> > >     them. Doing the relocations in the kernel makes this all possible.
> > >
> > >  3) Map blocks on the fence from submit. We can play with pending the
> > >     flush until the app asks for the buffer back, or we can play with
> > >     figuring out when flushes are useful automatically. Doesn't matter
> > >     if the policy is in the kernel.
> > >
> > > I'm interested in making deadlock avoidence trivial and eliminating any
> > > map-map contention.
> > >
> > >
> > It's rare to have two clients access the same buffer at the same time.
> > In what situation will this occur?
> >
> > If we think of map / unmap and validation / fence  as taking a buffer
> > mutex either for the CPU or for the GPU, that's the way implementation
> > is done today. The CPU side of the mutex should IIRC be per-client
> > recursive. OTOH, the TTM implementation won't stop the CPU from
> > accessing the buffer when it is unmapped, but then you're on your own.
> > "Mutexes" need to be taken in the correct order, otherwise a deadlock
> > will occur, and GL will, as outlined in Eric's illustration, more or
> > less encourage us to take buffers in the "incorrect" order.
> >
> > In essence what you propose is to eliminate the deadlock problem by just
> > avoiding taking the buffer mutex unless we know the GPU has it. I see
> > two problems with this:
> >
> >     * It will encourage different DRI clients to simultaneously access
> >       the same buffer.
> >     * Inter-client and GPU data coherence can be guaranteed if we issue
> >       a mb() / write-combining flush with the unmap operation (which,
> >       BTW, I'm not sure is done today). Otherwise it is up to the
> >       clients, and very easy to forget.
> >
> > I'm a bit afraid we might in the future regret taking the easy way out?
> >
> > OTOH, letting DRM resolve the deadlock by unmapping and remapping shared
> > buffers in the correct order might not be the best one either. It will
> > certainly mean some CPU overhead and what if we have to do the same with
> > buffer validation? (Yes for some operations with thousands and thousands
> > of relocations, the user space validation might need to stay).
> >
> > Personally, I'm slightly biased towards having DRM resolve the deadlock,
> > but I think any solution will do as long as the implications and why we
> > choose a certain solution are totally clear.
> >
> > For item 3) above the kernel must have a way to issue a flush when
> > needed for buffer eviction.
> > The current implementation also requires the buffer to be completely
> > flushed before mapping.
> > Other than that the flushing policy is currently completely up to the
> > DRM drivers.
> >
> > /Thomas
>
> I might say stupid things as i don't think i fully understand all
> the input to this problem. Anyway here is my thought on all this:
>
> 1) First client map never block (as in Keith layout) except on
>     fence from drm side (point 3 in Keith layout)
> 2) Client should always unmap buffer before submitting (as in Keith layout)
> 3) In drm side you always acquire buffer lock in a give order for
>     instance each buffer got and id and you lock from smaller id to bigger
>     one (with a clever implementation the cost for that will be small)
> 4) We got 2 gpu queue:
>              - one with pending apps ask in which we do all stuff necessary
>                to be done before submitting (locking buffer, validation, ...)
>                for instance we might wait here for each buffer that are still
>                mapped by some other apps in user space
>              - one run queue in which we add each apps ask that are now
>                ready to be submited to the gpu
>
> Of course in this scheme we keep the fencing stuff so user space can
> know when it safe to use previously submited buffer again. The outcome
> of having two seperate queue in drm is that if two apps lockup each other
> other apps can still use the gpu so only the apps fighting for a buffer will
> suffer.
>
> And for user space synchronization i believe it a user space problem i.e.
> it's up to user space to add proper synch. For instance as map doesn't
> block for any client in user space two apps can mess with same buffer
> it's up to user to have a policy to exclude each other (i believe this will
> be a dri or xorg problem to synch btw consumer).
>
> I believe in this scheme you can only have deadlock btw two buggy
> apps (like one forgeting to unmap a buffer) or any apps that forgot
> to unmap buffer before submitting won't cause damage to other
> apps. I hope i properly explain my thought (hey my brain is in a sleepy
> state right now).
>
> best,
> Jerome Glisse
>

Did i say i was sleepy :) ?  I forgot to tell why we should always
acquire lock in same order in pending queue, we should do this
because several kernel thread will work on the pending queue.
While the running queue should only be processed by one kernel
thread; thus we do not need anymore a big lock for the GPU
only this single thread will really talk to the gpu (in fact we might
still need the lock if xorg ddx do mmio gpu regs access).

On a side note i think this scheme also fit well with gpu having
several context and which doesn't need big validation (read
nv gpu).

best,
Jerome Glisse
