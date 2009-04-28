Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbZD1JO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbZD1JO1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbZD1JOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:14:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:62732 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578AbZD1JOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:14:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,259,1239001200"; 
   d="scan'208";a="136704366"
Date: Tue, 28 Apr 2009 17:09:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Elladan <elladan@eskimo.com>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>
Subject: Re: Swappiness vs. mmap() and interactive response
Message-ID: <20090428090916.GC17038@localhost>
References: <20090428044426.GA5035@eskimo.com> <20090428143019.EBBF.A69D9226@jp.fujitsu.com> <1240904919.7620.73.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240904919.7620.73.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 09:48:39AM +0200, Peter Zijlstra wrote:
> On Tue, 2009-04-28 at 14:35 +0900, KOSAKI Motohiro wrote:
> > (cc to linux-mm and Rik)
> > 
> > 
> > > Hi,
> > > 
> > > So, I just set up Ubuntu Jaunty (using Linux 2.6.28) on a quad core phenom box,
> > > and then I did the following (with XFS over LVM):
> > > 
> > > mv /500gig/of/data/on/disk/one /disk/two
> > > 
> > > This quickly caused the system to. grind.. to... a.... complete..... halt.
> > > Basically every UI operation, including the mouse in Xorg, started experiencing
> > > multiple second lag and delays.  This made the system essentially unusable --
> > > for example, just flipping to the window where the "mv" command was running
> > > took 10 seconds on more than one occasion.  Basically a "click and get coffee"
> > > interface.
> > 
> > I have some question and request.
> > 
> > 1. please post your /proc/meminfo
> > 2. Do above copy make tons swap-out? IOW your disk read much faster than write?
> > 3. cache limitation of memcgroup solve this problem?
> > 4. Which disk have your /bin and /usr/bin?
> > 
> 
> FWIW I fundamentally object to 3 as being a solution.
> 
> I still think the idea of read-ahead driven drop-behind is a good one,
> alas last time we brought that up people thought differently.

The semi-drop-behind is a great idea for the desktop - to put just
accessed pages to end of LRU. However I'm still afraid it vastly
changes the caching behavior and wont work well as expected in server
workloads - shall we verify this?

Back to this big-cp-hurts-responsibility issue. Background write
requests can easily pass the io scheduler's obstacles and fill up
the disk queue. Now every read request will have to wait 10+ writes
- leading to 10x slow down of major page faults.

I reach this conclusion based on recent CFQ code reviews. Will bring up
a queue depth limiting patch for more exercises..

Thanks,
Fengguang

