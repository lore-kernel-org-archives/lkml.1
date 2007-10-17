Return-Path: <linux-kernel-owner+w=401wt.eu-S935906AbXJQCWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935906AbXJQCWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 22:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758017AbXJQCWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 22:22:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39182 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756393AbXJQCWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 22:22:36 -0400
Date: Tue, 16 Oct 2007 19:21:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix adbhid mismerge
In-Reply-To: <alpine.LFD.0.999.0710161751070.26902@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0710161907020.26902@woody.linux-foundation.org>
References: <20071017000246.GE8181@ftp.linux.org.uk>
 <alpine.LFD.0.999.0710161751070.26902@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Oct 2007, Linus Torvalds wrote:
> 
> I don't think you did anything wrong. You used both --full-history 
> (implicitly: git-whatchanged) and you made sure to see the diffs for both 
> sides of any merge (-m), and that means that you should see every single 
> diff involved.

Btw, if anybody can come up with a better way to find these kinds of 
mis-merges, I'd love to hear about it.

In *this* particular case, the -c flag ("combined" merge diff) probably 
comes closest, and is certainly a lot better than passing in -m (which 
shows each merge against both parents separately), and in fact, I think 
you would have found the mis-merge immediately if you had used

	git whatchanged -p -c v2.6.23.. drivers/macintosh/adbhid.c

but I'm not going to guarantee that -c always gives you what you want.

In general, the rules are:

 - the default for merge diffs is to show "condensed combined" merge, ie 
   the diff of only those parts where the result actively differs from 
   *both* parents.

   This is very terse, and it has the wonderful property of showing merges 
   where you actually ended up doing "real work" and not just picking one 
   side or the other, but in this case the very fact that the mis-merge 
   had picked one side (and it really would have _needed_ a correct manual 
   merge) also meant that the default "--cc" format didn't show anything 
   at all.

 - "-c" is for regular combined merges: any file that was modified in both 
   parents will show up as a combination of the diffs of both sides, while 
   a file that was taken in its *entirety* is ignored.

   In this case that's exactly what you wanted. It's just too noisy to 
   necessarily be the default, and you can still have a silent mis-merge 
   if the merger picked *only* one side.

   But in general, I suspect that "-c" is often a good thing to try if you 
   cannot find the cause of some change in a regular commit, and suspect a 
   merge error.

 - "-m" shows each side totally independently. Quite frankly, I've never 
   found it useful. It is essentially guaranteed to show all changes, 
   since it shows the patches against all parents individually, so even if 
   we took only one side, we'll still show the patch against the *other* 
   side, but quite frankly, while it's thus useful in theory, in practice 
   the end result is just too noisy to likely ever really be useful as 
   anything but a "yes, the information is there (..but it's practically 
   impossible to find for all the other noise that is also there)"

The main reason "-m" exists is historical: before Junio implemented the 
combined formats, -m was the easy way to show *any* information. I bet -m 
can be useful in some case where you have some pattern you can search for 
(ie I used -m in this case to find the mis-merge, but realized only later 
that I would have been better off using -c), but it's not something I'd 
recommend unless you were really desperate.

What I'd actually really like would be something that shows the original 
conflict, but that's really expensive to compute (it basically involves 
re-doing the merge from scratch - finding the proper base commit(s) etc). 
So we never did that.

		Linus
