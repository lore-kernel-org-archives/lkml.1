Return-Path: <linux-kernel-owner+w=401wt.eu-S1755103AbXEDL5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbXEDL5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 07:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbXEDL5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 07:57:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:1973 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbXEDL5R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 07:57:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R/fR3zkvD/BqKXScUXOVUvcRJbCk7Pqc1hV9lzzozp5wC6hr3m4M1nBbTvmGZd79cLh/VK42QbLblJ+xaCncY9P8kNfrUGHXiSA8Dwp/zm0wYZ0dcPoA53YVWmwr09uU7LAe0M0QJdEUG9nxFkzGq/KP+8N1TvAj4uZuCCKcuLA=
Message-ID: <4240b9160705040457n46be9b62p7c760fb54898ba37@mail.gmail.com>
Date: Fri, 4 May 2007 13:57:15 +0200
From: "Jerome Glisse" <j.glisse@gmail.com>
To: "=?ISO-8859-1?Q?Thomas_Hellstr=F6m?=" <thomas@tungstengraphics.com>
Subject: Re: [RFC] [PATCH] DRM TTM Memory Manager patch
Cc: "Keith Packard" <keithp@keithp.com>, dri-devel@lists.sourceforge.net,
       "Dave Airlie" <airlied@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
In-Reply-To: <463B12F9.8060900@tungstengraphics.com>
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
	 <463B12F9.8060900@tungstengraphics.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/4/07, Thomas Hellström <thomas@tungstengraphics.com> wrote:
> Jerome Glisse wrote:
> > On 5/4/07, Thomas Hellström <thomas@tungstengraphics.com> wrote:
> >> Keith Packard wrote:
> >> > On Thu, 2007-05-03 at 01:01 +0200, Thomas Hellström wrote:
> >> >
> >> >
> >> >> It might be possible to find schemes that work around this. One way
> >> >> could possibly be to have a buffer mapping -and validate order for
> >> >> shared buffers.
> >> >>
> >> >
> >> > If mapping never blocks on anything other than the fence, then there
> >> > isn't any dead lock possibility. What this says is that ordering of
> >> > rendering between clients is *not DRMs problem*. I think that's a good
> >> > solution though; I want to let multiple apps work on DRM-able memory
> >> > with their own CPU without contention.
> >> >
> >> > I don't recall if Eric layed out the proposed rules, but:
> >> >
> >> >  1) Map never blocks on map. Clients interested in dealing with this
> >> >     are on their own.
> >> >
> >> >  2) Submit blocks on map. You must unmap all buffers before submitting
> >> >     them. Doing the relocations in the kernel makes this all possible.
> >> >
> >> >  3) Map blocks on the fence from submit. We can play with pending the
> >> >     flush until the app asks for the buffer back, or we can play with
> >> >     figuring out when flushes are useful automatically. Doesn't matter
> >> >     if the policy is in the kernel.
> >> >
> >> > I'm interested in making deadlock avoidence trivial and eliminating
> >> any
> >> > map-map contention.
> >> >
> >> >
> >> It's rare to have two clients access the same buffer at the same time.
> >> In what situation will this occur?
> >>
> >> If we think of map / unmap and validation / fence  as taking a buffer
> >> mutex either for the CPU or for the GPU, that's the way implementation
> >> is done today. The CPU side of the mutex should IIRC be per-client
> >> recursive. OTOH, the TTM implementation won't stop the CPU from
> >> accessing the buffer when it is unmapped, but then you're on your own.
> >> "Mutexes" need to be taken in the correct order, otherwise a deadlock
> >> will occur, and GL will, as outlined in Eric's illustration, more or
> >> less encourage us to take buffers in the "incorrect" order.
> >>
> >> In essence what you propose is to eliminate the deadlock problem by just
> >> avoiding taking the buffer mutex unless we know the GPU has it. I see
> >> two problems with this:
> >>
> >>     * It will encourage different DRI clients to simultaneously access
> >>       the same buffer.
> >>     * Inter-client and GPU data coherence can be guaranteed if we issue
> >>       a mb() / write-combining flush with the unmap operation (which,
> >>       BTW, I'm not sure is done today). Otherwise it is up to the
> >>       clients, and very easy to forget.
> >>
> >> I'm a bit afraid we might in the future regret taking the easy way out?
> >>
> >> OTOH, letting DRM resolve the deadlock by unmapping and remapping shared
> >> buffers in the correct order might not be the best one either. It will
> >> certainly mean some CPU overhead and what if we have to do the same with
> >> buffer validation? (Yes for some operations with thousands and thousands
> >> of relocations, the user space validation might need to stay).
> >>
> >> Personally, I'm slightly biased towards having DRM resolve the deadlock,
> >> but I think any solution will do as long as the implications and why we
> >> choose a certain solution are totally clear.
> >>
> >> For item 3) above the kernel must have a way to issue a flush when
> >> needed for buffer eviction.
> >> The current implementation also requires the buffer to be completely
> >> flushed before mapping.
> >> Other than that the flushing policy is currently completely up to the
> >> DRM drivers.
> >>
> >> /Thomas
> >
> > I might say stupid things as i don't think i fully understand all
> > the input to this problem. Anyway here is my thought on all this:
> >
> > 1) First client map never block (as in Keith layout) except on
> >    fence from drm side (point 3 in Keith layout)
> >
> But is there really a need for this except to avoid the above-mentioned
> deadlock?
> As I'm not too up to date with all the possibilities the servers and GL
> clients may be using shared buffers,
> I need some enlightenment :). Could we have an example, please?

I think the current main consumer would be compiz or any other
compositor which use TextureFromPixmap, i really think the we
might see further use of sharing graphical data among applications,
i got example here at my work of such use case even thought this
doesn't use GL at all but another indoor protocol. Another possible
case where such buffer sharing might occur is inside same application
with two or more GL context (i am ready to bet that we already have
some where example of such application).

> > 4) We got 2 gpu queue:
> >             - one with pending apps ask in which we do all stuff
> > necessary
> >               to be done before submitting (locking buffer,
> > validation, ...)
> >               for instance we might wait here for each buffer that are
> > still
> >               mapped by some other apps in user space
> >             - one run queue in which we add each apps ask that are now
> >               ready to be submited to the gpu
>
> This is getting closer and closer to a GPU scheduler, an interesting
> topic indeed.
> Perhaps we should have a separate  discussion on the  needs and
> requirements for such a thing?
>
> Regards,
> /Thomas

Hey ! I tried to hide that this was a dumb scheduler ;), i believe that
we need such things along memory management. A functionality that
is worth having is the possibility for the kernel to preempt the pending
queue to get exclusive access to the GPU (for instance when printing
kernel failure).

Maybe we should first discuss this in dri-devel and come back to
our lkml friends :) once we are happy with design. Even thought i
am sure there is people on lkml that definitely can help with design
considering their experiences on scheduler and memory management
and the whole synchronization problem.

best,
Jerome Glisse
