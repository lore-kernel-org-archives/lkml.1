Return-Path: <linux-kernel-owner+w=401wt.eu-S1753535AbZFYL4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbZFYL4s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 07:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbZFYL4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 07:56:40 -0400
Received: from nox.protox.org ([88.191.38.29]:59084 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbZFYL4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 07:56:40 -0400
Subject: Re: [PATCH] radeon: preallocate memory for command stream parsing
From: Jerome Glisse <glisse@freedesktop.org>
To: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       Jerome Glisse <jglisse@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
In-Reply-To: <4A433D7C.20002@shipmail.org>
References: <1245786367-2773-1-git-send-email-jglisse@redhat.com>
	 <84144f020906231252u5131ffbdk74f06f8a0f692cf9@mail.gmail.com>
	 <1245832141.2408.4.camel@localhost>
	 <1245913447.2018.18.camel@penberg-laptop>  <4A433D7C.20002@shipmail.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Jun 2009 13:56:36 +0200
Message-Id: <1245930996.13359.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 11:03 +0200, Thomas Hellström wrote:
> Pekka Enberg skrev:
> > Hi Jerome,
> >
> > On Tue, 2009-06-23 at 22:52 +0300, Pekka Enberg wrote:
> >   
> >>> On Tue, Jun 23, 2009 at 10:46 PM, Jerome Glisse<jglisse@redhat.com> wrote:
> >>>       
> >>>> Command stream parsing is the most common operation and can
> >>>> happen hundred of times per second, we don't want to allocate/free
> >>>> memory each time this ioctl is call. This rework the ioctl
> >>>> to avoid doing so by allocating temporary memory along the
> >>>> ib pool.
> >>>>
> >>>> Signed-off-by: Jerome Glisse <jglisse@redhat.com>
> >>>>         
> >>> So how much does this help (i.e. where are the numbers)? I am bit
> >>> surprised "hundred of times per second" is an issue for our slab
> >>> allocators. Hmm?
> >>>       
> >
> > On Wed, 2009-06-24 at 10:29 +0200, Jerome Glisse wrote:
> >   
> >> I didn't have real number but the vmap path was really slower,
> >> quake3 fps goes from ~20 to ~40 on average when going from vmap
> >> to preallocated. When using kmalloc i don't thing there was so
> >> much performance hit. But i think the biggest hit was that in
> >> previous code i asked for zeroed memory so i am pretty sure kernel
> >> spend a bit of time clearing page. I reworked the code to avoid
> >> needing cleared memory and so avoid memset, this is likely why
> >> we get a performance boost.
> >>     
> >
> > OK. If kmalloc() (without memset) really was too slow for your case, I'd
> > be interested in looking at it in more detail. I'm not completely
> > convinced the memory pool is needed here but I'm not a DRM expert so I'm
> > not NAK'ing this either...
> >
> > 			Pekka
> >
> >   
> Hi!
>  From previous experience with other drivers kmalloc() is just fine 
> performance-wise.
> I've also never seen memsetting pages turn up on the profile. It would 
> be interesting to see an oprofile timing of this to try and pinpoint 
> what's happening.
> 
> However, in this case, I believe Jerome was forced to use vmalloc to 
> guarantee that the allocation would succeed, and frequent vmallocs seem 
> to be a performance killer.
> 
> One should also be careful about frame-rates. Tuning memory manager / 
> command submission operation is usually a matter of how much CPU is 
> consumed for a given framerate. If one compares framerates one must make 
> sure that the CPU is at nearly 100% while benchmarking.
> 
> /Thomas
> 

To give a more correct rough estimate, at 60fps we will issue somethings
like 10 to 50 cs ioctl per frame so it's several thousands of cs ioctl
so several thousands of 64K allocation, and memory clearing, i believe
such things would show up on profile. I am not running kernel without
my patch as i am working on other stuff now, but i will lower the pool
size so that we don't waste too much memory right now i think the
preallocation use somethings around 8M of memory. I think i can get it
down to 1M without impacting performance (even less if we are on pcie).

Cheers,
Jerome

