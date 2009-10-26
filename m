Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZJZJkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZJZJkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 05:40:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbZJZJkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 05:40:15 -0400
Received: from nox.protox.org ([88.191.38.29]:56240 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336AbZJZJkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 05:40:14 -0400
Subject: Re: Changing radeon KMS cs+gem ioctl to merge read & write domain
From: Jerome Glisse <glisse@freedesktop.org>
To: Dave Airlie <airlied@gmail.com>
Cc: DRI Development Mailing List <dri-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <21d7e9970910251912w799b1fa4q1bea17f7524102d4@mail.gmail.com>
References: <1256165349.15474.17.camel@localhost>
	 <21d7e9970910251912w799b1fa4q1bea17f7524102d4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Oct 2009 10:37:40 +0100
Message-Id: <1256549860.1916.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-26 at 12:12 +1000, Dave Airlie wrote:
> On Thu, Oct 22, 2009 at 8:49 AM, Jerome Glisse <glisse@freedesktop.org> wrote:
> > Hi,
> >
> > I think we should merge the read & write domain of radeon KMS
> > into a single domains information. I don't think there is a
> > good reason for separate read & write domain, we did copy intel
> > model for that and intel use this mostly for cache coherency &
> > cache flushing as far as i understand. We make no good use of
> > this inside the kernel. In order to make this change less disruptive
> > and easier to introduce i propose we keep libdrm-radeon api
> > intact thus userspace xf86video-ati & mesa 3d driver doesn't
> > need a single line patch to adapt. Attached is a proof of concept,
> > a patch against libdrm which merge read & write domain and only
> > use the read domain to communicate with the kernel. I am still
> > in process of stress testing this patch but so far neither X
> > or 3D had any glitches.
> >
> 
> Can you list the advantages (speed, complexity reduction)?, I really
> really don't like this patch at this point in the development process,
> yes the API has warts does fixing it now help any or just increase
> the chance of regressions.

See below

> Like I don't think we've hit any of the limitations yet, and I suspect
> the API limitations we hit will require a new revision of the API, which
> I'd rather do once, than just hack away functionality because the current
> underlying implementation doesn't use it yet.
> 
> I'd really like to use the read/write information to help decide VRAM/GTT
> migration priorities in the future, I've mentioned this a few times and I've
> haven't heard how your scheme addresses this.

New API gives opportunity to give a list of prefered placement, this
would be a lot better than read/write. Userspace has better view of
what is the usage of a buffer (used one frame ? big texture used
several frame ? big texture of which only few texel will be use ? ...)
Read/Write domain fails to transmit any such information to the kernel.

> Some issues I can see are you haven't really defined how userspace
> users of this API should look, like who decides the buffer placement?
> userspace only? can the kernel override? how does the kernel know
> which allocs it can override and which it can't? how does space
> checking work for the VRAM but maybe GTT buffers?

Userspace decide list of placement and kernel can't override it, it
has to pick one placement in the list (mostly because of PPC and vertex
buffer & swap utility). So this doesn't change from what we have, right
now only read buffer can be in vram or gtt.

For space checking, it works pretty much as it does now, we got 2 pool
vram+gtt when a new buffer comes in you check if there is enough room
for it in any of the pool it's valid to put it in. If there isn't enough
then you ask for flush. You first pick the prefered pool and decrease
it if enough space, if not then try second pool if any.

> I don't think the API we have is perfect by any means I just don't think
> investing in tweaking the corners for no real benefit is worth it. Just
> make the gallium winsys API clean and then you don't need to look
> at this stuff, and in a year or two a new API that actually provides benefits
> and speedups after we've learned a bit from this one.
> 
> Dave.
> 

My fear here is that we will have to support 3 different API (old DRI1,
KMS CS+read/write, KMS CS+newapi). It's painful, of course we could
always let the code rot and don't touch it once it works.

GPU are really different from other HW we don't have a "simple" high
level common API we can't export to userspace (like network or anyother
device i am aware of) :(.

Cheers,
Jerome


