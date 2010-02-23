Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828Ab0BWEsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 23:48:24 -0500
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:33790 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753629Ab0BWEsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 23:48:23 -0500
Date: Tue, 23 Feb 2010 15:48:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: disk/crypto performance regression 2.6.31 -> 2.6.32 (mmap
	problem?)
Message-ID: <20100223044818.GD22370@discord.disaster>
References: <alpine.DEB.1.10.1002191729220.28940@uplift.swm.pp.se> <alpine.DEB.1.10.1002221337170.28940@uplift.swm.pp.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.1002221337170.28940@uplift.swm.pp.se>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 01:39:37PM +0100, Mikael Abrahamsson wrote:
> On Fri, 19 Feb 2010, Mikael Abrahamsson wrote:
>
>> I have a system with 8 gigs of ram, c2d 2.4GHz and md  
>> raid6->crypto->lvm/lv->xfs that I've had for quite a while. It used to 
>> be raid5, but with 2.6.32 I was able to restripe it into a raid6.
>
> This is not a 2.6.32 regression, the behaviour is similar in 2.6.31 I 
> have verified during the weekend.
>
> It seems iostat isn't really able to see exactly where the bottleneck is, 
> and my guess right now is that it's indeed the md raid6 layer that is  
> causing my performance problems, even though it doesn't look like it in  
> iostat.

XFS issues IO barriers by default. They were recently enabled in md
for raid5/6, so that might be the cause of the slowdown/latency. You
could try using the "nobarrier" mount option to see if this make the
problem go away, but beware that this can result in filesystem
corruption if the machine crashes.

If it is not barriers that are causing this, then the other thing
you might want to look at is if XFS is configured with lazy-count=1
(xfs_info <mntpt>). If it is not enabled (0), then a significant
amount of latency could be coming from the superblock buffer being
locked during transaction commits. Unfortunately enabling this
feature is an offline operation (via xfs_admin) so enabling may not
be feasible for you.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
