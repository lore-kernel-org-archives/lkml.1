Return-Path: <linux-kernel-owner+w=401wt.eu-S1753027AbXFXQmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbXFXQmS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 12:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbXFXQmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 12:42:12 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38523 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751000AbXFXQmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 12:42:11 -0400
Date: Sun, 24 Jun 2007 09:40:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Matt Mackall <mpm@selenic.com>, Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, davej@redhat.com,
       tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: Change in default vm_dirty_ratio
In-Reply-To: <1182623031.7066.1.camel@lappy>
Message-ID: <alpine.LFD.0.98.0706240907560.3593@woody.linux-foundation.org>
References: <1182201271.4883.22.camel@localhost.localdomain> 
 <20070618164711.9de1c38e.akpm@linux-foundation.org>  <20070620042434.GC12096@redhat.com>
  <20070619214407.dfff0ca6.akpm@linux-foundation.org>  <1182328536.21117.24.camel@twins>
  <20070620015826.03f1d71a.akpm@linux-foundation.org>  <20070620091404.GO18863@kernel.dk>
 <1182331182.21117.39.camel@twins>  <20070620092058.GP18863@kernel.dk>
 <20070621225320.GP11166@waste.org>  <alpine.LFD.0.98.0706211605540.3593@woody.linux-foundation.org>
 <1182623031.7066.1.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Jun 2007, Peter Zijlstra wrote:

> On Thu, 2007-06-21 at 16:08 -0700, Linus Torvalds wrote:
> > 
> > The vm_dirty_ratio thing is a global value, and I think we need that 
> > regardless (for the independent issue of memory deadlocks etc), but if we 
> > *additionally* had a per-device throttle that was based on some kind of 
> > adaptive thing, we could probably raise the global (hard) vm_dirty_ratio a 
> > lot.
> 
> I just did quite a bit of that:
> 
>   http://lkml.org/lkml/2007/6/14/437

Ok, that does look interesting.

A few comments:

 - Cosmetic: please please *please* don't do this:

	-	if (atomic_long_dec_return(&nfss->writeback) < NFS_CONGESTION_OFF_THRESH) {
	+	if (atomic_long_dec_return(&nfss->writeback) <
	+			NFS_CONGESTION_OFF_THRESH)

   we had a discussion about this not that long ago, and it drives me wild 
   to see people split lines like that. It used to be readable. Now it's 
   not.

   If it's the checkpatch.pl thing that caused you to split it like that, 
   I think we should just change the value where we start complaining. 
   Maybe set it at 95 characters per line or something.

 - I appreciate the extensive comments on floating proportions, and the 
   code looks really quite clean (apart from the cosmetic thing about) 
   from a quick look-through.

   HOWEVER. It does seem to be a bit of an overkill. Do we really need to 
   be quite that clever, and do we really need to do 64-bit calculations 
   for this? The 64-bit ops in particular seem quite iffy: if we ever 
   actually pass in an amount that doesn't fit in 32 bits, we'll turn 
   those per-cpu counters into totally synchronous global counters, which 
   seems to defeat the whole point of them. So I'm a bit taken aback by 
   that whole "mod64" thing

   (I also hate the naming. I don't think "..._mod()" was a good name to 
   begin with: "mod" means "modulus" to me, not "modify". Making it be 
   called "mod64" just makes it even *worse*, since it's now _obviously_ 
   about modulus - but isn't)

So I'd appreciate some more explanations, but I'd also appreciate some 
renaming of those functions. What used to be pretty bad naming just turned 
*really* bad, imnsho.

		Linus
