Return-Path: <linux-kernel-owner+w=401wt.eu-S965698AbXCLLll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965698AbXCLLll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 07:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965706AbXCLLlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 07:41:39 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:43845 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965698AbXCLLli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 07:41:38 -0400
To: dgc@sgi.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20070312062349.GN6095633@melbourne.sgi.com> (message from David
	Chinner on Mon, 12 Mar 2007 17:23:49 +1100)
Subject: Re: [patch 3/8] per backing_dev dirty and writeback page accounting
References: <20070306180443.669036741@szeredi.hu> <20070306180550.793803735@szeredi.hu> <20070312062349.GN6095633@melbourne.sgi.com>
Message-Id: <E1HQitT-0002wP-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 12 Mar 2007 12:40:47 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I have no idea how serious the scalability problems with this are.  If
> > they are serious, different solutions can probably be found for the
> > above, but this is certainly the simplest.
> 
> Atomic operations to a single per-backing device from all CPUs at once?
> That's a pretty serious scalability issue and it will cause a major
> performance regression for XFS.

OK.  How about just accounting writeback pages?  That should be much
less of a problem, since normally writeback is started from
pdflush/kupdate in large batches without any concurrency.

Or is it possible to export the state of the device queue to mm?
E.g. could balance_dirty_pages() query the backing dev if there are
any outstanding write requests?

> I'd call this a showstopper right now - maybe you need to look at
> something like the ZVC code that Christoph Lameter wrote, perhaps?

That's rather a heavyweight approach for this I think.

The only info balance_dirty_pages() really needs is whether there are
any dirty+writeback bound for the backing dev or not.

It knows about the diry pages, since it calls writeback_inodes() which
scans the dirty pages for this backing dev looking for ones to write
out.  If after returning from writeback_inodes() wbc->nr_to_write
didn't decrease and wbc->pages_skipped is zero then we know that there
are no more dirty pages for the device.  Or at least there are no
dirty pages which aren't already under writeback.

Thanks,
Miklos
