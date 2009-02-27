Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbZB0MFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbZB0MFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 07:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbZB0MFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 07:05:41 -0500
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:43709 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754201AbZB0MFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 07:05:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=lV1In1uXA229SDFUSJzFKKaY+NTP76AIDgAmVYdouf3GuQu/NLHcqWq2zV/Q++beNRlKS+LLX88bkuywL3a8aHFfz2XHqWf2d3y3ki2jKS96A9KhPlw6HiL4kgb1Ca6OapIABWac5sXc4YjbehqYRcTF8zdhNr/r39hjb0jmw+4=  ;
X-YMail-OSG: fzcN2.wVM1n3Bz8IzuTCBZLWlL4CTsSxOSbU1Mj98.JlONE.gyIcYry1QMCGyUooo6VSOKNkPU_4sF91bLCsSCwiTDt_IabD1p2BQ5oGMOV1soTj5QUP9JY9d6rK2mavvr7YZlJEzHBB9VtZA316rZgI0qDYfKmmO4mo7XRaQFp2.4c3iUEBMfgPoDi7eA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Date: Fri, 27 Feb 2009 23:05:00 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Salman Qazi <sqazi@google.com>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
References: <20090224020304.GA4496@google.com> <20090225072503.GD21903@elte.hu> <alpine.LFD.2.00.0902250753030.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902250753030.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902272305.01867.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009 03:04:22 Linus Torvalds wrote:
> On Wed, 25 Feb 2009, Ingo Molnar wrote:
> > The main artifact would be the unaligned edges around a bigger
> > write. In particular the tail portion of a big write will be
> > cached.
>
> .. but I don't really agree that this is a problem.
>
> Sure, it's "wrong", but does it actually matter? No. Is it worth adding
> complexity to existing interfaces for? I think not.
>
> In general, I think that software should not mess with nontemporal stores.
> The thing is, software almost never knows enough about the CPU cache to
> make an intelligent choice.
>
> So I didn't want to apply the nocache patches in the first place, but the
> performance numbers were pretty clear. I'll take "real numbers" over my
> personal dislikes any day. But now we have real numbers going the other
> way for small writes, and a patch to fix that.
>
> But we have no amount of real numbers for the edge cases, and I don't
> think they matter. In fact, I don't think they _can_ matter, because it is
> inevitably always going to be an issue of "which CPU and which memory
> subsystem".
>
> In other words, there is no "right" answer. There is no "perfect". But
> there is "we can fix the real numbers".

Well... these are "real" benchmark numbers. Where the benchmark is
actually apparently performing an access pattern that seemingly
should favour nontemporal stores (the numbers are just measuring the
phase were write(2) is being done).


> At the same time, we also do know:
>  - caches work
>  - CPU designers will continue to worry about the normal (cached) case,
>    and will do reasonable things with cache replacement.
>  - ergo: w should always consider the cached case to be the _normal_ mode,
>    and it's the nontempral loads/stores that need to explain themselves.
>
> So I do think we should just apply the simple patch. Not make a big deal
> out of it. We have numbers. We use cached memory copies for everything
> else. It's always "safe".
>
> And we pretty much know that the only time we will ever really care about
> the nontemporal case is with big writes - where the "edge effects"
> essentially become total noise.

I guess so. I wouldn't mind just doing cached stores all the time for
the reasons you say.

But whatever. If it ever becomes *really* important, I guess we can flag
this kind of behaviour from userspace.


