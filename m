Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504AbXDXKMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504AbXDXKMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 06:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbXDXKMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 06:12:23 -0400
Received: from amsfep16-int.chello.nl ([62.179.120.11]:44501 "EHLO
	amsfep16-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbXDXKMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 06:12:22 -0400
Subject: Re: [PATCH 10/10] mm: per device dirty threshold
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, neilb@suse.de, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com
In-Reply-To: <20070424030021.a091018d.akpm@linux-foundation.org>
References: <20070420155154.898600123@chello.nl>
	 <20070420155503.608300342@chello.nl>
	 <17965.29252.950216.971096@notabene.brown>
	 <1177398589.26937.40.camel@twins>
	 <E1HgGF4-00008p-00@dorka.pomaz.szeredi.hu>
	 <1177403494.26937.59.camel@twins>
	 <E1HgH69-0000Fl-00@dorka.pomaz.szeredi.hu>
	 <1177406817.26937.65.camel@twins>
	 <E1HgHcG-0000J5-00@dorka.pomaz.szeredi.hu>
	 <20070424030021.a091018d.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 24 Apr 2007 12:12:18 +0200
Message-Id: <1177409538.26937.75.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-24 at 03:00 -0700, Andrew Morton wrote:
> On Tue, 24 Apr 2007 11:47:20 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > > Ahh, now I see; I had totally blocked out these few lines:
> > > 
> > > 			pages_written += write_chunk - wbc.nr_to_write;
> > > 			if (pages_written >= write_chunk)
> > > 				break;		/* We've done our duty */
> > > 
> > > yeah, those look dubious indeed... And reading back Neil's comments, I
> > > think he agrees.
> > > 
> > > Shall we just kill those?
> > 
> > I think we should.
> > 
> > Athough I'm a little afraid, that Akpm will tell me again, that I'm a
> > stupid git, and that those lines are in fact vitally important ;)
> > 
> 
> It depends what they're replaced with.
> 
> That code is there, iirc, to prevent a process from getting stuck in
> balance_dirty_pages() forever due to the dirtying activity of other
> processes.
> 
> hm, we ask the process to write write_chunk pages each go around the loop.
> So if it wrote write-chunk/2 pages on the first pass it might end up writing
> write_chunk*1.5 pages total.  I guess that's rare and doesn't matter much
> if it does happen - the upper bound is write_chunk*2-1, I think.

Right, but I think the problem is that its dirty -> writeback, not dirty
-> writeback completed.

Ie. they don't guarantee progress, it could be that the total
nr_reclaimable + nr_writeback will steadily increase due to this break.

How about ensuring that vm_writeout_total increases least
2*sync_writeback_pages() during our stay in balance_dirty_pages(). That
way we have the guarantee that more pages get written out than can be
dirtied.

