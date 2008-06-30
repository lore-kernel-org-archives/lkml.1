Return-Path: <linux-kernel-owner+w=401wt.eu-S1761138AbYF3Pzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761138AbYF3Pzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbYF3Pzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:55:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40013 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750842AbYF3Pzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:55:42 -0400
Date: Mon, 30 Jun 2008 08:55:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] Fix copy_user on x86_64
In-Reply-To: <m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com>
Message-ID: <alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org>
References: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org> <m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Jun 2008, Vitaly Mayatskikh wrote:
> 
> "For this reason, all patches should be submitting e-mail "inline".
> WARNING:  Be wary of your editor's word-wrap corrupting your patch,
> if you choose to cut-n-paste your patch."
> 
> My first thought was "should be attached inline".

Yeah, no, the "inline" there means literally as no attachment at all, but 
inline in the normal mail.

Sometimes it's not possible (known broken MUA's/MTA's), and for really big 
patches it's usually not all that useful anyway, since nobody is going to 
review or comment on rally big patches in the first place (but because of 
that, nobody should ever even _send_ such patches, because they are 
pointless). But in general, if you don't have a crappy MUA/MTA setup, 
putting the patch at the end of the email as normal inline text, no 
attachment, means that every form of emailer known to man will have no 
problem quoting it for commentary or showing it by default etc.

> Agreed. Code was reworked again, will test it a bit more. Two more
> questions to you and Andi:
> 
> 1. Do you see any reasons to do fix alignment for destination as it was
> done in copy_user_generic_unrolled (yes, I know, access to unaligned
> address is slower)? It tries to byte-copy unaligned bytes first and then
> to do a normal copy. I think, most times destination addresses will be
> aligned and this check is not so necessary. If it is necessary, then
> copy_user_generic_string should do the same.

Usually the cost of alignment is higher for writes than for reads (eg you 
may be able to do two cache reads per cycle but only one cache write), so 
aligning the destination preferentially is always a good idea.

Also, if the source and destination are actualy mutually aligned, and the 
_start_ is just not aligned, then aligning the destination will align the 
source too (if they aren't mutually aligned, one or the other will always 
be an unaligned access, and as mentioned, it's _usually_ cheaper to do the 
load unaligned rather than the store).

So I suspect the alignment code is worth it. There are many situations 
where the kernel ends up having unaligned memory copies, sometimes big 
ones too: things like TCP packets aren't nice powrs-of-two, so when you do 
per-packet copying, even if the user passed in a buffer that was 
originally aligned, by the time you've copied a few packets you may no 
longer be nicely aligned any more.

> 2. What is the purpose of "minor optimization" in commit
> 3022d734a54cbd2b65eea9a024564821101b4a9a?

I think that one was just a "since we're doing that 'and' operation, and 
since it sets the flags anyway, jumping to a special sequence is free".

Btw, for string instructions, it would probably be nice if we actually 
tried to trigger the "fast string" mode if possible. Intel CPU's (and 
maybe AMD ones too) have a special cache-line optimizing mode for "rep 
movs" that triggers in special circumstances:

  "In order for a fast string move to occur, five conditions must be met:

   1. The source and destination address must be 8-byte aligned.
   2. The string operation (rep movs) must operate on the data in 
      ascending order
   3. The initial count (ECX) must be at least 64
   4. The source and the destination can't overlap by less than a cache 
      line
   5. The memory types of both source and destination must either be write 
      back cacheable or write combining."

and we historically haven't cared much, because the above _naturally_ 
happens for the bulk of the important cases (copy whole pages, which 
happens not just in the VM for COW, but also when a user reads a regular 
file in aligned chunks). But again, for networking buffers, it _might_ 
make sense to try to help trigger this case explicitly.

			Linus
