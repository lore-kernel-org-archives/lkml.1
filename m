Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbXDFGvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbXDFGvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 02:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbXDFGvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 02:51:35 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:24935 "EHLO
	amsfep13-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753596AbXDFGve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 02:51:34 -0400
Subject: Re: [PATCH 11/12] mm: accurate pageout congestion wait
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       nikita@clusterfs.com
In-Reply-To: <20070405161713.dcd8bed9.akpm@linux-foundation.org>
References: <20070405174209.498059336@programming.kicks-ass.net>
	 <20070405174320.373513202@programming.kicks-ass.net>
	 <20070405161713.dcd8bed9.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 08:51:29 +0200
Message-Id: <1175842289.6483.124.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 16:17 -0700, Andrew Morton wrote:
> On Thu, 05 Apr 2007 19:42:20 +0200
> root@programming.kicks-ass.net wrote:
> 
> > Only do the congestion wait when we actually encountered congestion.
> 
> The name congestion_wait() was accurate back in 2002, but it isn't accurate
> any more, and you got misled.  It does not only wait for a queue to become
> uncongested.

Quite so indeed.

> See clear_bdi_congested()'s callers.  As long as the queue is in an
> uncongested state, we deliver wakeups to congestion_wait() blockers on
> every IO completion.  As I said before, it is so that the MM's polling
> operations poll at a higher frequency when the IO system is working faster.
> (It is also to synchronise with end_page_writeback()'s feeding of clean
> pages to us via rotate_reclaimable_page()).

Hmm, but the condition under which we did call congestion_wait() is a
bit magical.

> Page reclaim can get into trouble without any request queue having entered
> a congested state.  For example, think about a machine which has a single
> disk, and the operator has increased that disk's request queue size to
> 100,000.  With your patch all the VM's throttling would be bypassed and we
> go into a busy loop and declare OOM instantly.
> 
> There are probably other situations in which page reclaim gets into trouble
> without a request queue being congested.

Ok, in the light of allt his, I will think on this some more.

> Minor point: bdi_congested() can be arbitrarily expensive - for DM stackups
> it is roughly proportional to the number of subdevices in the device.  We
> need to be careful about how frequently we call it.

Yuck, ok, good point.

