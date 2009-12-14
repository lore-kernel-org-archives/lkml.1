Return-Path: <linux-kernel-owner+w=401wt.eu-S1755968AbZLNNPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755968AbZLNNPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 08:15:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755066AbZLNNPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 08:15:05 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36648 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbZLNNPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 08:15:01 -0500
Date: Mon, 14 Dec 2009 08:14:44 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: lwoodman@redhat.com, kosaki.motohiro@jp.fujitsu.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, aarcange@redhat.com
Subject: Re: [PATCH] vmscan: limit concurrent reclaimers in shrink_zone
Message-ID: <20091214131444.GA8990@infradead.org>
References: <20091210185626.26f9828a@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091210185626.26f9828a@cuia.bos.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 06:56:26PM -0500, Rik van Riel wrote:
> Under very heavy multi-process workloads, like AIM7, the VM can
> get into trouble in a variety of ways.  The trouble start when
> there are hundreds, or even thousands of processes active in the
> page reclaim code.
> 
> Not only can the system suffer enormous slowdowns because of
> lock contention (and conditional reschedules) between thousands
> of processes in the page reclaim code, but each process will try
> to free up to SWAP_CLUSTER_MAX pages, even when the system already
> has lots of memory free.  In Larry's case, this resulted in over
> 6000 processes fighting over locks in the page reclaim code, even
> though the system already had 1.5GB of free memory.
>
> It should be possible to avoid both of those issues at once, by
> simply limiting how many processes are active in the page reclaim
> code simultaneously.
> 

This sounds like a very good argument against using direct reclaim at
all.  It reminds a bit of the issue we had in XFS with lots of processes
pushing the AIL and causing massive slowdowns due to lock contention
and cacheline bonucing.  Moving all the AIL pushing into a dedicated
thread solved that nicely.  In the VM we already have that dedicated
per-node kswapd thread, so moving off as much as possible work to
should be equivalent.

Of course any of this kind of tuning really requires a lot of testing
and benchrmarking to verify those assumptions.

