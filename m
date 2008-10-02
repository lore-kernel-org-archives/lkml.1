Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbYJBX7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbYJBX7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbYJBX6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:58:55 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:51323 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753380AbYJBX6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:58:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgkDAGf65Eh5LF82iGdsb2JhbACTWgEBARUiqUyBag
X-IronPort-AV: E=Sophos;i="4.33,353,1220193000"; 
   d="scan'208";a="219310931"
Date: Fri, 3 Oct 2008 09:58:49 +1000
From: Dave Chinner <david@fromorbit.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, arjan@infradead.org,
       andi@firstfloor.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002235849.GJ30001@disturbed>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>, arjan@infradead.org,
	andi@firstfloor.org, linux-kernel@vger.kernel.org,
	alan@lxorguk.ukuu.org.uk
References: <20081001200034.65eb67d6@infradead.org> <20081001215638.3a65134c.akpm@linux-foundation.org> <87fxnfpjqj.fsf@basil.nowhere.org> <20081002075511.GX19428@kernel.dk> <20081002093326.GF30001@disturbed> <20081002094537.GA19428@kernel.dk> <20081002120408.21585949@infradead.org> <20081002192223.GP19428@kernel.dk> <20081002143713.2f8ebc04.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081002143713.2f8ebc04.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 02:37:13PM -0700, Andrew Morton wrote:
> On Thu, 2 Oct 2008 21:22:23 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> > Can we agree on this patch?
> 
> This change will cause _all_ kjournald writeout to have elevated
> priority.  The majority of that writeout (in data=ordered mode) is file
> data, which we didn't intend to change.
> 
> The risk here is that this will *worsen* latency for plain old read(),
> because now kjournald writeout will be favoured.
> 
> There is in fact a good argument for _reducing_ kjournald's IO
> priority, not increasing it!
> 
> A better approach might be to mark the relevant buffers/bios as needing
> higher priority at submit_bh() time (if that's possible).  At least
> that way we don't accidentally elevate the priority of the bulk data.

You can do that for submit_bio() by calling bio_set_prio() before
submision - I did that for elevating only the XFS journal I/O.
submit_bh() doesn't have any way of passing a priority through to it
right now...

I should resurrect the XFS patches I had an retest them....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
