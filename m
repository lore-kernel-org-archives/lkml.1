Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbYCKMH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbYCKMH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 08:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbYCKMHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 08:07:15 -0400
Received: from phunq.net ([64.81.85.152]:38551 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753329AbYCKMHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 08:07:13 -0400
From: Daniel Phillips <phillips@phunq.net>
To: "Ph. Marek" <philipp.marek@bmlv.gv.at>
Subject: Re: [RFC] Stacking bio support
Date: Tue, 11 Mar 2008 04:07:10 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200803110352.41479.phillips@phunq.net> <200803111233.21386.philipp.marek@bmlv.gv.at>
In-Reply-To: <200803111233.21386.philipp.marek@bmlv.gv.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803110507.10858.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008 04:33, Ph. Marek wrote:
> Win32 has IRP stacks, which do mostly the same AFAIU.
> 	http://msdn2.microsoft.com/en-us/library/ms796144.aspx

That seems to be filling a similar need all right, though it looks
like a fancier (read: clunkier) solution.

> How do you handle the reallocation?
> - If you don't do it (but rely on the fact that the initial allocation is
>   enough), you might end up with NO_MORE_IRP_STACK_LOCATIONS
>     http://msdn2.microsoft.com/en-us/library/ms793675.aspx
> - If you do reallocate, the allocations have to register themselves in
>   the emergency pool (see the current thread about swapping over NFS)

Yes, I reallocate.  I do not currently register these with the
emergency pool, good spotting.  I intend to do all such reallocations
with GFP_MEMALLOC (out of tree deadlock-prevention allocation flag) and
rely on (out of tree) bio throttling to prevent the memalloc reserve
from being exhausted.  Hopefully these things will be in-tree in due
course.

Incidentally, the bio stack should make the bio throttling somewhat
more elegant, a nice circular effect.

> I don't say that it's impossible ... just that some "interesting" things will 
> await you. 

Tell me about it :-)

> That's different from the Win32 way AFAIK - there it's defined that every 
> layer *has* to use its own stack location. (But it's been some time since I 
> needed that, so I might be wrong.)

I think you are right.  In fact, I thought about this for a couple of
years, always getting hung up at exactly that point.  When I stopped
trying to see the stack as a fixed size object with preassigned frames,
the rest fell into place.  One obvious problem with the pre-assigned
approach: you don't always know the path ahead of time that a bio
will take to a physical device.
 
> But I sure hope you succeed!

Thankyou for your useful comments.  I do need to present a solution
complete with deadlock prevention.  I guess the bio code will end up
simpler there too, because with the memalloc anti-deadlock approach,
the array of bio mempools can go away.

Regards,

Daniel
