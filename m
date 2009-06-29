Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbZF2TWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbZF2TWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 15:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757400AbZF2TVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 15:21:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756919AbZF2TVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 15:21:50 -0400
Date: Mon, 29 Jun 2009 12:20:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: torvalds@linux-foundation.org, penberg@cs.helsinki.fi, arjan@infradead.org,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org, npiggin@suse.de,
       rientjes@google.com
Subject: Re: upcoming kerneloops.org item: get_page_from_freelist
Message-Id: <20090629122029.93cdcc39.akpm@linux-foundation.org>
In-Reply-To: <20090629153007.GD5065@csn.ul.ie>
References: <4A426825.80905@cs.helsinki.fi>
	<20090624113037.7d72ed59.akpm@linux-foundation.org>
	<alpine.LFD.2.01.0906241134510.3240@localhost.localdomain>
	<20090624120617.1e6799b5.akpm@linux-foundation.org>
	<alpine.LFD.2.01.0906241211550.3154@localhost.localdomain>
	<20090624123624.26c93459.akpm@linux-foundation.org>
	<alpine.LFD.2.01.0906241240360.3154@localhost.localdomain>
	<20090624130121.99321cca.akpm@linux-foundation.org>
	<alpine.LFD.2.01.0906241312090.3154@localhost.localdomain>
	<20090624145615.2ff9e56e.akpm@linux-foundation.org>
	<20090629153007.GD5065@csn.ul.ie>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009 16:30:07 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> Processes that have been OOM killed set the thread flag TIF_MEMDIE. A
> process such as this is expected to exit the page allocator but in the
> event it happens to have set __GFP_NOFAIL, it potentially loops forever.
> 
> This patch checks TIF_MEMDIE when deciding whether to loop again in the
> page allocator. Such a process will now return NULL after direct reclaim
> and OOM killing have both been considered as options. The potential
> problem is that a __GFP_NOFAIL allocation can still return failure so
> callers must still handle getting returned NULL.

I don't think we should do this :(

The __GFP_NOFAIL callers are using __GFP_NOFAIL for a reason - they
just cannot handle an allocation failure at all.  They won't even test
for a NULL return because a) they believe that __GFP_NOFAIL is magic and
b) if the allocation failed, they're screwed anyway.

So how feasible would it be to arrange for __GFP_NOFAIL callers to
ignore the oom-killing?  Presumably this means that they'll need to kill
someone else and keep on trying?

