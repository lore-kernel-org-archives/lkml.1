Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbZIUNq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbZIUNq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbZIUNqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:46:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:39716 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbZIUNqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:46:23 -0400
Message-ID: <4AB78385.6020900@kernel.org>
Date: Mon, 21 Sep 2009 22:45:41 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Sachin Sant <sachinp@in.ibm.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Nick Piggin <npiggin@suse.de>,
       Christoph Lameter <cl@linux-foundation.org>, heiko.carstens@de.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/3] slqb: Do not use DEFINE_PER_CPU for per-node data
References: <1253302451-27740-1-git-send-email-mel@csn.ul.ie> <1253302451-27740-2-git-send-email-mel@csn.ul.ie> <84144f020909200145w74037ab9vb66dae65d3b8a048@mail.gmail.com> <4AB5FD4D.3070005@kernel.org> <4AB5FFF8.7000602@cs.helsinki.fi> <4AB6508C.4070602@kernel.org> <4AB739A6.5060807@in.ibm.com> <20090921084248.GC12726@csn.ul.ie> <20090921130440.GN12726@csn.ul.ie>
In-Reply-To: <20090921130440.GN12726@csn.ul.ie>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 21 Sep 2009 13:45:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Mel Gorman wrote:
> This latter guess was close to the mark but not for the reasons I was
> guessing. There isn't magic per-cpu-area-freeing going on. Once I examined
> the implementation of per-cpu data, it was clear that the per-cpu areas for
> the node IDs were never being allocated in the first place on PowerPC. It's
> probable that this never worked but that it took a long time before SLQB
> was run on a memoryless configuration.

Ah... okay, so node id was being used to access percpu memory but the
id wasn't in cpu_possible_map.  Yeah, that will access weird places in
between proper percpu areas.  I never thought about that.  I'll add
debug version of percpu access macros which check that the offset and
cpu make sense so that things like this can be caught easier.

As Pekka suggested, using MAX_NUMNODES seems more appropriate tho
although it's suboptimal in that it would waste memory and more
importantly not use node-local memory. :-(

Sachin, does the hang you're seeing also disappear with Mel's patches?

Thanks.

-- 
tejun
