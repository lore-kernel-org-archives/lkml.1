Return-Path: <linux-kernel-owner+w=401wt.eu-S1757772AbYAPGNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbYAPGNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 01:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbYAPGNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 01:13:08 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:42312 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbYAPGNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 01:13:07 -0500
Date: Tue, 15 Jan 2008 22:13:06 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@gmail.com>
Subject: Re: [PATCH 001 of 6] md: Fix an occasional deadlock in raid5
In-Reply-To: <20080115215425.b1fcba31.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.0.999999.0801152157310.9578@twinlark.arctic.org>
References: <20080114123726.19968.patches@notabene> <1080114014525.20337@suse.de> <alpine.DEB.0.999999.0801152059170.9578@twinlark.arctic.org> <20080115215425.b1fcba31.akpm@linux-foundation.org>
User-Agent: Alpine 0.999999 (DEB 847 2007-12-06)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008, Andrew Morton wrote:

> On Tue, 15 Jan 2008 21:01:17 -0800 (PST) dean gaudet <dean@arctic.org> wrote:
> 
> > On Mon, 14 Jan 2008, NeilBrown wrote:
> > 
> > > 
> > > raid5's 'make_request' function calls generic_make_request on
> > > underlying devices and if we run out of stripe heads, it could end up
> > > waiting for one of those requests to complete.
> > > This is bad as recursive calls to generic_make_request go on a queue
> > > and are not even attempted until make_request completes.
> > > 
> > > So: don't make any generic_make_request calls in raid5 make_request
> > > until all waiting has been done.  We do this by simply setting
> > > STRIPE_HANDLE instead of calling handle_stripe().
> > > 
> > > If we need more stripe_heads, raid5d will get called to process the
> > > pending stripe_heads which will call generic_make_request from a
> > > different thread where no deadlock will happen.
> > > 
> > > 
> > > This change by itself causes a performance hit.  So add a change so
> > > that raid5_activate_delayed is only called at unplug time, never in
> > > raid5.  This seems to bring back the performance numbers.  Calling it
> > > in raid5d was sometimes too soon...
> > > 
> > > Cc: "Dan Williams" <dan.j.williams@gmail.com>
> > > Signed-off-by: Neil Brown <neilb@suse.de>
> > 
> > probably doesn't matter, but for the record:
> > 
> > Tested-by: dean gaudet <dean@arctic.org>
> > 
> > this time i tested with internal and external bitmaps and it survived 8h 
> > and 14h resp. under the parallel tar workload i used to reproduce the 
> > hang.
> > 
> > btw this should probably be a candidate for 2.6.22 and .23 stable.
> > 
> 
> hm, Neil said
> 
>   The first fixes a bug which could make it a candidate for 24-final. 
>   However it is a deadlock that seems to occur very rarely, and has been in
>   mainline since 2.6.22.  So letting it into one more release shouldn't be
>   a big problem.  While the fix is fairly simple, it could have some
>   unexpected consequences, so I'd rather go for the next cycle.
> 
> food fight!
> 

heheh.

it's really easy to reproduce the hang without the patch -- i could
hang the box in under 20 min on 2.6.22+ w/XFS and raid5 on 7x750GB.
i'll try with ext3... Dan's experiences suggest it won't happen with ext3
(or is even more rare), which would explain why this has is overall a
rare problem.

but it doesn't result in dataloss or permanent system hangups as long
as you can become root and raise the size of the stripe cache...

so OK i agree with Neil, let's test more... food fight over! :)

-dean
