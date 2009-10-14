Return-Path: <linux-kernel-owner+w=401wt.eu-S1761806AbZJNN4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761806AbZJNN4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 09:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761592AbZJNN4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 09:56:03 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:39446 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760532AbZJNN4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 09:56:03 -0400
Subject: Re: bdi_threshold slow to reach steady state
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wu Fengguang <fengguang.wu@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       Martin Bligh <mbligh@google.com>
In-Reply-To: <1255520272.8392.429.camel@twins>
References: <1255518586.2360.78.camel@castor>
	 <1255520272.8392.429.camel@twins>
Content-Type: text/plain
Date: Wed, 14 Oct 2009 14:55:20 +0100
Message-Id: <1255528520.2360.94.camel@castor>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 13:37 +0200, Peter Zijlstra wrote:
> On Wed, 2009-10-14 at 12:09 +0100, Richard Kennedy wrote:
> > Hi Peter,

> 
> Right, so we measure time in page writeback completions, and the measure
> I used was the round up power of two of the dirty_thresh. We adjust in
> the same time it takes to write out a full dirty_thresh amount of data.
> 
> The idea was that people would scale their dirty thesh according to
> their writeout capacity, etc..
> 
> Martin J Bligh complained about this very same issue and I told them to
> experiment with that same scale function. But I guess the result of that
> got lost in the google filter (stuff goes in, nothing ever comes back
> out).
> 
> Anyway, the dirty_thresh relation seems sensible still, but the exact
> parameters could be poked at. I have no objection to reducing the period
> with a factor of 16 like you did, except that we need some more
> feedback, preferably from people with more than a few spindles.

Sure, hopefully big fast machines have large amounts of memory so it
should be a good fit.

Yes, it would be good if someone with a big box tested this ;)
Here's a patch just in case anyone does feel like giving it a spin.

> (The initial ramp will be roughly twice as slow, since the steady state
> of this approximation is half-full).
> 
> > I know that my machine is getting a bit old now, it's AMDX2 & only has
> > sata 150 drives, so I'm not suggesting that this change is going to be
> > correct for all machines but maybe we can set a better default? or take
> > more factors in to account other than just memory size. 
> > 
> > BTW why is it ilog2(dirty_total -1) -- what does the -1 do?
> 
> http://lkml.org/lkml/2007/1/26/143
> 
thanks for that
regards
Richard

(patch against 2.6.32-rc4)

commit 11735a2336ba08cf21aebf79a706c86aca5e44b2
Author: Richard Kennedy <richard@rsk.demon.co.uk>
Date:   Wed Oct 14 14:46:21 2009 +0100

    mm: speed up per bdi dirty threshold calculations
    
    
    Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index a3b1409..018024e 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -144,7 +144,7 @@ static int calc_period_shift(void)
 	else
 		dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) /
 				100;
-	return 2 + ilog2(dirty_total - 1);
+	return ilog2(dirty_total - 1) - 2;
 }
 
 /*


