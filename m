Return-Path: <linux-kernel-owner+w=401wt.eu-S1030773AbXD1BMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030773AbXD1BMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 21:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030795AbXD1BMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 21:12:20 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030773AbXD1BMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 21:12:19 -0400
Date: Fri, 27 Apr 2007 18:12:04 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Back to the future.
In-Reply-To: <200704280300.22604.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.98.0704271801020.9964@woody.linux-foundation.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <200704280145.26253.rjw@sisk.pl>
 <alpine.LFD.0.98.0704271647340.9964@woody.linux-foundation.org>
 <200704280300.22604.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Apr 2007, Rafael J. Wysocki wrote:
> 
> > It's doubly bad, because that idiocy has also infected s2ram. Again, 
> > another thing that really makes no sense at all - and we do it not just 
> > for snapshotting, but for s2ram too. Can you tell me *why*?
> 
> Why we freeze tasks at all or why we freeze kernel threads?

In many ways, "at all".

I _do_ realize the IO request queue issues, and that we cannot actually do 
s2ram with some devices in the middle of a DMA. So we want to be able to 
avoid *that*, there's no question about that. And I suspect that stopping 
user threads and then waiting for a sync is practically one of the easier 
ways to do so.

So in practice, the "at all" may become a "why freeze kernel threads?" and 
freezing user threads I don't find really objectionable.

But as Paul pointed out, Linux on the old powerpc Mac hardware was 
actually rather famous for having working (and reliable) suspend long 
before it worked even remotely reliably on PC's. And they didn't do even
that.

(They didn't have ACPI, and they had a much more limited set of devices, 
but the whole process freezer is really about neither of those issues. The 
wild and wacky PC hardware has its problems, but that's _one_ thing we 
can't blame PC hardware for ;)

> > 	git grep create_freezeable_workthread
> 
> s/workthread/workqueue/

Yes.

> > and ponder the end results of that grep. If you don't see something wrong, 
> > you're blind.
> 
> This was a mistake, quite unrelated to the point you're making.

Did you actually _do_ the "grep" (with the fixed argument)?

I had two totally independent points. #1 was that you yourself have been 
fixing bugs in this area. #2 was the result of that grep. It's absolutely 
_empty_ except for the define to add that interface.

NOBODY USES IT!

Now, grep for the same interface that creates _non_freezeable workqueues.

Put another way:

	[torvalds@woody linux]$ git grep create_workqueue | wc -l
	35

	[torvalds@woody linux]$ git grep create_freezeable_workqueue | wc -l
	1

and that _one_ hit you get for the "freezeable" case is not actually a 
user, it's the definition!

Ie my point is, nobody wants freezeable kernel threads. Absolutely nobody.

Yet we have all this support for freezing them (or rather, we freeze them 
by default, and then we have all this support for _not_ doing that wrong 
default thing!)

So yes, I think it would be interesting to just stop freezing kernel 
threads. Totally.

		Linus
