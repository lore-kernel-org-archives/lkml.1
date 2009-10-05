Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbZJEVfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbZJEVfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 17:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbZJEVfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 17:35:06 -0400
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:51752 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754199AbZJEVfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 17:35:05 -0400
From: Frans Pop <elendil@planet.nl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Bug #14141] order 2 page allocation failures in iwlagn
Date: Mon, 5 Oct 2009 23:34:16 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera> <200910050851.02056.elendil@planet.nl> <20091005085739.GB5452@csn.ul.ie>
In-Reply-To: <20091005085739.GB5452@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910052334.23833.elendil@planet.nl>
X-OriginalArrivalTime: 05 Oct 2009 21:34:27.0901 (UTC) FILETIME=[9DC12ED0:01CA4603]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 October 2009, Mel Gorman wrote:
> On Mon, Oct 05, 2009 at 08:50:58AM +0200, Frans Pop wrote:
> > On Monday 05 October 2009, Frans Pop wrote:
> > > I'll dig into this a bit more as it looks like this should be
> > > reproducible, probably even without the kernel build. Next step is
> > > to see how .30 behaves in the same situation.
> >
> > This looks conclusive. I tested .30 and .32-rc3 from clean reboots and
> > only starting gitk. I only started music playing in the background
> > (amarok) from an NFS share to ensure network activity.
> >
> > With .32-rc3 I got 4 SKB allocation errors while starting the *second*
> > gitk instance. And the system was completely frozen with music stopped
> > until gitk finished loading.
> >
> > With .30 I was able to start *three* gitk's (which meant 2 of them got
> > (partially) swapped out) without any allocation errors. And with the
> > system remaining relatively responsive. There was a short break in the
> > music while I started the 2nd instance, but it just continued playing
> > afterwards. There was also some mild latency in the mouse cursor, but
> > nothing like the full desktop freeze I get with .32-rc3.
> >
> > One thing I should mention: my swap is an LVM volume that's in a VG
> > that's on a LUKS encrypted partition.
> >
> > Does this give you enough info to go on, or should I try a bisection?
>
> I'll be trying to reproduce it, but it's unlikely I'll manage to
> reproduce it reliably as there may be a specific combination of hardware
> necessary as well. What I'm going to try is writing a module that
> allocates order-5 every second GFP_ATOMIC and see can I reproduce using
> scenarios similar to yours but it'll take some time with no guarantee of
> success. If you could bisect it, it would be fantastic.

And the winner is:
2ff05b2b4eac2e63d345fc731ea151a060247f53 is first bad commit
commit 2ff05b2b4eac2e63d345fc731ea151a060247f53
Author: David Rientjes <rientjes@google.com>
Date:   Tue Jun 16 15:32:56 2009 -0700

    oom: move oom_adj value from task_struct to mm_struct

I'm confident that the bisection is good. The test case was very reliable 
while zooming in on the merge from akpm.

Cheers,
FJP
