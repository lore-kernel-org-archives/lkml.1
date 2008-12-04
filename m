Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbYLDOrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbYLDOrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 09:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753347AbYLDOrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 09:47:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51776 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbYLDOrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 09:47:02 -0500
Date: Thu, 4 Dec 2008 15:58:10 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Alasdair G Kergon <agk@redhat.com>,
       Andi Kleen <andi-suse@firstfloor.org>, Milan Broz <mbroz@redhat.com>
Subject: Re: Device loses barrier support (was: Fixed patch for simple barriers.)
Message-ID: <20081204145810.GR6703@one.firstfloor.org>
References: <Pine.LNX.4.64.0812040009340.15169@hs20-bc2-1.build.redhat.com> <20081204100050.GN6703@one.firstfloor.org> <Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com> <20081204142015.GQ6703@one.firstfloor.org> <Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You start pvmove. The filesystem doesn't know about pvmove.
> 
> The next time filesystem does somethig, it submits these 3 requests and 
> the 2nd fill unexpectedly fail.

Again the file systems handle failing barriers and they expect it.

> 
> So the fact that pvmove drains the request queue won't help you.

Help you against what? 

> 
> > > finished after the 2nd write) and you are in an interrupt context, where 
> > > you can't reissue -EOPNOTSUPP request. So what do you want to do?
> > 
> > The barrier aware file systems I know of just resubmit synchronously when 
> > a barrier fails.
> 
> ... and produce structure corruption for certain period in time, because 
> the writes meant to be ordered are submitted unordered.

No there is nothing unordered. The file system path typically looks like

commit of a transaction
	if (i have never seen a barrier failing) 
		write block with barrier
		if (EOPNOTSUPP) {
			record failure
			submit synchronously
		}
	} else
		submit synchronously


So if a pvmove barrier fails it will just submit synchronously.

The write block with barrier bit varies, jbd/gfs2 do it synchronously
too and xfs does it asynchronously (with io done callbacks), but
in both cases they handle an EOPNOTSUPP comming out in the final
io done.

When the pvmove migrates from no barrier support to barrier support
there won't be any barrier on the file system for the time of the
current mount, but that's also fine.

-Andi
