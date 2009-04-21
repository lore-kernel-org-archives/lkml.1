Return-Path: <linux-kernel-owner+w=401wt.eu-S1752275AbZDUHcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbZDUHcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbZDUHbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:31:52 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48020 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbZDUHbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:31:52 -0400
Date: Tue, 21 Apr 2009 09:31:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: Nikanth Karthikesan <knikanth@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] make hd_struct->in_flight atomic to avoid
	diskstat   corruption
Message-ID: <20090421073150.GZ4593@kernel.dk>
References: <200904161254.41433.knikanth@suse.de> <20090416073557.GU5178@kernel.dk> <200904161445.03955.knikanth@suse.de> <49E74377.6050209@kernel.org> <20090416163254.GQ5178@kernel.dk> <49EAE602.3090802@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EAE602.3090802@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 19 2009, Tejun Heo wrote:
> Hello,
> 
> Jens Axboe wrote:
> > On Thu, Apr 16 2009, Tejun Heo wrote:
> >> Hello, Nikanth, Jens.
> >>
> >> Nikanth Karthikesan wrote:
> >>>> Hmm. Did you observe this behaviour?
> >>> Sorry, not on current kernels. But on a very old 2.6.5 kernel.
> >>>
> >>> Reading Documentation/iostats.txt and the changelog of commit 
> >>> e71bf0d0ee89e51b92776391c5634938236977d5 made me assume that this could be a 
> >>> problem even today.
> >> The only problem we can run into there is if a request doesn't get
> >> attributed to a partition on issue but gets attributed to a partition
> >> on completion, which seems to be possible if a new partition is added
> >> while IO on the whole device which fell into the new partition area is
> >> already in progress, which, on the first glance, seems possible if the
> >> admin tries really hard.  I think we can get around the problem by
> >> doing part->in_flight = min(max(new_val, part0->in_flight), 0) in
> >> dec_in_flight().  This is pretty extreme corner case tho.
> > 
> > Heh, that is pretty extreme. I'd prefer just quiescing the queue,
> > perhaps we should do that for partition map swaps.
> 
> Yeah, I think that would be the better approach for swapping ptbl.
> RCU isn't really necessary there.

I think so, it definitely makes more sense to make the swap operation
heavier if we can make the read side free. Doesn't make much sense to
optimize for swapping partition tables ;)

-- 
Jens Axboe

