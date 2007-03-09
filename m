Return-Path: <linux-kernel-owner+w=401wt.eu-S2993005AbXCIGd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993005AbXCIGd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 01:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993001AbXCIGd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 01:33:29 -0500
Received: from straum.hexapodia.org ([64.81.70.185]:36080 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992999AbXCIGd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 01:33:28 -0500
Date: Thu, 8 Mar 2007 22:33:27 -0800
From: Andy Isaacson <adi@hexapodia.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
Subject: Re: [PATCH] fix read past end of array in md/linear.c
Message-ID: <20070309063327.GM29544@hexapodia.org>
References: <20070308205204.GA12152@hexapodia.org> <45F0C87A.9000400@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F0C87A.9000400@tmr.com>
User-Agent: Mutt/1.4.2.2i
X-PGP-Fingerprint: 48 01 21 E2 D4 E4 68 D1  B8 DF 39 B2 AF A3 16 B9
X-PGP-Key-URL: http://web.hexapodia.org/~adi/pgp.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 09:37:46PM -0500, Bill Davidsen wrote:
> Andy Isaacson wrote:
> >% dd bs=1 seek=840716287 if=/dev/zero of=d1 count=1
> >% for i in 2 3 4; do dd if=/dev/zero of=d$i bs=1k count=$(($i+150)); done
[snip]
> >-		for (j=i; i<cnt-1 && sz < min_spacing ; j++)
> >+		for (j=i; j<cnt-1 && sz < min_spacing ; j++)
> > 			sz += conf->disks[j].size;
> 
> After looking at that code, I have to wonder how this ever worked, or if 
> in fact anyone ever took this path. I assume that the value of sz caused 
> the loop exit in all cases, since this has been in the code at least 
> since 2.6.15, oldest thing I have handy.

Well, just about any sane set of device sizes causes sz to rapidly
exceed min_spacing.  You'll notice that my failure case is
{ 800MB, 151kB, 152kB, 153kB, 154kB }.

And even in the failure case, it's just a read from uninitialized
memory, which is probably either a small value (so it won't make the
answer very wrong) or a large value (so it will be rejected in the
immediately following code).  In my case it happened to be some slab
poison of 0xa5a5a5a5 or something like that, and the code went on just
fine.

-andy
