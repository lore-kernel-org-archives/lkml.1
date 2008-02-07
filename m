Return-Path: <linux-kernel-owner+w=401wt.eu-S934031AbYBGXSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031AbYBGXSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:18:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756256AbYBGXSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:18:24 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:48966 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbYBGXSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:18:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ls9I7r/sK3G5TodrSIMFly5MHf+QjNR+AHfUULE1UAyUkCrnFx3sS5M+1FX2JCHiS/hxytFbKsjHAXT5jMAn8bWlqMjRuMOyGoxOIq/Wa3iE4LVPfx8gqW2MdEXKf8DqAzWf+ppTrTvt50xJmfMZHj+YBrXJBuTFxSqfK8XR/0c=
Message-ID: <19f34abd0802071518j1ffc3dafp46fcbd8d36d36f17@mail.gmail.com>
Date: Fri, 8 Feb 2008 00:18:21 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: [PATCH 1/2] kmemcheck v3
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Richard Knutsson" <ricknu-0@student.ltu.se>
In-Reply-To: <Pine.LNX.4.64.0802071443440.3289@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47AB79D4.2070605@gmail.com>
	 <Pine.LNX.4.64.0802071341500.2544@schroedinger.engr.sgi.com>
	 <19f34abd0802071412m569e4993kffb4a3af163fa16c@mail.gmail.com>
	 <Pine.LNX.4.64.0802071443440.3289@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 7, 2008 11:53 PM, Christoph Lameter <clameter@sgi.com> wrote:
> > Are you sure you are not confusing tracking with tracing? It's only
> > one letter different in spelling, but makes a huge difference in
> > meaning :-)
>
> No I am quite sure what tracking is since the slab allocators have their
> own tracking.
>
> But you may want to explain things better.

Ok, then I think we are still talking about different things :-)

The tracking that kmemcheck does is actually a byte-for-byte tracking
of whether memory has been initialized or not. Think of it as valgrind
for the kernel. We do this by "hiding" pages (marking them non-present
for for MMU) and taking the page faults, which effectively tells us
what memory is being attempted to be read from or written to.

(This generally means that the tracking that kmemcheck does is
page-granular, but we can help this by making entire caches tracked or
non-tracked.)

(This also means that *all* tracked memory allocations require twice
the amount of memory that was requested -- but this is luckily
configurable by disabling kmemcheck entirely :-)).

I chose to implement this in the slab layer because this is probably
where most of the interesting allocations are coming from, and this
gives us a better control over what most users/callers care about,
namely the specific objects.

In a way, kmemcheck is similar to slab poisoning, since that can also
be used to detect the cases where memory is used before it is
initialized. This is a heavier-weight approach, however, and more
precise, as it gives you the exact location of the error.

I hope this clears it up.


Kind regards,
Vegard Nossum
