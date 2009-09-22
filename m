Return-Path: <linux-kernel-owner+w=401wt.eu-S1756301AbZIVNyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbZIVNyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbZIVNys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:54:48 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60092 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbZIVNys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:54:48 -0400
Date: Tue, 22 Sep 2009 14:54:53 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Nick Piggin <npiggin@suse.de>, Christoph Lameter <cl@linux-foundation.org>,
       heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 2/4] slqb: Record what node is local to a kmem_cache_cpu
Message-ID: <20090922135453.GF25965@csn.ul.ie>
References: <1253624054-10882-1-git-send-email-mel@csn.ul.ie> <1253624054-10882-3-git-send-email-mel@csn.ul.ie> <84144f020909220638l79329905sf9a35286130e88d0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <84144f020909220638l79329905sf9a35286130e88d0@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 04:38:32PM +0300, Pekka Enberg wrote:
> Hi Mel,
> 
> On Tue, Sep 22, 2009 at 3:54 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> > When freeing a page, SLQB checks if the page belongs to the local node.
> > If it is not, it is considered a remote free. On the allocation side, it
> > always checks the local lists and if they are empty, the page allocator
> > is called. On memoryless configurations, this is effectively a memory
> > leak and the machine quickly kills itself in an OOM storm.
> >
> > This patch records what node ID is considered local to a CPU. As the
> > management structure for the CPU is always allocated from the closest
> > node, the node the CPU structure resides on is considered "local".
> >
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> 
> I don't understand how the memory leak happens from the above
> description (or reading the code). page_to_nid() returns some crazy
> value at free time?

Nope, it isn't a leak as such, the allocator knows where the memory is.
The problem is that is always frees remote but on allocation, it sees
the per-cpu list is empty and calls the page allocator again. The remote
lists just grow.

> The remote list isn't drained properly?
> 

That is another way of looking at it. When the remote lists get to a
watermark, they should drain. However, it's worth pointing out if it's
repaired in this fashion, the performance of SLQB will suffer as it'll
never reuse the local list of pages and instead always get cold pages
from the allocator.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
