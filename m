Return-Path: <linux-kernel-owner+w=401wt.eu-S1758558AbYFZPij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558AbYFZPij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 11:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246AbYFZPiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 11:38:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754285AbYFZPiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 11:38:15 -0400
Date: Thu, 26 Jun 2008 08:37:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Anton Arapov <aarapov@redhat.com>
cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix copy_user on x86_64
In-Reply-To: <48635DA0.80102@redhat.com>
Message-ID: <alpine.LFD.1.10.0806260837290.10755@hp.linux-foundation.org>
References: <m3myl9hf0o.fsf@gravicappa.englab.brq.redhat.com> <48635DA0.80102@redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 26 Jun 2008, Anton Arapov wrote:
> 
> This is the patch patch for copy_user routine, you've discussed recently.

I don't think it works right.

Isn't this same routine also used for copy_in_user()? For that case both 
source _and_ destination can fault, but your fixup routines assume that 
onle one of them does (ie the fixup for a load-fault does a store for the 
previously loaded valies, and assumes that it doesn't trap)

Also, I'd realy rather do this all by handling the "taul" case in C. We 
already effectively have _half_ that support: the "clear end" flag ends up 
calling our specialized memset() routine, but it would be much nicer if 
we:

 - extended the "clear end" flag to be not just "clear end", but also 
   which direction things are going.
 - always call a (fixed) fixup-routine that is written in C (because 
   performance on a cycle basis no longer matters) that gets the remaining 
   length and the source and destination as arguments, along with the 
   "clear and direction flag".
 - make that fixup routine do the byte-exact tests and any necessary 
   clearing (and return the possibly-fixed-up remaining length).

Notice how this way we still have _optimal_ performance for the case where 
no fault happens, and we don't need any complex fixups in assembly code at 
all - the only thing the asm routines need to do is to get the right 
length (we already have this) and fix up the source/dest pointers (we 
don't generally have this, although the zero-at-end fixes up the 
destination pointer in order to zero it, of course).

Hmm?

			Linus
