Return-Path: <linux-kernel-owner+w=401wt.eu-S1756209AbZIUN5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbZIUN5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbZIUN52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:57:28 -0400
Received: from gir.skynet.ie ([193.1.99.77]:52173 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943AbZIUN51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:57:27 -0400
Date: Mon, 21 Sep 2009 14:57:33 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Tejun Heo <tj@kernel.org>
Cc: Sachin Sant <sachinp@in.ibm.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>, heiko.carstens@de.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/3] slqb: Do not use DEFINE_PER_CPU for per-node data
Message-ID: <20090921135733.GP12726@csn.ul.ie>
References: <1253302451-27740-1-git-send-email-mel@csn.ul.ie> <1253302451-27740-2-git-send-email-mel@csn.ul.ie> <84144f020909200145w74037ab9vb66dae65d3b8a048@mail.gmail.com> <4AB5FD4D.3070005@kernel.org> <4AB5FFF8.7000602@cs.helsinki.fi> <4AB6508C.4070602@kernel.org> <4AB739A6.5060807@in.ibm.com> <20090921084248.GC12726@csn.ul.ie> <20090921130440.GN12726@csn.ul.ie> <4AB78385.6020900@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4AB78385.6020900@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 10:45:41PM +0900, Tejun Heo wrote:
> Hello,
> 
> Mel Gorman wrote:
> > This latter guess was close to the mark but not for the reasons I was
> > guessing. There isn't magic per-cpu-area-freeing going on. Once I examined
> > the implementation of per-cpu data, it was clear that the per-cpu areas for
> > the node IDs were never being allocated in the first place on PowerPC. It's
> > probable that this never worked but that it took a long time before SLQB
> > was run on a memoryless configuration.
> 
> Ah... okay, so node id was being used to access percpu memory but the
> id wasn't in cpu_possible_map.  Yeah, that will access weird places in
> between proper percpu areas. 

Indeed

> I never thought about that.  I'll add
> debug version of percpu access macros which check that the offset and
> cpu make sense so that things like this can be caught easier.
> 

It would not hurt. I consider the per-node usage model to be rare but
it's possible there are issues with CPU hotplug and per-cpu data lurking
around that such a debug patch might catch.

> As Pekka suggested, using MAX_NUMNODES seems more appropriate tho
> although it's suboptimal in that it would waste memory and more
> importantly not use node-local memory. :-(
> 

If the per-cpu macros are to be used for per-node data, it would need to
be generalised to encompass more IDs than what is in cpu_possible_map.
It depends on how much demand there is for per-node data and how much it
helps. I have no data on that.

> Sachin, does the hang you're seeing also disappear with Mel's patches?
> 

Sachin should be enjoying his holiday and I'm hogging his machine at the
moment.  However, I can report that with this patch applied as well as the
remote-free patch that the machine locks up after a random amount of time
has passed and doesn't respond to sysrq. Setting
CONFIG_RCU_CPU_STALL_DETECTOR=y didn't help throw up an error. Will
enable a few other debug options related to stall detection and see does
it pop out.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
