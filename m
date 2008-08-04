Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbYHDPNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbYHDPNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 11:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbYHDPN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 11:13:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbYHDPN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 11:13:28 -0400
Date: Mon, 4 Aug 2008 11:11:58 -0400
From: Rik van Riel <riel@redhat.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org
Subject: Re: No, really, stop trying to delete slab until you've finished
 making slub perform as well
Message-ID: <20080804111158.7f108047@cuia.bos.redhat.com>
In-Reply-To: <48970779.80902@linux-foundation.org>
References: <20080801182324.572058187@lameter.com>
	<20080803015847.GD26461@parisc-linux.org>
	<48970779.80902@linux-foundation.org>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Aug 2008 08:43:21 -0500
Christoph Lameter <cl@linux-foundation.org> wrote:
> Matthew Wilcox wrote:
> > On Fri, May 09, 2008 at 07:21:01PM -0700, Christoph Lameter wrote:
> >> - Add a patch that obsoletes SLAB and explains why SLOB does not support
> >>   defrag (Either of those could be theoretically equipped to support
> >>   slab defrag in some way but it seems that Andrew/Linus want to reduce
> >>   the number of slab allocators).
> > 
> > Do we have to once again explain that slab still outperforms slub on at
> > least one important benchmark?  I hope Nick Piggin finds time to finish
> > tuning slqb; it already outperforms slub.
> > 
> 
> Uhh. I forgot to delete that statement. I did not include the patch in the series.
> 
> We have a fundamental issue design issue there. Queuing on free can result in
> better performance as in SLAB. However, it limits concurrency (per node lock
> taking) and causes latency spikes due to queue processing (f.e. one test load
> had 118.65 vs. 34 usecs just by switching to SLUB).
> 
> Could you address the performance issues in different ways? F.e. try to free
> when the object is hot or free from multiple processors? SLAB has to take the
> list_lock rather frequently under high concurrent loads (depends on queue
> size). That will not occur with SLUB. So you actually can free (and allocate)
> concurrently with high performance.

I guess you could bypass the queueing on free for objects that
come from a "local" SLUB page, only queueing objects that go
onto remote pages.

That way workloads that already perform well with SLUB should
keep the current performance, while workloads that currently
perform badly with SLUB should get an improvement.

-- 
All Rights Reversed
