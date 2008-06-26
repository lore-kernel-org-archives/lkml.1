Return-Path: <linux-kernel-owner+w=401wt.eu-S1758533AbYFZP64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533AbYFZP64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbYFZP6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:58:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:48449 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbYFZP6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:58:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=wdSfhrWrJ1JSSiAvCxCV/G610YNKEvN87T5C4SHYoO3tqZ4Lf7rI2D/ZZSxFXKcmUH
         yvv/mWDNzn1wU4C8xabNAp5mLnCPU1qW8Hie7bF+FPbJAQ4FEXHgRUTXrOA1o/EvFX18
         JZicw/GfOmOya5/u7q/MugMeCcAVBvaHDE2Fc=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Anton Arapov <aarapov@redhat.com>,
       Vitaly Mayatskikh <v.mayatskih@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix copy_user on x86_64
References: <m3myl9hf0o.fsf@gravicappa.englab.brq.redhat.com>
	<48635DA0.80102@redhat.com>
	<alpine.LFD.1.10.0806260837290.10755@hp.linux-foundation.org>
Date: Thu, 26 Jun 2008 17:58:41 +0200
In-Reply-To: <alpine.LFD.1.10.0806260837290.10755@hp.linux-foundation.org>
	(Linus Torvalds's message of "Thu, 26 Jun 2008 08:37:49 -0700 (PDT)")
Message-ID: <m3prq4dw7i.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

>> This is the patch patch for copy_user routine, you've discussed recently.
>
> I don't think it works right.
>
> Isn't this same routine also used for copy_in_user()? For that case both 
> source _and_ destination can fault, but your fixup routines assume that 
> onle one of them does (ie the fixup for a load-fault does a store for the 
> previously loaded valies, and assumes that it doesn't trap)

Right. I've missed it... :(

> Also, I'd realy rather do this all by handling the "taul" case in C. We 
> already effectively have _half_ that support: the "clear end" flag ends up 
> calling our specialized memset() routine, but it would be much nicer if 
> we:
>
>  - extended the "clear end" flag to be not just "clear end", but also 
>    which direction things are going.
>  - always call a (fixed) fixup-routine that is written in C (because 
>    performance on a cycle basis no longer matters) that gets the remaining 
>    length and the source and destination as arguments, along with the 
>    "clear and direction flag".
>  - make that fixup routine do the byte-exact tests and any necessary 
>    clearing (and return the possibly-fixed-up remaining length).
>
> Notice how this way we still have _optimal_ performance for the case where 
> no fault happens, and we don't need any complex fixups in assembly code at 
> all - the only thing the asm routines need to do is to get the right 
> length (we already have this) and fix up the source/dest pointers (we 
> don't generally have this, although the zero-at-end fixes up the 
> destination pointer in order to zero it, of course).
>
> Hmm?

Seems reasonable. However, we still need specialized memset() routine,
because, again, destination can fail. Thanks for the review, Linus!
-- 
wbr, Vitaly
