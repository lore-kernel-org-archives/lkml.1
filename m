Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbZKIHKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbZKIHKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 02:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbZKIHK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 02:10:29 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:57943 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbZKIHK2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 02:10:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ezsZitgA14v+gOnhEJE3MnbWWswrmUsLNNdlzRyI0hik1YFGw71mX0zthlEveWrX8j
         9QTHoqcBxwULifCQUYQfdKRGhrrw+8RGi33ysfsrPy69R6yhNHIv1I4zh4XN1kkABFZK
         ibkkQw3VkCSnarYP77fzEEDZrRWuEbqBD7c5M=
MIME-Version: 1.0
In-Reply-To: <200911091647.29655.rusty@rustcorp.com.au>
References: <cover.1257349249.git.mst@redhat.com>
	 <200911061529.17500.rusty@rustcorp.com.au>
	 <20091108113516.GA19016@redhat.com>
	 <200911091647.29655.rusty@rustcorp.com.au>
Date: Mon, 9 Nov 2009 09:10:32 +0200
Message-ID: <8f53421d0911082310n1f5f487ew8c2c03d2e1d7ca5c@mail.gmail.com>
Subject: Re: [PATCHv8 3/3] vhost_net: a kernel-level virtio server
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       gregory.haskins@gmail.com, s.hetze@linux-ag.com,
       Daniel Walker <dwalker@fifo99.com>,
       Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 9, 2009 at 8:17 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> > > +static void vhost_net_set_features(struct vhost_net *n, u64 features)
>> > > +{
>> > > + size_t hdr_size = features & (1 << VHOST_NET_F_VIRTIO_NET_HDR) ?
>> > > +         sizeof(struct virtio_net_hdr) : 0;
>> > > + int i;
>> > > + mutex_lock(&n->dev.mutex);
>> > > + n->dev.acked_features = features;
>> >
>> > Why is this called "acked_features"?  Not just "features"?  I expected
>> > to see code which exposed these back to userspace, and didn't.
>>
>> Not sure how do you mean. Userspace sets them, why
>> does it want to get them exposed back?
>
> There's something about the 'acked' which rubs me the wrong way.
> "enabled_features" is perhaps a better term than "acked_features"; "acked"
> seems more a user point-of-view, "enabled" seems more driver POV?
>

Hmm. Are you happy with the ioctl name? If yes I think being consistent
with that is important.


> set_features matches your ioctl names, but it sounds like a fn name :(
>
> It's marginal.  And 'features' is shorter than both.

I started with this but I was always getting confused whether this
includes all features or just acked features.  I'll go with
enabled_features.


>
>> > > + switch (ioctl) {
>> > > + case VHOST_SET_VRING_NUM:
>> >
>> > I haven't looked at your userspace implementation, but does a generic
>> > VHOST_SET_VRING_STATE & VHOST_GET_VRING_STATE with a struct make more
>> > sense?  It'd be simpler here,
>>
>> Not by much though, right?
>>
>> > but not sure if it'd be simpler to use?
>>
>> The problem is with VHOST_SET_VRING_BASE as well. I want it to be
>> separate because I want to make it possible to relocate e.g. used ring
>> to another address while ring is running. This would be a good debugging
>> tool (you look at kernel's used ring, check descriptor, then update
>> guest's used ring) and also possibly an extra way to do migration.  And
>> it's nicer to have vring size separate as well, because it is
>> initialized by host and never changed, right?
>
> Actually, this looks wrong to me:
>
> +       case VHOST_SET_VRING_BASE:
> ...
> +               vq->avail_idx = vq->last_avail_idx = s.num;
>
> The last_avail_idx is part of the state of the driver.  It needs to be saved
> and restored over susp/resume.


Exactly. That's what VHOST_GET/SET_VRING_BASE does.  avail_idx is just a
cached value for notify on empty, so what this does is clear the value.
What exactly do you refer to when you say "this looks wrong"?
This could trigger an extra notification if I ever called
trigger_irq without get first. As I don't, it in fact has no effect.

>  The only reason it's not in the ring itself
> is because I figured the other side doesn't need to see it (which is true, but
> missed debugging opportunities as well as man-in-the-middle issues like this
> one).  I had a patch which put this field at the end of the ring, I might
> resurrect it to avoid this problem.  This is backwards compatible with all
> implementations.  See patch at end.

Yes, I remember that patch. There seems to be little point though, at
this stage.


>
> I would drop avail_idx altogether: get_user is basically free, and simplifies
> a lot.  As most state is in the ring, all you need is an ioctl to save/restore
> the last_avail_idx.


avail_idx is there for notify on empty: I had this thought that it's
better to leave the avail cache line alone when we are triggering
interrupt to avoid bouncing it around if guest is updating it meanwhile
on another CPU, and I think my testing showed that it helped
performance, but could be a mistake.  You don't believe this can help?



>
>> We could merge DESC, AVAIL, USED, and it will reduce the amount of code
>> in userspace. With both base, size and fds separate, it seemed a bit
>> more symmetrical to have desc/avail/used separate as well.
>> What's your opinion?
>
> Well, DESC, AVAIL, and USED could easily be turned into SET/GET_LAYOUT.


Will do.

>
>> > For future reference, this is *exactly* the kind of thing which would have
>> > been nice as a followup patch.  Easy to separate, easy to review, not critical
>> > to the core.
>>
>> Yes. It's not too late to split it out though: should I do it yet?
>
> Only if you're feeling enthused.  It's lightly reviewed now.


Not really :) I'll keep this in mind for the future.
Thanks!



>
> Cheers,
> Rusty.
