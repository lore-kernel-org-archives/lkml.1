Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbZJZCMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbZJZCMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 22:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbZJZCMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 22:12:19 -0400
Received: from mail-gx0-f216.google.com ([209.85.217.216]:53205 "EHLO
	mail-gx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754596AbZJZCMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 22:12:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Jje9x2G1XWv3wYRpYAxebxtInfqAmtGXuI4swabA3car5j3H1fHBkUMRvrY1wRSQXJ
         m3colSmvu7XqimmD86pDMvu5XI2JY4HcFO1VgEpRXIfq7BpHpTtsBB8PeEvRqzjHtI22
         PnTnxKqBzIGhBYsdJpiWTXd9NoE7vDzvAFIDI=
MIME-Version: 1.0
In-Reply-To: <1256165349.15474.17.camel@localhost>
References: <1256165349.15474.17.camel@localhost>
Date: Mon, 26 Oct 2009 12:12:23 +1000
Message-ID: <21d7e9970910251912w799b1fa4q1bea17f7524102d4@mail.gmail.com>
Subject: Re: Changing radeon KMS cs+gem ioctl to merge read & write domain
From: Dave Airlie <airlied@gmail.com>
To: Jerome Glisse <glisse@freedesktop.org>
Cc: DRI Development Mailing List <dri-devel@lists.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 8:49 AM, Jerome Glisse <glisse@freedesktop.org> wrote:
> Hi,
>
> I think we should merge the read & write domain of radeon KMS
> into a single domains information. I don't think there is a
> good reason for separate read & write domain, we did copy intel
> model for that and intel use this mostly for cache coherency &
> cache flushing as far as i understand. We make no good use of
> this inside the kernel. In order to make this change less disruptive
> and easier to introduce i propose we keep libdrm-radeon api
> intact thus userspace xf86video-ati & mesa 3d driver doesn't
> need a single line patch to adapt. Attached is a proof of concept,
> a patch against libdrm which merge read & write domain and only
> use the read domain to communicate with the kernel. I am still
> in process of stress testing this patch but so far neither X
> or 3D had any glitches.
>

Can you list the advantages (speed, complexity reduction)?, I really
really don't like this patch at this point in the development process,
yes the API has warts does fixing it now help any or just increase
the chance of regressions.

Like I don't think we've hit any of the limitations yet, and I suspect
the API limitations we hit will require a new revision of the API, which
I'd rather do once, than just hack away functionality because the current
underlying implementation doesn't use it yet.

I'd really like to use the read/write information to help decide VRAM/GTT
migration priorities in the future, I've mentioned this a few times and I've
haven't heard how your scheme addresses this.

Some issues I can see are you haven't really defined how userspace
users of this API should look, like who decides the buffer placement?
userspace only? can the kernel override? how does the kernel know
which allocs it can override and which it can't? how does space
checking work for the VRAM but maybe GTT buffers?

I don't think the API we have is perfect by any means I just don't think
investing in tweaking the corners for no real benefit is worth it. Just
make the gallium winsys API clean and then you don't need to look
at this stuff, and in a year or two a new API that actually provides benefits
and speedups after we've learned a bit from this one.

Dave.
