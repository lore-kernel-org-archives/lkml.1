Return-Path: <linux-kernel-owner+w=401wt.eu-S1752712AbXJWKai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbXJWKai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 06:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXJWKa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 06:30:29 -0400
Received: from brick.kernel.dk ([87.55.233.238]:12340 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbXJWKa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 06:30:28 -0400
Date: Tue, 23 Oct 2007 12:29:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
Message-ID: <20071023102901.GF5059@kernel.dk>
References: <alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org> <20071022211617.31f5c63d@the-village.bc.nu> <alpine.LFD.0.999.0710221343330.30120@woody.linux-foundation.org> <20071022224343.4abf3c96@the-village.bc.nu> <alpine.LFD.0.999.0710221444220.30120@woody.linux-foundation.org> <471DBEF4.4030303@panasas.com> <20071023094142.GD5059@kernel.dk> <471DC3D9.2070809@panasas.com> <20071023095507.GE5059@kernel.dk> <471DCBB2.9020706@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471DCBB2.9020706@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, Boaz Harrosh wrote:
> On Tue, Oct 23 2007 at 11:55 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Tue, Oct 23 2007, Boaz Harrosh wrote:
> >> On Tue, Oct 23 2007 at 11:41 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> >>> On Tue, Oct 23 2007, Boaz Harrosh wrote:
> >>>> On Mon, Oct 22 2007 at 23:47 +0200, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >>>>> On Mon, 22 Oct 2007, Alan Cox wrote:
> >>>>>
> >>>>>> For structures, not array elements or stack objects. Does gcc now get
> >>>>>> aligned correct as an attribute on a stack object ?
> >>>>> I think m68k stack layout still guarantees 4-byte-alignment, no?
> >>>>>
> >>>>>> Still doesn't answer the rather more important question - why not just
> >>>>>> stick a NULL on the end instead of all the nutty hacks ?
> >>>>> You still do need one bit for the discontiguous case, so it's not like you 
> >>>>> can avoid the hacks anyway (unless you just blow up the structure 
> >>>>> entirely) and make it a separate member). So once you have that 
> >>>>> bit+pointer, using a separate NULL entry isn't exactly prettier. 
> >>>>>
> >>>>> Especially as we actally want to see the difference between 
> >>>>> "end-of-allocation" and "not yet filled in", so you shouldn't use NULL 
> >>>>> anyway, you should probably use something like "all-ones".
> >>>>>
> >>>>> 			Linus
> >>>>> -
> >>>> Every one is so hysterical about this sg-chaining problem. And massive
> >>>> patches produced, that when a simple none intrusive solution is proposed
> >>>> it is totally ignored because every one thinks, "I can not be that stupid".
> >>>> Well Einstein said: "Simplicity is the ultimate sophistication". So no one
> >>>> need to feel bad.
> >>> It's all about the end goal - having maintainable and resilient code.
> >>> And I think the sg code will be better once we get past the next day or
> >>> so, and it'll be more robust. That is what matters to me, not the
> >>> simplicity of the patch itself.
> >>>
> >> But that is exactly what his patch is. Much more robust. Because you do not
> >> relay on sglist content but on outside information, that you already have.
> >> Have you had an hard look at his solution? It just simply falls into place.
> >> Please try it out for yourself. I did, and it works.
> > 
> > Sure, I looked at it, it's not exactly rocket science, I do understand
> > what it achieves. I don't think the patch is bad as such, I'm merely
> > trying to state that I think the end code AND interface will be much
> > nicer with the current direction that the sg helpers are moving.
> > 
> > It does rely on outside context, because you need to pass in the sglist
> > number. In my opinion, this patch would be a bandaid for the original
> > chain code until we got around to fixing the PAGEALLOC crash. Which we
> > did, it's now merged. The patch doesn't make the code cleaner, it makes
> > it uglier. It'll work, but that still doesn't mean I have to agree it's
> > a nice design.
> > 
> A nice design is to have an struct like BIO. That holds a pointer to the 
> array of scatterlists, size, ..., and a next and prev pointers to the next
> chunks. Than have all kernel code that now accepts scatterlist* and size
> accept a pointer to such structure. And all is clear and defined.
> 
> But since we do not do that, and every single API in the kernel that
> receives a scatterlist pointer also receives an sg_count parameter,
> than I do not see what is so hacky about giving that sg_count parameter
> to the one that needs it the most. sg_next();

Not all paths need to know the exact number though, and with the changes
you could legitimately pass in just the header and iteration would work
fine.

> OK I guess this is all a matter of taste so there is no point arguing
> about it any more. I can see your view, and the work has been done so
> I guess there is no point going back. If it all works than it's for the
> best.

Yes agreed, debating taste is usually not very interesting as we wont
get far ;-)

> Thanks Jens for doing all this, The performance gain is substantial
> and we will all enjoy it.

My pleasure, I just wish it could have been a little less painful. But
in a day or two, it should all be behind us and we can move forward with
making good use of it.

-- 
Jens Axboe

