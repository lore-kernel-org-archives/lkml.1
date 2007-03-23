Return-Path: <linux-kernel-owner+w=401wt.eu-S934221AbXCWApR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934221AbXCWApR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 20:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934223AbXCWApR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 20:45:17 -0400
Received: from mail.suse.de ([195.135.220.2]:41318 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934221AbXCWApP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 20:45:15 -0400
From: Neil Brown <neilb@suse.de>
To: "Dan Williams" <dan.j.williams@intel.com>
Date: Fri, 23 Mar 2007 11:44:58 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17923.8970.917375.917772@notabene.brown>
Cc: "Jens Axboe" <jens.axboe@oracle.com>, linux@horizon.com,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-kernel@dale.us, cebbert@redhat.com
Subject: Re: 2.6.20.3 AMD64 oops in CFQ code
In-Reply-To: message from Dan Williams on Thursday March 22
References: <20070322184155.GY19922@kernel.dk>
	<20070322185413.13929.qmail@science.horizon.com>
	<20070322190052.GA19922@kernel.dk>
	<17923.6258.855467.589548@notabene.brown>
	<e9c3a7c20703221731p2eeb727eo44eb12ec9287d2c0@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday March 22, dan.j.williams@intel.com wrote:
> 
> Not a cfq failure, but I have been able to reproduce a different oops
> at array stop time while i/o's were pending.  I have not dug into it
> enough to suggest a patch, but I wonder if it is somehow related to
> the cfq failure since it involves congestion and drives going away:

Thanks.   I know about that one and have a patch about to be posted
which should fix it.  But I don't completely understand it.

When a raid5 array shuts down, it clears mddev->private, but doesn't
clean q->backing_dev_info.congested_fn.  So if someone tries to call
that congested_fn, it will try to dereference mddev->private and Oops.

Only by the time that raid5 is shutting down, no-one should have a
reference to the device any more, and no-one should be in a position
to call congested_fn !!

Maybe pdflush is just trying to sync the block device, even though
there is no dirty date .... dunno....

But I don't think it is related to the cfq problem as this one is only
a problem when the array is being stopped.

Thanks,
NeilBrown
