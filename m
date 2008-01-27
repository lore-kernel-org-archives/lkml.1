Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbYA0VRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbYA0VRq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 16:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbYA0VRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 16:17:38 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:10916 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbYA0VRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 16:17:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=I4elt9EFSCtWDmJOTwhxpcSTvCXodAMJq3dvcdSefyV1TKsd4LpBRGfbEQa9Wni9CdKbkZJGSn4N33ayReLjbkP3DiZUYTp0b17W+MOrdVbxFDS/kBRKHx+LWGVSdZU3L8edZj5j8pYN4FFIMpYbd2iootKbf9xY4hdxWj4i7QM=
Message-ID: <19f34abd0801271317o4b17dc28l3c93d4d28e3e2e73@mail.gmail.com>
Date: Sun, 27 Jan 2008 22:17:36 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: lib/idr.c: initialize struct idr_layer
Cc: "Jim Houston" <jim.houston@ccur.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Tejun Heo" <htejun@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <84144f020801271300g316b87bgea6beb265b5c62d3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0801271207j377fba5bg92cedceedbdd228@mail.gmail.com>
	 <84144f020801271300g316b87bgea6beb265b5c62d3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 27, 2008 10:00 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Hi Vegard,
>
> On Jan 27, 2008 10:07 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > I am testing my kmemcheck patches, and it has come up with a couple of
> > uses of uninitialized memory in lib/idr.c. These are (the line numbers
> > may differ slightly):
>
> [snip]
>
> > @@ -39,12 +39,16 @@ static struct idr_layer *alloc_layer(struct idr *idp)
> >  {
> >         struct idr_layer *p;
> >         unsigned long flags;
> > +       int i;
> >
> >         spin_lock_irqsave(&idp->lock, flags);
> >         if ((p = idp->id_free)) {
> >                 idp->id_free = p->ary[0];
> >                 idp->id_free_cnt--;
> > -               p->ary[0] = NULL;
> > +               p->bitmap = 0;
> > +               for(i = 0; i < ARRAY_SIZE(p->ary); ++i)
> > +                       p->ary[i] = NULL;
> > +               p->count = 0;
>
> But aren't these zeroed by idr_cache_ctor() already?

That would make sense. However...

idr_layer_cache is only used for allocations from idr_pre_get().
idr_pre_get() is only called from ida_pre_get().

If this analysis is correct, can this mean that the user has failed to
call ida_pre_get() before idr_get_new() was called?

Though in this case, idr_pre_get() actually *is* called first. Hmm...
I think there's a pretty big chance that kmemcheck is at fault :-(

Vegard
